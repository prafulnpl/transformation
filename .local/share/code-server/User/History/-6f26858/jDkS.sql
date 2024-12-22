-- models/gold/dim_customer.sql

with RankedStudents as (

    select distinct
        s.studentid,
        concat(coalesce(sm.firstname, ''), ' ', coalesce(sm.lastname, '')) as fullname,
        sc.classname as classname,
        f.facultyname as facultyname,
        d.departmentname as departmentname,
        a.ayear as ayear,
        sm.ssex as ssex,
        sm.dob,
        sm.admdate,
        sm.hoby,
        sm.status,
        g.schoolfrom as schoolfrom,
        g.contactaddress as contactaddress,
        g.contactphone as contactphone,
        g.parmanentaddress as parmanentaddress,
        g.parmanentphone as parmanentphone,
        g.fathername as fathername,
        dis.districtname as districtname,
        z.zonename as zonename,
        concat(coalesce(par.pfirstname, ''), ' ', coalesce(par.plastname, '')) as parentfullname,
        par.mobileno as parentmobileno,
        par.email as parentemail,
        par.phoneo as parentofficephoneno,
        par.mobile as parentmobileno1,
        row_number() over (partition by s.studentid order by a.ayearid desc) as rn
    from
        {{ ref('silver_studentdetail') }} s
    left join
        {{ ref('silver_studentmain') }} sm
        on sm.studentid = s.studentid
    left join
        {{ ref('silver_ayear') }} a
        on a.ayearid = s.ayearid
    left join
        {{ ref('silver_faculty') }} f
        on s.facultyid = f.facultyid
    left join
        {{ ref('silver_studentclass') }} sc
        on sc.classid = s.classid  
    left join
        {{ ref('silver_department') }} d
        on s.departmentid = d.departmentid
    left join
        {{ ref('silver_batch') }} b
        on b.batchid = sm.batchid
    left join
        {{ ref('silver_generalstudent') }} g
        on g.studentid = s.studentid
    left join
        {{ ref('silver_zone') }} z
        on z.zoneid = g.zoneid
    left join
        {{ ref('silver_district') }} dis
        on dis.districtid = g.districtid
    left join
        {{ ref('silver_parent') }} par
        on par.studentid = s.studentid

)

select
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
    fathername,
    districtname,
    zonename,
    parentfullname,
    parentmobileno,
    parentemail,
    parentofficephoneno,
    parentmobileno1,
    'UNIGLOBE COLLEGE' as organization
from
    RankedStudents
where
    rn = 1
