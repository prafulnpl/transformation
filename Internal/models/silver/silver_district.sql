-- Model: silver_district

with leads as (
    {{ flatten_json_trino('bronze_raw.airbyte_raw_district', '_airbyte_data', 'ST_') }}
)
select * from leads
