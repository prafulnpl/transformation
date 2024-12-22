{% macro flatten_json(table, json_column, keys, alias_prefix="") %}
    {%- set relation = source(table.split('.')[0], table.split('.')[1]) %}
    SELECT
        *,
        {%- for key in keys %}
            json_extract_scalar({{ json_column }}, '$.{{ key }}') AS {{ alias_prefix }}{{ key }}{% if not loop.last %}, {% endif %}
        {%- endfor %}
    FROM {{ relation }}
{% endmacro %}
