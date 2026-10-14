USE EmployeeManagement;
CREATE OR REPLACE VIEW DepartmentSalarySummary AS
SELECT d.dept_id,d.dept_name,COUNT(e.emp_id) employee_count,COALESCE(AVG(e.salary),0) average_salary,COALESCE(SUM(e.salary),0) total_salary
FROM Department d LEFT JOIN Employee e ON e.dept_id=d.dept_id GROUP BY d.dept_id,d.dept_name;
SELECT * FROM DepartmentSalarySummary;
ALTER TABLE Employee ADD COLUMN manager_id INT NULL;
ALTER TABLE Employee ADD CONSTRAINT fk_employee_manager FOREIGN KEY(manager_id) REFERENCES Employee(emp_id) ON DELETE SET NULL;
UPDATE Employee SET manager_id=2 WHERE emp_id IN (1,3,4,5,6);
UPDATE Employee SET manager_id=7 WHERE emp_id IN (8,9,10,11,12);
UPDATE Employee SET manager_id=14 WHERE emp_id IN (13,15,16,17,18);
UPDATE Employee SET manager_id=19 WHERE emp_id IN (20,21,22,23,24);
UPDATE Employee SET manager_id=25 WHERE emp_id IN (26,27,28,29,30);
CREATE OR REPLACE VIEW EmployeeHierarchy AS
SELECT e.emp_id,e.emp_name,e.job_title,e.manager_id,m.emp_name manager_name,e.dept_id FROM Employee e LEFT JOIN Employee m ON m.emp_id=e.manager_id;
SELECT * FROM EmployeeHierarchy;
CREATE OR REPLACE VIEW EmployeeBasic AS SELECT emp_id,emp_name,job_title,salary,dept_id FROM Employee;
UPDATE EmployeeBasic SET salary=salary+100 WHERE emp_id=1;
SELECT * FROM EmployeeBasic WHERE emp_id=1;
-- Recursive reporting chain
WITH RECURSIVE ReportingChain AS (
 SELECT emp_id,emp_name,manager_id,0 level_no,CAST(emp_name AS CHAR(2000)) reporting_path FROM Employee WHERE manager_id IS NULL
 UNION ALL
 SELECT e.emp_id,e.emp_name,e.manager_id,r.level_no+1,CONCAT(r.reporting_path,' -> ',e.emp_name)
 FROM Employee e JOIN ReportingChain r ON e.manager_id=r.emp_id
)
SELECT * FROM ReportingChain ORDER BY level_no,emp_id;
