
-- Рубрики

CREATE TABLE rubrics (
  id SERIAL PRIMARY KEY,
  parent_id INT[],
  name VARCHAR(50) NOT NULL
);



-- Пользователи

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  phone VARCHAR(15),
  active_payment_id INT,
  delivery_address TEXT,
  personal_discount_id INT,
  created_at TIMESTAMP
);


-- Аутентификация

CREATE TABLE passwords (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  password_token VARCHAR(120) NOT NULL UNIQUE,
  expires_at TIMESTAMP
);



-- Типы скидок

CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  discount VARCHAR(120) NOT NULL UNIQUE,
  percent INT NOT NULL
);



-- Методы оплаты

CREATE TABLE payment_methods (
  id SERIAL PRIMARY KEY,
  discount_id INT, 
  method VARCHAR(120) NOT NULL UNIQUE
);



-- Связь пользователей и методов оплаты

CREATE TABLE payments_users (
  user_id INT NOT NULL,
  payment_id INT,
  PRIMARY KEY (user_id,payment_id)
);



-- Корзина

CREATE TABLE cart (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  product_id INT NOT NULL,
  product_count INT NOT NULL,
  discount_id INT,
  added_at TIMESTAMP
);



-- Продукты

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  rubric_id INT NOT NULL,
  name VARCHAR(120) NOT NULL,
  description VARCHAR(120),
  type_id INT NOT NULL,
  main_photo_id INT NOT NULL,
  brand_id INT NOT NULL,
  size VARCHAR(10) NOT NULL,
  color VARCHAR(50) NOT NULL,
  season VARCHAR(50) NOT NULL,
  price FLOAT NOT NULL,
  count_available INT,
  product_discount INT,
  updated_at TIMESTAMP
);


-- Типы продуктов

CREATE TABLE products_types (
  id SERIAL PRIMARY KEY,
  type VARCHAR(50) NOT NULL
);


-- Фото продуктов

CREATE TABLE product_photos (
  id SERIAL PRIMARY KEY,
  url VARCHAR(250) NOT NULL UNIQUE,
  product_id INT NOT NULL,
  uploaded_at TIMESTAMP NOT NULL,
  size INT NOT NULL
);



-- Бренды

CREATE TABLE brands (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE,
  logo_url VARCHAR(250),
  description VARCHAR(250),
  site_url VARCHAR(250),
  added_at TIMESTAMP NOT NULL
);



-- Заказы

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  status INT NOT NULL,
  created_at TIMESTAMP NOT NULL
);



-- Статусы заказов

CREATE TABLE orders_statuses (
  id SERIAL PRIMARY KEY,
  status VARCHAR(50) NOT NULL UNIQUE
);



-- Связь заказы - продукты

CREATE TABLE ordered_products (
  product_id INT NOT NULL,
  count INT NOT NULL,
  order_id INT NOT NULL,
  PRIMARY KEY (order_id, product_id)
);

