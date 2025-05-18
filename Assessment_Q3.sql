-- Question 3: Account Inactivity Alert
-- Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days).


-- Use DB
USE adashi_staging;

-- calculates last transaction date, and incativity days with savings as type for atleast 1 year.
SELECT 
    ssa.id AS plan_id,
    ssa.owner_id,
    'Savings' AS type,
    MAX(ssa.created_on) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(ssa.created_on)) AS inactivity_days
FROM savings_savingsaccount ssa
WHERE 
	ssa.confirmed_amount > 0
GROUP BY 
	ssa.id, ssa.owner_id

-- 
HAVING 
	inactivity_days > 365
-- Combines the whole data together as a single unit
UNION ALL

-- calculates last transaction date and inactivity days with investment as type for atleat 1 year
SELECT 
    pp.id AS plan_id,
    pp.owner_id,
    'Investment' AS type,
    MAX(pp.created_on) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(pp.created_on)) AS inactivity_days
FROM 
	plans_plan pp
WHERE 
	pp.is_a_fund = 1
AND 
	pp.amount > 0
GROUP BY 
	pp.id, pp.owner_id
HAVING 
	inactivity_days > 365;
