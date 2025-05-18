-- Question 4: Customer Lifetime Value (CLV) Estimation

-- Use the DB
USE adashi_staging;


-- calculate users account tenure and total teansactions
SELECT 
    uc.id AS customer_id,
    CONCAT(uc.first_name, ' ', uc.last_name) AS name,
    TIMESTAMPDIFF(MONTH, uc.date_joined, CURDATE()) AS tenure_months,
    COUNT(ssa.id) AS total_transactions,
    
-- estimates the Customer Lifetime Value
    ROUND( ((COUNT(ssa.id) / 
    NULLIF(TIMESTAMPDIFF(MONTH, uc.date_joined, CURDATE()), 0)) * 12 * (AVG(ssa.confirmed_amount) * 0.001)) / 100, 2 ) 
    AS estimated_clv
FROM users_customuser uc

-- Joins customers with their savings accounts, groups by customer details to aggregate transactions, 
-- and orders by estimated CLV in descending order

LEFT JOIN 
	savings_savingsaccount ssa 
ON 
	ssa.owner_id = uc.id
GROUP BY 
	uc.id, CONCAT(uc.first_name, ' ', uc.last_name)
ORDER BY 
	estimated_clv DESC;
