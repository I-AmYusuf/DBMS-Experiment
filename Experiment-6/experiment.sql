USE EmployeeManagement;
CREATE TABLE IF NOT EXISTS SalaryAudit(audit_id INT AUTO_INCREMENT PRIMARY KEY,emp_id INT NOT NULL,old_salary DECIMAL(10,2),new_salary DECIMAL(10,2),changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
DROP PROCEDURE IF EXISTS transfer_employee;
DELIMITER $$
CREATE PROCEDURE transfer_employee(IN p_emp_id INT,IN p_new_dept_id INT)
BEGIN
 DECLARE v_emp_count INT DEFAULT 0;
 DECLARE v_dept_count INT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 START TRANSACTION;
 SELECT COUNT(*) INTO v_emp_count FROM Employee WHERE emp_id=p_emp_id FOR UPDATE;
 SELECT COUNT(*) INTO v_dept_count FROM Department WHERE dept_id=p_new_dept_id;
 IF v_emp_count=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Employee does not exist'; END IF;
 IF v_dept_count=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Department does not exist'; END IF;
 UPDATE Employee SET dept_id=p_new_dept_id WHERE emp_id=p_emp_id;
 COMMIT;
END$$
DROP TRIGGER IF EXISTS before_employee_salary_update$$
CREATE TRIGGER before_employee_salary_update BEFORE UPDATE ON Employee FOR EACH ROW
BEGIN
 IF NEW.salary IS NULL OR NEW.salary<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Salary must be greater than zero'; END IF;
END$$
DROP TRIGGER IF EXISTS after_employee_salary_update$$
CREATE TRIGGER after_employee_salary_update AFTER UPDATE ON Employee FOR EACH ROW
BEGIN
 IF NOT (OLD.salary <=> NEW.salary) THEN INSERT INTO SalaryAudit(emp_id,old_salary,new_salary) VALUES(OLD.emp_id,OLD.salary,NEW.salary); END IF;
END$$
DELIMITER ;
CALL transfer_employee(1,2);
SELECT emp_id,emp_name,dept_id FROM Employee WHERE emp_id=1;
UPDATE Employee SET salary=salary+1000 WHERE emp_id=1;
SELECT * FROM SalaryAudit WHERE emp_id=1;
-- Expected errors; execute separately:
-- CALL transfer_employee(999,2);
-- CALL transfer_employee(1,999);
-- UPDATE Employee SET salary=-100 WHERE emp_id=1;
