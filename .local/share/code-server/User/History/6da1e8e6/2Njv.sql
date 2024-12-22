SELECT 
    s.STUDENTID, 
    sm.FIRSTNAME, 
    sm.LASTNAME
FROM 
    default.airbyte_raw_studentdetail s
LEFT JOIN 
    default.airbyte_raw_studentmain sm 
    ON sm.STUDENTID = s.STUDENTID 
LIMIT 5
