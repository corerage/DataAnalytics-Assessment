

# SQL Analysis for Cowrywise Customers, Transaction Behaviour & Account Activity.

## Overview

This project contains SQL scripts developed for the Cowrywise assessment. It addresses core business questions related to **customer insights**, **transaction behavior**, and **account activity**, based on a **MySQL database** with the following tables:

- `users_customuser`
- `savings_savingsaccount`
- `plans_plan`
- `withdrawals_withdrawal`

**Environment:**

- **Database**: MySQL (via Docker)
- **GUI Tool**: DBeaver

---

## Assessment Questions & Solutions

### 1. High-Value Customers with Multiple Products

**Task**  
Identify customers who have at least one funded **savings** plan and one funded **investment** plan. Sort them by total deposit amount.

**Summary**  
This query fetches customers with both types of plans and calculates:
- Count of savings and investment plans
- Total confirmed deposits
- Conversion from **kobo to naira** (`/ 100.0`)

**Logic**  
- A **savings plan** is defined by `is_regular_savings = 1`  
- An **investment plan** is defined by `is_a_fund = 1`  
- Only plans with `confirmed_amount > 0` are considered  
- Joins savings and investment data per customer

**Output Columns**

| Column           | Description                            |
|------------------|----------------------------------------|
| owner_id         | ID of the customer                     |
| name             | Full name                              |
| savings_count    | Number of savings plans                |
| investment_count | Number of investment plans             |
| total_deposits   | Sum of confirmed amounts (in naira)    |

---

### 2. Transaction Frequency Analysis

**Task**  
Calculate the **average number of transactions per customer per month**, and categorize each customer as:

- **High Frequency** (≥ 10/month)  
- **Medium Frequency** (3–9/month)  
- **Low Frequency** (≤ 2/month)

**Summary**  
The query analyzes transaction activity to classify customers based on how frequently they transact.

**Logic**  
- Transactions are grouped per customer, per month  
- Monthly averages are calculated for each customer  
- Customers are classified into frequency buckets

**Output Columns**

| Column                | Description                              |
|------------------------|------------------------------------------|
| frequency_category     | High / Medium / Low                      |
| customer_count         | Number of customers in that category     |
| avg_transactions_month | Average monthly transactions             |

---

### 3. Account Inactivity Alert

**Task**  
Find all **active accounts** (savings or investment) that have **not received a transaction in the past 1 year (365 days)**.

**Summary**  
This query returns accounts with no recent inflows, signaling potential inactivity.

**Logic**  
- Uses `confirmed_amount` and `created_on` to determine last inflow  
- Filters for accounts with **no deposits** in the last 365 days  
- Both savings and investment plans are considered

**Output Columns**

| Column                 | Description                           |
|------------------------|---------------------------------------|
| plan_id                | ID of the savings/investment plan     |
| owner_id               | Customer ID                           |
| plan_type              | Savings or Investment                 |
| last_transaction_date  | Date of last deposit                  |
| inactivity_days        | Days since the last transaction       |

---

### 4. Customer Lifetime Value (CLV) Estimation

**Task**  
Estimate the **Customer Lifetime Value (CLV)** using the formula:
CLV = (total_transactions / tenure_in_months) * 12 * avg_profit_per_transaction

**Assumptions:**

- `profit_per_transaction = 0.1%` (or 0.001)  
- Tenure is calculated from the customer’s signup date  
- Output is ordered by estimated CLV (descending)

**Summary**  
Calculates CLV by evaluating account age, transaction volume, and estimated profit margin.

**Logic**  
- Calculate tenure in months from creation date  
- Sum all confirmed transactions  
- Estimate monthly average and extrapolate to yearly  
- using the 0.1% == 0.001 to estimate the annual profit.


**Output Columns**

| Column              | Description                            |
|----------------------|----------------------------------------|
| customer_id          | Unique ID of the customer              |
| name                 | Full name                              |
| tenure_months        | Number of months since signup          |
| total_transactions   | Sum of confirmed transaction amounts   |
| estimated_clv        | Calculated CLV based on assumptions    |

---

## How to Run

1. **Start the MySQL container:**

```bash
docker run --name mysql-db -e MYSQL_ROOT_PASSWORD=yourpassword -p 3306:3306 -d mysql



Connect to MySQL via DBeaver:
Host: localhost
Port: 3306
User: root
Password: yourpassword
Database: your_database_name

Run each query from DBeaver’s SQL editor to see results per task.

Challenge Faced: The inabilty to install a MSSQL server on my PC.

Challenge Overcomed: I was able to spin up a SQL docker image to run the server, where i connected it to a GUI tool using DBeaver.


Notes:

All monetary values  are stored in kobo and converted to naira where required.