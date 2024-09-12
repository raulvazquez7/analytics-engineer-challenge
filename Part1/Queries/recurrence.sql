--Declare date variables for analysis
DECLARE analysis_month DATE DEFAULT DATE('2022-12-01');  -- Define the month of analysis (Set for December)
DECLARE start_month DATE DEFAULT DATE_SUB(analysis_month, INTERVAL 11 MONTH);  -- Define the window start date

WITH orders AS (
  SELECT 
    order_id,
    shopper_id,
    merchant_id,
    order_date 
  FROM `burnished-flare-384310.seQura.orders`
),

merchants AS (
  SELECT 
    merchant_id,
    merchant_name 
  FROM `burnished-flare-384310.seQura.merchants`
),

last_month_shoppers AS (
  SELECT DISTINCT
    order_date,
    shopper_id,
    merchant_id
  FROM orders
  WHERE order_date BETWEEN analysis_month AND LAST_DAY(analysis_month)
),

previous_shoppers AS (
  SELECT DISTINCT 
    orders.shopper_id,
    orders.merchant_id
  FROM orders
  INNER JOIN last_month_shoppers ON orders.shopper_id = last_month_shoppers.shopper_id AND orders.merchant_id = last_month_shoppers.merchant_id
  WHERE orders.order_date BETWEEN start_month AND LAST_DAY(analysis_month)
  AND orders.order_date < analysis_month  -- Exclude orders on analysis month
),

analysis_month_recurrent_shoppers AS (
  SELECT 
    shopper_id,
    merchant_id
  FROM orders
  WHERE order_date BETWEEN analysis_month AND LAST_DAY(analysis_month)
  GROUP BY shopper_id, merchant_id
  HAVING COUNT(order_id) > 1  -- Detect multiples orders in the same month (on the same merchant_id)
),

output AS (
  SELECT 
    orders.order_date,
    orders.order_id,
    orders.shopper_id,
    CASE WHEN last_month_shoppers.shopper_id IS NULL THEN FALSE ELSE TRUE END AS shopped_in_last_closed_month,
    CASE WHEN previous_shoppers.shopper_id IS NOT NULL OR analysis_month_recurrent_shoppers.shopper_id IS NOT NULL THEN TRUE ELSE FALSE END AS recurrent_shopper,
    orders.merchant_id,
    merchants.merchant_name
  FROM orders
  LEFT JOIN merchants ON orders.merchant_id = merchants.merchant_id
  LEFT JOIN last_month_shoppers ON orders.shopper_id = last_month_shoppers.shopper_id AND orders.order_date = last_month_shoppers.order_date
  LEFT JOIN previous_shoppers ON orders.shopper_id = previous_shoppers.shopper_id AND orders.merchant_id = previous_shoppers.merchant_id
  LEFT JOIN analysis_month_recurrent_shoppers ON orders.shopper_id = analysis_month_recurrent_shoppers.shopper_id AND orders.merchant_id = analysis_month_recurrent_shoppers.merchant_id
),

recurrence_rate AS (
  SELECT 
    merchant_name,
    FORMAT_DATE('%Y-%m', analysis_month) AS month,
    ROUND(100 * COUNT(DISTINCT CASE WHEN recurrent_shopper THEN shopper_id END) / COUNT(DISTINCT shopper_id), 2) AS recurrence_rate
  FROM output
  GROUP BY merchant_name, month
)

SELECT 
* 
FROM recurrence_rate
ORDER BY month, merchant_name;

