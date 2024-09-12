{{ config(
    materialized='view'  
) }}

WITH monthly_data AS (
    -- Extraer los montos necesarios agrupados por mes
    SELECT 
        FORMAT_DATE('%Y-%m', order_date) AS month_year_order,
        SUM(CASE WHEN days_unbalanced > 0 THEN total_overdue ELSE 0 END) AS loans_in_arrears_debt,
        SUM(current_order_value) AS total_loans_amount
    FROM {{ ref('stg_orders') }}
    GROUP BY month_year_order
)

-- Calcular el Default Ratio por mes
SELECT 
    month_year_order,
    loans_in_arrears_debt,
    total_loans_amount,
    ROUND((loans_in_arrears_debt / total_loans_amount) * 100, 2) AS default_ratio
FROM monthly_data
