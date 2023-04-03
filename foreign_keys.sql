ALTER TABLE users
	ADD CONSTRAINT users_discounts_fk
	FOREIGN KEY (personal_discount_id)
	REFERENCES discounts (id)
		ON DELETE CASCADE,
	ADD CONSTRAINT users_active_payments_fk
	FOREIGN KEY (active_payment_id)
	REFERENCES payment_methods (id)
		ON DELETE CASCADE;


ALTER TABLE passwords
	ADD CONSTRAINT passwords_tokens_user_id_fk
	FOREIGN KEY (user_id)
	REFERENCES users (id)
		ON DELETE RESTRICT;


ALTER TABLE payment_methods
	ADD CONSTRAINT payment_methods_discounts_fk
	FOREIGN KEY (discount_id)
	REFERENCES discounts (id)
		ON DELETE CASCADE;


ALTER TABLE payments_users
	ADD CONSTRAINT payments_users_fk
	FOREIGN KEY (user_id)
	REFERENCES users (id)
		ON DELETE CASCADE,
	ADD CONSTRAINT payments_methods_fk
	FOREIGN KEY (payment_id)
	REFERENCES payment_methods (id)
		ON DELETE CASCADE;


ALTER TABLE cart
	ADD CONSTRAINT cart_users_fk
	FOREIGN KEY (user_id)
	REFERENCES users (id)
		ON DELETE CASCADE,
	ADD CONSTRAINT cart_products_fk
	FOREIGN KEY (product_id)
	REFERENCES products (id)
		ON DELETE CASCADE,
	ADD CONSTRAINT cart_discounts_fk
	FOREIGN KEY (discount_id)
	REFERENCES discounts (id)
		ON DELETE CASCADE;


ALTER TABLE products
	ADD CONSTRAINT products_rubrics_fk
	FOREIGN KEY (rubric_id)
	REFERENCES rubrics (id)
		ON DELETE CASCADE,
	ADD CONSTRAINT products_main_photos_fk
	FOREIGN KEY (main_photo_id)
	REFERENCES product_photos (id)
		ON DELETE CASCADE,
	ADD CONSTRAINT products_brands_fk
	FOREIGN KEY (brand_id)
	REFERENCES brands (id)
		ON DELETE CASCADE,
	ADD CONSTRAINT products_discounts_fk
	FOREIGN KEY (product_discount)
	REFERENCES discounts (id)
		ON DELETE CASCADE,
	ADD CONSTRAINT products_types_fk
	FOREIGN KEY (type_id)
	REFERENCES products_types (id)
		ON DELETE CASCADE;


ALTER TABLE product_photos
	ADD CONSTRAINT photos_products_fk
	FOREIGN KEY (product_id)
	REFERENCES products (id)
		ON DELETE CASCADE;


ALTER TABLE orders
	ADD CONSTRAINT order_user_id_fk
	FOREIGN KEY (user_id)
	REFERENCES users (id)
		ON DELETE CASCADE,
	ADD CONSTRAINT order_status_fk
	FOREIGN KEY (status)
	REFERENCES orders_statuses (id)
		ON DELETE CASCADE;


ALTER TABLE ordered_products
	ADD CONSTRAINT order_product_id_fk
	FOREIGN KEY (product_id)
	REFERENCES products (id)
		ON DELETE RESTRICT,
	ADD CONSTRAINT order_id_ordered_products_fk
	FOREIGN KEY (order_id)
	REFERENCES orders (id)
		ON DELETE RESTRICT;