-- Model: silver_employment

with leads as (
    { flatten_json_trino('bronze_raw.airbyte_raw_employment', '_airbyte_data', 'ST_') }
)
select * from leads
