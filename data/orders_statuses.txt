CREATE TABLE orders_statuses (
  id SERIAL PRIMARY KEY,
  status VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO orders_statuses (status)
VALUES
  ('New'),
  ('In progress'),
  ('Payment recieved'),
  ('Payment failed'),
  ('Completed'),
  ('Ready for pickup'),
  ('Refunded'),
  ('Delivery in progress'),
  ('Delivered'),
  ('Picked up'),
  ('Closed'),
  ('Cancelled');
