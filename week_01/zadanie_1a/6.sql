SELECT c.customer_name, o.order_id, o.profit FROM orders AS o
FULL OUTER JOIN customers AS c ON o.customer_id = c.customer_id
