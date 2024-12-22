{{
   config(
      materialized='table'
   )
}}

-- Combine college_leads and website_leads into dim_customer

WITH CollegeLeads AS (
    SELECT DISTINCT
        s.st_studentid AS st_id,
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
        g.st_parmanentphone AS st_phone_number, -- Align with website_leads field
        dis.st_districtname AS st_districtname,
        z.st_zonename AS st_zonename,
        'college_leads' AS source_type, -- Add source type
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
    WHERE
        ROW_NUMBER() OVER (PARTITION BY s.st_studentid ORDER BY a.st_ayearid DESC) = 1
),

WebsiteLeads AS (
    SELECT DISTINCT
        NULL AS st_id, -- No equivalent in website_leads
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
        st_country AS st_zonename, -- Align to zone name field
        'website_leads' AS source_type, -- Add source type
        st_form_type AS st_organization -- Use form type for organization
    FROM
        {{ ref('silver_websiteform') }}
)

SELECT * FROM CollegeLeads
UNION ALL
SELECT * FROM WebsiteLeads
