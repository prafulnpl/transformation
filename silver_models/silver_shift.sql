-- Model: silver_shift

with leads as (
    { flatten_json_trino('bronze_raw.airbyte_raw_shift', '_airbyte_data', 'ST_') }
)
select * from leads