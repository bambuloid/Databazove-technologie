SELECT c.region, SUM(o.profit), ROUND(AVG(o.discount), 2) AS discount, COUNT(o.order_id) FROM orders AS o
INNER JOIN customers AS c ON o.customer_id = c.customer_id
GROUP BY c.region