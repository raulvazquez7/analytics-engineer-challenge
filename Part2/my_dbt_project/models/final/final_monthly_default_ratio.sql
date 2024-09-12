{{ config(
    materialized='table'
) }}

SELECT 
    month_year_order,
    loans_in_arrears_debt,
    total_loans_amount,
    default_ratio
FROM {{ ref('intermediate_monthly_default_ratio') }}
ORDER BY month_year_order
