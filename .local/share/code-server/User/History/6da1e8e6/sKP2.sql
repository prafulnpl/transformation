
select * from {{ json_parser('airbyte_raw_studentdetail', '_airbyte_data', 'std_') }}
