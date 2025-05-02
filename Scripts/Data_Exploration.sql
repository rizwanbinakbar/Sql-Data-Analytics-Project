-- 📅 Find the range of available order dates
SELECT 
  MIN(order_date) AS first_order_date,
  MAX(order_date) AS last_order_date,
  TIMESTAMPDIFF(day, MIN(order_date), MAX(order_date)) AS total_days
FROM g_fact_sales;

-- 👶👴 Identify youngest and oldest customers
SELECT 
  MAX(TIMESTAMPDIFF(year, birth_date, NOW())) AS oldest_age,
  MIN(TIMESTAMPDIFF(year, birth_date, NOW())) AS youngest_age,
  MAX(birth_date) AS youngest_birth_date,
  MIN(birth_date) AS oldest_birth_date
FROM g_dim_customers;
