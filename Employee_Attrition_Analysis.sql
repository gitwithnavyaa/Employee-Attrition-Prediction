-- =====================================
-- EMPLOYEE ATTRITION ANALYSIS PROJECT
-- =====================================

CREATE DATABASE IF NOT EXISTS employee_attrition;

USE employee_attrition;
USE employee_attrition;

-- 1. Departments Table
CREATE TABLE departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) UNIQUE
);

-- 2. Employees Table
CREATE TABLE employees (
    EmployeeID VARCHAR(20) PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Age INT,
    Gender VARCHAR(20),
    MaritalStatus VARCHAR(30),
    Education VARCHAR(50),
    EducationField VARCHAR(60),
    Department VARCHAR(100),
    JobRole VARCHAR(100),
    JobLevel INT,
    ManagerID VARCHAR(20),
    Location VARCHAR(60),
    EmploymentType VARCHAR(30),
    BusinessTravel VARCHAR(30),
    DistanceFromHomeKM INT,
    HireDate DATE,
    Attrition VARCHAR(5)
);

-- 3. Salary Table
CREATE TABLE salary (
    EmployeeID VARCHAR(20) PRIMARY KEY,
    MonthlyIncomeINR DECIMAL(12,2),
    PercentSalaryHike INT,
    StockOptionLevel INT,
    FOREIGN KEY (EmployeeID) REFERENCES employees(EmployeeID)
);

-- 4. Attendance Table
CREATE TABLE attendance (
    EmployeeID VARCHAR(20) PRIMARY KEY,
    WorkingDaysPerYear INT,
    LeaveDaysPerYear INT,
    AbsentDaysPerYear INT,
    LateArrivalDaysPerYear INT,
    AttendanceRatePct DECIMAL(5,2),
    OverTime VARCHAR(5),
    FOREIGN KEY (EmployeeID) REFERENCES employees(EmployeeID)
);

-- 5. Performance Table
CREATE TABLE performance (
    EmployeeID VARCHAR(20) PRIMARY KEY,
    PerformanceRating INT,
    JobSatisfaction INT,
    EnvironmentSatisfaction INT,
    RelationshipSatisfaction INT,
    WorkLifeBalance INT,
    TrainingTimesLastYear INT,
    FOREIGN KEY (EmployeeID) REFERENCES employees(EmployeeID)
);

-- 6. Experience Table
CREATE TABLE experience (
    EmployeeID VARCHAR(20) PRIMARY KEY,
    TotalWorkingYears INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    NumCompaniesWorked INT,
    FOREIGN KEY (EmployeeID) REFERENCES employees(EmployeeID)
);

SHOW TABLES;

USE employee_attrition;
SELECT * FROM departments;

USE employee_attrition;
SHOW TABLES;

-- number of records in each table
SELECT 'departments' AS TableName, COUNT(*) AS TotalRows FROM departments
UNION ALL
SELECT 'employees', COUNT(*) FROM employees
UNION ALL
SELECT 'salary', COUNT(*) FROM salary
UNION ALL
SELECT 'attendance', COUNT(*) FROM attendance
UNION ALL
SELECT 'performance', COUNT(*) FROM performance
UNION ALL
SELECT 'experience', COUNT(*) FROM experience;
-- Verify employee data
SELECT * FROM employees LIMIT 10;

-- ===============================
-- SECTION 1: BASIC SQL ANALYSIS
-- ===============================

-- Query 1: Total Employees
SELECT COUNT(*) AS Total_Employees
FROM employees;

-- Query 2: Employees Who Left
SELECT COUNT(*) AS Employees_Left
FROM employees
WHERE Attrition = 'Yes';

-- calculate the Attrition Rate (%)
SELECT
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate
FROM employees;

-- Department-wise attrition analysis
SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left
FROM employees
GROUP BY Department
ORDER BY Employees_Left DESC;

-- Department-wise attrition rate
SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate
FROM employees
GROUP BY Department
ORDER BY Attrition_Rate DESC;

-- Job role-wise attrition
SELECT
    JobRole,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate
FROM employees
GROUP BY JobRole
ORDER BY Attrition_Rate DESC;

-- Gender-wise attrition
SELECT
    Gender,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate
FROM employees
GROUP BY Gender
ORDER BY Attrition_Rate DESC;

-- Overtime vs Attrition
SELECT
    OverTime,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate
FROM attendance
JOIN employees
    ON attendance.EmployeeID = employees.EmployeeID
GROUP BY OverTime
ORDER BY Attrition_Rate DESC;

-- Job Satisfaction vs Attrition
SELECT
    JobSatisfaction,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate
FROM performance
JOIN employees
    ON performance.EmployeeID = employees.EmployeeID
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- Work-Life Balance vs Attrition
SELECT
    WorkLifeBalance,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate
FROM performance
JOIN employees
    ON performance.EmployeeID = employees.EmployeeID
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;

-- Average Salary — Employees Who Left vs Retained
SELECT
    employees.Attrition,
    COUNT(*) AS Total_Employees,
    ROUND(AVG(salary.MonthlyIncomeINR), 2) AS Average_Monthly_Salary
FROM employees
JOIN salary
    ON employees.EmployeeID = salary.EmployeeID
GROUP BY employees.Attrition;

-- Age Group vs Attrition
SELECT
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS Age_Group,

    COUNT(*) AS Total_Employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Employees_Left,

    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate

FROM employees
GROUP BY Age_Group
ORDER BY MIN(Age);

-- Years at Company vs Attrition
SELECT
    CASE
        WHEN YearsAtCompany < 2 THEN 'Less than 2 Years'
        WHEN YearsAtCompany BETWEEN 2 AND 5 THEN '2-5 Years'
        WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10 Years'
        WHEN YearsAtCompany BETWEEN 11 AND 15 THEN '11-15 Years'
        ELSE 'Above 15 Years'
    END AS Experience_Group,

    COUNT(*) AS Total_Employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Employees_Left,

    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate

FROM employees
JOIN experience
    ON employees.EmployeeID = experience.EmployeeID

GROUP BY Experience_Group
ORDER BY MIN(YearsAtCompany);

-- Promotion Delay vs Attrition
SELECT
    CASE
        WHEN YearsSinceLastPromotion <= 1 THEN '0-1 Years'
        WHEN YearsSinceLastPromotion BETWEEN 2 AND 3 THEN '2-3 Years'
        WHEN YearsSinceLastPromotion BETWEEN 4 AND 5 THEN '4-5 Years'
        ELSE 'Above 5 Years'
    END AS Promotion_Wait_Group,

    COUNT(*) AS Total_Employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Employees_Left,

    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate

FROM employees
JOIN experience
    ON employees.EmployeeID = experience.EmployeeID

GROUP BY Promotion_Wait_Group
ORDER BY MIN(YearsSinceLastPromotion);

-- Attendance vs Attrition
SELECT
    employees.Attrition,
    COUNT(*) AS Total_Employees,

    ROUND(AVG(attendance.AbsentDaysPerYear), 2)
        AS Average_Absent_Days,

    ROUND(AVG(attendance.LateArrivalDaysPerYear), 2)
        AS Average_Late_Arrival_Days,

    ROUND(AVG(attendance.AttendanceRatePct), 2)
        AS Average_Attendance_Rate

FROM employees
JOIN attendance
    ON employees.EmployeeID = attendance.EmployeeID
GROUP BY employees.Attrition;

-- Business Travel vs Attrition
SELECT
    BusinessTravel,
    COUNT(*) AS Total_Employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Employees_Left,

    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate

FROM employees
GROUP BY BusinessTravel
ORDER BY Attrition_Rate DESC;

-- Location-wise Attrition
SELECT
    Location,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate
FROM employees
GROUP BY Location
ORDER BY Attrition_Rate DESC;

-- ===========
--  CASE WHEN
-- ===========

-- Query 1: Salary Band Analysis
SELECT
    CASE
        WHEN MonthlyIncomeINR < 30000 THEN 'Low Salary'
        WHEN MonthlyIncomeINR BETWEEN 30000 AND 60000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END AS Salary_Band,
    COUNT(*) AS Total_Employees
FROM salary
GROUP BY Salary_Band
ORDER BY Total_Employees DESC;

-- Query 2: It identifies employees who meet all three conditions
SELECT
    e.EmployeeID,
    e.EmployeeName,
    e.Department,
    s.MonthlyIncomeINR,
    p.JobSatisfaction,
    a.AbsentDaysPerYear,
    CASE
        WHEN s.MonthlyIncomeINR < 30000
             AND p.JobSatisfaction <= 2
             AND a.AbsentDaysPerYear > 5
        THEN 'Needs HR Attention'
        ELSE 'Normal'
    END AS HR_Status
FROM employees e
JOIN salary s
    ON e.EmployeeID = s.EmployeeID
JOIN performance p
    ON e.EmployeeID = p.EmployeeID
JOIN attendance a
    ON e.EmployeeID = a.EmployeeID
WHERE s.MonthlyIncomeINR < 30000
  AND p.JobSatisfaction <= 2
  AND a.AbsentDaysPerYear > 5;
  
-- ====================
-- SUBQUERIES AND CTEs
-- ====================

-- query 1: Employees earning above the company average
SELECT
    EmployeeID,
    MonthlyIncomeINR
FROM salary
WHERE MonthlyIncomeINR > (
    SELECT AVG(MonthlyIncomeINR)
    FROM salary
);

-- query 2: Department Average Salary
SELECT
    e.Department,
    ROUND(AVG(s.MonthlyIncomeINR), 2) AS Average_Salary
FROM employees e
JOIN salary s
    ON e.EmployeeID = s.EmployeeID
GROUP BY e.Department
ORDER BY Average_Salary DESC;

-- query 3: Final SQL Concept — CTE (Common Table Expression)
-- Which departments have the highest employee attrition rates?
WITH Department_Attrition AS (
    SELECT
        Department,
        COUNT(*) AS Total_Employees,
        SUM(
            CASE
                WHEN Attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS Employees_Left
    FROM employees
    GROUP BY Department
)

SELECT
    Department,
    Total_Employees,
    Employees_Left,
    ROUND(
        Employees_Left * 100.0 / Total_Employees,
        2
    ) AS Attrition_Rate
FROM Department_Attrition
ORDER BY Attrition_Rate DESC;