SELECT 
    airbyte_raw_studentdetail.STUDENTID, 
    airbyte_raw_studentmain.FIRSTNAME, 
    airbyte_raw_studentmain.LASTNAME
FROM 
    default.airbyte_raw_studentdetail 
LEFT JOIN 
    default.airbyte_raw_studentmain 
    ON airbyte_raw_studentdetail.STUDENTID = airbyte_raw_studentmain.STUDENTID 
LIMIT 5
