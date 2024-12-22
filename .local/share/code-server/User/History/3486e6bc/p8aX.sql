-- Model: silver_generalstudent

with leads as (
    {{ flatten_json_trino('bronze_raw.airbyte_raw_generalstudent', '_airbyte_data', 'st_') }}
)
select * from leads
