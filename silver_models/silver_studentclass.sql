-- Model: silver_studentclass

with leads as (
    { flatten_json_trino('bronze_raw.airbyte_raw_studentclass', '_airbyte_data', 'ST_') }
)
select * from leads
