SELECT c.customer_name, COUNT(o.order_id) FROM customers AS c
FULL OUTER JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;