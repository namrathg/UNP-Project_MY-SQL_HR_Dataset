-- STEP 1 (Creating the Schemas)

create database Human_Resources;
use Human_Resources;

CREATE TABLE EmpPerformance (
  EmpID INT PRIMARY KEY,
  EmpFullName VARCHAR(50),
  DepartmentName VARCHAR(20),
  DepartmentID INT,
  ManagerName VARCHAR(50),
  PerformanceRating int,
  EngagementSurvey INT,
  EmpSatisfaction INT,
  DaysLateLast30 INT,
  Absences INT
);

CREATE TABLE EmpDepartments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    DepartmentDesc TEXT,
    NumberofEmployees INT
);
 
 CREATE TABLE EmpDetails (
  EmpID INT PRIMARY KEY,
  EmpFullName VARCHAR(50),
  Gender VARCHAR(2),
  MaritalStatus VARCHAR(10),
  HispanicLatino VARCHAR(3),
  RaceDesc VARCHAR(50),
  City VARCHAR(20),
  DepartmentName VARCHAR(50),
  DepartmentID INT,
  Position VARCHAR(50),
  PositionID INT,
  Salary INT,
  RecruitmentSource VARCHAR(50)
);

-- STEP 2 (Creating Backup Database And Importing the Tables)

create database Human_Resources_Backup;
use Human_Resources_Backup;
ALTER TABLE human_resources_backup.empdepartments
RENAME COLUMN DeptartmentDesc to DepartmentDesc; 

SELECT @@GLOBAL.sql_safe_updates, @@SESSION.sql_safe_updates;

USE Human_Resources_Backup;
UPDATE EmpPerformance
SET PerformanceRating = CASE
    WHEN PerformanceRating = 'Exceeds' THEN 5
    WHEN PerformanceRating = 'Fully Meets' THEN 4
    WHEN PerformanceRating = 'Needs Improvement' THEN 3
    WHEN PerformanceRating = 'PIP' THEN 2
    ELSE PerformanceRating
    END
WHERE PerformanceRating IN ('Exceeds', 'Fully Meets', 'Needs Improvement', 'PIP')
AND EmpID IS NOT NULL;

ALTER TABLE Human_Resources_Backup.EmpPerformance
MODIFY PerformanceRating INT;

-- STEP 3 (Inserting  table from Human_Resources_Backup to Human_Resources)
INSERT INTO human_resources.empperformance (Empid, EmpfullName, DepartmentName,  DepartmentID, ManagerName, PerformanceRating, EngagementSurvey, EmpSatisfaction, DaysLateLast30, Absences)
SELECT Empid, EmpfullName, DepartmentName,  DepartmentID, ManagerName, PerformanceRating, EngagementSurvey, EmpSatisfaction, DaysLateLast30, Absences
FROM human_resources_backup.empperformance;


INSERT INTO human_resources.empdepartments (DepartmentID, DepartmentName, DepartmentDesc, numberofemployees)
SELECT DepartmentID, DepartmentName, DepartmentDesc, numberofemployees
FROM human_resources_backup.empdepartments;

INSERT INTO human_resources.empdetails (Empid, EmpfullName, Gender, MaritalStatus, HispanicLatino, RaceDesc, City, DepartmentName, DepartmentID, Position, PositionID, Salary, RecruitmentSource)
SELECT Empid, EmpfullName, Gender, MaritalStatus, HispanicLatino, RaceDesc, City, DepartmentName, DepartmentID, Position, PositionID, Salary, RecruitmentSource
FROM human_resources_backup.empdetails;

-- STEP 4 (Writing the SQL Queries)

# 1. Number of employees from each city
SELECT City, COUNT(*) as NumberOfEmployees
FROM Human_Resources.EmpDetails
GROUP BY City;

# 2. Average salary by RaceDesc
SELECT RaceDesc, AVG(Salary) as AverageSalary
FROM Human_Resources.EmpDetails
GROUP BY RaceDesc;

# 3. Department with the highest employees
SELECT DepartmentName, COUNT(*) as NumberOfEmployees
FROM Human_Resources.EmpDetails
GROUP BY DepartmentName
ORDER BY NumberOfEmployees DESC
LIMIT 1;

# 4. Department with the highest salary
SELECT DepartmentName, SUM(Salary) as TotalSalary
FROM Human_Resources.EmpDetails
GROUP BY DepartmentName
ORDER BY TotalSalary DESC
LIMIT 1;

# 5. Average salary per gender
SELECT Gender, AVG(Salary) as AverageSalary
FROM Human_Resources.EmpDetails
GROUP BY Gender;

# 6. Top Earning Positions
SELECT Position, AVG(Salary) as AverageSalary
FROM Human_Resources.EmpDetails
GROUP BY Position
ORDER BY AverageSalary DESC
LIMIT 1;

# 7. Number of employees from the source of recruitment
SELECT RecruitmentSource, COUNT(*) as NumberOfEmployees
FROM Human_Resources.EmpDetails
GROUP BY RecruitmentSource;

# 8. Total absences by departments
SELECT DepartmentName, SUM(Absences) as TotalAbsences
FROM Human_Resources.EmpPerformance
GROUP BY DepartmentName;

# 9. Top Performing Departments
SELECT DepartmentName, AVG(PerformanceRating) as AveragePerformanceRating
FROM Human_Resources.EmpPerformance
GROUP BY DepartmentName
ORDER BY AveragePerformanceRating DESC
LIMIT 1;

# 10. Average Performance Rating
SELECT AVG(PerformanceRating) as AveragePerformanceRating
FROM Human_Resources.EmpPerformance;



