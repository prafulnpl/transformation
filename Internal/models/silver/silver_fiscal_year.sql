-- Model: silver_fiscal_year

with leads as (
    {{ flatten_json_trino('bronze_raw.airbyte_raw_fiscal_year', '_airbyte_data', 'ST_') }}
)
select * from leads
