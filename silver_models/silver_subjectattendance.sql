-- Model: silver_subjectattendance

with leads as (
    { flatten_json_trino('bronze_raw.airbyte_raw_subjectattendance', '_airbyte_data', 'ST_') }
)
select * from leads
