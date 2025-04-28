create database employeemanagementsystem;
use employeemanagementsystem;

CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL
);
INSERT INTO departments (department_name) VALUES
('Human Resources'),
('Finance'),
('Engineering'),
('Marketing'),
('Sales');
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    department_id INT,
    hire_date DATE,
    job_title VARCHAR(100),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

INSERT INTO employees (first_name, last_name, email, department_id, hire_date, job_title) VALUES
('John', 'Doe', 'john.doe@example.com', 1, '2020-05-01', 'HR Manager'),
('Jane', 'Smith', 'jane.smith@example.com', 2, '2019-03-15', 'Financial Analyst'),
('Jim', 'Brown', 'jim.brown@example.com', 3, '2018-08-20', 'Software Engineer'),
('Sara', 'Johnson', 'sara.johnson@example.com', 4, '2021-02-11', 'Marketing Specialist'),
('Tom', 'Williams', 'tom.williams@example.com', 5, '2017-12-05', 'Sales Manager');

CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(200) NOT NULL,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(15, 2)
);

INSERT INTO projects (project_name, start_date, end_date, budget) VALUES
('HR System Upgrade', '2023-01-01', '2023-06-30', 50000.00),
('Financial Reporting Tool', '2022-05-01', '2023-01-31', 75000.00),
('Website Redesign', '2023-03-01', '2023-12-31', 100000.00),
('Product Launch Campaign', '2023-04-01', '2023-09-30', 20000.00);

CREATE TABLE salary (
    employee_id INT,
    salary DECIMAL(15, 2),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO salary (employee_id, salary) VALUES
(1, 60000.00),
(2, 70000.00),
(3, 85000.00),
(4, 50000.00),
(5, 75000.00);

SELECT * FROM employees;

SELECT first_name, last_name FROM employees
JOIN departments ON employees.department_id = departments.department_id
WHERE department_name = 'Engineering';

SELECT SUM(salary) FROM salary;

SELECT first_name, last_name, department_name 
FROM employees 
JOIN departments ON employees.department_id = departments.department_id;

SELECT department_name, AVG(salary) AS avg_salary
FROM employees
JOIN salary ON employees.employee_id = salary.employee_id
JOIN departments ON employees.department_id = departments.department_id
GROUP BY department_name
ORDER BY avg_salary DESC
LIMIT 1;

CREATE TABLE project_employee (
    project_employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    project_id INT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

INSERT INTO project_employee (employee_id, project_id) VALUES
(1, 1),  -- John Doe works on HR System Upgrade
(2, 2),  -- Jane Smith works on Financial Reporting Tool
(3, 3),  -- Jim Brown works on Website Redesign
(4, 4),  -- Sara Johnson works on Product Launch Campaign
(5, 3);  -- Tom Williams works on Website Redesign


SELECT e.first_name, e.last_name, p.project_name 
FROM employees e
JOIN project_employee pe ON e.employee_id = pe.employee_id
JOIN projects p ON pe.project_id = p.project_id;

SELECT first_name, last_name, salary 
FROM employees
JOIN salary ON employees.employee_id = salary.employee_id
WHERE salary > (SELECT AVG(salary) FROM salary);

CREATE INDEX idx_salary_employee_id ON salary(employee_id);

CREATE VIEW employee_salary_view AS
SELECT e.first_name, e.last_name, d.department_name, s.salary
FROM employees e
JOIN salary s ON e.employee_id = s.employee_id
JOIN departments d ON e.department_id = d.department_id;

DELIMITER $$

CREATE TRIGGER update_end_date
AFTER UPDATE ON projects
FOR EACH ROW
BEGIN
    -- Check if the budget is less than or equal to 0
    IF NEW.budget <= 0 THEN
        -- Update the end_date of the project
        UPDATE projects
        SET end_date = NOW()
        WHERE project_id = NEW.project_id;
    END IF;
END $$

DELIMITER ;

START TRANSACTION;

UPDATE salary SET salary = salary * 1.1 WHERE employee_id = 1;
UPDATE salary SET salary = salary * 1.1 WHERE employee_id = 2;

COMMIT;

DELIMITER $$

CREATE PROCEDURE GetEmployeeSalary(IN emp_id INT)
BEGIN
    SELECT salary FROM salary WHERE employee_id = emp_id;
END$$

DELIMITER ;



