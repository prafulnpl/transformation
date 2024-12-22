-- Auto-generated file for Raw data for converted leads

with leads as (
    {{ flatten_json_trino('bronze_raw.airbyte_raw_guardian', '_airbyte_data', 'ST_') }}
)
select * from leads
