-- Question 1 
-- What are the total sales in different seasons (S1 - S4) from year 2017 to 2020?
SELECT
d.year, 
CASE
	WHEN d.month_name = "June" OR d.month_name = "July" OR d.month_name = "August" THEN "S2"
    WHEN d.month_name = "September" OR d.month_name = "October" OR d.month_name = "November" THEN "S3"
    WHEN d.month_name = "December" OR d.month_name = "January" OR d.month_name = "February" THEN "S4"
    ELSE "S1"
END AS season,
SUM(t.sales_qty*t.norm_sales_amount) AS revenue
FROM sales.date AS d
RIGHT JOIN sales.transactions AS t
ON d.date = t.order_date
GROUP BY d.year, season
ORDER BY revenue DESC
;


-- Question 2
-- What are the sales per product type? Which type made the highest sales revenue?
SELECT 
p.product_type,
SUM(t.sales_qty*t.norm_sales_amount) AS revenue
FROM sales.products AS p
RIGHT JOIN sales.transactions AS t
ON p.product_code = t.product_code
GROUP BY p.product_type
ORDER BY revenue DESC
;


-- Question 3
-- What are the sales per customer? Who has the highest sales revenue? Which selling type has highest sales revenue?
SELECT 
c.customer_name,
SUM(t.sales_qty*t.norm_sales_amount) AS revenue
FROM sales.customers AS c
RIGHT JOIN sales.transactions AS t
ON c.customer_code = t.customer_code
GROUP BY c.customer_name
ORDER BY revenue DESC
;

SELECT 
c.customer_type,
SUM(t.sales_qty*t.norm_sales_amount) AS revenue
FROM sales.customers AS c
RIGHT JOIN sales.transactions AS t
ON c.customer_code = t.customer_code
GROUP BY c.customer_type
ORDER BY revenue DESC
;


-- Question 4
-- Which market (city) has the highest sales reveune? What is the sales revenue in different zones?
SELECT 
m.markets_name,
SUM(t.sales_qty*t.norm_sales_amount) AS revenue
FROM sales.markets AS m
RIGHT JOIN sales.transactions AS t
ON m.markets_code = t.market_code
GROUP BY m.markets_name
ORDER BY revenue DESC
;

SELECT 
m.zone,
SUM(t.sales_qty*t.norm_sales_amount) AS revenue
FROM sales.markets AS m
RIGHT JOIN sales.transactions AS t
ON m.markets_code = t.market_code
GROUP BY m.zone
ORDER BY revenue DESC
;


-- Question 5
-- Which customer have bought the most products? 
SELECT 
c.customer_name,
SUM(t.sales_qty) AS sales_qty
FROM sales.customers AS c
RIGHT JOIN sales.transactions AS t
ON c.customer_code = t.customer_code
GROUP BY c.customer_name
ORDER BY sales_qty DESC
;