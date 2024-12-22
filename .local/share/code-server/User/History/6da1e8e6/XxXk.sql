with leads
{{ flatten_json_trino('bronze_raw.airbyte_raw_studentmain', '_airbyte_data', 'ST_') }}

select * from leads