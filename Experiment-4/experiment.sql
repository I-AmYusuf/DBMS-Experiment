USE EmployeeManagement;
-- INNER JOIN
SELECT e.emp_name,d.dept_name FROM Employee e INNER JOIN Department d ON e.dept_id=d.dept_id;
-- LEFT JOIN
SELECT d.dept_name,e.emp_name FROM Department d LEFT JOIN Employee e ON e.dept_id=d.dept_id;
-- Self-join: employee pairs in same department
SELECT a.emp_name employee1,b.emp_name employee2,a.dept_id FROM Employee a JOIN Employee b ON a.dept_id=b.dept_id AND a.emp_id<b.emp_id;
-- Three-way join (four tables for project assignment)
SELECT e.emp_name,d.dept_name,p.project_name,ep.hours_worked FROM Employee e JOIN Department d ON e.dept_id=d.dept_id JOIN Employee_Project ep ON ep.emp_id=e.emp_id JOIN Project p ON p.project_id=ep.project_id;
-- Correlated subquery
SELECT e.emp_name,e.salary,e.dept_id FROM Employee e WHERE e.salary>(SELECT AVG(x.salary) FROM Employee x WHERE x.dept_id=e.dept_id);
-- EXISTS
SELECT e.emp_id,e.emp_name FROM Employee e WHERE EXISTS(SELECT 1 FROM Employee_Project ep WHERE ep.emp_id=e.emp_id);
-- Simulated INTERSECT
SELECT e.emp_id,e.emp_name FROM Employee e WHERE e.salary>60000 AND EXISTS(SELECT 1 FROM Employee_Project ep WHERE ep.emp_id=e.emp_id);
-- Simulated EXCEPT
SELECT e.emp_id,e.emp_name FROM Employee e WHERE NOT EXISTS(SELECT 1 FROM Employee_Project ep WHERE ep.emp_id=e.emp_id);
-- Execution plans
EXPLAIN SELECT e.emp_name,d.dept_name FROM Employee e JOIN Department d ON e.dept_id=d.dept_id;
EXPLAIN ANALYZE SELECT e.emp_name,d.dept_name FROM Employee e JOIN Department d ON e.dept_id=d.dept_id;
