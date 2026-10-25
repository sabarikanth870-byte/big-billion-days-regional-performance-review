-- Business question: How did completed revenue perform by region and month?
-- An INNER JOIN is used because the report only includes orders, and every order has exactly one matching customer.
-- COUNT(DISTINCT o.customer_id) is necessary because one customer can place multiple completed orders in the same region-month.
SELECT c.region,
       o.order_month,
       COUNT(*) AS number_of_orders,
       COUNT(DISTINCT o.customer_id) AS number_of_customers,
       SUM(o.amount) AS total_revenue,
       AVG(o.amount) AS average_revenue
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region, o.order_month
ORDER BY c.region ASC, o.order_month ASC;
