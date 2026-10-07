--1
CREATE OR REPLACE VIEW high_value_customers AS
SELECT c.customer_id, c.customer_name, SUM(o.sales) AS total_sales FROM customers c
INNER JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

SELECT * FROM high_value_customers
WHERE total_sales > 2000;

--2
CREATE OR REPLACE VIEW regional_monthly_sales AS
SELECT c.region, DATE_TRUNC('month', o.order_date) AS mesiac, SUM(o.sales) AS monthly_sales FROM customers AS c
INNER JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.region, mesiac

SELECT * FROM regional_monthly_sales WHERE region = 'West';

--3
CREATE OR REPLACE VIEW analyst_orders AS
SELECT order_id, customer_id, product_id, sales, quantity, discount FROM orders;

SELECT * FROM analyst_orders;