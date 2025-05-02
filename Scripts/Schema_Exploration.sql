-- View basic data structure and contents
SELECT * FROM g_fact_sales;
SELECT * FROM g_dim_products;
SELECT * FROM g_dim_customers;

-- Check the list of all tables in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- Check column details for a specific table
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 's_crm_prd_info';
