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

    -- Step 3: Generate SQL to flatten the JSON
    SELECT
        *,
        {%- for key in keys %}
            -- Handle keys with special characters
            json_extract_scalar({{ json_column }}, '$."{{ key | replace("?", "_question_mark") | replace(" ", "_space") | replace('"', "_quote") }}"') 
            AS {{ alias_prefix }}{{ key | replace("?", "_question_mark") | replace(" ", "_space") | replace('"', "_quote") }}{% if not loop.last %}, {% endif %}
        {%- endfor %}
    FROM {{ relation }}
{% endmacro %}
