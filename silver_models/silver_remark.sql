-- Model: silver_remark

with leads as (
    { flatten_json_trino('bronze_raw.airbyte_raw_remark', '_airbyte_data', 'ST_') }
)
select * from leads
