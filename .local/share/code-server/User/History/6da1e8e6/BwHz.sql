


SELECT 
*
FROM 
    default.airbyte_raw_studentdetail as s
LEFT JOIN 
    default.airbyte_raw_studentmain as sm
    ON STUDENTID = STUDENTID 
LIMIT 5

