/*
=========================================================================
							             Products Report
=========================================================================
Purpose: 
		- The purpose consolidates key products metrics & behaviours
	Highlights:
		1. Gather essential fields such as product name, category, & sub-category and cost
        2. Segments product by revenue to identify High-performers, Medium-range or Low-perfomers
        3. Aggregates product-level metrics:
		  -- total orders
		  -- total sales
          -- total quantity
          -- total customers (unique)
          -- lifespan (in months)
		4. Calculate valuable KPI's:
          -- recency (months since last order)
          -- average order revenue (AOR)
          -- average monthly spend
=========================================================================
*/
SELECT * FROM g_dim_products;
CREATE VIEW g_product_report AS
(
WITH base_query AS(
/*  ---------------------------------------------------------------
1. Base Query: RetrSieves core columns from tables
    ---------------------------------------------------------------  */
SELECT 
	f.order_number,
	f.order_date,
    f.customer_key,
	f.sales,	
	f.quantity,
	p.product_key,
    p.product_name,
	p.category,
    p.sub_category,
    p.cost
FROM g_fact_sales f
LEFT JOIN g_dim_products p
	ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
),
product_aggregation AS (
/*  ---------------------------------------------------------------
2. Product Aggregation: Summarizes key elements at product level
    ---------------------------------------------------------------  */
SELECT 
	product_key,
	product_name,
	category,
	sub_category,
    cost,
    TIMESTAMPDIFF(month, MIN(order_date), MAX(order_date)) AS time_spam,
    MAX(order_date) AS last_sale_date,
	COUNT(DISTINCT order_number) AS total_orders,
    COUNT(DISTINCT customer_key) AS total_customers,
	SUM(sales) AS total_sales,
	SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
FROM base_query
GROUP BY
	product_key,
	product_name,
	category,
	sub_category,
    cost
)
/*  ---------------------------------------------------------------
3. Final Query: Comnines all product results into one output
    ---------------------------------------------------------------  */
SELECT 
	product_key,
	product_name,
	category,
    sub_category,
    cost,
    last_sale_date,
    TIMESTAMPDIFF(month, last_sale_date, NOW()) AS recency,
	CASE 
		WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales > 10000 THEN 'Mid-Rande'
        ELSE 'Low-Performer'
	END product_segment,
	time_spam,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    -- Computing Average order revenue (AOR)
    CASE 
		WHEN total_orders = 0 THEN 0
        ELSE ROUND(total_sales/total_orders, 2)
	END avg_order_revenue,
    -- Computing Average monthly revenue (AMR)
    CASE 
		WHEN time_spam = 0 THEN total_sales
        ELSE ROUND(total_sales/time_spam, 2)
	END avg_monthly_revenue
FROM product_aggregation
);


SELECT * FROM g_product_report;
