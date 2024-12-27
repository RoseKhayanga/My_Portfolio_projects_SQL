-- Data Cleaning 

-- DATASET Consumer Behavior Kaggle
-- aiding businesses in crafting targeted marketing strategies, optimizing product offerings, and enhancing overall customer satisfaction.

-- Data Cleaning steps
-- 1) Check and Remove duplicates
-- 2)Standardisation and fix errors
-- 3)Check for null and empty cells
-- 4)Removing unnecessary rows and columns.


USE shopping_behaviour;

SELECT *
FROM shopping_behaviour.shopping_behavior_updated;

-- Creating a duplicate dataset that we can clean in order to not alter the original data

DROP TABLE IF EXISTS shopping_behaviour.shopping_behavior1;

CREATE TABLE shopping_behaviour.shopping_behavior1
LIKE shopping_behaviour.shopping_behavior_updated;

INSERT shopping_behaviour.shopping_behavior1
SELECT * FROM shopping_behaviour.shopping_behavior_updated;

SELECT *
FROM shopping_behaviour.shopping_behavior1;

-- 1) Check and Remove duplicates

-- Method 1

SELECT *
FROM (
	 SELECT (`Customer ID`,`Age`,`Gender`,`Item Purchased`,`Category`,`Purchase Amount (USD)`,`Location`,`Size`,`Color`,`Season`,
             `Review Rating`,`Subscription Status`,`Shipping Type`,`Discount Applied`,`Promo Code Used`,`Previous Purchases`,`Payment Method`,
			`Frequency of Purchases`,
	         ROW_NUMBER() OVER
                  (PARTITION BY `Customer ID`,`Age`,`Gender`,`Item Purchased`,`Category`,`Purchase Amount (USD)`,`Location`,`Size`,
                  `Color`,`Season`,`Review Rating`,`Subscription Status`,`Shipping Type`,`Discount Applied`,`Promo Code Used`,
                  `Previous Purchases`,`Payment Method`,`Frequency of Purchases`) AS row_num
      FROM  shopping_behaviour.shopping_behavior1        
       ) duplicates
WHERE  row_num > 1;

-- Method 2
     
SELECT `Customer ID`,`Age`,`Gender`,`Item Purchased`,`Category`,`Purchase Amount (USD)`,`Location`,`Size`,`Color`,`Season`,
             `Review Rating`,`Subscription Status`,`Shipping Type`,`Discount Applied`,`Promo Code Used`,`Previous Purchases`,`Payment Method`,
			`Frequency of Purchases`,count(*) AS duplicates
FROM  shopping_behaviour.shopping_behavior1 
GROUP BY `Customer ID`,`Age`,`Gender`,`Item Purchased`,`Category`,`Purchase Amount (USD)`,`Location`,`Size`,
                  `Color`,`Season`,`Review Rating`,`Subscription Status`,`Shipping Type`,`Discount Applied`,`Promo Code Used`,
                  `Previous Purchases`,`Payment Method`,`Frequency of Purchases`
 HAVING count(*) > 1;

-- There are No duplicates 

-- 2)Standardisation and fix errors
SELECT *
FROM shopping_behaviour.shopping_behavior1;

SELECT DISTINCT `Category`
FROM shopping_behaviour.shopping_behavior1;

-- From the data there is no need for standardization and no errors in the data

-- 3)Check for null and empty cells
SELECT 
    `Customer ID`, `Age`, `Gender`, `Item Purchased`, `Category`, 
    `Purchase Amount (USD)`, `Location`, `Size`, `Color`,
    `Season`, `Review Rating`, `Subscription Status`, `Shipping Type`, 
    `Discount Applied`, `Promo Code Used`, `Previous Purchases`, 
    `Payment Method`, `Frequency of Purchases`
FROM 
    shopping_behaviour.shopping_behavior1  
WHERE 
    `Customer ID` IS NULL OR `Customer ID` = '' OR
    `Age` IS NULL OR `Age` = '' OR
    `Gender` IS NULL OR `Gender` = '' OR
    `Item Purchased` IS NULL OR `Item Purchased` = '' OR
    `Category` IS NULL OR `Category` = '' OR
    `Purchase Amount (USD)` IS NULL OR `Purchase Amount (USD)` = '' OR
    `Location` IS NULL OR `Location` = '' OR
    `Size` IS NULL OR `Size` = '' OR
    `Color` IS NULL OR `Color` = '' OR
    `Season` IS NULL OR `Season` = '' OR
    `Review Rating` IS NULL OR `Review Rating` = '' OR
    `Subscription Status` IS NULL OR `Subscription Status` = '' OR
    `Shipping Type` IS NULL OR `Shipping Type` = '' OR
    `Discount Applied` IS NULL OR `Discount Applied` = '' OR
    `Promo Code Used` IS NULL OR `Promo Code Used` = '' OR
    `Previous Purchases` IS NULL OR `Previous Purchases` = '' OR
    `Payment Method` IS NULL OR `Payment Method` = '' OR
    `Frequency of Purchases` IS NULL OR `Frequency of Purchases` = '';
    
-- There no null or empty values
-- -- 4)Removing unnecessary rows and columns.
SELECT *
FROM shopping_behaviour.shopping_behavior1;
-- All columns give neccessary information important in making business decisisons.

