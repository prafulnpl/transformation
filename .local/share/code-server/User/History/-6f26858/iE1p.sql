-- models/gold/dim_customer.sql

WITH RankedStudents AS (
    SELECT DISTINCT
        s.studentid,
        concat(coalesce(sm.firstname, ''), ' ', coalesce(sm.lastname, '')) AS fullname,
        sc.classname AS classname,
        f.facultyname AS facultyname,
        d.departmentname AS departmentname,
        a.ayear AS ayear,
        sm.ssex AS ssex,
        sm.dob,
        sm.admdate,
        sm.hoby,
        sm.status,
        g.schoolfrom AS schoolfrom,
        g.contactaddress AS contactaddress,
        g.contactphone AS contactphone,
        g.parmanentaddress AS parmanentaddress,
        g.parmanentphone AS parmanentphone,
        g.fathername AS fathername,
        dis.districtname AS districtname,
        z.zonename AS zonename,
        concat(coalesce(par.pfirstname, ''), ' ', coalesce(par.plastname, '')) AS parentfullname,
        ROW_NUMBER() OVER (PARTITION BY s.studentid ORDER BY a.ayearid DESC) AS rn
    FROM TABLE(flatten_json_trino('bronze_raw.airbyte_raw_studentdetail', '_airbyte_data', 'ST_')) AS s
    LEFT JOIN TABLE(flatten_json_trino('bronze_raw.airbyte_raw_studentmain', '_airbyte_data', 'ST_')) AS sm
        ON sm.studentid = s.studentid
    LEFT JOIN TABLE(flatten_json_trino('bronze_raw.airbyte_raw_ayear', '_airbyte_data', 'ST_')) AS a
        ON a.ayearid = s.ayearid
    LEFT JOIN TABLE(flatten_json_trino('bronze_raw.airbyte_raw_faculty', '_airbyte_data', 'ST_')) AS f
        ON s.facultyid = f.facultyid
    LEFT JOIN TABLE(flatten_json_trino('bronze_raw.airbyte_raw_studentclass', '_airbyte_data', 'ST_')) AS sc
        ON sc.classid = s.classid  
    LEFT JOIN TABLE(flatten_json_trino('bronze_raw.airbyte_raw_department', '_airbyte_data', 'ST_')) AS d
        ON s.departmentid = d.departmentid
    LEFT JOIN TABLE(flatten_json_trino('bronze_raw.airbyte_raw_generalstudent', '_airbyte_data', 'ST_')) AS g
        ON g.studentid = s.studentid
    LEFT JOIN TABLE(flatten_json_trino('bronze_raw.airbyte_raw_zone', '_airbyte_data', 'ST_')) AS z
        ON z.zoneid = g.zoneid
    LEFT JOIN TABLE(flatten_json_trino('bronze_raw.airbyte_raw_district', '_airbyte_data', 'ST_')) AS dis
        ON dis.districtid = g.districtid
)

SELECT
    studentid,
    fullname,
    classname,
    facultyname,
    departmentname,
    ayear,
    ssex,
    dob,
    admdate,
    hoby,
    status,
    schoolfrom,
    contactaddress,
    contactphone,
    parmanentaddress,
    parmanentphone,
    districtname,
    zonename,
    'UNIGLOBE COLLEGE' AS organization
FROM
    RankedStudents
WHERE
    rn = 1;
