SELECT c.customer_name, SUM(o.profit) FROM customers AS c
INNER JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING SUM(o.profit) > 2000;