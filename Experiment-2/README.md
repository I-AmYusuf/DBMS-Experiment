# Experiment 2 — ER to Relational Schema

**Aim:** Convert an e-commerce ER model into relational tables and demonstrate primary keys, foreign keys, NOT NULL, UNIQUE, ON DELETE CASCADE, ON DELETE SET NULL, and referential integrity.

**Requirements:** MySQL 8.0+.

**Run:** Execute `experiment.sql` from top to bottom. The invalid foreign-key insert is commented out; uncomment it to observe the expected integrity error.

**Expected result:** The tables and sample rows are created. Cascading deletion removes dependent rows, SET NULL clears an optional reference, and invalid foreign keys are rejected.
