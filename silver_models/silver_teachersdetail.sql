-- Model: silver_teachersdetail

with leads as (
    { flatten_json_trino('bronze_raw.airbyte_raw_teachersdetail', '_airbyte_data', 'ST_') }
)
select * from leads
