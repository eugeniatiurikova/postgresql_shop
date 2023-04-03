

-- Функция нахождения покупателей с определенным типом активного метода платежа

CREATE FUNCTION customer_with_payment_method_id (method_id BIGINT, OUT all_users ARRAY)AS$$SELECT ARRAY_AGG (DISTINCT id) FROM users
	LEFT JOIN payments_users
	ON users.id = payments_users.user_id
	WHERE active_payment_id = 2
	ORDER BY id;$$LANGUAGE SQL;

SELECT customer_with_payment_method_id();




-- Покупатели, которые не указали ни один активный способ оплаты

CREATE OR REPLACE VIEW users_with_no_active_payment AS 
SELECT id, active_payment_id FROM users
	LEFT JOIN payments_users
	ON users.id = payments_users.user_id
	WHERE active_payment_id IS NULL;
	
SELECT * FROM users_with_no_active_payment;




-- Для покупателей, у которых не установлен активный спсособ платежа, установить активным первый из всех заявленных пользователем

UPDATE users SET active_payment_id = (
	SELECT payment_id FROM payments_users 
	WHERE user_id = users.id LIMIT 1) 
	WHERE users.id = (
		SELECT DISTINCT id FROM users
		LEFT JOIN payments_users
			ON users.id = payments_users.user_id
		WHERE active_payment_id IS NULL);



-- Покупатели, у которых нет ни одного способа оплаты

SELECT 
	users.id AS user_id, 
	payment_id, 
	active_payment_id, 
	first_name, 
	last_name 
	FROM payments_users
	RIGHT JOIN users 
		ON payments_users.user_id = users.id
WHERE payment_id IS NULL
ORDER BY user_id;




-- Добавить пользователям без способов оплаты способ оплаты по умолчанию (1)

INSERT INTO payments_users (user_id, payment_id)
	SELECT 
		users.id AS user_id, 
		payment_methods.id AS payment_id
	FROM payments_users
	RIGHT JOIN users 
		ON payments_users.user_id = users.id
	JOIN payment_methods 
		ON payment_methods.id = 1
	WHERE payment_id IS NULL;





-- 5 покупателей с наибольшим кол-вом позиций в заказе

SELECT DISTINCT
	id AS order_id, user_id, 
	COUNT(id) OVER (PARTITION BY orders.id) AS positions_in_order
	FROM orders
	JOIN ordered_products
		ON orders.id = ordered_products.order_id
ORDER BY positions_in_order DESC LIMIT 5;




-- ФИО покупателя, id заказа, время создания, метод платежа, id и кол-во товаров в заказе для всех новых заказов (статус = 1)

SELECT DISTINCT selected_orders.order_id, 
	created_at, 
	first_name, 
	last_name, 
	payment_method, 
	product_id, 
	count
	FROM (
	  SELECT first_name, 
		last_name, 
		orders.id AS order_id, 
		status, 
		orders.created_at, 
		user_id, 
		method AS payment_method
	  FROM orders
		JOIN users
		ON orders.user_id = users.id
		JOIN payment_methods
		ON payment_methods.id = active_payment_id
	) AS selected_orders
	JOIN ordered_products
		ON selected_orders.order_id = ordered_products.order_id
WHERE status = 1;




-- То же с общим табличным выражением 

WITH selected_orders AS (
	SELECT 	first_name, 
		last_name, 
		orders.id AS order_id, 
		status, 
		orders.created_at, 
		user_id, 
		method AS payment_method
	  FROM orders
		JOIN users
		ON orders.user_id = users.id
		JOIN payment_methods
		ON payment_methods.id = active_payment_id)
SELECT DISTINCT selected_orders.order_id, created_at, first_name, last_name, payment_method, product_id, count
	FROM selected_orders
	JOIN ordered_products
		ON selected_orders.order_id = ordered_products.order_id
WHERE status = 1;




-- Оптимизированный запрос

SELECT	first_name, 
	last_name,  
	orders.id AS order_id, 
	orders.created_at, 
	method AS payment_method, 
	product_id, 
	count
	FROM orders
		JOIN users
			ON orders.user_id = users.id
		JOIN payment_methods
			ON payment_methods.id = active_payment_id
		JOIN ordered_products
			ON orders.id = ordered_products.order_id
WHERE status = 1;




-- Покупатели, сделавшие больше всего заказов

SELECT DISTINCT
	user_id, 
	COUNT(user_id) OVER (PARTITION BY orders.user_id) AS orders_by_user
	FROM orders
	JOIN ordered_products
		ON orders.id = ordered_products.order_id
ORDER BY orders_by_user DESC;



-- Функция, определяющая покупателя с наибольшим числом заказов

CREATE FUNCTION customer_with_more_orders(OUT user_id BIGINT, OUT orders_total BIGINT)AS$$SELECT DISTINCT
	user_id, 
	COUNT(user_id) OVER (PARTITION BY orders.user_id) AS orders_by_user
	FROM orders
	JOIN ordered_products
		ON orders.id = ordered_products.order_id
ORDER BY orders_by_user DESC LIMIT 1;$$LANGUAGE SQL;

SELECT customer_with_more_orders();




-- К-во позиций в заказах

SELECT DISTINCT order_id,
	COUNT(order_id) OVER (PARTITION BY order_id) AS total
	FROM ordered_products
ORDER BY total DESC;




-- Полная стоимость заказов

SELECT user_id, status, order_id, total_sum FROM orders
	JOIN (
	SELECT DISTINCT order_id,
		sum(price * count) OVER (PARTITION BY order_id) AS total_sum
	FROM ordered_products
		JOIN products
		ON ordered_products.product_id = products.id) AS total_sums
	ON orders.id = total_sums.order_id
ORDER BY total_sum DESC;




-- Все новые заказы по убыванию общей суммы

SELECT order_id, first_name, last_name, status, total_sum 
	FROM orders
	JOIN (
	SELECT DISTINCT order_id,
		sum(price * count) OVER (PARTITION BY order_id) AS total_sum
	FROM ordered_products
		JOIN products
		ON ordered_products.product_id = products.id) AS total_sums
	ON orders.id = total_sums.order_id
	JOIN users ON user_id = users.id
WHERE status = 1
ORDER BY total_sum DESC;




-- Имена и фамилии владельцев заказов, id заказов и их полная стоимость 

SELECT orders_users.order_id, first_name, last_name, total_sum 
	FROM (
		SELECT user_id, first_name, last_name, orders.id AS order_id FROM orders
			JOIN users
			ON orders.user_id = users.id) 
	AS orders_users
	JOIN (
		SELECT DISTINCT order_id,
			sum(price * count) OVER (PARTITION BY order_id) AS total_sum
		FROM ordered_products
			JOIN products
			ON ordered_products.product_id = products.id) 
	AS total_sums
	ON orders_users.order_id = total_sums.order_id
ORDER BY total_sum DESC;





-- Товары в корзине и общая стоимость для каждого из покупателей

SELECT user_id, product_id, product_count, price, 
	(product_count * price) AS total,
	SUM(product_count * price) OVER(PARTITION BY user_id) as grand_total
	FROM cart
		JOIN products
		ON product_id = products.id
ORDER BY user_id;




-- Функция для определения общей стоимости корзины для выбранного покупателя

CREATE FUNCTION customer_cart_total_sum(input_user_id INT, OUT total BIGINT)AS$$SELECT DISTINCT SUM(product_count * price) OVER()
	FROM cart
		JOIN products
		ON product_id = products.id
WHERE user_id = input_user_id;$$LANGUAGE SQL;

SELECT customer_cart_total_sum();




-- Покупатели, у которых в корзине товаров больше чем на 10000

SELECT DISTINCT user_id, grand_total 
FROM (
	SELECT user_id, product_id, product_count, price, (product_count * price) AS total,
	SUM(product_count * price) OVER(PARTITION BY user_id) as grand_total
	FROM cart
		JOIN products
		ON product_id = products.id
	ORDER BY user_id) AS cart_with_sums
WHERE cart_with_sums.grand_total >= 10000;




-- Установить покупателям, у которых в корзине товаров больше, чем на 5000, персональную скидку 5 (Total amount more then 5000), а тем, у которых там больше, чем на 10000 - персональную скидку 4 (Total amount more then 10000)

CREATE TEMPORARY TABLE users_with_cart_more_then5k (
	id INT,
	discount INT
);

CREATE VIEW cart_with_sums AS (
  SELECT user_id, product_id, product_count, price, 
	(product_count * price) AS total,
	SUM(product_count * price) OVER(PARTITION BY user_id) as grand_total
	FROM cart
	JOIN products ON product_id = products.id
);

INSERT INTO users_with_cart_more_then5k
	SELECT DISTINCT user_id, 4 AS discount FROM cart_with_sums
		WHERE cart_with_sums.grand_total >= 10000;

INSERT INTO users_with_cart_more_then5k
	SELECT DISTINCT user_id, 5 AS discount FROM cart_with_sums
		WHERE cart_with_sums.grand_total >= 5000 AND cart_with_sums.grand_total < 10000;
		
UPDATE users SET personal_discount_id = discount
	FROM users_with_cart_more_then5k
	WHERE users_with_cart_more_then5k.id = users.id;
