CREATE DATABASE IF NOT EXISTS BankingDB;
USE BankingDB;
CREATE TABLE IF NOT EXISTS BankAccount(account_id INT PRIMARY KEY,account_holder VARCHAR(100) NOT NULL,balance DECIMAL(12,2) NOT NULL CHECK(balance>=0)) ENGINE=InnoDB;
INSERT INTO BankAccount VALUES (101,'Aman',10000),(102,'Priya',5000),(103,'Rahul',8000) ON DUPLICATE KEY UPDATE account_holder=VALUES(account_holder);
-- Transfer and commit
START TRANSACTION;
UPDATE BankAccount SET balance=balance-2000 WHERE account_id=101 AND balance>=2000;
UPDATE BankAccount SET balance=balance+2000 WHERE account_id=102;
COMMIT;
SELECT * FROM BankAccount;
-- Rollback both changes
START TRANSACTION;
UPDATE BankAccount SET balance=balance-1000 WHERE account_id=101;
UPDATE BankAccount SET balance=balance+1000 WHERE account_id=103;
ROLLBACK;
SELECT * FROM BankAccount;
-- Savepoint: undo only the second update
START TRANSACTION;
UPDATE BankAccount SET balance=balance-500 WHERE account_id=101;
SAVEPOINT sp1;
UPDATE BankAccount SET balance=balance+500 WHERE account_id=102;
ROLLBACK TO SAVEPOINT sp1;
COMMIT;
SELECT * FROM BankAccount;
-- Session 1 concurrency demonstration:
-- SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- START TRANSACTION; SELECT balance FROM BankAccount WHERE account_id=101;
-- In Session 2: START TRANSACTION; UPDATE BankAccount SET balance=balance+100 WHERE account_id=101; COMMIT;
-- Repeat SELECT in Session 1, then COMMIT. READ COMMITTED can see the new committed value.
-- Repeat using REPEATABLE READ; consistent reads normally retain the transaction snapshot.
