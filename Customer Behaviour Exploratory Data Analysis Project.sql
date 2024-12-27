-- Exploratory Data Analysis

-- DATASET Consumer Behavior Kaggle
-- aiding businesses in crafting targeted marketing strategies, optimizing product offerings, and enhancing overall customer satisfaction.

-- Skills used:CTE's, Derived Tables, Windows Functions, Aggregate Functions, 

USE shopping_behaviour;

SELECT *
FROM shopping_behaviour.shopping_behavior1;

-- Distinct ages
SELECT DISTINCT age
FROM shopping_behaviour.shopping_behavior1
ORDER BY 1;

-- Group ages for a unified analysis

ALTER TABLE shopping_behaviour.shopping_behavior1
ADD COLUMN `Age Group` VARCHAR(10); 

UPDATE shopping_behaviour.shopping_behavior1
SET `Age Group` = CASE
    WHEN `Age` BETWEEN 18 AND 25 THEN '18-25'
    WHEN `Age` BETWEEN 26 AND 35 THEN '26-35'
    WHEN `Age` BETWEEN 36 AND 45 THEN '36-45'
    WHEN `Age` BETWEEN 46 AND 55 THEN '46-55'
    WHEN `Age` BETWEEN 56 AND 70 THEN '56-70'
    ELSE 'Out of Range' 
END;

SELECT *
FROM shopping_behaviour.shopping_behavior1;


-- A Customer Segmentation

-- Identify different age groups purchase item

SELECT 
    `Age Group`, 
    GROUP_CONCAT(DISTINCT `Item Purchased` ORDER BY `Item Purchased` ASC) AS `Distinct Items`
FROM 
    shopping_behaviour.shopping_behavior1
GROUP BY 
    `Age Group`
ORDER BY 
    `Age Group`;

-- All age groups seem to buy all the items 

-- Find total purchase per age group

SELECT 
    `Age Group`, 
    `Item Purchased`, 
    COUNT(*) AS `Purchase Count`,
    SUM(`Purchase Amount (USD)`) AS `Total Purchase Amount`
FROM 
    shopping_behaviour.shopping_behavior1
GROUP BY 
      `Age Group`,`Item Purchased`
ORDER BY 
    `Age Group`DESC, `Total Purchase Amount` DESC;
    
-- To find the rolling Total purchases for each age group

-- a) Using CTE'S 

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

-- Using a derived table
    
SELECT 
    `Age Group`,
    `Item Purchased`,
    `Purchase Count`,
    `Total Purchase Amount`,
    SUM(`Total Purchase Amount`) OVER (
        PARTITION BY `Age Group`
        ORDER BY `Total Purchase Amount` DESC
    ) AS `Rolling Total Purchase Amount`
FROM (
    SELECT 
        `Age Group`, 
        `Item Purchased`, 
        COUNT(*) AS `Purchase Count`,
        SUM(`Purchase Amount (USD)`) AS `Total Purchase Amount`
    FROM 
        shopping_behaviour.shopping_behavior1
    GROUP BY 
        `Age Group`, `Item Purchased`
) AS CTE_PurchaseSummary
ORDER BY 
    `Age Group` DESC, `Total Purchase Amount` DESC;
    
-- In summary age group 56-70 have a totsl of 65256USD,Age group 46-55 total of 45619USD,Age group 36-45 total of 43234USD,age group 26-35 total of 44342USD and age group 18-25 have a total of 34630USD

    
SELECT *
FROM shopping_behaviour.shopping_behavior1;

-- Identify gender that purchase most products

SELECT 
    `Gender`, 
    COUNT(*) AS `Total Purchases`
FROM 
    shopping_behaviour.shopping_behavior1
GROUP BY 
    `Gender`
ORDER BY
    `Total Purchases` DESC;
    
    -- Males make the most purchases totalling to 2652,females make a total of 124 purchases.
SELECT *
FROM shopping_behaviour.shopping_behavior1;

-- Identify frequency of purchase by gender and age group 

SELECT 
    `Gender`,`Age Group`,`Frequency of Purchases`,
    COUNT(*) AS `Purchase Frequency`
FROM 
    shopping_behaviour.shopping_behavior1
GROUP BY 
    `Gender`,`Age Group`,`Frequency of Purchases`
ORDER BY
    `Purchase Frequency` DESC;
    
-- Males aged 56-70 who shop annually and quarterly have the highest purchase frequency.

-- Location Puchase analysis
SELECT `Location`,count(*) as `Total Purchases`,SUM(`Purchase Amount (USD)`) as `Total Purchase Amount`
FROM
    shopping_behaviour.shopping_behavior1
GROUP BY `Location`
ORDER BY
    `Total Purchase Amount` DESC;
    
-- Montana has the highest purchases and purchase amount

-- to find top items sold in each location

SELECT 
    `Location`,
    `Item Purchased`,
    COUNT(*) AS `Purchase Count`,
    SUM(`Purchase Amount (USD)`) AS `Total Purchase Amount`
FROM 
    shopping_behaviour.shopping_behavior1
GROUP BY 
    `Location`, `Item Purchased`
ORDER BY 
    `Location`, `Purchase Count` DESC;

