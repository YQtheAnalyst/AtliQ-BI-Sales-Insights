#  Product Sales Insight - AtliQ Hardware

## Table of Contents
- [Technologies](#technologies)
- [Business Intelligence](#business-intelligence)
- [Project Planning](#Project-Planning)
- [Data Examing & Data Quality Report](#data-examing--data-quality-report)
- [Descriptive Analysis](#descriptive-analysis)
- [Data Cleaning & ETL](#data-cleaning--etl-extract-transform-load)
- [Data Modeling](#data-modeling)
- [DAX: Metrics Build](#dashboard)
- [Dashboard](#Dashboard)
- [Report](#Report)
- [References](#References)

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

 #### AIMS Grid
**1. Purpose** To unlock sales insights that are not visible before for the sales them for decision support and automate them to reduced manual time spent in data gathering. To find out if customer behaviour influences the sales performance.
     
**2. Stakeholders** 
- Sales Director
- Marketing Team 
- Customer Service Team
- Data and Analytics Team
- IT 
     
**3. End result** An automated dashboard providing quick and latest sights in order to support Data driven decision making.
     
**4. Success Criteria**
- Dahboard uncovering sales order insights with latest data available
- Dashboard uncovering the customer behaviour
- Sales team able to take better decisions and prove 10% cost saving of total spend.
- Sales analysis stop data gathering manually in order to save 20% business time andreinvest it value added activity.


## Data Examing & Data Quality Report

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

- Negative values in sales amount

    Column `sales_amount` in table `transaction` contains negative values, which are incorrect

    Suggestions: Delete the rows with negative sales amounts

- Lack of data in Year `2017` and `2020`

    The database only contains data from Oct 2017 to June 2020

    Suggestions: Gather more information about Year 2017 and 2020 or analyze the existing data, but ensure to consider the factor of imcomplete data

- Redundant data in market names

    Table `markets` include redundant market information `New York` and `Paris` which will not be considered in this analysis

    Suggestions: Delete the rows

## Descriptive Analysis

The following codes present tables to answer the questions I put forward in the section [Business Inteligence](#the-solution)

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

## Data Cleaning & ETL (Extract, Transform, Load)

- Data Loading

    Connect the MySQL server to the Power BI desktop, and load database

- Data Cleaning & Transformation

    According to the data quality report, transform the tables with Power Query

    `hh`

## Data Modeling

## DAX: Metrics Build

    - Revenue
    - Sales quanity
    - Repeat Purchase Rate = ``
    - Customer Churn Rate = ``
    - Customer Loyalty Rate = ``
  
## Dashboard

## Report

## References
https://codebasics.io/panel/webinars/purchases

https://www.coursera.org/professional-certificates/google-business-intelligence