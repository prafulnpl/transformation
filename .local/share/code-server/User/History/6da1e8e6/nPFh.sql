select * from {source('bronze_raw.default.airbyte_raw_studentmain')}
{{ source("source_name", "table_name") }}

--select * from {{ json_parser('bronze_raw.default.airbyte_raw_studentmain', '_airbyte_data', 'std_') }}

