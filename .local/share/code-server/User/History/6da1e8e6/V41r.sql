{{ flatten_json('bronze_raw.airbyte_raw_studentmain', '_airbyte_data', ['STUDENTID', 'FIRSTNAME', 'LASTNAME', 'NATIONALITYID', 'RELIGIONID', 'DOB', 'ADMDATE', 'SSEX', 'STATUS', 'BatchID'], 'st_') }}
