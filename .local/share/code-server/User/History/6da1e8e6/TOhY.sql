-- models/json_parser_flatten.sql

WITH parsed_json AS (
    SELECT *
    FROM json_parser(
        {{ source('bronze_raw', 'airbyte_raw_studentmain') }},
        '_airbyte_data',
        '_st'
    )
)
SELECT *
FROM parsed_json