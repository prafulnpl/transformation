{% macro flatten_json_trino(table, json_column, alias_prefix="") %}
    {%- set relation = source(table.split('.')[0], table.split('.')[1]) %}

    -- Step 1: Generate SQL to discover JSON keys
    {%- set json_keys_query %}
        SELECT DISTINCT key
        FROM (
            SELECT key
            FROM {{ relation }},
                 UNNEST(map_keys(CAST(json_parse({{ json_column }}) AS MAP(VARCHAR, JSON)))) AS t(key)
        )
    {%- endset %}

    -- Step 2: Run the query to get JSON keys
    {%- set results = run_query(json_keys_query) %}
    {%- set keys = results.columns[0].values() if execute else [] %}

    -- Step 3: Sanitize keys for SQL compliance and JSON path compatibility
    {%- set sanitized_keys = [] %}
    {%- set escaped_keys = [] %}
    {%- for key in keys %}
        {%- set sanitized_key = key
            | replace(' ', '_')
            | replace('-', '_')
            | replace(':', '_')
            | replace('?', '_')
            | replace('.', '_') %}
        {%- if sanitized_key[0].isdigit() %}
            {%- set sanitized_key = 'key_' + sanitized_key %}
        {%- endif %}
        {%- do sanitized_keys.append(sanitized_key) %}
        {%- set escaped_key = '"' ~ key | replace('"', '\\"') ~ '"' %}
        {%- do escaped_keys.append(escaped_key) %}
    {%- endfor %}

    -- Step 4: Generate SQL to flatten the JSON
    SELECT
        *,
        {%- for idx in range(keys | length) %}
            -- Extract value based on its type
            CASE
                WHEN json_type(json_extract({{ json_column }}, '$.{{ escaped_keys[idx] }}')) = 'ARRAY' THEN
                    CAST(json_format(json_extract({{ json_column }}, '$.{{ escaped_keys[idx] }}')) AS VARCHAR)
                WHEN json_type(json_extract({{ json_column }}, '$.{{ escaped_keys[idx] }}')) = 'OBJECT' THEN
                    CAST(json_format(json_extract({{ json_column }}, '$.{{ escaped_keys[idx] }}')) AS VARCHAR)
                ELSE
                    json_extract_scalar({{ json_column }}, '$.{{ escaped_keys[idx] }}')
            END AS {{ alias_prefix }}{{ sanitized_keys[idx] }}{% if not loop.last %}, {% endif %}
        {%- endfor %}
    FROM {{ relation }}
{% endmacro %}