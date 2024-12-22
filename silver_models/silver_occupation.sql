-- Model: silver_occupation

with leads as (
    { flatten_json_trino('bronze_raw.airbyte_raw_occupation', '_airbyte_data', 'ST_') }
)
select * from leads
