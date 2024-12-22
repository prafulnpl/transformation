select * from {{ source("bronze_raw1", "airbyte_raw_studentmain") }}

--select * from {{ json_parser('bronze_raw.default.airbyte_raw_studentmain', '_airbyte_data', 'std_') }}


