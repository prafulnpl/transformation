-- Model: silver_teachermain

with leads as (
    { flatten_json_trino('bronze_raw.airbyte_raw_teachermain', '_airbyte_data', 'ST_') }
)
select * from leads
