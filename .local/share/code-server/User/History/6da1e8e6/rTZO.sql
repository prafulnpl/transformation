SELECT 
    s.STUDENTID, 
    sm.FIRSTNAME, 
    sm.LASTNAME
FROM 
    default.airbyte_raw_studentdetail 
LEFT JOIN 
    default.airbyte_raw_studentmain 
    ON STUDENTID = STUDENTID 
LIMIT 5
