-- Question 1: High-Value Customers with Multiple Products
-- Task: Write a query to find customers with at least one funded savings plan AND one funded 
-- investment plan, sorted by total deposits.

-- Use the DB
USE adashi_staging;

-- Gets customers who have savings, investment, and total deposits, as well as converts kobo to naira
SELECT 
    uc.id AS owner_id,
    CONCAT(uc.first_name, ' ', uc.last_name) AS name,
    COALESCE(s.savings_count, 0) AS savings_count,
    COALESCE(i.investment_count, 0) AS investment_count,
    (COALESCE(s.savings_sum, 0) + COALESCE(i.investment_sum, 0)) / 100.0 AS total_deposits 
FROM 
    users_customuser uc
    
-- Gets savings when it is a regular account.
LEFT JOIN
    (
        SELECT 
            owner_id,
            COUNT(*) AS savings_count,
            SUM(amount) AS savings_sum
        FROM plans_plan
        WHERE is_regular_savings = 1
          AND amount > 0
        GROUP BY owner_id
    ) s ON uc.id = s.owner_id
    
-- Gets Plan when it is a Investment account
LEFT JOIN
    (
        SELECT 
            owner_id,
            COUNT(*) AS investment_count,
            SUM(amount) AS investment_sum
        FROM plans_plan
        WHERE is_a_fund = 1
          AND amount > 0
        GROUP BY owner_id
    ) i ON uc.id = i.owner_id
WHERE 
    COALESCE(s.savings_count, 0) > 0
    AND COALESCE(i.investment_count, 0) > 0
ORDER BY 
    total_deposits DESC;
