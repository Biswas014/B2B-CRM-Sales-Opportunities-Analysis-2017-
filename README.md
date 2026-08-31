# B2B CRM Sales Opportunities Analysis (2017)
An advanced SQL analytics project focused on analyzing sales opportunities, sales cycle length, deal stages, win rates, and revenue generated from successful deals.

## Project Overview
This project analyzes a B2B sales process in which businesses are the accounts being targeted by sales teams. The sales journey is explored from identifying potential accounts and managing opportunities to negotiating and closing deals.
The analysis focuses on sales opportunities, deal stages, sales cycle length, win rates, revenue generation, product performance, sales-agent performance, and regional differences.

## Tech Stack
SQL – Used for data exploration, analysis, aggregation, joins, subqueries, CTEs, and business analysis.

PostgreSQL – Relational database management system used to store the CRM data and execute analytical queries.

## Dataset
The dataset contains 8,800 sales opportunities recorded throughout 2017. It consists of four tables covering product information, account details, sales agent information, and opportunity-level sales pipeline data, including deal stages and closing values.

Link: [Maven Analytics]( https://mavenanalytics.io/data-playground/crm-sales-opportunities)

## Highlights

### Business Problem
Despite generating millions in revenue, the business wants to identify opportunities to improve sales efficiency, shorten the sales cycle, increase deal conversion, and understand differences in performance across products, accounts, sales agents, and regions.
The analysis aims to answer the following questions:
1. Which deals closed at a value higher than the product's list price? 
2. Which accounts have never had a single won deal? 
3. Which sales agents generated closed revenue above the average revenue across all sales agents? 
4. What is the average sales cycle length for each product series? 
5. How did revenue vary across months and quarters in 2017? 
6. For each regional office, what were the total won revenue, win rate, average sales cycle length, and top-performing sales agent by won revenue?

### Key Findings
💡 8,800 opportunities in 2017, of which 4,238 were won and 2,089 were still open.

💡 Won opportunities generated approximately $10 million in revenue.

💡Sales agent Darcel Schlecht handled the highest number of opportunities, maintained a strong win rate, and generated the highest won revenue. Whereas, Wilburn Farren handled fewest opportunities but with a higher win rate.

💡Out of 4238 won deals, 2040 deals were ended with a higher closing value than the actual list price of a product.

💡 GTK had the longest average sales cycle at 54 days, around 6 days longer than the other product series.

💡There were no such a company where the deal ended with zero won opportunity.

💡Revenue declined noticeably in April, July and October months compared with the preceding months, while June recorded the highest monthly revenue followed by September and march.

💡The west region generated the highest revenue with an average sales cycle of 48 days.

### Recommendations
•	The practices followed by the top-performing sales agent could be studied and incorporated into agent training to improve the number of won opportunities.

•	The GTK product series recorded the longest sales cycle and should be investigated further to identify potential bottlenecks, such as pricing, product-related issues, or gaps in agent training.

•	Months with significant revenue declines compared with the preceding months should be investigated to identify the factors contributing to these fluctuations.

## Project Workflow
1. Data Import & Database Setup 
Created a CRM database in postgresql, the required tables, and imported the raw csv files 

2 Data Exploration & Quality Checks  
Examined table structures, duplicate entries, and missing records. 

3.Data Analysis 
Analyzed sales opportunities, deal stages, sales cycle length, revenue, win rates, sales agents, products, accounts, and regional performance.

## The Project Schema
![CRM Sales Schema](B2B-CRM-Sales-Opportunities-Analysis-2017-/Schema Structure/CRM_Sales_Schema.JPG)


