/*
=========================================================================
							              Customer Report
=========================================================================
Purpose: 
		- The purpose consolidates key customer metrics & behaviours
	Highlights:
		1. Gather essential fields such as name, age, & transactional details
        2. Segments customer into categories (VIP, Regular & New) and age groups
        3. Aggregates customer-level metrics:
		  -- total orders
		  -- total sales
          -- total quantity
          -- total products
          -- lifespan (in months)
		4. Calculate valuable KPI's:
          -- recency (months since last order)
          -- average order value (AOV)
          -- average monthly spend
=========================================================================
*/

CREATE VIEW g_customer_report AS
(
WITH base_query AS(
/*  ---------------------------------------------------------------
1. Base Query: RetrSieves core columns from tables
    ---------------------------------------------------------------  */
SELECT 
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales,	
	f.quantity,
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	TIMESTAMPDIFF(year, c.birth_date, NOW()) AS age
FROM g_fact_sales f
LEFT JOIN g_dim_customers c
ON f.customer_key = c.customer_key
WHERE order_date IS NOT NULL
),
customer_aggregtion AS (
/*  ---------------------------------------------------------------
2. Customer Aggregation: Summarizes key elements at customer level
    ---------------------------------------------------------------  */
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	TIMESTAMPDIFF(month, MIN(order_date), MAX(order_date)) AS time_spam
FROM base_query
GROUP BY
	customer_key,
	customer_number,
	customer_name,
	age
)
/*  ---------------------------------------------------------------
3. Final Query: Comnines all customer results into one output
    ---------------------------------------------------------------  */
SELECT 
	customer_key,
	customer_number,
	customer_name,
	CASE 
		WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60 & Above'
	END age_group,
    CASE 
		WHEN time_spam >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN time_spam >= 12 AND total_sales<= 5000 THEN 'Regular'
		ELSE 'New'
	END cust_segmentation,
	last_order_date,
    TIMESTAMPDIFF(month, last_order_date, NOW()) AS recency,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	time_spam,
    -- Computing Average order value (AOV)
    CASE 
		WHEN total_orders = 0 THEN 0
        ELSE ROUND(total_sales/total_orders, 2)
	END avg_order_value,
    -- Computing Average monthly spent (AMO)
    CASE 
		WHEN time_spam = 0 THEN total_sales
        ELSE ROUND(total_sales/time_spam, 2)
	END avg_monthly_value
FROM customer_aggregtion
);


SELECT * FROM g_customer_report;
