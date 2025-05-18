
-- Question 2: Transaction Frequency Analysis
-- Task: Calculate the average number of transactions per customer per month and categorize them.



-- Use the DB 
USE adashi_staging;


-- Aggregate number of transaction for each customer per month.
WITH monthly_transactions AS (
    SELECT 
        ssa.owner_id,
        DATE_FORMAT(ssa.created_on, '%Y-%m-01') AS txn_month,
        COUNT(*) AS transactions_in_month
    FROM savings_savingsaccount ssa
    GROUP BY ssa.owner_id, txn_month
),

-- Calculates average monthly transaction of customers each month

average_transactions AS (
    SELECT 
        owner_id,
        AVG(transactions_in_month) AS avg_txn_per_month
    FROM monthly_transactions
    GROUP BY owner_id
),

-- Categorize customers based on average monthly transaction.
categorized_customers AS (
    SELECT 
        CASE 
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_txn_per_month
    FROM average_transactions
)

-- Grouping and analyzing data by category
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY 
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;
