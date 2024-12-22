
select * from {{ json_parser('bronze_raw.default.airbyte_raw_studentdetail', '_airbyte_data', 'std_') }}
