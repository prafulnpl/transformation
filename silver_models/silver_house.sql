-- Model: silver_house

with leads as (
    { flatten_json_trino('bronze_raw.airbyte_raw_house', '_airbyte_data', 'ST_') }
)
select * from leads
