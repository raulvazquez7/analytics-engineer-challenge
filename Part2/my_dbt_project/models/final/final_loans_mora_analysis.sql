{{ config(
    materialized='table'
) }}

SELECT 
    shopper_age,
    month_year_order,
    product,
    merchant,
    default_type,
    delayed_period
FROM {{ ref('intermediate_loans_mora_analysis') }}
ORDER BY month_year_order, delayed_period
