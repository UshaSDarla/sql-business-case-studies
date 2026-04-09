-- ===========================================
-- Basic SQL Query Concepts
-- ===========================================

-- This guide covers the core SQL concepts every beginner should know
-- before moving to advanced topics like joins, subqueries, and window functions.

-- Topics Covered:
-- SELECT, FROM, WHERE, Comparison operators, AND / OR / NOT,
-- ORDER BY, DISTINCT, LIMIT, LIKE, IN, BETWEEN, IS NULL,
-- Aggregate functions, GROUP BY, HAVING, Aliases, Basic JOIN, CASE WHEN

-- -------------------------------------------
-- 1. SELECT
-- Used to choose columns from a table.
-- -------------------------------------------
SELECT customer_name, city
FROM customers;

-- -------------------------------------------
-- 2. FROM
-- Specifies the table to retrieve data from.
-- -------------------------------------------
SELECT *
FROM orders;

-- -------------------------------------------
-- 3. WHERE
-- Filters rows based on a condition.
-- -------------------------------------------
SELECT *
FROM customers
WHERE city = 'New York';

-- -------------------------------------------
-- 4. Comparison Operators
-- Common operators used inside WHERE:
--   =    equal to
--   !=   or <> not equal to
--   >    greater than
--   <    less than
--   >=   greater than or equal to
--   <=   less than or equal to
-- -------------------------------------------
SELECT *
FROM orders
WHERE amount > 500;

-- -------------------------------------------
-- 5. AND, OR, NOT
-- Used to combine multiple conditions.
-- -------------------------------------------

-- AND: both conditions must be true
SELECT *
FROM customers
WHERE city = 'Dallas'
  AND status = 'Active';

-- OR: at least one condition must be true
SELECT *
FROM customers
WHERE city = 'Dallas'
   OR city = 'Austin';

-- -------------------------------------------
-- 6. ORDER BY
-- Sorts query results.
-- ASC = ascending (default)
-- DESC = descending
-- -------------------------------------------
SELECT *
FROM orders
ORDER BY amount DESC;

-- -------------------------------------------
-- 7. DISTINCT
-- Removes duplicate values from the result set.
-- -------------------------------------------
SELECT DISTINCT city
FROM customers;

-- -------------------------------------------
-- 8. LIMIT
-- Returns only a certain number of rows.
-- -------------------------------------------
SELECT *
FROM orders
LIMIT 5;

-- -------------------------------------------
-- 9. LIKE
-- Used for pattern matching in text columns.
--   'A%'    = starts with A
--   '%son'  = ends with son
--   '%ann%' = contains ann
-- -------------------------------------------
SELECT *
FROM customers
WHERE customer_name LIKE 'A%';

-- -------------------------------------------
-- 10. IN
-- Checks whether a value exists in a list.
-- -------------------------------------------
SELECT *
FROM customers
WHERE city IN ('New York', 'Chicago', 'Boston');

-- -------------------------------------------
-- 11. BETWEEN
-- Used for a range of values (inclusive).
-- -------------------------------------------
SELECT *
FROM orders
WHERE amount BETWEEN 100 AND 500;

-- -------------------------------------------
-- 12. IS NULL
-- Checks for missing (NULL) values.
-- -------------------------------------------
SELECT *
FROM customers
WHERE email IS NULL;

-- -------------------------------------------
-- 13. Aggregate Functions
-- Used to summarize data:
--   COUNT()  count rows
--   SUM()    total values
--   AVG()    average value
--   MIN()    minimum value
--   MAX()    maximum value
-- -------------------------------------------
SELECT COUNT(*) AS total_orders
FROM orders;

SELECT SUM(amount) AS total_sales
FROM orders;

-- -------------------------------------------
-- 14. GROUP BY
-- Groups rows for aggregation.
-- -------------------------------------------
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city;

-- -------------------------------------------
-- 15. HAVING
-- Filters grouped results (used after GROUP BY).
-- -------------------------------------------
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city
HAVING COUNT(*) > 5;

-- -------------------------------------------
-- 16. Aliases
-- Used to rename columns or tables temporarily.
-- -------------------------------------------

-- Column alias
SELECT customer_name AS name
FROM customers;

-- Table alias
SELECT c.customer_name
FROM customers c;

-- -------------------------------------------
-- 17. Basic JOIN
-- Combines data from multiple tables
-- by matching rows on a shared column.
-- -------------------------------------------
SELECT c.customer_name, o.order_id, o.amount
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id;

-- -------------------------------------------
-- 18. CASE WHEN
-- Used for conditional logic inside a query.
-- -------------------------------------------
SELECT order_id,
       amount,
       CASE
           WHEN amount >= 1000 THEN 'High'
           WHEN amount >= 500 THEN 'Medium'
           ELSE 'Low'
       END AS order_category
FROM orders;

-- -------------------------------------------
-- Combined Example
-- This query:
--   1. Filters active customers
--   2. Groups by city
--   3. Counts customers per city
--   4. Keeps only cities with more than 2 customers
--   5. Sorts from highest to lowest count
-- -------------------------------------------
SELECT city,
       COUNT(*) AS total_customers
FROM customers
WHERE status = 'Active'
GROUP BY city
HAVING COUNT(*) > 2
ORDER BY total_customers DESC;

-- -------------------------------------------
-- Suggested Learning Order:
--   1. SELECT, FROM, WHERE
--   2. ORDER BY, DISTINCT, LIMIT
--   3. AND, OR, IN, BETWEEN, LIKE
--   4. COUNT, SUM, AVG
--   5. GROUP BY, HAVING
--   6. JOIN
--   7. CASE WHEN
--
-- Once comfortable with these, move to
-- subqueries, CTEs, and window functions.
-- -------------------------------------------
