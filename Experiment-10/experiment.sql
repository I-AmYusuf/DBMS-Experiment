CREATE DATABASE IF NOT EXISTS OptimizationDB;
USE OptimizationDB;
DROP TABLE IF EXISTS SalesData;
CREATE TABLE SalesData(sale_id INT PRIMARY KEY,customer_id INT NOT NULL,product_id INT NOT NULL,region VARCHAR(30) NOT NULL,sale_date DATE NOT NULL,quantity INT NOT NULL,amount DECIMAL(10,2) NOT NULL,status VARCHAR(20) NOT NULL);
SET SESSION cte_max_recursion_depth=11000;
INSERT INTO SalesData
WITH RECURSIVE Numbers AS (SELECT 1 n UNION ALL SELECT n+1 FROM Numbers WHERE n<10000)
SELECT n,MOD(n,1000)+1,MOD(n,100)+1,
CASE MOD(n,4) WHEN 0 THEN 'North' WHEN 1 THEN 'South' WHEN 2 THEN 'East' ELSE 'West' END,
DATE_ADD('2025-01-01',INTERVAL MOD(n,365) DAY),MOD(n,10)+1,(MOD(n,500)+1)*100,
CASE MOD(n,3) WHEN 0 THEN 'Completed' WHEN 1 THEN 'Pending' ELSE 'Cancelled' END
FROM Numbers;
SELECT COUNT(*) total_records FROM SalesData;
-- Five baseline plans (run these before index creation)
EXPLAIN SELECT * FROM SalesData WHERE YEAR(sale_date)=2025;
EXPLAIN SELECT * FROM SalesData WHERE UPPER(region)='NORTH';
EXPLAIN SELECT * FROM SalesData WHERE customer_id=101 ORDER BY sale_date DESC;
EXPLAIN SELECT * FROM SalesData WHERE region='North' AND status='Completed' AND sale_date>='2025-06-01';
EXPLAIN SELECT region,status,SUM(amount) total_sales FROM SalesData GROUP BY region,status;
-- Indexes
CREATE INDEX idx_sale_date ON SalesData(sale_date);
CREATE INDEX idx_customer_date ON SalesData(customer_id,sale_date);
CREATE INDEX idx_region_status_date ON SalesData(region,status,sale_date);
CREATE INDEX idx_region_status ON SalesData(region,status);
ANALYZE TABLE SalesData;
-- Optimized/re-written queries
EXPLAIN ANALYZE SELECT * FROM SalesData WHERE sale_date>='2025-01-01' AND sale_date<'2026-01-01';
EXPLAIN ANALYZE SELECT * FROM SalesData WHERE region='North';
EXPLAIN ANALYZE SELECT * FROM SalesData WHERE customer_id=101 ORDER BY sale_date DESC;
EXPLAIN ANALYZE SELECT * FROM SalesData WHERE region='North' AND status='Completed' AND sale_date>='2025-06-01';
EXPLAIN ANALYZE SELECT region,status,SUM(amount) total_sales FROM SalesData GROUP BY region,status;
-- Avoid wrapping indexed columns in functions; use sargable range predicates.
