SECTION A — SQL Basics
Q1
SELECT *
FROM customers;

Q2
SELECT first_name, last_name, city
FROM customers;

Q3
SELECT DISTINCT category
FROM products;

Q4
-- Primary Keys:
-- customers -> customer_id
-- products -> product_id
-- orders -> order_id
-- order_items -> item_id

-- Primary Key must be UNIQUE and NOT NULL
-- because it uniquely identifies each row.

Q5
-- Constraints on email column:
-- UNIQUE and NOT NULL

-- Duplicate email insertion will produce
-- UNIQUE constraint violation error.

Q6
INSERT INTO products
VALUES (209, 'Test Product', 'Electronics', 'TestBrand', -50, 10);
-- CHECK constraint on unit_price prevents negative values.

SECTION B — Filtering & Optimization

Q7
SELECT *
FROM orders
WHERE status = 'Delivered';

Q8
SELECT *
FROM products
WHERE category = 'Electronics'
AND unit_price > 2000;

Q9
SELECT *
FROM customers
WHERE state = 'Maharashtra'
AND YEAR(join_date) = 2024;

Q10
SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25'
AND status != 'Cancelled';

Q11
-- idx_orders_date improves performance
-- for queries filtering by order_date.

SELECT *
FROM orders
WHERE order_date = '2024-08-15';

Q12
-- YEAR(join_date) prevents index usage
-- because function is applied on column.

-- SARGable version:

SELECT *
FROM customers
WHERE join_date >= '2024-01-01'
AND join_date < '2025-01-01';

SECTION C — Aggregation

Q13
SELECT COUNT(*) AS total_orders
FROM orders;

Q14
SELECT SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'Delivered';

Q15
SELECT category,
AVG(unit_price) AS average_price
FROM products
GROUP BY category;

Q16
SELECT status,
COUNT(*) AS total_orders,
SUM(total_amount) AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;

Q17
SELECT category,
MAX(unit_price) AS max_price,
MIN(unit_price) AS min_price
FROM products
GROUP BY category;

Q18
SELECT category,
AVG(unit_price) AS average_price
FROM products
GROUP BY category
HAVING AVG(unit_price) > 2000;

SECTION D — Joins & Relationships

Q19
SELECT o.order_id,
o.order_date,
c.first_name,
c.last_name,
o.total_amount
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;

Q20
SELECT c.first_name,
c.last_name,
o.order_id,
o.order_date
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

Q21
SELECT o.order_id,
p.product_name,
oi.quantity,
oi.unit_price,
oi.discount_pct
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id;

Q22
-- LEFT JOIN returns all rows from left table
-- and matching rows from right table.

-- RIGHT JOIN returns all rows from right table
-- and matching rows from left table.

-- FULL OUTER JOIN returns all rows
-- from both tables whether matching or not.

Q23
-- Foreign Keys:
-- orders.customer_id -> customers.customer_id
-- order_items.order_id -> orders.order_id
-- order_items.product_id -> products.product_id

-- Inserting customer_id = 999 into orders
-- will fail due to FOREIGN KEY constraint.

SECTION E — Advanced Concepts

Q24
SELECT product_name,
unit_price,
CASE
    WHEN unit_price < 1000 THEN 'Budget'
    WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
    ELSE 'Premium'
END AS price_tier
FROM products;

Q25
SELECT
SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS Delivered_Orders,
SUM(CASE WHEN status != 'Delivered' THEN 1 ELSE 0 END) AS Not_Delivered_Orders
FROM orders;

Q26
-- A - Atomicity:
-- Either complete transaction or rollback fully.

-- C - Consistency:
-- Database remains valid before and after transaction.

-- I - Isolation:
-- Transactions do not interfere with each other.

-- D - Durability:
-- Once committed, data remains saved permanently.

Q27
BEGIN TRANSACTION;

BEGIN TRY

INSERT INTO orders
VALUES (1011, 102, GETDATE(), 'Pending', 1598.00);

INSERT INTO order_items
VALUES (5016, 1011, 206, 1, 1299.00, 0);

INSERT INTO order_items
VALUES (5017, 1011, 208, 1, 299.00, 0);

UPDATE products
SET stock_qty = stock_qty - 1
WHERE product_id = 206;

UPDATE products
SET stock_qty = stock_qty - 1
WHERE product_id = 208;

COMMIT TRANSACTION;

END TRY

BEGIN CATCH

ROLLBACK TRANSACTION;

END CATCH;