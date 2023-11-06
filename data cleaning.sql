SELECT * FROM sales.transactions;
SELECT DISTINCT sales_qty FROM sales.transactions ORDER BY sales_qty;
SELECT DISTINCT sales_amount FROM sales.transactions ORDER BY sales_amount;

### 1 ###
# Delete the rows where sales_amount = 0 and -1
DELETE FROM sales.transactions WHERE sales_amount <= 0;


### 2 ###
# fix the type of column name
SELECT * FROM sales.customers;
ALTER TABLE sales.customers
RENAME COLUMN custmer_name to customer_name;


### 3 ###
# Change the currency from USD to INR
SELECT DISTINCT currency FROM sales.transactions;
-- Unify the 'INR', fix the typos
UPDATE sales.transactions
SET currency = "INR"
WHERE currency = "INR%"
;
-- Unify the 'USD', fix the typos
UPDATE sales.transactions
SET currency = "USD"
WHERE currency = "USD%"
;
-- Add a new column to the existing table
ALTER TABLE sales.transactions
ADD norm_sales_amount double;
-- Update the new column using a CASE statement
UPDATE sales.transactions
SET norm_sales_amount = 
  CASE 
	WHEN currency = "USD" THEN sales_amount*83
	ELSE sales_amount
  END;



