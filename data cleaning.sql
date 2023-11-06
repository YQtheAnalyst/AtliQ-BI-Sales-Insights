-- There are three tasks to do in data cleaning part, which are:
-- 1. Delete the rows where sales_amount and sales_qty are less than and equal to 0 
-- 2. Fix the typos of column names
-- 3. Change all sales_amount to INR currency
SELECT * FROM sales.transactions;

-- 1. Delete the rows where sales_amount and sales_qty (sales quantity) are less than 0
SELECT DISTINCT sales_qty FROM sales.transactions ORDER BY sales_qty;
SELECT DISTINCT sales_amount FROM sales.transactions ORDER BY sales_amount;

DELETE FROM sales.transactions WHERE sales_amount <= 0;


-- 2. fix the typo of column name in the customer table
SELECT * FROM sales.customers;

ALTER TABLE sales.customers
RENAME COLUMN custmer_name to customer_name;


-- 3. Calculate the sales_amount which are in USD to INR (1USD ~ 83INR)
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