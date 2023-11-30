#  Product Sales Insight - AtliQ Hardware

## Table of Contents
- [Technologies](#technologies)
- [Business Intelligence](#business-intelligence)
    - [Problem](#the-problem)
    - [Solution](#the-solution)
    - [Results](#results)
- [Project Planning](#Project-Planning)
- [Data Preprocessing](#data-preprocessing)
    - [Data Examing](#data-examing)
    - [Data Quality Report](#data-quality-report)
    - [Data Analysis](#data-analysis)
- [ETL](#etl-extract-transform-load)
- [Data Modeling](#data-modeling)
- [DAX: Metrics Build](#dax-metrics-build)
- [Dashboard](#dashboard)
- [Report](#report)
- [References](#references)

## Technologies

1. MySQL: Data Analysis

2. Microsoft Power BI: ETL (Extract, Transformation, and Load), data visualiztion

3. Power Query Editor

4. DAX Language 

5. Business Intelligence: Problem-solving, report generation

## Business Intelligence

AtliQ Hardware is a company which supplies computer hardware and peripherals to many of clients. Sales directors at this company has amounts of customer transaction data to manage, and that's where the problem comes in!

- ### The problem

    The company is experiencing sales decrease in recent years. The sales director consults with the BI team to consider how to approach two concerns:

    - How is the sales performance based on history records?

    - Why the company has sales decrease in recent years?

    However, these stakeholders currently don't have metrics in place to specifically measure the sales performance or strategies, and this is where I will start to do my work.

- ### The solution

    In order to address the stakeholder's needs, I gathered data from [database](https://codebasics.io/resources/sales-insights-data-analysis-project). I found that the following metrics have already been applied:

    - Sales quantity

    - Revenue

    By comparing the existing metrics, the company can understand the sales insights well. However, I would like to consider more metrics about customer loyalty to better understand **customer behaviour** in the company. The questions I put forward to help myself think further:

    - How much revenue / How many transactions does each customer contribute?

    - How many customers will repeat purchasing / does the company has lost?

    These metrics help company to explore the resaons for sales decrease behind the customer behaviour. I then organize this data within the database systems and load it to visualization software to generate dashboard and report for stakeholders to consider as they strategize how to increase sales performance.

- ### Results


## Project Planning

![AIM Grid](images/aims.png)

Reference: [@codebasics](https://www.youtube.com/watch?v=9QiZ0-HZG_A&list=PLeo1K3hjS3uva8pk1FI3iK9kCOKQdz1I9&index=2&ab_channel=codebasics)

## Data Preprocessing

First, I used MySQL to get a general view of the whole database and generate the data quality report for reference. The key points I will be focusing on include data types, count of rows, entries of categorical values, range of numerical values, incorrect values, null values, and so on.

### Data Examing

- Check the data types and Null values for tables
   
    ```
    USE sales;

    DESCRIBE transactions;

    SELECT * FROM markets 
    WHERE zone = '';
    ```

- Check the counts of the rows for tables

    ```
    SELECT COUNT(*) FROM transactions;
    ```

 - Check data integrity for categorical columns
    
    ```
    SELECT 
        COUNT(DISTINCT product_code) AS products_in_transactions
    FROM transactions;

    SELECT 
        COUNT(DISTINCT product_code) AS products_listed
    FROM products;
    ```

- Check distinct values for categorical column

    ```
    SELECT 
        DISTINCT currency 
    FROM transactions;
    ```

- Checked the time period for DATE column

    ```
    SELECT 
        MIN(order_date), 
        MAX(order_date) 
    FROM transactions;
    ```

- Check data range for numerical columns

    ```
    SELECT 
        COUNT(sales_amount)
    FROM transactions 
    WHERE sales_amount <= 0;
    ```

### Data Quality Report

- Lack of data in `product_code`

    I found there are 279 product codes in `product` reference table whilst 339 in `transaction` table. The null value will be generated if I try to JOIN two tables in the future

    Suggestion: Gather more information for `product` reference table to ensure data integrity or remove the null product in the following analysis

- Different currecies `INR` and `USD`

    Column `Currency` contains two different currencies, `INR` and `USD`. It also contains typos, `INR ` and `USD `

    Suggestion: Data transformation. Re-calculate the sales amount according to `INR` to unify the currency, and correct the typos

- Negative values in `sales_amount`

    Column `sales_amount` in table `transaction` contains negative values, which are incorrect

    Suggestions: Delete the rows with negative sales amounts

- Lack of data in Year `2017` and `2020`

    The database only contains data from Oct 2017 to June 2020

    Suggestions: Gather more data in Year 2017 and 2020 or analyze the existing data, but ensure to consider the factor of imcomplete data

- Redundant data in `market_names`

    Table `markets` include redundant market information `New York` and `Paris` which will not be considered in this analysis

    Suggestions: Delete the rows

### Data Analysis

The following codes present tables to answer the questions I put forward in the section [Business Intelligence](#the-solution)

- Check the yearly total revenue and sales quantity for each customer

    ```
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
    ```

- Count transaction times every year for each customer

    ```
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
    ```

- Count the total number of customers every year

    ```
    SELECT 
        YEAR(order_date) AS year, 
        COUNT(*) AS transaction_times
    FROM transactions
    GROUP BY 
        YEAR(order_date);
    ```

## ETL (Extract, Transform, Load)

In this step, data is extracted from SQL server, then is transformed with Power Query, and finally is is loaded to Power BI model. Based on the data quality report, the following transformations were implemented.

- Correct the typos `USD ` and `INR `

    ```
    /* Clean the text */
    = Table.TransformColumns(#"Removed Errors",{{"currency", Text.Clean, type text}})
    ```

- Calculate the sales amount in `INR`

    ```
    /* Creat a conditional column 'USD sales amount' where shows the USD sales amounts as original numbers, and INR sales amounts as 0 */
    = Table.AddColumn(#"Cleaned Text", "USD_sales_amount", each if [currency] = "USD" then [sales_amount] else 0)

    /* Multiply the new column by the currency ratio, 83.3 */
    = Table.AddColumn(#"Added Conditional Column", "INR_sales_amount", each [USD_sales_amount]*83.3)

    /* Create the conditional column which contains the correct INR sales amount*/
    = Table.AddColumn(#"Added Custom", "sales_amount_updated", each if [currency] = "INR" then [sales_amount] else if [currency] = "USD" then [INR sales amount] else null)
    ```

- Delete the non-positive values in `sales_amount`

    ```
    = Table.SelectRows(#"Renamed Columns", each [sales_amount] >= 0)
    ```

- Delete the redundant values in `market_name`

    ```
    /* Delete the markets names of New York and Paris */
    = Table.SelectRows(#"Changed Type1", each ([markets_name] <> "New York" and [markets_name] <> "Paris"))
    ```

## Data Modeling

![Data Modeling](images/model.png)

## DAX: Metrics Build

    - Revenue
    - Sales quanity
    - Repeat Purchase Rate = ``
    - Customer Churn Rate = ``
    - Customer Loyalty Rate = ``
  
## Dashboard

![Sales Insight](images/insight.png)

## Report

## References
https://codebasics.io/panel/webinars/purchases

https://www.coursera.org/professional-certificates/google-business-intelligence