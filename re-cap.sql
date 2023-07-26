-- RE-CAP

--QUESTION-1
--Find the number of orders made by employee number 6 between '2018-01-04' and '2019-01-04'

SELECT COUNT(order_id) cnt_order
FROM sale.orders
WHERE staff_id=6
AND order_date BETWEEN '2018-01-04' AND '2019-01-04';

--QUESTION-2
--Report the number of orders made by each employee in store number 1
--between '2018-01-04' and '2019-01-04'

SELECT staff_id, COUNT(staff_id) order_num
FROM sale.orders
WHERE store_id=1
AND order_date BETWEEN '2018-01-04' AND '2019-01-04'
GROUP BY staff_id;

--QUESTION-3
--Report the daily number of orders made by the employees in the store number 1
--between '2018-01-04' and '2019-02-04'

SELECT staff_id, order_date, COUNT(order_id) cnt_order
FROM sale.orders
WHERE store_id=1
AND order_date BETWEEN '2018-01-04' AND '2018-02-04'
GROUP BY staff_id, order_date
ORDER BY 1;

--QUESTION-4
--Find the store with the highest number of unshipped orders.

SELECT TOP 1 store_id, COUNT(store_id) AS cnt_order
FROM sale.orders
WHERE shipped_date IS NULL
GROUP BY store_id
ORDER BY cnt_order DESC;

--If we want to find store name in the same statement;

SELECT TOP 1 s.store_name, o.store_id, COUNT(o.store_id) AS cnt_order
FROM sale.orders o
LEFT JOIN sale.store s ON s.store_id=o.store_id
WHERE o.shipped_date IS NULL
GROUP BY s.store_name, o.store_id
ORDER BY cnt_order DESC;

--DIFFERENT USAGE OF 'TOP' KEYWORD
-- TOP N WITH TIES --->Return if more than one of the top data of the result is the same, it gives us them as well.
-- TOP N PERCENT ----> Return a specific percentage of rows from the result set.
-- TOP N PERCENT WITH TIES ----> Return a specific percentage of rows and include any additional rows with the same values.

--QUESTION-5
--Find the distribution of the number of customers who placed ordes before 2020 by stores.

SELECT s.store_name, o.store_id, COUNT(o.customer_id) cnt_order
FROM sale.orders o
LEFT JOIN sale.store s ON s.store_id=o.store_id
WHERE DATEPART(YEAR, order_date) < 2020
GROUP BY s.store_name, o.store_id
ORDER BY cnt_order DESC;

--QUESTION-6
--Find the employee with the lowest performance in the second quarter of 2020 (must return name and number of orders) 

SELECT TOP 1 o.staff_id, s.first_name, COUNT(o.order_id) cnt_orders
FROM sale.orders o
LEFT JOIN sale.staff s ON s.staff_id=o.staff_id
WHERE YEAR(o.order_date)=2020
AND DATEPART(Q, o.order_date)=2
GROUP BY o.staff_id, s.first_name
ORDER BY cnt_orders;

SELECT TOP 1 o.staff_id, s.first_name, COUNT(o.order_id) cnt_orders
FROM sale.orders o
LEFT JOIN sale.staff s ON s.staff_id=o.staff_id
WHERE order_date LIKE '2020-0[4,6]-%'
GROUP BY o.staff_id, s.first_name
ORDER BY cnt_orders;


--QUESTION-7
--Find the product with the least profit.

SELECT TOP 1 i.product_id, SUM(i.quantity*i.list_price*(1-i.discount)) total_income
FROM sale.order_item i
GROUP BY i.product_id
ORDER BY total_income;

--QUESTION-8
--Find the store with the highest turnover in the 4th, 5th and 6th months of 2018.

SELECT TOP 1 store_name, 
	SUM(quantity*list_price*(1-discount)) total_income
FROM sale.store a, sale.orders b, sale.order_item c
WHERE a.store_id=b.store_id
AND b.order_id=c.order_id
AND order_date LIKE '2018-0[4-6]-%'
GROUP BY store_name
ORDER BY total_income DESC;


--QUESTION-9
--Report the weekly sales performance of the employees for the 4th month of 2020.

--solution-1
SELECT s.first_name, s.last_name, DATEPART(ISOWK, o.order_date) ord_week,
	SUM(i.quantity) total_quantity,
	COUNT(o.order_id) total_order,
	SUM(i.quantity*i.list_price*(1-i.discount)) total_sales
FROM sale.orders o
	INNER JOIN sale.order_item i ON o.order_id=i.order_id
	INNER JOIN sale.staff s ON o.staff_id=s.staff_id
WHERE YEAR(order_date)=2020 AND MONTH(order_date)=4
GROUP BY first_name, last_name, DATEPART(ISOWK, order_date);

--solution-2
SELECT s.first_name, s.last_name, DATEPART(ISOWK, o.order_date) ord_week,
	SUM(i.quantity) total_quantity,
	COUNT(o.order_id) total_order,
	SUM(i.quantity*i.list_price*(1-i.discount)) total_sales
FROM sale.staff s
INNER JOIN sale.orders o ON o.staff_id=s.staff_id
INNER JOIN sale.order_item i ON i.order_id=o.order_id
WHERE YEAR(order_date)=2020 AND MONTH(order_date)=4
GROUP BY s.first_name, s.last_name, DATEPART(ISOWK, o.order_date);






----------------------------------------------------------
--difference between week and isoweek

SELECT DATEPART(w, '2018-01-01')
SELECT DATEPART(ISOWK, '2018-01-01')
SELECT DATEPART(dw, '2018-01-01')


----------------------------------------------------------
--JOINs

SELECT * FROM product.stock

SELECT a.product_id, b.store_id, ISNULL(c.quantity,0) quantity --COALESCE
FROM product.product a
	CROSS JOIN sale.store b
	LEFT JOIN product.stock c ON a.product_id=c.product_id
	AND b.store_id=c.store_id
ORDER BY 1,2;


--------------------------------------------
--COALESCE vs. ISNULL

SELECT ISNULL(phone,0) phone
FROM sale.customer;


SELECT COALESCE(phone,'0') phone
FROM sale.customer;

SELECT 1 + '1' --implicit conversion


--NULLIF
--it avoids zero division errors

SELECT NULLIF(1, '1')

SELECT 1/0

SELECT 1/NULLIF(number, 0)
SELECT 1/NULLIF(0, 0)
SELECT 1/NULLIF(1, 0)
SELECT 1/NULLIF(5, 0)