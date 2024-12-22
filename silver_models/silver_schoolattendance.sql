-- Model: silver_schoolattendance

with leads as (
    { flatten_json_trino('bronze_raw.airbyte_raw_schoolattendance', '_airbyte_data', 'ST_') }
)
select * from leads
