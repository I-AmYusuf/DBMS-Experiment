# Experiment 7 — Normalization UNF to 3NF and BCNF

**Aim:** Identify functional dependencies and normalize a denormalized sales table. Verify reconstruction using joins.

**Assumptions:** order_id determines order-level details; customer_id determines customer details; product_id determines product details; salesperson_id determines salesperson name; (order_id, product_id) determines quantity.

**Expected result:** Decomposed tables reconstruct the five original sales lines. Under these dependencies the resulting relations satisfy BCNF. Run on a fresh NormalizationDB.
