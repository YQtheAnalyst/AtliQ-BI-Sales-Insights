-- ------------------------DATA CLEANING ----------------------------

-- There are 4 tasks to do in data cleaning part, which are:
-- 1. Identify and delete the rows where sales_amount are less than 0
-- 2. Fix the typos of column names
-- 3. Change all sales_amount to INR currency
-- 4. Delete the Null values in Markets table

-- 1. Identify and delete the rows where sales_amount are less than 0

SELECT 
DISTINCT sales_amount 
FROM sales.transactions 
ORDER BY sales_amount;

DELETE FROM sales.transactions 
WHERE sales_amount <= 0;


-- 2. fix the typo of column name in the customer table

ALTER TABLE sales.customers
RENAME COLUMN custmer_name to customer_name;


-- 3. Calculate the sales_amount which are in USD to INR (1USD ~ 83INR) (part of data wrangling)

SELECT DISTINCT currency FROM sales.transactions;

-- Change all 'INR%' to 'INR'
UPDATE sales.transactions
SET currency = "INR"
WHERE currency LIKE "INR%"
;

-- Change all 'USD%' to 'USD'
UPDATE sales.transactions
SET currency = "USD"
WHERE currency LIKE "USD%"
;

-- Add a new column to the existing table, for further calculation purpose
ALTER TABLE sales.transactions
ADD norm_sales_amount double;

-- Calculate the sales_amount in INR unit, and store in the new column
UPDATE sales.transactions
SET norm_sales_amount = 
  CASE 
	WHEN currency = "USD" THEN sales_amount*83
	ELSE sales_amount
  END;
  
  
-- 4 Delete the Null values in Markets table
DELETE FROM sales.markets WHERE zone = "";



-- ------------------------DATA WRANGLING ----------------------------
-- There are 1 task to do in data wrangling section, generating 3 performace metrics:
-- Building the performance metrics:
-- (1) Revenue
-- (2) Sales growth per quarter
-- (3) Average revenue per customer by market zone / city

-- (1) Revenue = sales Quantity * Normalized Sales Amount

ALTER TABLE sales.transactions
ADD revenue double;

UPDATE sales.transactions
SET revenue = norm_sales_amount*sales_qty;


-- (2) Sales growth per quarter
SELECT
d.year, 
CASE
	WHEN d.month_name = "June" OR d.month_name = "July" OR d.month_name = "August" OR d.month_name = "May" THEN "Q2"
    WHEN d.month_name = "September" OR d.month_name = "October" OR d.month_name = "November" OR d.month_name = "December" THEN "Q3"
    ELSE "Q1"
END AS quarter,
SUM(t.sales_qty*t.norm_sales_amount) AS revenue
FROM sales.date AS d
RIGHT JOIN sales.transactions AS t
ON d.date = t.order_date
GROUP BY d.year, quarter
ORDER BY revenue DESC
;

-- (3) Average revenue per customer by market zone / city
SELECT * FROM sales.transactions;
SELECT 
m.zone,
ROUND(AVG(revenue),0) AS AVG_revenue
FROM sales.transactions AS t
LEFT JOIN sales.markets AS m
ON t.market_code = m.markets_code
GROUP BY m.zone
ORDER BY AVG_revenue DESC
;

SELECT 
m.markets_name,
ROUND(AVG(revenue),0) AS AVG_revenue
FROM sales.transactions AS t
LEFT JOIN sales.markets AS m
ON t.market_code = m.markets_code
GROUP BY m.markets_name
ORDER BY AVG_revenue DESC
;