CREATE DATABASE blinkit;

CREATE TABLE blinkit_customers(
customer_id bigint,
customer_name varchar(50),
email varchar(50),
phone bigint,
address varchar(200),
area text,
pincode bigint,
registration_date date,
customer_segment varchar(50),
total_orders int,
avg_order_value int
);

CREATE TABLE blinkit_customer_feedback(
feedback_id bigint primary key ,
order_id bigint ,
customer_id bigint ,
rating int ,
feedback varchar(100) ,
feedback_category varchar(20) ,
sentiment varchar(20) ,
feedback_date date
);

CREATE TABLE blinkit_delivery_performance(
order_id bigint primary key,
delivery_partner_id bigint ,
promised_time datetime ,
actual_time datetime ,
delivery_time_minutes int, 
distance_km float ,
delivery_status varchar(50) ,
reasons_if_delayed varchar(50)
);

CREATE TABLE blinkit_inventory(
product_id bigint ,
date date ,
stock_received int ,
damaged_stock int
);

CREATE TABLE blinkit_order_items(
product_id bigint ,
date date ,
stock_received int ,
damaged_stock int
);

CREATE TABLE blinkit_orders(
order_id bigint ,
customer_id bigint ,
order_date date ,
order_time time ,
promised_delivery_date date ,
promised_delivery_time time ,
actual_delivery_date date ,
actual_delivery_time time ,
delivery_status varchar(50) ,
order_total double ,
payment_method varchar(50) ,
delivery_partner_id bigint ,
store_id bigint
);

CREATE TABLE blinkit_products(
product_id bigint ,
product_name text ,
category text ,
brand text ,
price double ,
mrp double ,
margin_percentage double ,
shelf_life_days int ,
min_stock_level int ,
max_stock_level int
);

use blinkit;

ALTER TABLE blinkit_customers
DROP COLUMN	customer_name;

ALTER TABLE blinkit_customers
DROP COLUMN	email;

ALTER TABLE blinkit_customers
DROP COLUMN	phone;

ALTER TABLE blinkit_customers
DROP COLUMN	registration_date;

ALTER TABLE blinkit_customer_feedback
DROP COLUMN	feedback_date;

ALTER TABLE blinkit_orders
DROP COLUMN	promised_delivery_date;

ALTER TABLE blinkit_orders
DROP COLUMN	actual_delivery_date;

CREATE TABLE MAIN_TABLE AS
SELECT o.order_id,c.customer_id,o.order_date,o.order_time,
o.promised_delivery_time,o.actual_delivery_time,
o.delivery_status,o.order_total as total_price,
o.payment_method,c.area as city,c.customer_segment,
c.total_orders,c.avg_order_value,cf.feedback,
cf.feedback_category,cf.sentiment,d.delivery_time_minutes,
d.distance_km,d.reasons_if_delayed,oi.quantity,oi.unit_price,
oi.product_id,p.product_name,p.category,p.brand,p.mrp,
p.price,p.margin_percentage,p.shelf_life_days,
SUM(i.stock_received) as total_stock_received,
SUM(i.damaged_stock) as total_damaged_stock
FROM blinkit_orders o
LEFT JOIN 
blinkit_customers c ON o.customer_id = c.customer_id
LEFT JOIN 
blinkit_customer_feedback cf ON o.order_id = cf.order_id
LEFT JOIN 
blinkit_order_items oi ON o.order_id = oi.order_id
LEFT JOIN 
blinkit_delivery_performance d ON o.order_id = d.order_id
LEFT JOIN 
blinkit_products p ON oi.product_id = p.product_id
LEFT JOIN 
blinkit_inventory i ON oi.product_id = i.product_id
GROUP BY o.order_id,c.customer_id,o.order_date,o.order_time,
o.promised_delivery_time,o.actual_delivery_time,o.delivery_status,
o.order_total,o.payment_method,c.area,c.customer_segment,
c.total_orders,c.avg_order_value,cf.feedback,cf.feedback_category,
cf.sentiment,d.delivery_time_minutes,d.distance_km,
d.reasons_if_delayed,oi.quantity,oi.unit_price,oi.product_id,
p.product_name,p.category,
p.brand,p.mrp,p.price,p.margin_percentage,p.shelf_life_days;

use blinkit
