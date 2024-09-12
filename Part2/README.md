# Technical Test (Part II)

## **Loan Default Model**

Risk department has asked Data Team for calculating how the default ratio is evolving through the time. The goal of this exercise is to create an output model to let stakeholder do a detailed monitoritzation of the orders which are not up to date on theirs payments.

The way of calculating the default ratio is to divide the loans in arrears by the total loans granted in the same period.

![0E77CD43-E6E9-4478-BA87-1DDD0D641B9F_4_5005_c](https://github.com/user-attachments/assets/4bddb1c8-87c9-4e90-b0cc-0254c928226f)

Main table, “Orders”, is the loans table which contains overdue_xxxx fiels for calculating the total sum of debt and the is_in_default bool to know if the loan is in arreas.
Also, if days_unbalanced field is greater than 0 means that the loan is in arreas. No less important is the field ‘current_oder_value’ which represents the amount of money of an order (loan).

![134F6E48-D6C9-4C3A-A09E-D968B877C4BC_4_5005_c](https://github.com/user-attachments/assets/3526a458-85c7-47db-a64b-7aa8c03bb660)

Debt only includes orders in default for the specific period, while Total Orders are all orders in arreas or up to date with payments.

The desidered Output for the DataSet needed is:

- `shopper_age`
- `month_year_order` (YYYY-MM)
- `product`
- `merchant`
- `default_type`
- `delayed_period`

## Output

[See model here!](https://github.com/raulvazquez7/analytics-engineer-challenge/tree/main/Part2/my_dbt_project)

### Analysis Objective

The objective of the analysis is to create a dataset that allows us to examine the relationship between the buyer's profile (age), the merchant, the product, and the different types of delinquency (`delayed_period`). This type of analysis is crucial for identifying risk patterns, evaluating the effectiveness of collection mechanisms, and adjusting risk mitigation strategies.

### Approach

My approach was to create a model in dbt differentiating between three phases:

- **staging**: create basic views that extract data from the tables we will work with.
- **intermediate**: two views where the deeper transformation is carried out, as well as the joining of different data to add more information.
- **final**: the final tables where only the fields necessary for the analysis are extracted.

The idea was to create a dataset where `order_id` entries belonging to more than one `delayed_period` group were duplicated. For example, an `order_id` with 35 days_unbalance will appear twice in the output, once in group 17 and once in group 30. This is essential to capture the full contribution of each order to the different delinquency levels and to understand how risk accumulates.

As a bonus, since it was not specifically requested, I created a model capable of calculating the monthly default ratio. We will look at this next.

### Assumptions and comments to be shared

- I created mockups of the data sources to conduct real tests, understand the problem, and propose a solution. These can be found in the Data folder.
- We do not use is_in_default since the days_unbalanced field already serves to determine whether a loan is in default when it is greater than 0.
- In the aggregation of delayed_period, we are excluding delinquencies of 1 to 16 days, which are not being considered for the analysis. To address this, we should include an additional level in the analysis to account for them.
- In the aggregation of delayed_period, we assume that more than one order_id can be aggregated into more than one level. For example, an order with 35 days will be aggregated into levels 17 and 30 but not in 60 and 90 as it does not exceed these numbers.
- I assumed that the desired dataset is intended for visualization in a dashboard, which is why the dbt instruction is to create a table.

### Explanation of the model, queries and context

The idea here is to share with you some specifics of the analysis and comments without going into too much detail.

<u><strong>Texto en negrita y subrayado</strong></u>

In the **"staging"** phase, the idea was to create five views, one for each of the tables in our analytical model, to extract the data as well as perform some simple calculations.

The only notable point here is that in the stg_orders query, we create a new column called total_overdue, which we calculate by summing overdue_principal and overdue_fees.

```sql
-- stg_dim_shoppers
{{ config(
    materialized='view'
) }}

SELECT 
    shopper_id,
    age
FROM {{ source('seQura_dbt', 'dim_shoppers') }}

-- stg_merchants
{{ config(
    materialized='view'
) }}

SELECT 
    merchant_id,
    merchant_name
FROM {{ source('seQura_dbt', 'merchants') }}

-- stg_orders
{{ config(
    materialized='view'  
) }}

WITH raw_orders AS (
    SELECT 
        order_id,
        shopper_id,
        order_date,
        product_id,
        merchant_id,
        is_in_default,
        days_unbalanced,
        current_order_value,
        overdue_principal,
        overdue_fees
    FROM {{ source('seQura_dbt', 'orders') }}
)

SELECT 
    *,
    overdue_principal + overdue_fees AS total_overdue 
FROM raw_orders
WHERE current_order_value IS NOT NULL

-- stg_product
{{ config(
    materialized='view'
) }}

SELECT 
    product_id,
    product_name
FROM {{ source('seQura_dbt', 'products') }}

-- stg_rel_default_order_type
{{ config(
    materialized='view'
) }}

SELECT 
    default_type_id,
    order_id,
    default_type
FROM {{ source('seQura_dbt', 'rel_default_order_type') }}

```

