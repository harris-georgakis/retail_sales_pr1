
-- Creation of Main Table
DROP TABLE retail_sales;

CREATE TABLE retail_sales (
transactions_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR (15),	
age INT,
category VARCHAR (15),	
quantity INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT

);



SELECT COUNT(*) AS Total_Data
FROM retail_sales rs ;

SELECT * 
FROM retail_sales
LIMIT 10;

---- Check if any rows are NULL
SELECT * 
FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL
OR gender IS NULL OR age IS NULL OR category IS NULL
OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;


-- Delete empty records
DELETE FROM retail_sales 
WHERE transactions_id IS NULL
OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL
OR gender IS NULL OR age IS NULL OR category IS NULL
OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;



--- Data Exploration

--- How many sales we have?

SELECT COUNT(*) AS Total_Sales
FROM retail_sales;

-- How many customers did we have?

SELECT COUNT(DISTINCT customer_id) AS Total_Customers
FROM retail_sales;


-- Retrieve the columns for sales made on '2022-04-11'

SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-04-11';


--- Retrieve all the transactions in the 'Clothing' category with total quantity of more than 10 for November 2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
 AND quantity >=4
  AND sale_date >= '2022-11-01' AND sale_date < '2022-12-01';



--- Get the total sales and orders for each category

SELECT category, SUM(total_sale) AS net_category_sale, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category
ORDER BY net_category_sale DESC


--- What is the average age of customers who purchases items from the 'Beauty' category?

SELECT ROUND(AVG(age),2) AS 'average Customers Age'
FROM retail_sales
WHERE category = 'Beauty'


--- Show me all transactions with a total_sale is greater than 1000


SELECT *
FROM retail_sales
WHERE total_sale > 1000


--- What was the total number of transactions made by each gender in each category?

SELECT 
     category,gender, COUNT(transactions_id) AS 'Total_Num_Transactions_By_Gender'
FROM retail_sales
GROUP 
    BY
     gender,
     category
ORDER BY 1;

--- What was the average sale for each month? Tell me the best selling month of each year


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


--- Who were the top 5 customers based on the highest total sales?

SELECT customer_id,
SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY total_sales DESC
LIMIT 5
;


--- Find the number of unique customers who purchases items from each category

SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

--- Create each shift and number of orders

WITH hourly_sales AS(
SELECT *,
  CASE 
	WHEN (EXTRACT(HOUR FROM sale_time))<12 THEN 'Morning/ M'
	WHEN (EXTRACT(HOUR FROM sale_time))BETWEEN 12 AND 17 THEN 'Afternoon/ A'
	ELSE'Evening/ E'
  END AS shift_timetable
FROM retail_sales)


SELECT shift_timetable, COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift_timetable;


--- End of the Project


