
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
