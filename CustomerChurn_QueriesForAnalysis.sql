USE customer_churn_analysis;

 -- Question 1: Identify the total number of customers and the churn rate
SELECT 
    COUNT(*) AS Total_Customers, 
    SUM(CASE WHEN `Customer Status` = 'Churned' THEN 1 ELSE 0 END) AS Churned_Customers,
    (SUM(CASE WHEN `Customer Status` = 'Churned' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn;

-- Question 2: Find the average age of churned customers
SELECT AVG(Age) AS Avg_Churned_Age 
FROM churned_customers;

-- Question 3: Discover the most common contract types among churned customers
SELECT 
    Contract, 
    COUNT(*) AS Churned_Count 
FROM churned_customers
GROUP BY Contract
ORDER BY Churned_Count DESC;

-- Question 4: Analyze the distribution of monthly charges among churned customers
SELECT 
    MIN(`Monthly Charge`) AS Min_Monthly_Charge,
    MAX(`Monthly Charge`) AS Max_Monthly_Charge,
    AVG(`Monthly Charge`) AS Avg_Monthly_Charge
FROM churned_customers;

-- -- Question 5: Create a query to identify the contract types that are most prone to churn
SELECT 
    Contract,
    (COUNT(*) / (SELECT COUNT(*) FROM customer_churn WHERE Contract = churned_customers.Contract)) * 100 AS Churn_Rate
FROM churned_customers
GROUP BY Contract
ORDER BY Churn_Rate DESC;

-- Question 6: Identify customers with high total charges who have churned
SELECT * 
FROM churned_high_value_customers
ORDER BY `Total Charges` DESC
LIMIT 10;

-- Question 7: Calculate the total charges distribution for churned and non-churned customers
SELECT 
    `Customer Status`,
    MIN(`Total Charges`) AS Min_Total_Charges,
    MAX(`Total Charges`) AS Max_Total_Charges,
    AVG(`Total Charges`) AS Avg_Total_Charges
FROM customer_churn
GROUP BY `Customer Status`;

-- Question 8: Calculate the average monthly charges for different contract types among churned customers
SELECT 
    Contract,
    AVG(`Monthly Charge`) AS Avg_Monthly_Charge
FROM churned_customers
GROUP BY Contract;

-- Question 9: Identify customers who have both online security and online backup services and have not churned
SELECT * 
FROM stayed_customers
WHERE `Online Security` = 'Yes' AND `Online Backup` = 'Yes';

-- Question 10: Determine the most common combinations of services among churned customers
SELECT 
    `Internet Service`,
    `Streaming TV`,
    `Streaming Movies`,
    COUNT(*) AS Churned_Count
FROM churned_customers
GROUP BY `Internet Service`, `Streaming TV`, `Streaming Movies`
ORDER BY Churned_Count DESC
LIMIT 10;

-- Question 17: Calculate the average total charges for customers grouped by gender and marital status.
SELECT 
    Gender, 
    Married, 
    AVG(`Total Charges`) AS Avg_Total_Charges
FROM customer_churn
GROUP BY Gender, Married;

-- Question 18: Calculate the average monthly charges for different age groups among churned customers.
SELECT 
    CASE 
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Above 50'
    END AS Age_Group,
    AVG(`Monthly Charge`) AS Avg_Monthly_Charge
FROM churned_customers
GROUP BY Age_Group;

-- Question 14: Identify the contract types with the highest churn rate among senior citizens (age 65 and over)
SELECT 
    Contract,
    COUNT(*) AS Churned_Senior_Customers,
    (COUNT(*) / (SELECT COUNT(*) FROM churned_senior_citizens)) * 100 AS Senior_Churn_Rate
FROM churned_senior_citizens
GROUP BY Contract
ORDER BY Senior_Churn_Rate DESC;

-- Question 19: Calculate the average monthly charges and total charges for customers who have churned, grouped by contract type and internet service type
SELECT 
    Contract,
    `Internet Service`,
    AVG(`Monthly Charge`) AS Avg_Monthly_Charge,
    AVG(`Total Charges`) AS Avg_Total_Charges
FROM churned_customers
GROUP BY Contract, `Internet Service`
ORDER BY Avg_Monthly_Charge DESC;

-- Question 16: Identify the customers who have churned and used the most online services
SELECT *
FROM churned_customers
WHERE `Online Security` = 'Yes' AND `Online Backup` = 'Yes' AND `Streaming TV` = 'Yes'
ORDER BY `Total Charges` DESC
LIMIT 10;

-- Question 24: Create a view to find the customers with the highest monthly charges in each contract type
CREATE VIEW highest_monthly_charges AS
SELECT 
    Contract,
    `Customer ID`,
    MAX(`Monthly Charge`) AS Max_Monthly_Charge
FROM customer_churn
GROUP BY Contract;

-- Question 25: Create a view to identify customers who have churned and their average monthly charges compared to the overall average.
CREATE VIEW churn_analysis_view AS
SELECT 
    `Customer Status`,
    AVG(`Monthly Charge`) AS Avg_Monthly_Charge
FROM customer_churn
GROUP BY `Customer Status`;

-- Question 27: Stored Procedure to Calculate Churn Rate
DELIMITER //
CREATE PROCEDURE Calculate_Churn_Rate()
BEGIN
    SELECT 
        COUNT(*) AS Total_Customers,
        SUM(CASE WHEN `Customer Status` = 'Churned' THEN 1 ELSE 0 END) AS Churned_Customers,
        (SUM(CASE WHEN `Customer Status` = 'Churned' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS Churn_Rate
    FROM customer_churn;
END //
DELIMITER ;
