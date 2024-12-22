-- Auto-generated file for Raw data for converted leads

{{
   config(
      materialized='table'
}}

with leads as (
    {{ flatten_json_trino('bronze_raw.airbyte_raw_dlytica_academy_lead_converted_lead_tbln3zyr01r2qasyc', '_airbyte_data', 'st_') }}
)
select * from leads
