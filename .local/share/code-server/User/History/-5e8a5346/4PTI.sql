{% macro flatten_json(table, json_column, alias_prefix="") %}
    {%- set relation = source(table.split('.')[0], table.split('.')[1]) %}
    
    -- Query to extract distinct JSON keys dynamically
    {%- set json_keys_query %}
        SELECT DISTINCT json_keys(key)
        FROM (
            SELECT CAST(json_parse({{ json_column }}) AS MAP(VARCHAR, VARCHAR)) AS key
            FROM {{ relation }}
        )
    {%- endset %}

    -- Run the query to get keys
    {%- set results = run_query(json_keys_query) %}
    {%- set keys = results.columns[0].values() if execute else [] %}

    -- Build SQL for flattened JSON fields
    SELECT
        *
        {%- for key in keys %}
        , CAST(json_extract({{ json_column }}, '$.{{ key }}') AS VARCHAR) AS {{ alias_prefix }}{{ key }}
        {%- endfor %}
    FROM {{ relation }}
{% endmacro %}
