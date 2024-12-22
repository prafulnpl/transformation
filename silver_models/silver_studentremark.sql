-- Model: silver_studentremark

with leads as (
    { flatten_json_trino('bronze_raw.airbyte_raw_studentremark', '_airbyte_data', 'ST_') }
)
select * from leads
