CREATE DATABASE IF NOT EXISTS EcommerceDB;
USE EcommerceDB;
CREATE TABLE Customer(customer_id INT PRIMARY KEY, customer_name VARCHAR(100) NOT NULL, email VARCHAR(100) NOT NULL UNIQUE);
CREATE TABLE Seller(seller_id INT PRIMARY KEY, seller_name VARCHAR(100) NOT NULL);
CREATE TABLE Category(category_id INT PRIMARY KEY, category_name VARCHAR(50) NOT NULL UNIQUE);
CREATE TABLE Product(product_id INT PRIMARY KEY, product_name VARCHAR(100) NOT NULL, price DECIMAL(10,2) NOT NULL, category_id INT NOT NULL, seller_id INT NOT NULL, FOREIGN KEY(category_id) REFERENCES Category(category_id) ON DELETE CASCADE, FOREIGN KEY(seller_id) REFERENCES Seller(seller_id) ON DELETE CASCADE);
CREATE TABLE Orders(order_id INT PRIMARY KEY, customer_id INT NOT NULL, order_date DATE NOT NULL, status VARCHAR(20) DEFAULT 'Pending', FOREIGN KEY(customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE);
CREATE TABLE OrderItem(order_id INT, product_id INT, quantity INT NOT NULL, unit_price DECIMAL(10,2) NOT NULL, PRIMARY KEY(order_id,product_id), FOREIGN KEY(order_id) REFERENCES Orders(order_id) ON DELETE CASCADE, FOREIGN KEY(product_id) REFERENCES Product(product_id) ON DELETE CASCADE);
CREATE TABLE Payment(payment_id INT PRIMARY KEY, order_id INT NOT NULL UNIQUE, amount DECIMAL(10,2) NOT NULL, FOREIGN KEY(order_id) REFERENCES Orders(order_id) ON DELETE CASCADE);
CREATE TABLE Delivery(delivery_id INT PRIMARY KEY, order_id INT NOT NULL UNIQUE, delivery_status VARCHAR(30), FOREIGN KEY(order_id) REFERENCES Orders(order_id) ON DELETE CASCADE);
CREATE TABLE Address(address_id INT PRIMARY KEY, customer_id INT NOT NULL, city VARCHAR(50), FOREIGN KEY(customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE);
CREATE TABLE CustomerCoupon(coupon_id INT PRIMARY KEY, customer_id INT NULL, coupon_code VARCHAR(30) NOT NULL, FOREIGN KEY(customer_id) REFERENCES Customer(customer_id) ON DELETE SET NULL);
INSERT INTO Customer VALUES (1,'Aman Sharma','aman@example.com'),(2,'Priya Verma','priya@example.com');
INSERT INTO Seller VALUES (1,'Tech Store');
INSERT INTO Category VALUES (1,'Electronics'),(2,'Books');
INSERT INTO Product VALUES (101,'Laptop',55000,1,1),(102,'Database Book',600,2,1);
INSERT INTO Orders VALUES (1001,1,'2026-10-01','Pending');
INSERT INTO OrderItem VALUES (1001,101,1,55000),(1001,102,2,600);
INSERT INTO Payment VALUES (501,1001,56200);
INSERT INTO Delivery VALUES (601,1001,'Processing');
INSERT INTO Address VALUES (701,1,'Delhi');
INSERT INTO CustomerCoupon VALUES (1,2,'SAVE10');
-- Cascade test:
DELETE FROM Customer WHERE customer_id=1;
SELECT * FROM Orders;
SELECT * FROM Address;
-- SET NULL test:
DELETE FROM Customer WHERE customer_id=2;
SELECT * FROM CustomerCoupon;
-- Expected FK violation; uncomment and execute separately:
-- INSERT INTO Orders VALUES (1002,999,'2026-10-02','Pending');
