Create table flourmills_sale (
    sales_id INT PRIMARY KEY,
    sales_date DATE,
    region VARCHAR(100),
    state VARCHAR(100),
    product_category VARCHAR(100),
    product_name VARCHAR(150),
    customer_type VARCHAR(100),
    customer_id INT,
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    discount_rate INT,
    payment_method VARCHAR(100),
    sales_rep VARCHAR(150),
    warehouse VARCHAR(100),
    delivery_status VARCHAR(100),
    order_channel VARCHAR(100),
    batch_number INT,
    production_date DATE,
    total_amount DECIMAL(10, 2)
)

-- 1
SELECT product_name, total_amount FROM flourmills_sale
WHERE total_amount > (SELECT AVG(total_amount) FROM flourmills_sale);


-- 2
SELECT sales_id, sales_date, region, product_category FROM flourmills_sale
WHERE product_category =  (
        SELECT product_category FROM flourmills_sale 
        GROUP BY product_category 
        ORDER BY SUM(total_amount) DESC 
        LIMIT 1)
ORDER BY sales_id;

-- 3
SELECT product_name, total_amount, (SELECT AVG(total_amount) FROM flourmills_sale) AS avg_amount FROM flourmills_sale;

-- 4
SELECT product_name, total_amount, total_amount/(SELECT SUM(total_amount) FROM flourmills_sale) AS amount_share FROM flourmills_sale;

-- 5
SELECT * FROM (
    SELECT EXTRACT(MONTH FROM sales_date), SUM(total_amount) FROM flourmills_sale 
    GROUP BY EXTRACT(MONTH FROM sales_date) 
    ORDER BY EXTRACT(MONTH FROM sales_date) ASC) AS tabulka;

-- 6
SELECT * FROM (
    SELECT product_category, SUM(total_amount) AS totalsum FROM flourmills_sale
    GROUP BY product_category
) AS tabulka
WHERE totalsum > 50000000;

--7
SELECT t1.product_name, t1.product_category, t1.total_amount
FROM flourmills_sale t1
WHERE total_amount > (SELECT AVG(total_amount) FROM flourmills_sale t2 WHERE t1.product_category = t2.product_category);

--8
SELECT t1.product_name, t1.region, t1.total_amount, (SELECT MIN(total_amount) FROM flourmills_sale t2 WHERE t1.region = t2.region) AS region_min_amount
FROM flourmills_sale t1

--10
SELECT product_category, product_name, total_amount
FROM flourmills_sale AS f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sale AS f2
    WHERE f2.product_category = f1.product_category
      AND f2.total_amount > 200000
);

--11
SELECT DISTINCT product_category FROM (SELECT DISTINCT product_category FROM flourmills_sale) f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sale AS f2
    WHERE f2.product_category = f1.product_category
    group by f2.product_category
    HAVING COUNT(DISTINCT f2.region) > 3
    
);

--12
SELECT region FROM flourmills_sale AS f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sale AS f2
    WHERE f2.region = f1.region
    GROUP BY f2.region
    HAVING EXTRACT(YEAR FROM f1.sales_date) = 2024
)

--13
SELECT DISTINCT product_category FROM flourmills_sale AS f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sale AS f2
    WHERE f2.product_category = f1.product_category
    GROUP BY f2.product_category
    HAVING f1.total_amount < 50000
)

-- 14
SELECT DISTINCT region FROM flourmills_sale AS f1
WHERE NOT EXISTS(
    SELECT 1
    FROM flourmills_sale AS f2
    WHERE f2.region = f1.region
    AND product_category = 'Flour'
)