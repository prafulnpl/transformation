WITH source_data AS (
    SELECT
        id, -- Assuming your table has an ID or similar primary column
        json_extract_scalar(_airbyte_data, '$.STUDENTID') AS studentid,
        json_extract_scalar(_airbyte_data, '$.FIRSTNAME') AS firstname,
        json_extract_scalar(_airbyte_data, '$.LASTNAME') AS lastname,
        json_extract_scalar(_airbyte_data, '$.NATIONALITYID') AS nationalityid,
        json_extract_scalar(_airbyte_data, '$.RELIGIONID') AS religionid,
        json_extract_scalar(_airbyte_data, '$.DOB') AS dob,
        json_extract_scalar(_airbyte_data, '$.ADMDATE') AS admdate,
        json_extract_scalar(_airbyte_data, '$.SSEX') AS ssex,
        json_extract_scalar(_airbyte_data, '$.STATUS') AS status,
        json_extract_scalar(_airbyte_data, '$.BatchID') AS batchid
    FROM {{ source('bronze_raw',
