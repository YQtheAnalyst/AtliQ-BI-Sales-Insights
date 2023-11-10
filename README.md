# Sales-Insights

This project is under continuous updating...

### Introduction
MatCore Hardware is a company which supplies computer hardware and peripherals in India, where the headquarters is located in Delhi. The sales director, Alex, faces lots of challenges including tracking the market sales in this dynamically growing market. However, the information he has is only Excel files with massive numbers, which contain information related to transactions, customers, markets etc.. So, he approached the data analyst team with the requirements that he would like to know about the business insights in different marketing areas -- north, south and central India.

This project is to analyze the sales insight in different marketing zones, visualize the key information, and generate the report to support decision-making for the sales director in MatCore. The main tools utilized are Excel, SQL and Tableau.


### Project Planning
Utilized AIMS grid to organize this project.

1. Purpose

To uncover the sales insights for sales team to support decision making, and to automate them to reduce manal time spend in data gathering.

2. Stakeholders

Sales director, marketing team, customer service team, data & analytics team and IT.

3. End results

An automated dashboard and a report provding sales insights in order to support data driven decision making.

4. Success criteria

Dashboard(s) uncovering sales order insights with the latest data available.
The sales team is able to make better decisions and prove 10% cost savings of total spend.


### Data cleaning and wrangling
* Please refer to the (data cleaning & wrangling.sql) for detail information

Firstly, I performed the data cleaning process to remove and fix inaccurate data with 4 main tasks, which included:

1. Identify and delete the rows where sales_amount is less than 0

2. Fix the typos of column names

3. Change all sales_amount to INR currency

4. Delete the Null values in the Markets table

Secondly, I performed the data wrangling process, to create 2 new tables for performance metrics for hoc analysis.

1. Create column Revenue

2. Create sales growth per quarter table

3. Create average sales amount/ quantity per customer table

hoc analysis questions:

1. Which marketing zone has the highest revenue?

2. Which customers contribute to the highest revenue in different zones?

3. What is the sales growth per quarter from 2017 to 2022? What about it in different zones?

4. What is the average revenue per customer in different zones? What can you learn about related to customer behaviour?

For detail information, please refer to the file (data cleaning & wrangling.sql)

### Data visualization
I visualized the business insights in Tableau to uncover the hidden patterns.
For further information, please refer to the Tableau Public, 
