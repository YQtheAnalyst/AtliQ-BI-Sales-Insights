# Sales-Insights

This project is under continuous updating...

### Introduction
MatCore Hardware is a company which supplies computer hardware and peripherals in India, where the headquarters is located in Delhi. The sales director, Alex, faces lots of challenges including tracking the market sales in this dynamically growing market. However, the information he has is only Excel files with massive numbers, which contain information related to transactions, customers, markets etc.. So, he approached the data analyst team with the requirements that he would like to know about the business insights in different marketing areas -- north, south and central India.

This project is to analyze the sales insight in different marketing zones, visualize the key information, and generate the report to support decision-making for the sales director in MatCore. The main tools utilized are Excel, SQL and Tableau.


### Project Planning
Utilized AIMS grid to organize this project.

1. PURPOSE

To uncover the sales insights for the sales team to support decision making, and to automate them to reduce manual time spent in data gathering.

2. STAKEHOLDERS

Sales director, marketing team, customer service team, data & analytics team and IT.

3. END RESULTS

An automated dashboard and a report providing sales insights in order to support data-driven decision-making.

4. SUCCESS CRITERIA

Dashboard(s) uncovering sales order insights with the latest data available.
The sales team is able to make better decisions and prove 10% cost savings of total spend.


### Identify the problems
In order to solve the problems, I utilized 3 performance metrics to further study the sales insights -- revenue, sales growth per quarter, and average revenue per customer


### Data cleaning and wrangling
Firstly, I performed the data cleaning process to remove and fix inaccurate data with 4 main tasks, which included:

(1) Identify and delete the rows where sales_amount is less than 0

(2) Fix the typos of column names

(3) Change all sales_amount to INR currency

(4) Delete the Null values in the Markets table


Secondly, I performed the data wrangling process, where I created new columns and converted datasets into another format more suitable for further use.
(1) Create column Revenue

(2) Create tables containing two other performance metrics

(3) Combine multiple tables into one more appropriate form


For further information, please refer to the file (data cleaning & wrangling.sql)


### hoc analysis
This section focuses on preparing data to answer the following questions:
(1) Which marketing zone has the highest revenue?


### Data visualization
I visualized the business insights in Tableau to uncover the hidden patterns.
For further information, please refer to the Tableau Public, 
