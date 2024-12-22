{% macro flatten_json(table, json_column, alias_prefix="") %}
    {%- set relation = ref(table) %}
    {%- set columns = dbt_utils.get_columns_in_relation(relation) %}

    {%- set flatten_fields = [] %}

    {%- for column in columns %}
        {%- if column == json_column %}
            -- Extract keys dynamically from the JSON column
            {%- set json_keys_query %}
                SELECT DISTINCT jsonb_object_keys({{ column }}) AS key
                FROM {{ relation }}
            {%- endset %}

            {%- set results = run_query(json_keys_query) %}

            {%- for row in results %}
                {%- set key = row['key'] %}
                {{ flatten_fields.append("{{ json_column }}->>'" ~ key ~ "' AS " ~ alias_prefix ~ key) }}
            {%- endfor %}
        {%- else %}
            {{ flatten_fields.append(column) }}
        {%- endif %}
    {%- endfor %}

    SELECT
        {{ flatten_fields | join(',\n        ') }}
    FROM {{ relation }}
{% endmacro %}