-- Model: silver_classsubject

with leads as (
    {{ flatten_json_trino('bronze_raw.airbyte_raw_classsubject', '_airbyte_data', 'ST_') }}
)
select * from leads
