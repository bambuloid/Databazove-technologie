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

--4
CREATE INDEX idx_order_customer_id ON orders (customer_id);

SELECT * FROM orders WHERE customer_id = 'C001';

--5
CREATE INDEX idx_orders_order_date ON orders (order_date);

SELECT DATE_TRUNC('month', order_date) AS mesiac, SUM(sales) AS predaje 
FROM orders
GROUP BY mesiac
ORDER BY mesiac;

--6
CREATE INDEX idx_orders_region_category ON orders(customer_id, order_date);

SELECT o.customer_id, c.region, DATE_TRUNC('month', o.order_date) AS mesiac, o.profit FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.region = 'West' AND DATE_TRUNC('month', o.order_date) >= '2024-01-01'

--7
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 'C001';


-- tvorba databazy retail_sales

CREATE DATABASE retail_sales;

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL,
    region VARCHAR(20) NOT NULL,
    category VARCHAR(50) NOT NULL,
    ship_mode VARCHAR(30) NOT NULL,
    sales DECIMAL(10, 2) NOT NULL,
    profit DECIMAL(10, 2) NOT NULL
);

ALTER DATABASE retail_sales SET datestyle TO 'ISO, MDY';

SELECT * FROM orders;

--8
CREATE OR REPLACE PROCEDURE get_customer_sales(IN p_customer_id VARCHAR(20))
LANGUAGE plpgsql
AS $$
DECLARE total_sales INT;
BEGIN

    SELECT COUNT(sales) INTO total_sales FROM orders
    WHERE customer_id = p_customer_id;
    
    
RAISE NOTICE 'Total sales for customer %: %', p_customer_id, total_sales;

END;
$$;


CALL get_customer_sales('CUST00861')

--9
CREATE OR REPLACE PROCEDURE apply_regional_discount(p_region_name VARCHAR(20), p_discount_rate DECIMAL(10,2))
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE orders
    SET sales = sales * (1 - p_discount_rate)
    WHERE region = p_region_name;

    RAISE NOTICE '%: %', p_region_name, p_discount_rate;
END;
$$;

CALL apply_regional_discount('West', 0.10);

--10
CREATE OR REPLACE PROCEDURE get_sales_between(start_date DATE, end_date DATE)
LANGUAGE plpgsql
AS $$
DECLARE total_sales DECIMAL(10,2);
BEGIN
SELECT SUM(sales) INTO total_sales FROM orders
WHERE order_date BETWEEN start_date AND end_date;

RAISE NOTICE ' % - %: %', start_date, end_date, total_sales;

END;
$$;

CALL get_sales_between('2024-01-01', '2024-03-31');

