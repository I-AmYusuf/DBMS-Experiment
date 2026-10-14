DROP DATABASE IF EXISTS EmployeeManagement;
CREATE DATABASE EmployeeManagement;
USE EmployeeManagement;
CREATE TABLE Department(dept_id INT PRIMARY KEY,dept_name VARCHAR(50) NOT NULL UNIQUE,location VARCHAR(50));
CREATE TABLE Employee(emp_id INT PRIMARY KEY,emp_name VARCHAR(60) NOT NULL,job_title VARCHAR(50),salary DECIMAL(10,2),hire_date DATE,dept_id INT,FOREIGN KEY(dept_id) REFERENCES Department(dept_id));
CREATE TABLE Project(project_id INT PRIMARY KEY,project_name VARCHAR(100) NOT NULL,budget DECIMAL(12,2),status VARCHAR(20));
CREATE TABLE Employee_Project(emp_id INT,project_id INT,hours_worked INT DEFAULT 0,PRIMARY KEY(emp_id,project_id),FOREIGN KEY(emp_id) REFERENCES Employee(emp_id),FOREIGN KEY(project_id) REFERENCES Project(project_id));
INSERT INTO Department VALUES (1,'IT','Delhi'),(2,'HR','Noida'),(3,'Finance','Gurugram'),(4,'Marketing','Mumbai'),(5,'Operations','Pune');
INSERT INTO Project VALUES (101,'Website Development',500000,'Active'),(102,'Mobile Application',750000,'Active'),(103,'Payroll System',300000,'Completed'),(104,'Data Analytics',600000,'Active'),(105,'Cybersecurity',450000,'Active'),(106,'Marketing Campaign',250000,'Completed'),(107,'Cloud Migration',800000,'Active'),(108,'Inventory System',350000,'Planning');
INSERT INTO Employee VALUES
(1,'Aarav Sharma','Developer',65000,'2022-01-15',1),(2,'Priya Verma','Manager',85000,'2020-03-10',1),(3,'Rahul Singh','Analyst',55000,'2023-06-12',1),(4,'Sneha Gupta','Tester',48000,'2022-08-20',1),(5,'Vikram Patel','Developer',70000,'2021-11-05',1),(6,'Ananya Das','Data Analyst',62000,'2023-02-14',1),
(7,'Rohan Mehta','HR Manager',75000,'2019-04-11',2),(8,'Kavya Joshi','HR Executive',42000,'2022-07-19',2),(9,'Arjun Rao','Recruiter',45000,'2023-01-09',2),(10,'Isha Kapoor','HR Executive',40000,'2024-05-16',2),(11,'Karan Malhotra','Trainer',50000,'2021-09-23',2),(12,'Meera Nair','HR Analyst',52000,'2020-12-02',2),
(13,'Aditya Jain','Accountant',58000,'2021-02-18',3),(14,'Pooja Mishra','Finance Manager',90000,'2018-06-25',3),(15,'Sahil Khanna','Auditor',60000,'2022-10-08',3),(16,'Neha Agarwal','Accountant',54000,'2023-04-17',3),(17,'Manish Yadav','Financial Analyst',68000,'2020-08-30',3),(18,'Riya Chawla','Auditor',57000,'2024-01-22',3),
(19,'Aman Bansal','Marketing Manager',80000,'2019-07-13',4),(20,'Simran Kaur','Content Writer',45000,'2022-05-21',4),(21,'Dev Kumar','SEO Analyst',50000,'2023-09-04',4),(22,'Tanya Sethi','Designer',55000,'2021-12-15',4),(23,'Nikhil Arora','Sales Executive',47000,'2024-02-10',4),(24,'Diya Roy','Marketing Analyst',58000,'2020-10-19',4),
(25,'Varun Thakur','Operations Manager',82000,'2018-03-07',5),(26,'Aditi Saxena','Coordinator',46000,'2022-04-12',5),(27,'Mohit Saini','Supervisor',52000,'2021-06-28',5),(28,'Nisha Pillai','Logistics Analyst',61000,'2023-11-03',5),(29,'Yash Tiwari','Technician',43000,'2024-03-18',5),(30,'Sana Sheikh','Coordinator',48000,'2020-09-14',5);
INSERT INTO Employee_Project VALUES (1,101,120),(2,101,80),(3,104,100),(4,105,90),(5,102,110),(6,104,120),(7,103,70),(8,103,80),(9,106,90),(10,103,60),(11,106,100),(12,103,75),(13,103,100),(14,103,80),(15,104,90),(16,103,110),(17,104,120),(18,106,85),(19,106,100),(20,106,95),(21,101,80),(22,102,90),(23,106,70),(24,104,110),(25,108,100),(26,108,85),(27,108,90),(28,107,120),(29,107,100),(30,108,75);
-- Selection and projection
SELECT * FROM Employee WHERE salary>60000;
SELECT emp_name,job_title,salary FROM Employee;
SELECT DISTINCT job_title FROM Employee;
-- Aggregates
SELECT COUNT(*) total_employees,AVG(salary) avg_salary,MIN(salary) min_salary,MAX(salary) max_salary,SUM(salary) payroll FROM Employee;
-- GROUP BY and HAVING
SELECT dept_id,COUNT(*) employee_count,AVG(salary) avg_salary FROM Employee GROUP BY dept_id HAVING AVG(salary)>55000;
-- CASE
SELECT emp_name,salary,CASE WHEN salary>=80000 THEN 'High' WHEN salary>=55000 THEN 'Medium' ELSE 'Low' END salary_grade FROM Employee;
-- ORDER BY
SELECT emp_name,salary FROM Employee ORDER BY salary DESC;
-- Join summary
SELECT d.dept_name,COUNT(e.emp_id) employee_count,SUM(e.salary) payroll FROM Department d LEFT JOIN Employee e ON e.dept_id=d.dept_id GROUP BY d.dept_id,d.dept_name;
SELECT p.project_name,COUNT(ep.emp_id) assigned_employees,SUM(ep.hours_worked) total_hours FROM Project p LEFT JOIN Employee_Project ep ON p.project_id=ep.project_id GROUP BY p.project_id,p.project_name ORDER BY total_hours DESC;
SELECT (SELECT COUNT(*) FROM Employee) employees,(SELECT COUNT(*) FROM Department) departments,(SELECT COUNT(*) FROM Project) projects,(SELECT COUNT(*) FROM Employee_Project) assignments;
