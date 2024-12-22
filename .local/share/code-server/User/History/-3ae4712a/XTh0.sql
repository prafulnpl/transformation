-- Auto-generated file for Raw data for screened leads
{{
   config(
      materialized='table'
   )
}}


with leads as (
    {{ flatten_json_trino('bronze_raw.airbyte_raw_dlytica_academy_lead_websiteform_tblsqbgch37c4nrii', '_airbyte_data', 'ST_') }}
)
select * from leads;
