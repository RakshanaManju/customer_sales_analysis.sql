-- Customer Sales Analysis
-- Top 10 customers by total spend
SELECT customer_id, SUM(total_amount) AS total_spent
FROM sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- Most frequently purchased items
SELECT item_id, COUNT(*) AS purchase_frequency
FROM sales
GROUP BY item_id
ORDER BY purchase_frequency DESC;

-- Average order value
SELECT AVG(total_amount) AS average_order_value
FROM sales;
