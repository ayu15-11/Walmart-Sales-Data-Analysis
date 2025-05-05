SELECT * FROM walmart_db.walmart;

SELECT COUNT(*) FROM walmart;
 SELECT DISTINCT payment_method FROM walmart
 GROUP BY payment_method;
 
 SELECT MIN(quantity) FROM walmart;
 
 
 -- q1 : What are the different payment methods, and how many transactions and
-- items were sold with each method?
 
 SELECT payment_method,
 COUNT(*) as no_payments,
 SUM(quantity) as no_qantity_sold
 FROM walmart
 group by payment_method;
 
 -- Identify the Highest-Rated Category in Each Branch
 SELECT branch, category, AVG(rating) AS avg_rating
FROM walmart
GROUP BY branch, category
HAVING avg_rating = (
    SELECT MAX(avg_rating_sub)
    FROM (
        SELECT branch AS branch_sub, category AS category_sub, AVG(rating) AS avg_rating_sub
        FROM walmart
        WHERE branch = walmart.branch
        GROUP BY branch, category
    ) AS subquery
);

-- Determine the Busiest Day for Each Branch
SELECT branch, DAYNAME(STR_TO_DATE(date, '%m/%d/%Y')) AS day_of_week, COUNT(invoice_id) AS total_transactions
FROM walmart
GROUP BY branch, day_of_week
ORDER BY branch, total_transactions DESC;


-- Calculate Total Quantity Sold by Payment Method
SELECT payment_method, SUM(quantity) AS total_quantity_sold
FROM walmart
GROUP BY payment_method;

-- Analyze Category Ratings by City
SELECT city, category, 
       AVG(rating) AS average_rating, 
       MIN(rating) AS minimum_rating, 
       MAX(rating) AS maximum_rating
FROM walmart
GROUP BY city, category;

--  Calculate Total Profit by Category (Ranked Highest to Lowest)
SELECT category, SUM(profit_margin) AS total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC;

-- Determine the Most Common Payment Method per Branch
SELECT branch, payment_method, COUNT(*) AS method_count
FROM walmart
GROUP BY branch, payment_method
HAVING method_count = (
    SELECT MAX(method_count_sub)
    FROM (
        SELECT branch AS branch_sub, payment_method AS payment_method_sub, COUNT(*) AS method_count_sub
        FROM walmart
        WHERE branch = walmart.branch
        GROUP BY branch, payment_method
    ) AS subquery
);

-- Analyze Sales Shifts Throughout the Day
SELECT branch,
       CASE
           WHEN HOUR(STR_TO_DATE(time, '%H:%i:%s')) < 12 THEN 'Morning'
           WHEN HOUR(STR_TO_DATE(time, '%H:%i:%s')) < 18 THEN 'Afternoon'
           ELSE 'Evening'
       END AS shift,
       COUNT(invoice_id) AS total_transactions
FROM walmart
GROUP BY branch, shift;

-- Identify Branches with Highest Revenue Decline Year-Over-Year

SELECT branch,
       SUM(CASE WHEN YEAR(STR_TO_DATE(date, '%m/%d/%Y')) = 2024 THEN total ELSE 0 END) AS revenue_2024,
       SUM(CASE WHEN YEAR(STR_TO_DATE(date, '%m/%d/%Y')) = 2023 THEN total ELSE 0 END) AS revenue_2023,
       (SUM(CASE WHEN YEAR(STR_TO_DATE(date, '%m/%d/%Y')) = 2023 THEN total ELSE 0 END) - 
        SUM(CASE WHEN YEAR(STR_TO_DATE(date, '%m/%d/%Y')) = 2024 THEN total ELSE 0 END)) AS revenue_decline
FROM walmart
GROUP BY branch
ORDER BY revenue_decline DESC;
