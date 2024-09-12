
# Technical Test (Part I)

## Shopper Recurrence Rate metric calculation

Shopper Recurrence is a metric representing the percentage of customers who have made a purchase with a merchant in the most recent closed month and have also made a purchase with the same merchant at least once in the 12 months including the closed month. This metric is a key indicator of customer loyalty and repeat business, providing insights into the effectiveness of the merchant’s offerings and customer engagement strategies.

![Shopper Recurrence Rate Calculation](https://prod-files-secure.s3.us-west-2.amazonaws.com/e408a58c-bbac-400d-95de-0fcf6af49619/be2c2516-1a18-4ecc-b65d-4d78e6c36b0f/image.png)

The desired output should be the table `shopper_recurrence_rate` containing the following fields:

- `merchant_name`
- `month`
- `recurrence_rate`
