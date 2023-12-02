-- ------------------------DATA CLEANING ----------------------------

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

-- ------------------------Task 0.1------------------------------------
-- Combine the tables with neccessary information into one, for the convience of further analysis
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
-- Create the table calculating the total revenue of each zone for each month
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
-- Create the table calculating the average sales amount / quantity of each zone
CREATE TABLE 
  avg_sales_customer
SELECT
	markets.zone,
	ROUND(AVG(norm_sales_amount),0) AS avg_sales,
	ROUND(AVG(sales_qty),0) AS avg_sales_qty
FROM 
	transactions
LEFT JOIN 
  markets ON markets.markets_code = transactions.market_code
LEFT JOIN 
  customers ON customers.customer_code = transactions.customer_code
GROUP BY
	markets.zone
;


-- ------------------ data analysis --------------------
SELECT * FROM sales.transactions;

-- check the data types of table "transactions"
USE sales;

DESCRIBE transactions;

SELECT 
	COUNT(*) 
FROM transactions;


-- check the listed codes and reference codes

-- Product
-- product codes: 279; products in transactions: 339
SELECT 
	COUNT(DISTINCT product_code) 
FROM transactions;

SELECT 
	COUNT(DISTINCT product_code) 
FROM products;

-- Market
-- markets codes: 17; markets in transactions: 15
SELECT 
	COUNT(DISTINCT market_code) 
FROM transactions;

SELECT 
	COUNT(DISTINCT market_code) 
FROM markets;

-- Customer
-- customer codes: 38; customers in transactions: 38
SELECT 
	COUNT(DISTINCT customer_code) 
FROM transactions;

SELECT 
	COUNT(DISTINCT customer_code) 
FROM customers;


-- check the date range
SELECT 
	MIN(order_date), 
	MAX(order_date) 
FROM transactions;

-- Select the rows where sales amount is non positive
SELECT 
	COUNT(sales_amount) 
FROM transactions
WHERE sales_amount <= 0;

-- Select rows which are redundant
SELECT * FROM markets
WHERE zone = '';


-- ------------------------------------------------------------------
-- Check the yearly total revenue and sales quantity for each customer
SELECT 
    customer_code, 
    YEAR(order_date) AS year, 
    SUM(sales_amount)AS total_sales_amount, 
    SUM(sales_qty) AS total_sales_qty
FROM transactions
GROUP BY 
    customer_code, YEAR(order_date)
ORDER BY 
    customer_code;

-- Count transaction times every year for each customer
SELECT 
    c.custmer_name, 
    YEAR(t.order_date) AS year, 
    COUNT(*) AS transaction_times
FROM transactions AS t
LEFT JOIN 
    customers AS c ON c.customer_code = t.customer_code
GROUP BY 
    t.customer_code, YEAR(t.order_date)
ORDER BY 
    c.custmer_name;

-- Count the total number of customers every year
SELECT 
    YEAR(order_date) AS year, 
    COUNT(*) AS transaction_times
FROM transactions
GROUP BY 
    YEAR(order_date);