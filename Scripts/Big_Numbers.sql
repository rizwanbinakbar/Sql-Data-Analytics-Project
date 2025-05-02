-- 📈 Combined summary report for key metrics
SELECT 'Total Sales' AS measure_name, SUM(sales) AS measure_value FROM g_fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM g_fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM g_fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM g_fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM g_dim_products
UNION ALL
SELECT 'Total Customers', COUNT(DISTINCT customer_id) FROM g_dim_customers
UNION ALL
SELECT 'Customers Who Placed Orders', COUNT(DISTINCT customer_id) FROM g_dim_customers;
