SELECT o.order_id, c.customer_name, o.profit FROM orders AS o
INNER JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.profit > 500
ORDER BY o.profit DESC;
