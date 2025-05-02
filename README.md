# 🧠 Retail Sales Data Analysis with SQL

Welcome to my SQL portfolio project! This analysis dives deep into a retail sales dataset to extract meaningful business insights using advanced SQL techniques. The goal is to demonstrate real-world data analysis skills by building reports and answering performance-based questions across products, customers, and time.

---

## 📁 Dataset Structure

The dataset is structured in a star schema and includes the following tables:

- **g_fact_sales**: Transaction-level sales data
- **g_dim_customers**: Customer demographics and details
- **g_dim_products**: Product metadata (name, cost, category, etc.)

---

## 🔍 What This Project Covers

This project includes a mix of exploratory analysis, business performance evaluations, and creation of analytical views (reports). Here's a breakdown of what you'll find:

---

## 1️⃣ Exploratory Time-Series Analysis

These queries focus on **monthly trends** in sales and customer activity:

- Total sales, customers, and quantity per month
- Cumulative and moving averages for sales
- Yearly sales trends
- Performance analysis (sales growth & fluctuations)

---

## 2️⃣ Performance Deep-Dive

### 📊 Product Performance

Analyzed product sales over the years using:

- `LAG()` to compare sales with previous years
- `AVG()` to determine how products perform vs. their overall average
- Classification of products as *Above Average*, *Below Average*, or *Average*
- Sales increase or decrease flags

### 🌍 Regional & Category Analysis

- **Top-selling categories and sub-categories**
- **Sales contribution by country**
- Part-to-whole breakdown using percentage of total sales

---

## 3️⃣ Product Segmentation

Products were segmented based on their **cost range**:

- Ranges: `<100`, `100-500`, ..., `Above 2000`
- Count of products in each price range
- Also included: Max, Min, and Average product cost across all products

---

## 4️⃣ Customer Segmentation

Segmented customers into:

- **VIP**: At least 12 months of activity and spending > 5000
- **Regular**: 12+ months, spending ≤ 5000
- **New**: Less than 12 months of activity

---

## 📄 Reports Created as SQL Views

### 🧾 `g_product_report`

**Purpose**: A complete product dashboard with revenue, behavior, and KPIs  
**Highlights**:
- Total orders, customers, quantity, and sales per product
- Product lifespan and recency of last order
- Segmented as **High-Performer**, **Mid-Range**, or **Low-Performer**
- KPIs like Average Order Revenue and Monthly Revenue

### 🧾 `g_customer_report`

**Purpose**: Full view of customer behavior and segment performance  
**Highlights**:
- Customer age group and segmentation (VIP, Regular, New)
- Order, sales, quantity, and product metrics
- Recency of last order
- KPIs like Average Order Value and Average Monthly Spend

---

## 💡 Key SQL Techniques Used

- `WINDOW FUNCTIONS`: `LAG()`, `AVG() OVER`, `SUM() OVER`
- `COMMON TABLE EXPRESSIONS (CTEs)`
- `CASE` statements for segmentation logic
- `DATE FUNCTIONS`: `TIMESTAMPDIFF`, `DATE_FORMAT`, `YEAR`, `MONTH`
- `VIEWS`: Created reusable reporting layers

---

## 📌 Conclusion

This project showcases how SQL can be used not just for querying data, but for building analytical layers, deriving business KPIs, and supporting decision-making through well-structured insights.

Feel free to fork, study, or build upon it. Always open to feedback and collaboration!

---

**🔗 Author**: Rizwan Khan  
**📚 Tech Stack**: MySQL Workbench  
**🎯 Goal**: Practicing real-world data analysis & reporting using SQL
