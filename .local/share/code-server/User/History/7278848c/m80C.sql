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

    -- Step 3: Sanitize keys to remove special characters, spaces, or numbers
    {%- set sanitized_keys = [] %}
    {%- for key in keys %}
        {%- set sanitized_key = key | replace(' ', '_') | replace('-', '_') | replace(':', '_') | replace('.', '_') | regex_replace('[^A-Za-z0-9_]', '') %}
        {%- do sanitized_keys.append(sanitized_key) %}
    {%- endfor %}

    -- Step 4: Generate SQL to flatten the JSON
    SELECT
        *,
        {%- for key, sanitized_key in keys | zip(sanitized_keys) %}
            -- Handle JSON extraction for arrays or scalar values
            CASE
                WHEN json_extract({{ json_column }}, '$.{{ key }}') IS NOT NULL 
                THEN CASE
                        WHEN json_extract({{ json_column }}, '$.{{ key }}') LIKE '[%' THEN 
                            json_array_get(json_parse(json_extract({{ json_column }}, '$.{{ key }}')), 0) -- Extract first array element
                        ELSE json_extract_scalar({{ json_column }}, '$.{{ key }}')
                     END
                ELSE NULL
            END AS {{ alias_prefix }}{{ sanitized_key }}{% if not loop.last %}, {% endif %}
        {%- endfor %}
    FROM {{ relation }}
{% endmacro %}
