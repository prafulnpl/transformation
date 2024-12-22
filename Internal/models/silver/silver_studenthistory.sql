-- Model: silver_studenthistory

with leads as (
    {{ flatten_json_trino('bronze_raw.airbyte_raw_studenthistory', '_airbyte_data', 'ST_') }}
)
select * from leads
