use ecommerce;

SELECT c.name, c.last_name
FROM customer c
JOIN orders o ON c.id = o.customer_id
WHERE MONTH(o.order_date) = 1
AND YEAR(o.order_date) = 2020
AND o.price * o.quantity > 1500
AND MONTH(c.birth_date) = MONTH(CURDATE())
AND DAY(c.birth_date) = DAY(CURDATE());

SELECT 
  MONTH(o.order_date) AS month,
  YEAR(o.order_date) AS year,
  c.name,
  c.last_name,
  COUNT(DISTINCT o.id) AS sales_quantity,
  SUM(o.quantity) AS products_sold,
  SUM(o.price * o.quantity) AS total_sales
FROM orders o
JOIN item i ON o.item_id = i.id
JOIN category c2 ON i.category_id = c2.id
JOIN customer c ON o.customer_id = c.id
WHERE c2.name = 'Celulares'
AND YEAR(o.order_date) = 2020
GROUP BY YEAR(o.order_date), MONTH(o.order_date), c.id, c.name, c.last_name
ORDER BY YEAR(o.order_date), MONTH(o.order_date), total_sales DESC
LIMIT 5;
