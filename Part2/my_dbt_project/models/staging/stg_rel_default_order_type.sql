{{ config(
    materialized='view'
) }}

SELECT 
    default_type_id,
    order_id,
    default_type
FROM {{ source('seQura_dbt', 'rel_default_order_type') }}
