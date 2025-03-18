# SQL PROJECTS

This projects explore data cleaning and exploratory data analysis using sql and explores skills such as SQL queries,JOINS,Unions,Window functions,bulding tables and schemas,data cleaning and data exploration using SQL.

## Customer Segmentation and Behaviour Analysis

## Table of Contents

   [Project_Overview](#project-overview)
   
   [Data_Source](#data-source)

   [Tools](#tools)

   [Data_Cleaning](#data-cleaning)

   [Exploratory_data_analysis](#exploratory-data-analysis)

   [Data_Analysis](#data-analysis)

   [Findings](#findings)

   [Recommendations](#recommendations)

   [Limitations](#limitations)

   [Referrences](#referrences)

     
   
### Project Overview
---

This project is designed to aid a business in crafting targeted marketing strategies,optimizing product offerings and enhancing customer satisfation.

### Data Source
---
The primary dataset 'shopping_trends.csv' was used for analysis,the data gives detailed information on shopping trends for a clothing store company.

### Tools
---
- SQL Server

### Data Cleaning
---

The following steps were taken in cleaning the data 
 1) Check and Remove duplicates
 2) Standardisation and fix errors
 3) Check for null and empty cells
 4) Removing unnecessary rows and columns.

### Exploratory Data Analysis
---

#### A Customer Segmentation

- Identify different age groups purchase item
- Find total purchase per age group
- Identify gender that purchase most products
- Identify frequency of purchase by gender and age group
- What is the location Purchase analysis?

### Data Analysis
---
Interesting codes I explored include :

```sql
SELECT `Customer ID`,`Age`,`Gender`,`Item Purchased`,`Category`,`Purchase Amount (USD)`,`Location`,`Size`,`Color`,`Season`,
             `Review Rating`,`Subscription Status`,`Shipping Type`,`Discount Applied`,`Promo Code Used`,`Previous Purchases`,`Payment Method`,
			`Frequency of Purchases`,count(*) AS duplicates
FROM  shopping_behaviour.shopping_behavior1 
GROUP BY `Customer ID`,`Age`,`Gender`,`Item Purchased`,`Category`,`Purchase Amount (USD)`,`Location`,`Size`,
                  `Color`,`Season`,`Review Rating`,`Subscription Status`,`Shipping Type`,`Discount Applied`,`Promo Code Used`,
                  `Previous Purchases`,`Payment Method`,`Frequency of Purchases`
 HAVING count(*) > 1;
```
``` sql
WITH CTE_PurchaseSummary AS (
    SELECT 
        `Age Group`, 
        `Item Purchased`, 
        COUNT(*) AS `Purchase Count`,
        SUM(`Purchase Amount (USD)`) AS `Total Purchase Amount`
    FROM 
        shopping_behaviour.shopping_behavior1
    GROUP BY 
        `Age Group`, `Item Purchased`
),
CTE_RollingTotal AS (
    SELECT 
        `Age Group`,
        `Item Purchased`,
        `Purchase Count`,
        `Total Purchase Amount`,
        SUM(`Total Purchase Amount`) OVER (
            PARTITION BY `Age Group`
            ORDER BY `Total Purchase Amount` DESC
        ) AS `Rolling Total Purchase Amount`
    FROM 
        CTE_PurchaseSummary
)
SELECT 
    `Age Group`,
    `Item Purchased`,
    `Purchase Count`,
    `Total Purchase Amount`,
    `Rolling Total Purchase Amount`
FROM 
    CTE_RollingTotal
ORDER BY 
    `Age Group` DESC, `Total Purchase Amount` DESC;
```

### Findings
---
- All age groups seem to buy all the items
- Males make the most purchases totalling to 2652,females make a total of 124 purchases.
- Males aged 56-70 who shop annually and quarterly have the highest purchase frequency.
- Montana has the highest purchases and purchase amount

### Recommendations
---
Based on the analysis,I recommend the following:
1) Offer personalised target marketing for the different age groups and genders based on their preferences
2) Offer more marketing strategies to areas already experiencing high sales to further boost sales
3) Identify low market sales location and reason for churn to identify best strategy in pricing,marketing and product inventory management.

### Limitations
---

- I removed all undefined ages as it would affect the findings and analysis of the overall project.

### Referrences
---
I used data analyst chat gtp sql optimization to help ease coding setbacks
  






 
  - 
