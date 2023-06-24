create database employee;
use employee;


CREATE TABLE
    tbl_Employee (
        employee_name VARCHAR(255) NOT NULL,
        street VARCHAR(255) NOT NULL,
        city VARCHAR(255) NOT NULL,
        PRIMARY KEY(employee_name)
    );


CREATE TABLE
    tbl_Works (
        employee_name VARCHAR(255) NOT NULL,
        FOREIGN KEY (employee_name) REFERENCES tbl_Employee(employee_name),
        company_name VARCHAR(255),
        salary DECIMAL(10, 2)
    );

CREATE TABLE
    tbl_Company (
        company_name VARCHAR(255) NOT NULL,
        city VARCHAR(255),
        PRIMARY KEY(company_name)
    );

CREATE TABLE
    tbl_Manages (
        employee_name VARCHAR(255) NOT NULL,
        FOREIGN KEY (employee_name) REFERENCES tbl_Employee(employee_name),
        manager_name VARCHAR(255)
    );

INSERT INTO
    tbl_Employee (employee_name, street, city)
VALUES (
        'Alice Williams',
        '321 Maple St',
        'Houston'
    ), (
        'Sara Davis',
        '159 Broadway',
        'New York'
    ), (
        'Mark Thompson',
        '235 Fifth Ave',
        'New York'
    ), (
        'Ashley Johnson',
        '876 Market St',
        'Chicago'
    ), (
        'Emily Williams',
        '741 First St',
        'Los Angeles'
    ), (
        'Michael Brown',
        '902 Main St',
        'Houston'
    ), (
        'Samantha Smith',
        '111 Second St',
        'Chicago'
    );

INSERT INTO
    tbl_Employee (employee_name, street, city)
VALUES (
        'Patrick',
        '123 Main St',
        'New Mexico'
    );

INSERT INTO
    tbl_Works (
        employee_name,
        company_name,
        salary
    )
VALUES (
        'Patrick',
        'Pongyang Corporation',
        500000
    );

INSERT INTO
    tbl_Works (
        employee_name,
        company_name,
        salary
    )
VALUES (
        'Sara Davis',
        'First Bank Corporation',
        82500.00
    ), (
        'Mark Thompson',
        'Small Bank Corporation',
        78000.00
    ), (
        'Ashley Johnson',
        'Small Bank Corporation',
        92000.00
    ), (
        'Emily Williams',
        'Small Bank Corporation',
        86500.00
    ), (
        'Michael Brown',
        'Small Bank Corporation',
        81000.00
    ), (
        'Samantha Smith',
        'Small Bank Corporation',
        77000.00
    );

INSERT INTO
    tbl_Company (company_name, city)
VALUES (
        'Small Bank Corporation', 'Chicago'), 
        ('ABC Inc', 'Los Angeles'), 
        ('Def Co', 'Houston'), 
        ('First Bank Corporation','New York'), 
        ('456 Corp', 'Chicago'), 
        ('789 Inc', 'Los Angeles'), 
        ('321 Co', 'Houston'),
        ('Pongyang Corporation','Chicago'
    );

INSERT INTO tbl_Manages (employee_name, manager_name)
VALUES 
    ('Mark Thompson', 'Emily Williams'),
    ('Samantha Smith', 'Sara Davis'),
    ('Alice Williams', 'Emily Williams');
      


SELECT * FROM tbl_Employee;
SELECT * FROM tbl_Works;
SELECT * FROM tbl_Manages;

-- (a) Find the names of all employees who work for First Bank Corporation.
SELECT employee_name from tbl_works
where company_name='First Bank Corporation';

-- (b) Find the names and cities of residence of all employees who work for First Bank Corporation.
SELECT employee_name, city
FROM tbl_Employee
WHERE employee_name IN (
    SELECT employee_name
    FROM tbl_Works
    WHERE company_name = 'First Bank Corporation' 
);

-- b) using joins 

SELECT tbl_Employee.employee_name, tbl_Employee.city
FROM tbl_Employee
INNER JOIN tbl_Works ON tbl_Employee.employee_name = tbl_Works.employee_name
Inner JOIN tbl_Company ON tbl_Works.company_name = tbl_Company.company_name
WHERE tbl_Company.company_name = 'First Bank Corporation';


-- c) (c) Find the names, street addresses, and cities of residence of all employees who work for
-- First Bank Corporation and earn more than $10,000.
 
 SELECT employee_name, street, city 
 FROM tbl_Employee
 WHERE employee_name IN(
 SELECT employee_name
 FROM tbl_Works
 WHERE company_name='First Bank Corporation' AND salary > 10000

);

-- USING joins (c)
SELECT tbl_Employee.employee_name, tbl_Employee.street,tbl_employee.city
FROM tbl_Employee
Join tbl_Works ON tbl_employee.employee_name=tbl_works.employee_name
Join tbl_Company ON tbl_Works.company_name=tbl_Company.company_name
WHERE tbl_Company.company_name='First Bank Corporation' AND salary > 10000;



-- (d) Find all employees in the database who live in the same cities as the companies for which they work.

SELECT tbl_Employee.employee_name, tbl_Employee.city
FROM tbl_Employee, tbl_Works, tbl_Company
WHERE tbl_Employee.employee_name = tbl_Works.employee_name
  AND tbl_Works.company_name = tbl_Company.company_name
  AND tbl_Employee.city = tbl_Company.city;
  
  SELECT employee_name, city
  FROM tbl_Employee
  WHERE employee_name IN(
  SELECT employee_name
  FROM tbl_Works
  WHERE company_name IN (
  SELECT company_name
  FROM tbl_Company
  WHERE tbl_Employee.city=tbl_Company.city));
  
  SELECT tbl_Employee.employee_name
  FROM tbl_Employee
  Join tbl_Works ON tbl_Employee.employee_name=tbl_Works.employee_name
  Join tbl_Company ON tbl_Works.company_name=tbl_Company.company_name
  WHERE tbl_Employee.city=tbl_Company.city;

-- (e) Find all employees in the database who live in the same cities and on the same streets as do their managers
    
SELECT e.employee_name
FROM tbl_Employee as e
Join tbl_Manages as m
ON m.manager_name=e.employee_name
Join tbl_Employee as e1
ON e1.employee_name=m.employee_name
WHERE e.city=e1.city AND e.street=e1.street;













-- f) (f) Find all employees in the database who do not work for First Bank Corporation.

SELECT employee_name
FROM tbl_Employee
WHERE employee_name IN (
    SELECT employee_name
    FROM tbl_Works
    WHERE company_name != 'First Bank Corporation' 
);

-- (g) Find all employees in the database who earn more than each employee of Small Bank Corporation.


-- (h) Assume that the companies may be located in several cities. Find all companies located
-- in every city in which Small Bank Corporation is located.

SELECT company_name
FROM tbl_Company
WHERE city IN(
    SELECT city
    FROM tbl_Company
    WHERE company_name = 'Small Bank Corporation'
)
GROUP BY company_name
HAVING COUNT(DISTINCT city) = (
    SELECT COUNT(DISTINCT city)
    FROM tbl_Company
    WHERE company_name = 'Small Bank Corporation'
);


-- i) Find all employees who earn more than the average salary of all employees of their company.
SELECT employee_name
FROM tbl_Works AS w1
WHERE salary > (
    SELECT AVG(salary)
    FROM tbl_Works AS w2
    WHERE w1.company_name = w2.company_name
    GROUP BY company_name
);

-- j)Find the company that has the most employees.
SELECT company_name
FROM tbl_Works
GROUP BY company_name
HAVING COUNT(*) = (
    SELECT MAX(emp_count)
    FROM (
        SELECT COUNT(*) AS emp_count
        FROM tbl_Works
        GROUP BY company_name
    ) AS counts
);


-- k)  Find the company that has the smallest payroll

SELECT company_name
FROM tbl_Works
GROUP BY company_name
HAVING SUM(salary) = (
    SELECT MIN(payroll)
    FROM (
        SELECT SUM(salary) AS payroll
        FROM tbl_Works
        GROUP BY company_name
    ) AS payrolls
);
-- l)  Find those companies whose employees earn a higher salary, on average, than the
 -- average salary at First Bank Corporation.

SELECT company_name
FROM tbl_Works
GROUP BY company_name
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM tbl_Works
    WHERE company_name = 'First Bank Corporation'
);



-- 3) Modify the database so that Jones now lives in Newtown
  -- a)
  UPDATE tbl_Employee
  SET city='Newtown'
  WHERE employee_name='Jones';
  
  -- b) Give all employee of first Bank Corporation a 10 percent raise
  
  UPDATE tbl_Works
  SET Salary=Salary*1.1
  WHERE Company_name='First Bank Corporation';
  
  -- c) Give all managers of first Bank corporation a 10 percent raise
  
  UPDATE tbl_works
  SET Salary=Salary*1.1
  WHERE employee_name IN(
  SELECT employee_name
  FROM tbl_Manages
  WHERE manager_name IN (
  SELECT employee_name
  FROM tbl_WORKS
  WHERE company_name='First Bank Corporation'
  )
  );
  
  -- d) 
  UPDATE tbl_Works
  SET salary=CASE
  WHEN salary*1.1<=100000 THEN salary*1.1
  ELSE salary*1.03
  
  END 
  Where employee_name IN(
  SELECT employee_name
  FROM tbl_Manages
  WHERE manager_name IN(
  SLECT employee_name
  FROM tbl_Works
  WHERE company_name='First Bank Corporation'
  ));
 

