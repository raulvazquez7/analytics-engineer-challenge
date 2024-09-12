{{ config(
    materialized='view'
) }}

SELECT 
    merchant_id,
    merchant_name
FROM {{ source('seQura_dbt', 'merchants') }}
