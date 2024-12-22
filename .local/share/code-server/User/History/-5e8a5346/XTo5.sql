{% macro json_parser(table, json_column, alias_prefix="") %}
    {%- set relation = ref(table) %}
    {%- set query %}
        SELECT DISTINCT jsonb_object_keys({{ json_column }}) AS key
        FROM {{ relation }}
    {%- endset %}

    {%- set results = run_query(query) %}
    {%- set keys = results.columns[0].values() if execute else [] %}

    SELECT
        -- Include all non-JSON columns
        {%- set columns = [] %}
        {%- for column in adapter.get_columns_in_relation(relation) %}
            {%- if column != json_column %}
                {{ columns.append(column) }}
            {%- endif %}
        {%- endfor %}
        {{ columns | join(', ') }}{% if columns | length > 0 %}, {% endif %}

        -- Flatten JSON fields into separate columns
        {%- for key in keys %}
            {{ json_column }}->>'{{ key }}' AS {{ alias_prefix }}{{ key }}{% if not loop.last %}, {% endif %}
        {%- endfor %}
    FROM {{ relation }}
{% endmacro %}
