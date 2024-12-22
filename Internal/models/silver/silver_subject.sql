-- Model: silver_subject

with leads as (
    {{ flatten_json_trino('bronze_raw.airbyte_raw_subject', '_airbyte_data', 'ST_') }}
)
select * from leads
