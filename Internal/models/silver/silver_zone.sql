-- Model: silver_zone

with leads as (
    {{ flatten_json_trino('bronze_raw.airbyte_raw_zone', '_airbyte_data', 'ST_') }}
)
select * from leads
