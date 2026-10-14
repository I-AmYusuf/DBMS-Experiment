CREATE DATABASE IF NOT EXISTS NormalizationDB;
USE NormalizationDB;
DROP TABLE IF EXISTS OrderItems_3NF;
DROP TABLE IF EXISTS Orders_3NF;
DROP TABLE IF EXISTS Products_3NF;
DROP TABLE IF EXISTS Salespersons;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Sales_UNF;
CREATE TABLE Sales_UNF(order_id INT,order_date DATE,customer_id INT,customer_name VARCHAR(100),customer_city VARCHAR(50),product_id INT,product_name VARCHAR(100),unit_price DECIMAL(10,2),quantity INT,salesperson_id INT,salesperson_name VARCHAR(100));
INSERT INTO Sales_UNF VALUES
(1,'2026-09-01',101,'Aman','Delhi',201,'Laptop',50000,1,301,'Ravi'),
(1,'2026-09-01',101,'Aman','Delhi',202,'Mouse',800,2,301,'Ravi'),
(2,'2026-09-02',102,'Priya','Noida',201,'Laptop',50000,1,302,'Neha'),
(3,'2026-09-03',103,'Rahul','Delhi',203,'Keyboard',1500,2,301,'Ravi'),
(4,'2026-09-04',101,'Aman','Delhi',203,'Keyboard',1500,1,302,'Neha');
-- 1NF: one atomic product per row; composite key (order_id, product_id)
CREATE TABLE Customers(customer_id INT PRIMARY KEY,customer_name VARCHAR(100),customer_city VARCHAR(50));
INSERT INTO Customers SELECT DISTINCT customer_id,customer_name,customer_city FROM Sales_UNF;
CREATE TABLE Salespersons(salesperson_id INT PRIMARY KEY,salesperson_name VARCHAR(100));
INSERT INTO Salespersons SELECT DISTINCT salesperson_id,salesperson_name FROM Sales_UNF;
CREATE TABLE Orders_3NF(order_id INT PRIMARY KEY,order_date DATE,customer_id INT,salesperson_id INT,FOREIGN KEY(customer_id) REFERENCES Customers(customer_id),FOREIGN KEY(salesperson_id) REFERENCES Salespersons(salesperson_id));
INSERT INTO Orders_3NF SELECT DISTINCT order_id,order_date,customer_id,salesperson_id FROM Sales_UNF;
CREATE TABLE Products_3NF(product_id INT PRIMARY KEY,product_name VARCHAR(100),unit_price DECIMAL(10,2));
INSERT INTO Products_3NF SELECT DISTINCT product_id,product_name,unit_price FROM Sales_UNF;
CREATE TABLE OrderItems_3NF(order_id INT,product_id INT,quantity INT,PRIMARY KEY(order_id,product_id),FOREIGN KEY(order_id) REFERENCES Orders_3NF(order_id),FOREIGN KEY(product_id) REFERENCES Products_3NF(product_id));
INSERT INTO OrderItems_3NF SELECT order_id,product_id,quantity FROM Sales_UNF;
-- Lossless reconstruction check
SELECT o.order_id,o.order_date,c.customer_name,c.customer_city,p.product_name,p.unit_price,oi.quantity,s.salesperson_name
FROM Orders_3NF o JOIN Customers c ON c.customer_id=o.customer_id JOIN Salespersons s ON s.salesperson_id=o.salesperson_id JOIN OrderItems_3NF oi ON oi.order_id=o.order_id JOIN Products_3NF p ON p.product_id=oi.product_id ORDER BY o.order_id,p.product_id;
SELECT (SELECT COUNT(*) FROM Sales_UNF) original_rows,(SELECT COUNT(*) FROM Orders_3NF o JOIN OrderItems_3NF oi ON oi.order_id=o.order_id JOIN Products_3NF p ON p.product_id=oi.product_id JOIN Customers c ON c.customer_id=o.customer_id JOIN Salespersons s ON s.salesperson_id=o.salesperson_id) reconstructed_rows;
-- Dependency checks: these queries should return no rows
SELECT product_id,COUNT(*) FROM Products_3NF GROUP BY product_id HAVING COUNT(*)>1;
SELECT order_id,product_id,COUNT(*) FROM OrderItems_3NF GROUP BY order_id,product_id HAVING COUNT(*)>1;
