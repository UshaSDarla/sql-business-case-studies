-- ===========================================
-- SQL Intermediate Concepts
-- ===========================================

-- This guide covers the next important SQL topics after basic queries:
--   - Subqueries
--   - Common Table Expressions (CTEs)
--   - Window Functions
--
-- These are very common in interviews and real project work.

-- -------------------------------------------
-- 1. Subqueries
-- -------------------------------------------
-- A subquery is a query inside another query.
-- You usually use it when:
--   - Filtering based on calculated results
--   - Comparing against aggregated values
--   - Finding top or bottom values
--   - Checking whether matching records exist

-- Example 1: Find customers whose total spending is above average
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total_spend)
    FROM (
        SELECT customer_id,
               SUM(amount) AS total_spend
        FROM orders
        GROUP BY customer_id
    ) t
);

-- Example 2: Find employees with the second highest salary
SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (
    SELECT MAX(salary)
    FROM employees
);

-- Types of subqueries:
--   - Single-row subquery
--   - Multi-row subquery
--   - Correlated subquery
--   - Nested subquery

-- Correlated subquery example:
-- A correlated subquery runs once for each row of the outer query.
SELECT e1.employee_id,
       e1.employee_name,
       e1.salary
FROM employees e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e1.department_id = e2.department_id
);
-- This finds employees earning more than the average salary in their own department.

-- -------------------------------------------
-- 2. Common Table Expressions (CTEs)
-- -------------------------------------------
-- A CTE is a temporary result set defined with WITH.
-- It makes complex queries easier to read and organize.

-- Basic CTE syntax
WITH sales_summary AS (
    SELECT customer_id,
           SUM(amount) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM sales_summary;

-- Example 1: Customers with sales greater than 2000
WITH customer_sales AS (
    SELECT customer_id,
           SUM(amount) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT customer_id,
       total_sales
FROM customer_sales
WHERE total_sales > 2000;

-- Example 2: Multiple CTEs
WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', order_date) AS sales_month,
           SUM(amount) AS total_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
),
avg_sales AS (
    SELECT AVG(total_sales) AS avg_monthly_sales
    FROM monthly_sales
)
SELECT m.sales_month,
       m.total_sales,
       a.avg_monthly_sales
FROM monthly_sales m
CROSS JOIN avg_sales a;

-- Why use CTEs:
--   - Cleaner than deeply nested subqueries
--   - Easier to debug
--   - Better readability
--   - Useful for step-by-step logic

-- -------------------------------------------
-- 3. Window Functions
-- -------------------------------------------
-- A window function performs calculations across a set of rows
-- related to the current row.
-- Unlike GROUP BY, it does not collapse rows.
-- This is one of the most important SQL topics for interviews.

-- Common window functions:
--   ROW_NUMBER(), RANK(), DENSE_RANK(),
--   LAG(), LEAD(), SUM() OVER(), AVG() OVER()

-- -------------------------------------------
-- 3.1 ROW_NUMBER()
-- Assigns a unique number to each row.
-- -------------------------------------------
SELECT employee_id,
       employee_name,
       salary,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
FROM employees;

-- -------------------------------------------
-- 3.2 RANK()
-- Gives the same rank for ties, but skips the next rank.
-- -------------------------------------------
SELECT employee_id,
       employee_name,
       salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

-- -------------------------------------------
-- 3.3 DENSE_RANK()
-- Gives the same rank for ties, but does not skip the next rank.
-- -------------------------------------------
SELECT employee_id,
       employee_name,
       salary,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_salary_rank
FROM employees;

-- -------------------------------------------
-- 3.4 Running Total
-- Calculates cumulative sales over time.
-- -------------------------------------------
SELECT order_date,
       amount,
       SUM(amount) OVER (ORDER BY order_date) AS running_total
FROM orders;

-- -------------------------------------------
-- 3.5 PARTITION BY
-- Resets the calculation for each group.
-- This ranks employees within each department.
-- -------------------------------------------
SELECT employee_id,
       department_id,
       salary,
       ROW_NUMBER() OVER (
           PARTITION BY department_id
           ORDER BY salary DESC
       ) AS dept_rank
FROM employees;

-- -------------------------------------------
-- 3.6 LAG()
-- Compares the current row with the previous row.
-- -------------------------------------------
SELECT sales_month,
       total_sales,
       LAG(total_sales) OVER (ORDER BY sales_month) AS previous_month_sales
FROM monthly_sales;

-- -------------------------------------------
-- 3.7 LEAD()
-- Compares the current row with the next row.
-- -------------------------------------------
SELECT sales_month,
       total_sales,
       LEAD(total_sales) OVER (ORDER BY sales_month) AS next_month_sales
FROM monthly_sales;

-- -------------------------------------------
-- 4. Difference Between GROUP BY and Window Functions
-- -------------------------------------------

-- GROUP BY: combines rows, returns one row per group, used for summary output
SELECT department_id,
       AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;

-- Window Function: keeps all original rows, adds calculated values alongside each row
SELECT employee_id,
       department_id,
       salary,
       AVG(salary) OVER (PARTITION BY department_id) AS dept_avg_salary
FROM employees;

-- -------------------------------------------
-- 5. Most Common Interview Patterns
-- -------------------------------------------

-- Pattern 1: Top N per group
WITH ranked_employees AS (
    SELECT employee_id,
           department_id,
           salary,
           ROW_NUMBER() OVER (
               PARTITION BY department_id
               ORDER BY salary DESC
           ) AS rn
    FROM employees
)
SELECT *
FROM ranked_employees
WHERE rn <= 3;

-- Pattern 2: Month-over-month change
WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', order_date) AS sales_month,
           SUM(amount) AS total_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT sales_month,
       total_sales,
       LAG(total_sales) OVER (ORDER BY sales_month) AS previous_month_sales,
       total_sales - LAG(total_sales) OVER (ORDER BY sales_month) AS sales_change
FROM monthly_sales;

-- Pattern 3: Find duplicate records
SELECT email,
       COUNT(*) AS duplicate_count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

-- Pattern 4: Find latest record per customer
WITH ranked_orders AS (
    SELECT customer_id,
           order_id,
           order_date,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id
               ORDER BY order_date DESC
           ) AS rn
    FROM orders
)
SELECT *
FROM ranked_orders
WHERE rn = 1;

-- -------------------------------------------
-- 6. Best Learning Order
-- -------------------------------------------
--   1. Simple subqueries
--   2. Correlated subqueries
--   3. Basic CTEs
--   4. Multiple CTEs
--   5. ROW_NUMBER, RANK, DENSE_RANK
--   6. SUM() OVER() running totals
--   7. LAG and LEAD
--   8. Top N per group problems

-- -------------------------------------------
-- 7. Quick Summary
-- -------------------------------------------
--   Subquery:        A query inside another query.
--   CTE:             A temporary named result set using WITH.
--   Window Function: A function that calculates across related rows
--                    without collapsing them.

-- -------------------------------------------
-- 8. Practice Questions
-- -------------------------------------------
--   1. Find the second highest salary
--   2. Find employees earning above department average
--   3. Find top 3 customers by sales
--   4. Find latest order for each customer
--   5. Calculate running total of sales
--   6. Compare current month sales with previous month
--   7. Rank employees by salary within each department
--   8. Find duplicate emails in a table

-- -------------------------------------------
-- 9. Final Tip
-- -------------------------------------------
-- If a query feels too nested and hard to read, try a CTE.
-- If you need ranking, running totals, or previous/next row comparison, use a window function.
-- If you need one query to depend on another's result, use a subquery.
