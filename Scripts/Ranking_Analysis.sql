-- 🏆 Top 5 revenue-generating products
SELECT p.product_name, SUM(f.sales) AS total_revenue
FROM g_fact_sales f
LEFT JOIN g_dim_products p ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- 🥄 Bottom 5 products by revenue
SELECT p.product_name, SUM(f.sales) AS total_revenue
FROM g_fact_sales f
LEFT JOIN g_dim_products p ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC
LIMIT 5;

-- 💸 Top 10 customers by revenue
SELECT c.customer_id, c.first_name, c.last_name, SUM(f.sales) AS total_sales
FROM g_fact_sales f
LEFT JOIN g_dim_customers c ON c.customer_key = f.customer_key
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_sales DESC
LIMIT 10;

-- 🔻 3 customers with the fewest orders
SELECT c.customer_key, c.first_name, c.last_name, COUNT(DISTINCT order_number) AS total_orders
FROM g_fact_sales f
LEFT JOIN g_dim_customers c ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_orders ASC
LIMIT 3;
