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
