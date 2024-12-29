-- Phase 1: Database and Table Setup
CREATE DATABASE customer_churn_analysis;
USE customer_churn_analysis;

-- Describe and Verify Tables
DESCRIBE customer_churn_analysis;
SELECT COUNT(*) AS Total_Rows FROM customer_churn_analysis;
SHOW TABLES;

-- Rename Tables for Better Readability
RENAME TABLE customer_churn_analysis TO customer_churn;
SHOW Tables;

-- Basic Data Overview
SELECT COUNT(*) AS Total_Rows FROM customer_churn;
SELECT * FROM customer_churn LIMIT 10;

-- Check for Invalid or Missing Data
SELECT * FROM customer_churn WHERE Monthly_Charge < 0 OR Total_Charges < 0;
DESCRIBE customer_churn;

-- Update Column Names for Consistency
SELECT * FROM customer_churn WHERE 'Monthly Charge' < 0 OR 'Total Charges' < 0;
DESCRIBE customer_churn;
ALTER TABLE customer_churn CHANGE `ï»¿Customer ID` `Customer ID` VARCHAR(255);
DESCRIBE customer_churn;
ALTER TABLE customer_churn CHANGE `ï»¿Customer ID` `Customer ID` VARCHAR(255);
SELECT * FROM customer_churn WHERE 'Monthly_Charge' < 0 OR 'Total_Charges' < 0;
SELECT * FROM customer_churn 
WHERE 'Monthly Charge' > 1000 OR 'Total Charges' > 100000 OR 'Monthly Charge' IS NULL OR 'Total Charges' IS NULL;

-- Column Validation
SELECT DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'customer_churn' AND COLUMN_NAME IN ('Monthly Charge', 'Total Charges');

-- Identify and Address Missing or Outlier Data
SELECT * FROM customer_churn
WHERE `Monthly Charge` IS NULL OR `Total Charges` IS NULL;
SELECT MIN(`Monthly Charge`) AS Min_Charge, MAX(`Monthly Charge`) AS Max_Charge,
       MIN(`Total Charges`) AS Min_Total, MAX(`Total Charges`) AS Max_Total
FROM customer_churn;

-- Add Normalized Columns
ALTER TABLE customer_churn 
ADD COLUMN Normalized_Monthly_Charge FLOAT, 
ADD COLUMN Normalized_Total_Charges FLOAT;
SELECT MIN(`Monthly Charge`) AS Min_Charge, MAX(`Monthly Charge`) AS Max_Charge,
       MIN(`Total Charges`) AS Min_Total, MAX(`Total Charges`) AS Max_Total
FROM customer_churn;

-- Populate Normalized Columns
SET SQL_SAFE_UPDATES = 0;
UPDATE customer_churn
SET Normalized_Monthly_Charge = (`Monthly Charge` - (-10)) / (118.75 - (-10)),
    Normalized_Total_Charges = (`Total Charges` - 18.8) / (8684.8 - 18.8);
    SET SQL_SAFE_UPDATES = 1;
    
    -- Verify Normalization
    SELECT `Monthly Charge`, Normalized_Monthly_Charge,
       `Total Charges`, Normalized_Total_Charges
FROM customer_churn
LIMIT 10;

-- Phase 2: Data Segmentation
-- Create Subsets Based on Customer Status
CREATE TABLE churned_customers AS
SELECT * 
FROM customer_churn
WHERE `Customer Status` = 'Churned';

CREATE TABLE stayed_customers AS
SELECT * 
FROM customer_churn
WHERE `Customer Status` = 'Stayed';

CREATE TABLE joined_customers AS
SELECT * 
FROM customer_churn
WHERE `Customer Status` = 'Joined';

-- Verify Subsets
SELECT COUNT(*) AS Total_Churned FROM churned_customers;
SELECT COUNT(*) AS Total_Stayed FROM stayed_customers;
SELECT COUNT(*) AS Total_Joined FROM joined_customers;
SELECT * FROM churned_customers LIMIT 10;
SELECT * FROM stayed_customers LIMIT 10;
SELECT * FROM joined_customers LIMIT 10;

-- Further Segmentation by Contract Type
CREATE TABLE churned_month_to_month AS
SELECT * 
FROM churned_customers
WHERE Contract = 'Month-to-Month';

CREATE TABLE churned_one_year AS
SELECT * 
FROM churned_customers
WHERE Contract = 'One Year';

CREATE TABLE churned_two_year AS
SELECT * 
FROM churned_customers
WHERE Contract = 'Two Year';

CREATE TABLE active_month_to_month AS
SELECT * 
FROM stayed_customers
WHERE Contract = 'Month-to-Month';

CREATE TABLE active_one_year AS
SELECT * 
FROM stayed_customers
WHERE Contract = 'One Year';

CREATE TABLE active_two_year AS
SELECT * 
FROM stayed_customers
WHERE Contract = 'Two Year';

-- High-Value Customers
CREATE TABLE churned_high_value_customers AS
SELECT * 
FROM churned_customers
WHERE `Total Charges` > 5000;

CREATE TABLE active_high_value_customers AS
SELECT * 
FROM stayed_customers
WHERE `Total Charges` > 5000;

-- Senior Citizens
CREATE TABLE churned_senior_citizens AS
SELECT * 
FROM churned_customers
WHERE Age >= 65;

CREATE TABLE active_senior_citizens AS
SELECT * 
FROM stayed_customers
WHERE Age >= 65;

-- Online Service Users
CREATE TABLE churned_online_services AS
SELECT * 
FROM churned_customers
WHERE `Online Security` = 'Yes' AND `Online Backup` = 'Yes';

CREATE TABLE active_online_services AS
SELECT * 
FROM stayed_customers
WHERE `Online Security` = 'Yes' AND `Online Backup` = 'Yes';

-- Streaming Service Users
CREATE TABLE churned_streaming_services AS
SELECT * 
FROM churned_customers
WHERE `Streaming TV` = 'Yes' AND `Streaming Movies` = 'Yes';

CREATE TABLE active_streaming_services AS
SELECT * 
FROM stayed_customers
WHERE `Streaming TV` = 'Yes' AND `Streaming Movies` = 'Yes';

-- Tenure Analysis
CREATE TABLE churned_short_term AS
SELECT * 
FROM churned_customers
WHERE `Tenure in Months` <= 12;

CREATE TABLE active_short_term AS
SELECT * 
FROM stayed_customers
WHERE `Tenure in Months` <= 12;

CREATE TABLE churned_long_term AS
SELECT * 
FROM churned_customers
WHERE `Tenure in Months` > 12;

CREATE TABLE active_long_term AS
SELECT * 
FROM stayed_customers
WHERE `Tenure in Months` > 12;
