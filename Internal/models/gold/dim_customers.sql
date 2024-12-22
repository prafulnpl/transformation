{{
   config(
      materialized='table'
   )
}}

WITH CollegeLeadsRanked AS (
    SELECT DISTINCT
        s.st_studentid AS st_id,
        sm.st_firstname AS first_name,
        sm.st_lastname AS last_name,
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
        g.st_parmanentphone AS st_phone_number,
        dis.st_districtname AS st_districtname,
        z.st_zonename AS st_zonename,
        'lead_dump_sql' AS st_sourcedetail,
        ROW_NUMBER() OVER (PARTITION BY s.st_studentid ORDER BY a.st_ayearid DESC) AS rn,
        'college_leads' AS st_source_type,
        'UNIGLOBE COLLEGE' AS st_organization
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
),
CollegeLeads AS (
    SELECT
        st_id,
        first_name,
        last_name,
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
        st_phone_number,
        st_districtname,
        st_zonename,
        st_source_type,
        st_sourcedetail,
        st_organization
    FROM
        CollegeLeadsRanked
    WHERE
        rn = 1
),
WebsiteLeads AS (
    SELECT DISTINCT
        NULL AS st_id,
        split_part(st_name, ' ', 1) AS first_name, -- Extract first name
        CASE
            WHEN cardinality(split(st_name, ' ')) > 1 THEN split_part(st_name, ' ', 2) -- Extract last name
            ELSE NULL
        END AS last_name,
        st_name AS st_fullname,
        NULL AS st_classname,
        NULL AS st_facultyname,
        NULL AS st_departmentname,
        NULL AS st_ayear,
        NULL AS st_ssex,
        NULL AS st_dob,
        NULL AS st_admdate,
        NULL AS st_hoby,
        NULL AS st_status,
        NULL AS st_schoolfrom,
        NULL AS st_contactaddress,
        NULL AS st_contactphone,
        NULL AS st_parmanentaddress,
        st_phone_number AS st_phone_number,
        NULL AS st_districtname,
        st_country AS st_zonename,
        'website_leads' AS st_source_type,
        st_form_type AS st_sourcedetail,
        NULL AS st_organization
    FROM
        {{ ref('silver_websiteform') }}
)

SELECT * FROM CollegeLeads
UNION ALL
SELECT * FROM WebsiteLeads
