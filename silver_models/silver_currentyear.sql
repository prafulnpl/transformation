-- Model: silver_currentyear

with leads as (
    { flatten_json_trino('bronze_raw.airbyte_raw_currentyear', '_airbyte_data', 'ST_') }
)
select * from leads
