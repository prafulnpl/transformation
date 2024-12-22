
select * from {{ json_parser('default.airbyte_raw_studentdetail', '_airbyte_data', 'std_') }}
