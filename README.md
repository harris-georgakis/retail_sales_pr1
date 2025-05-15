# Project Title: Retail Sales Data Analysis – Exploring Numbers that May Matter

## Project Overview

As an aspiring data analyst, I undertook this project to apply foundational SQL skills to a real-world dataset. By working with retail sales data, I practiced essential techniques—from database setup and cleaning to exploratory analysis and business insights—strengthening my ability to transform raw data into actionable information.


**Project Title**: Retail Sales Analysis  
**Database**: `retail_sales_analysis.db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.


## Goals
1. **Database Setup**:
     - Designed and populated a relational database to store retail sales data, ensuring proper table structures and relationships.
2. **Data Cleaning & Validation**: 
     - Identified and handled missing values, duplicates, and inconsistencies to ensure data reliability.
     - Standardized formats (e.g., dates, currencies) for accurate analysis.

3. **Exploratory Data Analysis (EDA)**:
    -  Analyzed sales trends, customer behavior, and product performance using aggregate functions and filtering.
    -  Visualized key metrics (e.g., revenue by region, top-selling products) to uncover patterns.

4. **Business Insights**:
    - Answered targeted questions (e.g., "Which products have the highest profit margins?" or "How do sales vary by season?") through structured SQL queries.
    - Drew conclusions to support potential business decisions, such as inventory planning or marketing strategies.

Tools used: SQL (PostgreSQL/MySQL), Excel (for initial data review).

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `pretail_sales_analysis.db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (cogs), and total sale amount.

```sql
CREATE DATABASE retail_sales_analysis.db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: What is the total number of records in this dataset?

- **Customer Count**: How many unique customers are in the dataset?
  
- **Category Count**: Identify all unique product categories in the dataset. Discover all the unique product categories for this dataset.
  
- **Null Value Check**: Check for any null values and delete records with missing data.

```sql

SELECT COUNT(*) AS Total_Data FROM retail_sales ;
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * 
FROM retail_sales
WHERE
      transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL
      OR gender IS NULL OR age IS NULL OR category IS NULL OR quantity IS NULL
      OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;

DELETE FROM retail_sales
WHERE 
      transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL
      OR gender IS NULL OR age IS NULL OR category IS NULL OR quantity IS NULL
      OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were crafted to address key business questions about our sales performance:

1. **Retrieve the columns for sales made on '2022-04-11'.**:
```sql
SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-04-11';
```

2. **Retrieve all the transactions in the 'Clothing' category with total quantity of more than 10 and specifically for November 2022.**:
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
 AND quantity >=4
  AND sale_date >= '2022-11-01' AND sale_date < '2022-12-01';
```

3. **Calculate the total sales and orders for each category.**:
```sql
SELECT
     category, SUM(total_sale) AS net_category_sale, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category
ORDER BY net_category_sale DESC
```

4. **What is the average age of customers who purchases items from the 'Beauty' category?**:
```sql
SELECT
    ROUND(AVG(age),2) AS 'average Customers Age'
FROM retail_sales
WHERE category = 'Beauty'
```

5. **Show me all transactions with a total_sale is greater than 1000.**:
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000
```

6. **What was the total number of transactions made by each gender in each category?**:
```sql
SELECT 
     category,gender,
     gender,
     COUNT(transactions_id) AS 'Total_Num_Transactions_By_Gender'
FROM retail_sales
GROUP BY
     gender,
     category
ORDER BY 1;
```

7. **What was the average sale for each month? Tell me the best selling month of each year?**:
```sql
 WITH table1 AS (
   SELECT 
     EXTRACT(year FROM sale_date) AS year,
     EXTRACT(month FROM sale_date) AS month,
     AVG(total_sale) AS avg_sale,
     RANK()OVER(PARTITION BY EXTRACT(year FROM sale_date) ORDER BY AVG(total_sale) DESC) AS Rank
   FROM retail_sales
       GROUP BY 1,2) 
     
SELECT year,
       month,
       avg_sale 
FROM table1
WHERE rank =1;
```

8. **Who were the top 5 customers based on the highest total sales?**:
```sql
SELECT
     customer_id,
     SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY total_sales DESC
LIMIT 5
;
```

9. **Find the number of unique customers who purchases items from each category.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```

10. **Create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).**:
```sql
WITH hourly_sale
AS
(
WITH hourly_sales AS(
SELECT *,
  CASE 
	WHEN (EXTRACT(HOUR FROM sale_time))<12 THEN 'Morning/ M'
	WHEN (EXTRACT(HOUR FROM sale_time))BETWEEN 12 AND 17 THEN 'Afternoon/ A'
	ELSE'Evening/ E'
  END AS shift_timetable
FROM retail_sales)

SELECT
   shift_timetable,
   COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift_timetable;

```

## Key Findings

Through this analysis, we uncovered several valuable insights about retail sales performance:

1. **Customer Segmentation**:
  -Our customer base spans multiple age groups, with distinct purchasing patterns across categories like Clothing and Beauty.
  -Top-spending customers were identified, revealing opportunities for loyalty programs or targeted promotions.
2. **Revenue Analysis**:
   - We detected high-value transactions (exceeding $1,000), indicating a premium customer segment worth further engagement.
   - Category performance metrics highlighted which product lines drive the most revenue.
3.  **Seasonal Trends**: 
   - Monthly sales fluctuations revealed clear peak seasons, enabling better inventory and staffing planning.
   - Certain product categories showed predictable seasonal demand patterns.

### Analytical Deliverables

To translate these findings into actionable business intelligence, we developed:

 **Sales Summary**:
- Comprehensive overview of total revenue, category performance, and customer demographics
- Key metrics segmented by time periods and product types.
**Trend Analysis Report**:
-Month-over-month sales comparisons
-Identification of growth opportunities and underperforming segments
  **Customer Insights**:
- Profiles of top-spending customers
- Category-specific customer engagement metrics

## Conclusion

This end-to-end analysis demonstrates how fundamental SQL skills can extract meaningful business intelligence from raw sales data. The methodologies employed - from initial data cleaning to advanced querying - provide a replicable framework for future data analysis projects.

## Author - Harris Georgakis

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Ways to Connect

Let's engage and connect in **LinkedIn**: [Connect with me professionally](https://gr.linkedin.com/in/charalamposgeorgakis)
