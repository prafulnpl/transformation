
select * from {{ flatten_json('default.airbyte_raw_studentdetail', '_airbyte_data', 'std_') }}

