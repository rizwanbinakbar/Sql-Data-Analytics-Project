-- ================== Raw Data Preview ==================
-- Preview data from main fact and dimension tables
SELECT * FROM g_fact_sales;
SELECT * FROM g_dim_customers;
SELECT * FROM g_dim_products;

-- ================== Monthly Summary ==================
-- Generate monthly summary of total sales, distinct customers, and quantity sold
SELECT 
  YEAR(order_date) AS order_year,
  MONTH(order_date) AS order_month,
  SUM(sales) AS total_sales,
  COUNT(DISTINCT customer_key) AS total_customers,
  SUM(quantity) AS total_quantity
FROM g_fact_sales
WHERE MONTH(order_date) IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- Calculate total monthly sales using formatted date
SELECT 
  DATE_FORMAT(order_date, '%Y-%m-01') AS order_month,
  SUM(sales) AS total_sales
FROM g_fact_sales
WHERE MONTH(order_date) IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
ORDER BY DATE_FORMAT(order_date, '%Y-%m-01');

-- ================== Cumulative Analysis ==================
-- Calculate monthly sales, running total of sales, and moving average of prices
SELECT 
  order_month,
  total_sales,
  SUM(total_sales) OVER(PARTITION BY order_month ORDER BY order_month) AS runing_total,
  AVG(avg_price) OVER(ORDER BY order_month) AS moving_average
FROM (
  SELECT 
    DATE_FORMAT(order_date, '%Y-%m-01') AS order_month,
    SUM(sales) AS total_sales,
    AVG(price) AS avg_price
  FROM g_fact_sales
  WHERE order_date IS NOT NULL
  GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
) t;

-- ================== Performance Analysis ==================
-- Evaluate yearly performance using total and average sales
SELECT 
  YEAR(order_date) AS order_year,
  SUM(sales) AS tota_sales,
  AVG(sales) AS avg_sales
FROM g_fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_year;

-- Analyze yearly performance of each product by comparing to average and previous year's performance
WITH yearly_prod_sales AS (
  SELECT 
    YEAR(f.order_date) AS order_year,
    p.product_name,
    SUM(f.sales) AS current_sales
  FROM g_fact_sales f
  LEFT JOIN g_dim_products p ON f.product_key = p.product_key
  WHERE order_date IS NOT NULL
  GROUP BY YEAR(f.order_date), p.product_name
)
SELECT 
  order_year,
  product_name,
  current_sales,
  AVG(current_sales) OVER(PARTITION BY product_name) AS avg,
  current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
  CASE 
    WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Average'
    WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Average'
    ELSE 'Average'
  END AS flag_test,
  LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS py_sales,
  current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_sales,
  CASE 
    WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Sale increased'
    WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Sale decreased'
    ELSE 'Same sale'
  END AS sale_diff
FROM yearly_prod_sales
ORDER BY product_name, order_year;

-- ================== Part-to-Whole Analysis ==================
-- Determine sales contribution by category and sub-category
WITH category_sales AS (
  SELECT 
    p.category,
    p.sub_category,
    SUM(f.sales) AS total_sales
  FROM g_fact_sales f
  LEFT JOIN g_dim_products p ON p.product_key = f.product_key
  GROUP BY p.category, p.sub_category
)
SELECT 
  category,
  sub_category,
  total_sales,
  CONCAT((total_sales / SUM(total_sales) OVER()) * 100, '%') AS perc_of_overall_sales
FROM category_sales
ORDER BY perc_of_overall_sales DESC;

-- Determine sales contribution by country
SELECT 
  c.country,
  SUM(s.sales) AS total_sales,
  (SUM(s.sales) / total.total_sales) * 100 AS perc_of_total_sales
FROM g_fact_sales s
LEFT JOIN g_dim_customers c ON c.customer_key = s.customer_key,
  (SELECT SUM(sales) AS total_sales FROM g_fact_sales) AS total
GROUP BY c.country, total.total_sales
ORDER BY perc_of_total_sales DESC;

-- ================== Product Segmentation ==================
-- Segment products based on cost and count how many products fall into each segment
WITH product_segment AS (
  SELECT 
    product_key,
    product_name,
    cost,
    category,
    CASE 
      WHEN cost < 100 THEN 'Below 100'
      WHEN cost BETWEEN 100 AND 500 THEN '100-500'
      WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
      WHEN cost BETWEEN 1000 AND 1500 THEN '1000-1500'
      WHEN cost BETWEEN 1500 AND 2000 THEN '1500-2000'
      ELSE 'Above 2000'
    END AS cost_range
  FROM g_dim_products
)
SELECT 
  COUNT(product_key) AS total_products,
  cost_range
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC;

-- Additional product cost statistics
SELECT 
  MAX(cost),
  MIN(cost),
  AVG(cost)
FROM g_dim_products;

-- ================== Customer Segmentation ==================
/*
Segment customers into three categories based on their spending and purchase history:
  - VIP: At least 12 months history and spending over 5000
  - Regular: At least 12 months history and spending 5000 or less
  - New: Less than 12 months history
*/
WITH customer_spending AS ( 
  SELECT
    c.customer_key,
    SUM(f.sales) AS total_spending,
    MIN(f.order_date) AS first_order,
    MAX(f.order_date) AS last_order,
    TIMESTAMPDIFF(month, MIN(f.order_date), MAX(f.order_date)) AS life_spam
  FROM g_fact_sales f
  LEFT JOIN g_dim_customers c ON f.customer_key = c.customer_key
  GROUP BY c.customer_key
)
SELECT 
  customer_key,
  total_spending,
  life_spam,
  CASE 
    WHEN life_spam >= 12 AND total_spending > 5000 THEN 'VIP'
    WHEN life_spam >= 12 AND total_spending <= 5000 THEN 'Regular'
    ELSE 'New'
  END AS cust_type
FROM customer_spending
ORDER BY total_spending DESC;
