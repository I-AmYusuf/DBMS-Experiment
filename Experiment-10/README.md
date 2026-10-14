# Experiment 10 — Query Optimization

**Aim:** Generate at least 10,000 rows, examine five queries with EXPLAIN, optimize using indexes and query rewriting, and compare execution plans/timing.

**Requirements:** MySQL 8.0.18+ for EXPLAIN ANALYZE.

**How to compare:** Run the five baseline queries before creating indexes, record EXPLAIN output and elapsed time, then create indexes and run the rewritten queries. The script includes ANALYZE TABLE and example EXPLAIN ANALYZE statements. Do not assume a fixed speedup; record measurements from your machine.
