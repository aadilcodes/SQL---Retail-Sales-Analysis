-- SQL retail Sales Analysis - P1

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transactions_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(15),  -- IN EXCEL MAX(LEN(SELECT ROW))
		quantiy INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
);

SELECT * FROM retail_sales
LIMIT 10;

SELECT 
	COUNT(*)
FROM retail_sales;


-- DATA CLEANING 
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR 
	gender IS NULL
	OR
	category IS NULL
	or
	quantiy is null;

--
DELETE FROM retail_sales
WHERE quantiy IS NULL;

-- DATA EXPLORATION

-- How many sales we have?

SELECT 
	COUNT (*) as total_sale 
FROM retail_sales

-- How many UNIQUE customers we have?
SELECT 
	COUNT (DISTINCT(customer_id)) as total_sale 
FROM retail_sales

-- How many category we have we have?
SELECT 
	 DISTINCT(category)  
FROM retail_sales


-- DATA ANALYSIS & Business problems n answers

-- Q1. Write a sql query to retrieve all columns for sales made on '2022-11-05'

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2. write a query to retrieve all transcations where category is clothing and qty sold is 
-- more than 4 in the month of nov-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date,'yyyy-mm') = ('2022-11')
	AND 
	quantiy >= 4;

-- Q3 Write sql query to calculate the total sales (total_sale) for each category.

SELECT
	Category,
	SUM(total_sale) as net_sale,
	COUNT(*) AS total_orders
from retail_sales
group by 1

-- Q4 Write a sql query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
	ROUND(avg(age),2) AS avg_Age
From retail_sales
Where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT
	category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales
GROUP BY category,
		 gender
ORDER BY 1

-- Q.7 Write a sql query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	year,
	month,
	AVG_total_Sale
FROM
	(
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as AVG_total_Sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS RANK
	FROM retail_sales
	GROUP BY 1,2
	) as t1
where rank = 1
--ORDER BY 1,3 DESC


-- Q8 write a sql query to find the top 5 customers based onthe higest total sales

SELECT 
	   customer_id,
	   SUM(total_sale) as total_Sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q9 write a sql query to find the number of unique customers who purchased items from each category.

SELECT 
	category,
	COUNT(DISTINCT(customer_id))
FROM retail_sales
GROUP BY 1

-- Q10 Write a sql query to create each shift and number of orders (Example morning <=12 ,
-- afternoon between 12 -17, evening >17)

WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR from sale_time)< 12 THEN 'Morning'
		WHEN EXTRACT(HOUR from sale_time) BETWEEN 12 AND 17  THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT shift,
	COUNT(*) as total_orders
FROM hourly_sale
Group BY shift

-- end of prject