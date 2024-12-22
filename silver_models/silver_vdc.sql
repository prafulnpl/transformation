-- Model: silver_vdc

with leads as (
    { flatten_json_trino('bronze_raw.airbyte_raw_vdc', '_airbyte_data', 'ST_') }
)
select * from leads
