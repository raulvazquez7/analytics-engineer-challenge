{{ config(
    materialized='view'
) }}

WITH arrears_data AS (
    -- Extraemos los datos necesarios de la tabla de orders
    SELECT
        o.order_id,
        o.shopper_id,
        s.age AS shopper_age, 
        o.merchant_id,
        m.merchant_name AS merchant,
        p.product_name AS product,
        r.default_type,
        o.order_date,
        FORMAT_DATE('%Y-%m', o.order_date) AS month_year_order,
        o.current_order_value,
        o.total_overdue,
        o.days_unbalanced
    FROM {{ ref('stg_orders') }} o
    LEFT JOIN {{ ref('stg_dim_shoppers') }} s ON o.shopper_id = s.shopper_id
    LEFT JOIN {{ ref('stg_merchants') }} m ON o.merchant_id = m.merchant_id
    LEFT JOIN {{ ref('stg_product') }} p ON o.product_id = p.product_id
    LEFT JOIN {{ ref('stg_rel_default_order_type') }} r ON o.order_id = r.order_id
    WHERE o.days_unbalanced >= 17  -- Solo consideramos órdenes con mora
),

expanded_periods AS (
    -- Generamos una fila para cada `order_id` en función de sus niveles de mora
    SELECT 
        order_id,
        shopper_id,
        shopper_age,
        merchant_id,
        merchant,
        product,
        default_type,
        order_date,
        month_year_order,
        current_order_value,
        total_overdue,
        days_unbalanced,
        '17 days' AS delayed_period
    FROM arrears_data
    WHERE days_unbalanced >= 17

    UNION ALL

    SELECT 
        order_id,
        shopper_id,
        shopper_age,
        merchant_id,
        merchant,
        product,
        default_type,
        order_date,
        month_year_order,
        current_order_value,
        total_overdue,
        days_unbalanced,
        '30 days' AS delayed_period
    FROM arrears_data
    WHERE days_unbalanced >= 30

    UNION ALL

    SELECT 
        order_id,
        shopper_id,
        shopper_age,
        merchant_id,
        merchant,
        product,
        default_type,
        order_date,
        month_year_order,
        current_order_value,
        total_overdue,
        days_unbalanced,
        '60 days' AS delayed_period
    FROM arrears_data
    WHERE days_unbalanced >= 60

    UNION ALL

    SELECT 
        order_id,
        shopper_id,
        shopper_age,
        merchant_id,
        merchant,
        product,
        default_type,
        order_date,
        month_year_order,
        current_order_value,
        total_overdue,
        days_unbalanced,
        '90 days' AS delayed_period
    FROM arrears_data
    WHERE days_unbalanced >= 90
)

SELECT 
    order_id,
    shopper_id,
    shopper_age,
    merchant_id,
    merchant,
    product,
    default_type,
    order_date,
    month_year_order,
    current_order_value,
    total_overdue,
    days_unbalanced,
    delayed_period
FROM expanded_periods
