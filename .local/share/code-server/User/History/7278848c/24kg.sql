{% macro flatten_json_trino(table, json_column, alias_prefix="") %}
    {%- set relation = source(table.split('.')[0], table.split('.')[1]) %}

    -- Step 1: Generate SQL to discover JSON keys across all rows
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
        -- Determine if the key requires escaping (e.g., contains special characters)
        {%- if key | match('[^a-zA-Z0-9_]') %}
            {%- set escaped_key = '"{}"'.format(key | replace('"', '\\"')) %}
        {%- else %}
            {%- set escaped_key = key %}
        {%- endif %}
        {%- do escaped_keys.append(escaped_key) %}
    {%- endfor %}

    -- Step 4: Generate SQL to flatten the JSON, using NULL for missing keys
    SELECT
        *,
        {%- for idx in range(keys | length) %}
            -- Extract scalar values or default to NULL for missing keys
            CASE
                WHEN json_extract({{ json_column }}, '$.{{ escaped_keys[idx] }}') IS NULL THEN NULL
                ELSE CAST(json_extract({{ json_column }}, '$.{{ escaped_keys[idx] }}') AS VARCHAR)
            END AS {{ alias_prefix }}{{ sanitized_keys[idx] }}{% if not loop.last %}, {% endif %}
        {%- endfor %}
    FROM {{ relation }}
{% endmacro %}
