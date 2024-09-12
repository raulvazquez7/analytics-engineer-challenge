
# Technical Test (Part I)

## Shopper Recurrence Rate metric calculation

Shopper Recurrence is a metric representing the percentage of customers who have made a purchase with a merchant in the most recent closed month and have also made a purchase with the same merchant at least once in the 12 months including the closed month. This metric is a key indicator of customer loyalty and repeat business, providing insights into the effectiveness of the merchant’s offerings and customer engagement strategies.

![A1D4C177-4430-4220-AA88-859C1711F414_4_5005_c](https://github.com/user-attachments/assets/3b0b4544-ae2e-46ea-ba0b-077437cb8200)

The desired output should be the table `shopper_recurrence_rate` containing the following fields:

- `merchant_name`
- `month`
- `recurrence_rate`

## Output

[See csv output here!](https://github.com/raulvazquez7/analytics-engineer-challenge/blob/main/Part1/Output/monthly_recurrence_rate.csv)

### Analysis Objective

The main objective of the analysis is to calculate the recurrence rate of buyers for each specific month and merchant, evaluating how many buyers made recurring purchases with a merchant in a specific month and in the 12 months prior, including the month of analysis.

### Assumptions and comments to be shared

- The first assumption is that we are currently in January 2023, as the last closed month we have in the data is December 2022.
- We can only calculate recurrence for the months of December, November, and October because the last available month is September.
- Each row in the table represents a purchase, so to determine if a user has made a purchase in the last twelve months, we will directly check if they are present in any row in the last 12 months.
- I aimed to create a modular query using WITH expressions to make it structured, easy to understand, and easy to modify if necessary.
- I also wanted to create a query that is parameterizable and flexible so that by only changing the dates at the top, we can perform analyses for the months we want.
- The query we attached only loads results for one month; if we want to load historical data for several months, we would need to create a small process to automate it.

## Query

[See output query here!](https://github.com/raulvazquez7/analytics-engineer-challenge/blob/main/Part1/Queries/recurrence.sql)

### Explanation of the query and context

The idea here is to share with you some specifics of the analysis and comments without going into too much detail.

The first thing we do is declare two variables to make this query parameterizable.
- `analysis_month`: The first date of the analysis month where we want to measure recurrence. For example, if we set it to 2022-12-01, the analysis will be done on December.
- `start_month`: This date is calculated from the analysis_month; following the previous example, the start_month will be 2022-01-01.

```sql
--Declare date variables for analysis
DECLARE analysis_month DATE DEFAULT DATE('2022-12-01');  -- Define the month of analysis (Set for December)
DECLARE start_month DATE DEFAULT DATE_SUB(analysis_month, INTERVAL 11 MONTH);  -- Define the window start date
```

The first and second subqueries are just the extraction of data from our two main tables: orders, where purchases are recorded, and merchants, where we have the necessary merchant_name information.

```sql
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
```

The third subquery, last_month_shoppers, is used to extract the unique number of shopper_id who purchased in the last closed month along with order_date and merchant_id information, which will be used later to create the shopped_in_last_closed_month column.

```sql
last_month_shoppers AS (
  SELECT DISTINCT
    order_date,
    shopper_id,
    merchant_id
  FROM orders
  WHERE order_date BETWEEN analysis_month AND LAST_DAY(analysis_month)
),
```
