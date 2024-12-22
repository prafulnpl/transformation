select * from {{ source("bronze_raw", "airbyte_raw_studentmain") }}

--select * from {{ json_parser('bronze_raw.default.airbyte_raw_studentmain', '_airbyte_data', 'std_') }}


