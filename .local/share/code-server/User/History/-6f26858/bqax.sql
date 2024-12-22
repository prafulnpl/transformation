-- models/gold/dim_customer.sql

WITH RankedStudents AS (
    SELECT DISTINCT
        s.studentid AS st_studentid,
        concat(coalesce(sm.firstname, ''), ' ', coalesce(sm.lastname, '')) AS st_fullname,
        sc.classname AS st_classname,
        f.facultyname AS st_facultyname,
        d.departmentname AS st_departmentname,
        a.ayear AS st_ayear,
        sm.ssex AS st_ssex,
        sm.dob AS st_dob,
        sm.admdate AS st_admdate,
        sm.hoby AS st_hoby,
        sm.status AS st_status,
        g.schoolfrom AS st_schoolfrom,
        g.contactaddress AS st_contactaddress,
        g.contactphone AS st_contactphone,
        g.parmanentaddress AS st_parmanentaddress,
        g.parmanentphone AS st_parmanentphone,
        g.fathername AS st_fathername,
        dis.districtname AS st_districtname,
        z.zonename AS st_zonename,
        concat(coalesce(par.pfirstname, ''), ' ', coalesce(par.plastname, '')) AS st_parentfullname,
        ROW_NUMBER() OVER (PARTITION BY s.studentid ORDER BY a.ayearid DESC) AS rn
    FROM
        {{ ref('silver_studentdetail') }} s
    LEFT JOIN
        {{ ref('silver_studentmain') }} sm
        ON sm.studentid = s.studentid
    LEFT JOIN
        {{ ref('silver_ayear') }} a
        ON a.ayearid = s.ayearid
    LEFT JOIN
        {{ ref('silver_faculty') }} f
        ON s.facultyid = f.facultyid
    LEFT JOIN
        {{ ref('silver_studentclass') }} sc
        ON sc.classid = s.classid  
    LEFT JOIN
        {{ ref('silver_department') }} d
        ON s.departmentid = d.departmentid
    LEFT JOIN
        {{ ref('silver_generalstudent') }} g
        ON g.studentid = s.studentid
    LEFT JOIN
        {{ ref('silver_zone') }} z
        ON z.zoneid = g.zoneid
    LEFT JOIN
        {{ ref('silver_district') }} dis
        ON dis.districtid = g.districtid
)

SELECT
    st_studentid,
    st_fullname,
    st_classname,
    st_facultyname,
    st_departmentname,
    st_ayear,
    st_ssex,
    st_dob,
    st_admdate,
    st_hoby,
    st_status,
    st_schoolfrom,
    st_contactaddress,
    st_contactphone,
    st_parmanentaddress,
    st_parmanentphone,
    st_districtname,
    st_zonename,
    'UNIGLOBE COLLEGE' AS st_organization
FROM
    RankedStudents
WHERE
    rn = 1
