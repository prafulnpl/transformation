-- Auto-generated file for Raw data for converted leads

with leads as (
    {{ flatten_json_trino('bronze_raw.airbyte_raw_dlytica_academy_lead_converted_lead_tbln3zyr01r2qasyc', '_airbyte_data', 'ST_') }}
)
select * from leads


-- Model: silver_guardian

with leads as (
    {{ flatten_json_trino('bronze_raw.airbyte_raw_guardian', '_airbyte_data', 'ST_') }}
)
select * from leads
