-- ------------------------DATA CLEANING ----------------------------

-- There are 4 tasks to do in data cleaning part, which are:
-- 1. Identify and delete the rows where sales_amount are less than 0
-- 2. Fix the typos of column names
-- 3. Change all sales_amount to INR currency
-- 4. Delete the Null values in Markets table

-- ------------------------Task 1------------------------------------

-- Identify the rows where sales_amount < 0
SELECT 
  DISTINCT sales_amount 
FROM 
  sales.transactions 
ORDER BY 
  sales_amount;

-- delete them
DELETE FROM 
  sales.transactions 
WHERE 
  sales_amount <= 0;


-- ------------------------Task 2------------------------------------

-- fix the typo of column name
ALTER TABLE 
  sales.customers
RENAME COLUMN 
  custmer_name to customer_name;


-- ------------------------Task 3------------------------------------

-- Identify the rows where currency is not inaccurate
SELECT DISTINCT 
  currency 
FROM 
  sales.transactions;

-- Change all 'INR%' to 'INR'
UPDATE 
  sales.transactions
SET 
  currency = "INR"
WHERE 
  currency LIKE "INR%"
;

-- Change all 'USD%' to 'USD'
UPDATE 
  sales.transactions
SET 
  currency = "USD"
WHERE 
  currency LIKE "USD%"
;

-- Add a new column to the existing table, for further calculation purpose
ALTER TABLE 
  sales.transactions
ADD 
  norm_sales_amount double;

-- for sales_amount where the currency is "USD", transform the figures to "INR"
UPDATE 
  sales.transactions
SET 
  norm_sales_amount = 
  CASE 
	  WHEN currency = "USD" THEN sales_amount*83
	  ELSE sales_amount
  END;
  

-- ------------------------Task 4------------------------------------
-- Delete the Null values in Markets table
DELETE FROM 
  sales.markets 
WHERE 
  zone = "";




-- -------------------------------------------------------------------
-- ------------------------DATA WRANGLING ----------------------------
-- Building tables present 3 performance metrics, as well as answering the following questions:
-- 0.0 Revenue
-- 0.1 Create the new table containing key information
-- 1. Which marketing zone has the highest revenue?
-- 2. Which customer contribute to the highest revenue in different zones?
-- 3. What is the sales growth per quarter from 2017 to 2022? What about it in different zones?
-- 4. What is the average revenue per customer in each zone? What can you learn about related to customer behaviour?

-- ------------------------Task 0.0------------------------------------
-- Create new column for further calculation purpose
ALTER TABLE 
  sales.transactions
ADD 
  revenue double;

-- Calculate Revenue = sales Quantity * Normalized Sales Amount
UPDATE 
  sales.transactions
SET 
  revenue = norm_sales_amount*sales_qty;


-- ------------------------Task 0.1------------------------------------
-- Combine the tables with neccessary information into one
CREATE TABLE 
	all_transaction
SELECT
	c.customer_name,
	m.markets_name,
	m.zone,
	t.order_date,
	t.sales_qty,
	t.norm_sales_amount,
	t.revenue
FROM 
	sales.transactions AS t
LEFT JOIN 
	sales.customers AS c ON c.customer_code = t.customer_code
LEFT JOIN 
	sales.markets AS m ON m.markets_code = t.market_code
;


-- ------------------------Task 1------------------------------------
-- Which marketing zone has the highest revenue?
-- Calculate the total revenue of each zone
SELECT
	zone,
	SUM(revenue) AS total_revenue
FROM
	all_transaction
GROUP BY 
	zone
ORDER BY 
	revenue ASC
;

-- Calculate the total revenue of each city
SELECT
	markets_name,
	SUM(revenue) AS total_revenue
FROM
	all_transaction
GROUP BY 
	markets_name
ORDER BY 
	revenue ASC
;


-- ------------------------Task 2------------------------------------
-- Which customer contribute to the highest revenue in different zones?
-- Calculate the total revenue of each zone, each customer
SELECT
	zone,
  customer_name,
	SUM(revenue) AS total_revenue
FROM
	all_transaction
GROUP BY 
	zone, customer_name
ORDER BY 
	revenue ASC
;


-- ------------------------Task 3------------------------------------
-- What is the sales growth per quarter from 2017 to 2022? What about it in different zones?
-- Create the table calculating the total revenue of each zone, per quarter
CREATE TABLE 
  sales_quarter
SELECT
	d.year,
	SUM(t.revenue) AS total_revenue,
  t.zone,
	CASE
		WHEN d.month_name = "June" 
      OR d.month_name = "July" 
      OR d.month_name = "August" 
      OR d.month_name = "May" 
      THEN "Q2"
		WHEN d.month_name = "September" 
      OR d.month_name = "October" 
      OR d.month_name = "November" 
      OR d.month_name = "December" 
      THEN "Q3"
		ELSE "Q1"
	END AS quarter
FROM 
	sales.date AS d
RIGHT JOIN 
	sales.all_transaction AS t ON d.date = t.order_date
GROUP BY 
	d.year, quarter
;


-- ------------------------Task 4------------------------------------
-- What is the average revenue per customer in each zone? What can you learn about related to customer behaviour?
-- Create the table calculating the average sales amount / quantity of each zone, per customer
CREATE TABLE 
  avg_sales_customer
SELECT
	zone,
  customer_name,
  ROUND(AVG(sales_qty),0) AS avg_sales_qty_percustomer,
  ROUND(AVG(norm_sales_amount),0) AS avg_sales
FROM 
	all_transaction
GROUP BY
	customer_name
;    