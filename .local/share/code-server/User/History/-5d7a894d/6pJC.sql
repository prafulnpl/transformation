-- Auto-generated file for Raw data for screened leads

with leads as (
    { flatten_json_trino('bronze_raw.airbyte_raw_dlytica_academy_lead_screened_leads_tblelhdxsn4et31rl', '_airbyte_data', 'ST_') }
)
select * from leads;
