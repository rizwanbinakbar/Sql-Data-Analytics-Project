-- 💰 Total revenue (sales)
SELECT SUM(sales) AS total_sales FROM g_fact_sales;

-- 📦 Total quantity of items sold
SELECT SUM(quantity) AS sold_items FROM g_fact_sales;

-- 💵 Average selling price
SELECT AVG(price) AS avg_price FROM g_fact_sales;

-- 📦 Total number of distinct products
SELECT COUNT(DISTINCT product_name) AS total_products FROM g_dim_products;

-- 🧍‍♂️ Total number of distinct customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM g_dim_customers;

-- 🛒 Total number of orders placed
SELECT COUNT(DISTINCT order_number) AS total_orders FROM g_fact_sales;
