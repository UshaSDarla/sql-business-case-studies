-- Use case:
-- Check if critical columns like ID, name, or transaction date are missing.

-- ============================================================
-- Data Quality Checks
-- ============================================================

-- Data quality checks are used to make sure data is accurate, complete,
-- consistent, and reliable before it is used for reporting, analytics,
-- or downstream processing.

-- Why Data Quality Checks Matter
-- Bad data can cause:
--   - wrong reports
--   - duplicate customer records
--   - failed pipelines
--   - incorrect KPI calculations
--   - poor business decisions

-- ============================================================
-- 1) Common Types of Data Quality Checks
-- ============================================================

-- 1. Null Checks

-- Null Check: Identify rows with missing values in critical columns (ID, name, email)
SELECT *
FROM customers
WHERE customer_id IS NULL
   OR customer_name IS NULL
   OR email IS NULL;
-- Use case: Find missing values in important columns.

-- 2. Duplicate Checks
-- Used to find duplicate records.

-- Duplicate on one column
-- Duplicate on multiple columns
SELECT first_name,
       last_name,
       email,
       COUNT(*) AS duplicate_count
FROM customers
GROUP BY first_name, last_name, email
HAVING COUNT(*) > 1;

-- Use case: Detect duplicate customer or account records.

-- 3. Unique Key Checks
-- Used to confirm a column expected to be unique is actually unique.

-- Unique Key Check: Confirm account_number is unique
SELECT account_number,
       COUNT(*) AS record_count
FROM accounts
GROUP BY account_number
HAVING COUNT(*) > 1;

-- Use case: Account number, loan ID, employee ID, order ID.

-- 4. Referential Integrity Checks
-- Used to find orphan records where child records do not match parent records.

-- Referential Integrity Check: Find orphan orders with no matching customer
SELECT o.*
FROM orders o
LEFT JOIN customers c
  ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Use case: Orders without matching customer, payments without matching loan, transactions without matching account.

-- 5. Range Checks
-- Used to make sure values fall within expected limits.

-- Range Check: Salary must be between 0 and 1,000,000
SELECT *
FROM employees
WHERE salary < 0
   OR salary > 1000000;

-- Range Check: Age must be between 0 and 120
SELECT *
FROM customers
WHERE age < 0
   OR age > 120;

-- Use case: Age, salary, interest rate, transaction amount, credit score.

-- 6. Format Checks
-- Used to validate patterns like email, phone number, zip code, account code.

-- Format Check: Validate email contains '@' and '.'
SELECT *
FROM customers
WHERE email IS NOT NULL
  AND email NOT LIKE '%@%.%';

-- Use case: Bad email values, invalid phone numbers, malformed IDs.

-- 7. Length Checks
-- Used to confirm field length is correct.

-- Length Check: Account number must be exactly 10 characters
SELECT *
FROM accounts
WHERE LENGTH(account_number) <> 10;

-- Use case: Account numbers, zip codes, employee IDs, product codes.

-- 8. Domain / Allowed Values Checks
-- Used to verify a column only contains approved values.

-- Domain Check: Status must be one of the allowed values
SELECT DISTINCT status
FROM loans
WHERE status NOT IN ('ACTIVE', 'CLOSED', 'DELINQUENT', 'CHARGED_OFF');

-- Use case: Status, payment type, order status, transaction channel.

-- 9. Date Validation Checks
-- Used to find invalid or illogical date values.

-- Date Check: Order date should not be in the future
SELECT *
FROM orders
WHERE order_date > CURRENT_DATE;

-- Date Check: Payment date should not be before due date
SELECT *
FROM loans
WHERE payment_date < due_date;

-- Use case: Future transaction dates, close date before open date, birth date after today.

-- 10. Record Count Checks
-- Used to compare row counts between source and target.

-- Record Count Check: Compare source vs target row counts
SELECT COUNT(*) AS source_count
FROM source_customers;

SELECT COUNT(*) AS target_count
FROM target_customers;

-- Use case: ETL validation, migration checks, reconciliation.

-- 11. Aggregate Reconciliation Checks
-- Used to compare totals across systems.

-- Aggregate Reconciliation: Compare source vs target totals
SELECT SUM(amount) AS source_total
FROM source_transactions;

SELECT SUM(amount) AS target_total
FROM target_transactions;

-- Use case: Loan balances, payments, revenue, transaction amounts.

-- 12. Business Rule Checks
-- Used to verify business logic.

-- Business Rule: Closed loans must have zero balance
SELECT *
FROM loans
WHERE loan_status = 'CLOSED'
  AND outstanding_balance <> 0;

-- Business Rule: Failed transactions should not have non-positive amount
SELECT *
FROM transactions
WHERE transaction_status = 'FAILED'
  AND amount <= 0;

-- Use case: Closed loans should have zero balance, completed orders should have payment, active employee should have hire date.


-- ============================================================
-- 2) Example Data Quality Query Set
-- ============================================================

-- Customer table checks
-- Null Check: Critical columns must not be null
SELECT *
FROM customers
WHERE customer_id IS NULL
   OR customer_name IS NULL;
-- Duplicate Check: Find duplicate customer IDs
SELECT customer_id,
       COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
-- Format Check: Invalid email format
SELECT *
FROM customers
WHERE email IS NOT NULL
  AND email NOT LIKE '%@%.%';
-- 4) Example Banking Data Quality Checks
-- Orphan Check: Transactions without matching account
SELECT t.*
FROM transactions t
LEFT JOIN accounts a
  ON t.account_id = a.account_id
WHERE a.account_id IS NULL;
-- Range Check: Loans should not have negative balance
SELECT *
FROM loans
WHERE outstanding_balance < 0;
-- Business Rule: Closed loans should have zero balance
SELECT *
FROM loans
WHERE loan_status = 'CLOSED'
  AND outstanding_balance > 0;
-- Duplicate Check: Find duplicate account numbers
SELECT account_number,
       COUNT(*) AS duplicate_count
FROM accounts
GROUP BY account_number
HAVING COUNT(*) > 1;
-- Orphan Check: Payments without matching loan
SELECT p.*
FROM payments p
LEFT JOIN loans l
  ON p.loan_id = l.loan_id
WHERE l.loan_id IS NULL;
-- 5) Source to Target Validation Example
-- Record Count: Compare source vs target row counts
SELECT 'source' AS system_name, COUNT(*) AS record_count
FROM source_orders
UNION ALL
SELECT 'target' AS system_name, COUNT(*) AS record_count
FROM target_orders;
-- Aggregate Reconciliation: Compare source vs target totals
SELECT 'source' AS system_name, SUM(order_amount) AS total_amount
FROM source_orders
UNION ALL
SELECT 'target' AS system_name, SUM(order_amount) AS total_amount
FROM target_orders;
-- Missing Records: Find source records not in target
SELECT s.order_id
FROM source_orders s
LEFT JOIN target_orders t
  ON s.order_id = t.order_id
WHERE t.order_id IS NULL;

-- ============================================================
-- 2) Data Quality Categories
-- ============================================================

-- COMPLETENESS
-- Checks whether required data is present.
-- Examples: null check, missing records, blank strings

-- UNIQUENESS
-- Checks whether records are duplicated.
-- Examples: duplicate customer IDs, repeated account numbers

-- CONSISTENCY
-- Checks whether values match across tables or systems.
-- Examples: source vs target totals, same customer status across systems

-- VALIDITY
-- Checks whether values follow business rules and formats.
-- Examples: correct email format, allowed status values, date rules

-- ACCURACY
-- Checks whether the value is actually correct.
-- Examples: salary loaded correctly, transaction amount matches source, balance matches statement

