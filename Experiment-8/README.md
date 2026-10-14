# Experiment 8 — Transactions and Concurrency

**Aim:** Demonstrate BEGIN/START TRANSACTION, COMMIT, ROLLBACK, SAVEPOINT and isolation levels using bank accounts.

**Requirements:** MySQL with InnoDB. For isolation/concurrency demonstrations, open two SQL editor sessions and follow the comments.

**Expected result:** Committed changes persist; rolled-back changes do not. READ COMMITTED may see newly committed changes on a subsequent read, while REPEATABLE READ consistent reads normally use the same snapshot within a transaction.
