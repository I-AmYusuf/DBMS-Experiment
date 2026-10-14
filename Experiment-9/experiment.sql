CREATE DATABASE IF NOT EXISTS RailwayDB;
USE RailwayDB;
DROP TABLE IF EXISTS RailwayBooking;
CREATE TABLE RailwayBooking(booking_id INT PRIMARY KEY,passenger_name VARCHAR(100) NOT NULL,train_no INT NOT NULL,journey_date DATE NOT NULL,source_station VARCHAR(50) NOT NULL,destination_station VARCHAR(50) NOT NULL,seat_no INT NOT NULL,fare DECIMAL(8,2) NOT NULL,booking_status VARCHAR(20) NOT NULL);
SET SESSION cte_max_recursion_depth=6000;
INSERT INTO RailwayBooking
WITH RECURSIVE Numbers AS (SELECT 1 n UNION ALL SELECT n+1 FROM Numbers WHERE n<5000)
SELECT n,CONCAT('Passenger_',n),12000+MOD(n,20),DATE_ADD('2026-11-01',INTERVAL MOD(n,30) DAY),
CASE MOD(n,4) WHEN 0 THEN 'Delhi' WHEN 1 THEN 'Mumbai' WHEN 2 THEN 'Chennai' ELSE 'Kolkata' END,
CASE MOD(n,4) WHEN 0 THEN 'Jaipur' WHEN 1 THEN 'Pune' WHEN 2 THEN 'Bengaluru' ELSE 'Lucknow' END,
MOD(n,72)+1,300+MOD(n,1700),CASE MOD(n,3) WHEN 0 THEN 'Confirmed' WHEN 1 THEN 'Waiting' ELSE 'Cancelled' END
FROM Numbers;
SELECT COUNT(*) total_bookings FROM RailwayBooking;
-- Before indexes
EXPLAIN SELECT * FROM RailwayBooking WHERE train_no=12005;
EXPLAIN SELECT * FROM RailwayBooking WHERE source_station='Delhi' AND booking_status='Confirmed' ORDER BY journey_date;
EXPLAIN ANALYZE SELECT * FROM RailwayBooking WHERE train_no=12005;
-- Indexes
CREATE INDEX idx_train ON RailwayBooking(train_no);
CREATE INDEX idx_source_status_date ON RailwayBooking(source_station,booking_status,journey_date);
ANALYZE TABLE RailwayBooking;
-- After indexes
EXPLAIN SELECT * FROM RailwayBooking WHERE train_no=12005;
EXPLAIN SELECT * FROM RailwayBooking WHERE source_station='Delhi' AND booking_status='Confirmed' ORDER BY journey_date;
EXPLAIN ANALYZE SELECT * FROM RailwayBooking WHERE source_station='Delhi' AND booking_status='Confirmed' ORDER BY journey_date;
SHOW INDEX FROM RailwayBooking;
