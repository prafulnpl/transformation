{{
   config(
      materialized='table'
   )
}}

WITH RankedStudents AS (
    SELECT DISTINCT
        s.st_studentid,
        concat(coalesce(sm.st_firstname, ''), ' ', coalesce(sm.st_lastname, '')) AS st_fullname,
        sc.st_classname AS st_classname,
        f.st_facultyname AS st_facultyname,
        d.st_departmentname AS st_departmentname,
        a.st_ayear AS st_ayear,
        sm.st_ssex AS st_ssex,
        sm.st_dob AS st_dob,
        sm.st_admdate AS st_admdate,
        sm.st_hoby AS st_hoby,
        sm.st_status AS st_status,
        g.st_schoolfrom AS st_schoolfrom,
        g.st_contactaddress AS st_contactaddress,
        g.st_contactphone AS st_contactphone,
        g.st_parmanentaddress AS st_parmanentaddress,
        g.st_parmanentphone AS st_parmanentphone,
        g.st_fathername AS st_fathername,
        dis.st_districtname AS st_districtname,
        z.st_zonename AS st_zonename,
        ROW_NUMBER() OVER (PARTITION BY s.st_studentid ORDER BY a.st_ayearid DESC) AS rn
    FROM
        {{ ref('silver_studentdetail') }} s
    LEFT JOIN
        {{ ref('silver_studentmain') }} sm
        ON sm.st_studentid = s.st_studentid
    LEFT JOIN
        {{ ref('silver_ayear') }} a
        ON a.st_ayearid = s.st_ayearid
    LEFT JOIN
        {{ ref('silver_faculty') }} f
        ON s.st_facultyid = f.st_facultyid
    LEFT JOIN
        {{ ref('silver_studentclass') }} sc
        ON sc.st_classid = s.st_classid  
    LEFT JOIN
        {{ ref('silver_department') }} d
        ON s.st_departmentid = d.st_departmentid
    LEFT JOIN
        {{ ref('silver_generalstudent') }} g
        ON g.st_studentid = s.st_studentid
    LEFT JOIN
        {{ ref('silver_zone') }} z
        ON z.st_zoneid = g.st_zoneid
    LEFT JOIN
        {{ ref('silver_district') }} dis
        ON dis.st_districtid = g.st_districtid
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
    'UNIGLOBE COLLEGE' AS st_organization,
    wf.name AS form_name,
    wf.email AS form_email,
    wf.country AS form_country,
    wf.call_note AS form_call_note,
    wf.phone_number AS form_phone_number,
    wf.course_type AS form_course_type,
    wf.requested_course_plan AS form_requested_course_plan,
    wf.form_type AS form_form_type,
    wf.looking_for AS form_looking_for,
    wf.linkedin_url AS form_linkedin_url,
    wf.created_date AS form_created_date
FROM
    RankedStudents rs
LEFT JOIN
    {{ ref('silver_websiteform') }} wf
    ON wf.phone_number = rs.st_parmanentphone
WHERE
    rs.rn = 1
