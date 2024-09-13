-- NOTE THAT THERE ARE QUESTIONS AND SOLUTIONS BELOW THE SCHEMA CODE

-- Create the InternalTransfers table with OldDepartment and NewDepartment columns
CREATE TABLE InternalTransfers (
EmployeeID INT PRIMARY KEY,
EmployeeName VARCHAR(50),
OldDepartment VARCHAR(50),
NewDepartment VARCHAR(50)
);


-- Create the NewHires table with a HireDate column
CREATE TABLE NewHires ( 
EmployeeID INT PRIMARY KEY,
EmployeeName VARCHAR(50),
Department VARCHAR(50),
HireDate DATE
);


-- Create the Resignations table
CREATE TABLE Resignations (
EmployeeID INT PRIMARY KEY,
EmployeeName VARCHAR(50),
Department VARCHAR(50)
);








-- Insert 50 rows into the NewHires table
INSERT INTO NewHires (EmployeeID, EmployeeName, Department, HireDate) VALUES
(1, 'John Doe', 'HR', '2023-01-15'),
(2, 'Jane Smith', 'IT', '2023-02-20'),
(3, 'Mike Johnson', 'Finance', '2023-03-10'),
(4, 'Emily White', 'HR', '2023-04-05'),
(5, 'David Brown', 'IT', '2023-05-12'),
(6, 'Linda Taylor', 'Finance', '2023-06-25'),
(7, 'James Anderson', 'HR', '2023-07-14'),
(8, 'Sophia Lee', 'IT', '2023-08-21'),
(9, 'Michael Clark', 'Finance', '2023-09-01'),
(10, 'Olivia Hall', 'HR', '2023-10-19'),
(11, 'Daniel Wilson', 'IT', '2023-01-28'),
(12, 'Ava Miller', 'Finance', '2023-12-03'),
(13, 'William Thomas', 'HR', '2023-01-07'),
(14, 'Ella Garcia', 'IT', '2023-02-14'),
(15, 'Joseph Martinez', 'Finance', '2023-03-20'),
(16, 'Mia Rodriguez', 'HR', '2023-04-25'),
(17, 'Charles Hernandez', 'IT', '2023-05-30'),
(18, 'Charlotte Davis', 'Finance', '2023-06-07'),
(19, 'Matthew Brown', 'HR', '2023-07-15'),
(20, 'Amelia Evans', 'IT', '2023-08-22'),
(21, 'David Young', 'Finance', '2023-09-02'),
(22, 'Olivia Moore', 'HR', '2023-10-11'),
(23, 'Ethan Harris', 'IT', '2023-01-16'),
(24, 'Sophia Rivera', 'Finance', '2023-12-20'),
(25, 'Liam Foster', 'HR', '2023-01-03'),
(26, 'Ava Butler', 'IT', '2023-02-09'),
(27, 'Logan Simmons', 'Finance', '2023-03-18'),
(28, 'Emma Perez', 'HR', '2023-04-27'),
(29, 'Mason Turner', 'IT', '2023-05-04'),
(30, 'Harper Price', 'Finance', '2023-06-14'),
(31, 'Noah Baker', 'HR', '2023-07-22'),
(32, 'Isabella Brooks', 'IT', '2023-08-31'),
(33, 'William Ward', 'Finance', '2023-09-12'),
(34, 'Aria Reed', 'HR', '2023-10-19'),
(35, 'Benjamin Morris', 'IT', '2023-01-26'),
(36, 'Luna Mitchell', 'Finance', '2023-12-04'),
(37, 'Lucas Hayes', 'HR', '2023-01-08'),
(38, 'Lily Rogers', 'IT', '2023-02-15'),
(39, 'Alexander Simmons', 'Finance', '2023-03-21'),
(40, 'Grace Collins', 'HR', '2023-04-26'),
(41, 'Jack Johnson', 'IT', '2023-05-03'),
(42, 'Sophia Parker', 'Finance', '2023-06-12'),
(43, 'Jacob Wood', 'HR', '2023-07-18'),
(44, 'Mia Scott', 'IT', '2023-08-27'),
(45, 'Ethan Cook', 'Finance', '2023-09-09'),
(46, 'Ava Adams', 'HR', '2023-10-17'),
(47, 'Daniel White', 'IT', '2023-01-23'),
(48, 'Olivia Stewart', 'Finance', '2023-12-05'),
(49, 'Mason Nelson', 'HR', '2023-01-09'),
(50, 'Emily Taylor', 'IT', '2023-02-16');








-- Insert 25 rows into the InternalTransfers table
INSERT INTO InternalTransfers (EmployeeID, EmployeeName, OldDepartment, NewDepartment) VALUES
(11, 'Daniel Wilson', 'IT', 'Finance'),
(16, 'Mia Rodriguez', 'HR', 'IT'),
(17, 'Charles Hernandez', 'IT', 'Finance'),
(18, 'Charlotte Davis', 'Finance', 'HR'),
(22, 'Olivia Moore', 'HR', 'Finance'),
(23, 'Ethan Harris', 'IT', 'HR'),
(24, 'Sophia Rivera', 'Finance', 'IT'),
(26, 'Ava Butler', 'IT', 'Finance'),
(27, 'Logan Simmons', 'Finance', 'HR'),
(29, 'Mason Turner', 'IT', 'Finance'),
(30, 'Harper Price', 'Finance', 'IT'),
(33, 'William Ward', 'Finance', 'HR'),
(35, 'Benjamin Morris', 'IT', 'Finance'),
(37, 'Lucas Hayes', 'HR', 'IT'),
(38, 'Lily Rogers', 'IT', 'Finance'),
(41, 'Jack Johnson', 'IT', 'HR'),
(42, 'Sophia Parker', 'Finance', 'IT'),
(44, 'Mia Scott', 'IT', 'HR'),
(45, 'Ethan Cook', 'Finance', 'IT'),
(47, 'Daniel White', 'IT', 'Finance'),
(49, 'Mason Nelson', 'HR', 'Finance'),
(2, 'Jane Smith', 'IT', 'Finance'),
(3, 'Mike Johnson', 'Finance', 'HR'),
(5, 'David Brown', 'IT', 'HR'),
(9, 'Michael Clark', 'Finance', 'IT'),
(14, 'Ella Garcia', 'IT', 'Finance');






-- Insert 15 rows into the Resignations table for employees in the Finance department
INSERT INTO Resignations (EmployeeID, EmployeeName, Department) VALUES
(11, 'Daniel Wilson', 'Finance'),
(17, 'Charles Hernandez', 'Finance'),
(30, 'Harper Price', 'IT'),
(3, 'Mike Johnson', 'HR'),
(9, 'Michael Clark', 'IT'),
(45, 'Ethan Cook', 'IT'),
(2, 'Jane Smith', 'Finance'),
(14, 'Ella Garcia', 'Finance'),
(33, 'William Ward', 'HR'),
(27, 'Logan Simmons', 'HR'),
(37, 'Lucas Hayes', 'IT'),
(38, 'Lily Rogers', 'Finance'),
(49, 'Mason Nelson', 'Finance');


--QUESTIONS AND SOLUTIONS
--1. **New Hires**: Find employees who were newly hired in the first half of 2023.
SELECT EmployeeID, EmployeeName, Department, HireDate
FROM NewHires
WHERE HireDate BETWEEN '2023-01-01' AND '2023-06-30';


--2. **Internal Transfers**: Out of these employees hired, find out those who transferred to the Finance department using the internal transfers table.
SELECT IT.EmployeeID, IT.EmployeeName, IT.OldDepartment, IT.NewDepartment
FROM InternalTransfers IT
JOIN (
    SELECT EmployeeID
    FROM NewHires
    WHERE HireDate BETWEEN '2023-01-01' AND '2023-06-30'
) NH ON IT.EmployeeID = NH.EmployeeID
WHERE IT.NewDepartment = 'Finance';

--OR using 'WHERE IN' clause
SELECT EmployeeID, EmployeeName, OldDepartment, NewDepartment
FROM InternalTransfers
WHERE NewDepartment = 'Finance'
AND EmployeeID IN (
    SELECT EmployeeID
    FROM NewHires
    WHERE HireDate BETWEEN '2023-01-01' AND '2023-06-30'
);

--OR using 'INTERSECT'
SELECT EmployeeID
FROM InternalTransfers
WHERE NewDepartment = 'Finance'
INTERSECT
SELECT EmployeeID
FROM NewHires
WHERE HireDate BETWEEN '2023-01-01' AND '2023-06-30';


--3. **Resignations**: Out of those who transferred to the finance department, find out those who have resigned
SELECT R.EmployeeID, R.EmployeeName, R.Department
FROM Resignations R
JOIN (
    SELECT IT.EmployeeID
    FROM InternalTransfers IT
    JOIN (
        SELECT EmployeeID
        FROM NewHires
        WHERE HireDate BETWEEN '2023-01-01' AND '2023-06-30'
    ) NH ON IT.EmployeeID = NH.EmployeeID
    WHERE IT.NewDepartment = 'Finance'
) T ON R.EmployeeID = T.EmployeeID;

--OR using 'WHERE IN' clause
SELECT EmployeeID, EmployeeName, Department
FROM Resignations
WHERE EmployeeID IN (
    SELECT EmployeeID
    FROM InternalTransfers
    WHERE NewDepartment = 'Finance'
    AND EmployeeID IN (
        SELECT EmployeeID
        FROM NewHires
        WHERE HireDate BETWEEN '2023-01-01' AND '2023-06-30'
    )
);

--OR using 'INTERSECT'
SELECT EmployeeID
FROM Resignations
INTERSECT
SELECT EmployeeID
FROM InternalTransfers
WHERE NewDepartment = 'Finance'
AND EmployeeID IN (
    SELECT EmployeeID
    FROM NewHires
    WHERE HireDate BETWEEN '2023-01-01' AND '2023-06-30'
);
