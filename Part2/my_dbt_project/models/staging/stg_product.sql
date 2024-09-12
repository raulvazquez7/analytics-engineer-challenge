{{ config(
    materialized='view'
) }}

SELECT 
    product_id,
    product_name
FROM {{ source('seQura_dbt', 'products') }}
