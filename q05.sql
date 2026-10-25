-- Business question: What are the headline completed-order KPIs?
SELECT COUNT(*) AS total_orders,
       SUM(o.amount) AS total_revenue,
       AVG(o.amount) AS avg_order_value,
       MIN(o.amount) AS min_order_value,
       MAX(o.amount) AS max_order_value
FROM orders AS o
WHERE o.status = 'completed';
