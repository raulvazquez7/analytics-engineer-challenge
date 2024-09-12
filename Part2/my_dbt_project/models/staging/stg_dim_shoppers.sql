{{ config(
    materialized='view'
) }}

SELECT 
    shopper_id,
    age
FROM {{ source('seQura_dbt', 'dim_shoppers') }}
