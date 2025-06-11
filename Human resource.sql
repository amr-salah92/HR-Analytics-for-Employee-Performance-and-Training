/***********************************************
  HUMAN RESOURCE DATA ANALYSIS PROJECT
  --------------------------------------
  Project Overview:
  This project involves cleaning, transforming, 
  and analyzing HR data to derive key business insights.

  Goals:
  1. Clean and standardize HR data to ensure consistency.
  2. Perform exploratory data analysis (EDA).
  3. Conduct BI queries to explore workforce metrics.
  4. Validate data quality for accurate insights.

  Sections:
  - Database setup and configuration
  - Data cleaning and preparation
  - Data exploration and validation
  - Data transformation
  - Business insights and analysis
***********************************************/


/***************************************
  SECTION 1: DATABASE SETUP & CONFIGURATION
***************************************/
USE human_resource;

-- Disable safe update mode to allow update/delete without WHERE key restrictions
SET SQL_SAFE_UPDATES = 0;


/***************************************
  SECTION 2: DATA CLEANING & PREPARATION
***************************************/

-- Preview sample data
SELECT * FROM cleand LIMIT 5;

-- Fix corrupted column name encoding
ALTER TABLE cleand CHANGE COLUMN ï»¿ID ID INT;

-- Convert date strings to proper DATE format
START TRANSACTION;

UPDATE cleand SET DOB = STR_TO_DATE(DOB, '%d/%m/%Y');
UPDATE cleand SET StartDate = STR_TO_DATE(StartDate, '%d/%m/%Y');
UPDATE cleand 
  SET ExitDate = STR_TO_DATE(ExitDate, '%d/%m/%Y') 
  WHERE ExitDate IS NOT NULL AND ExitDate <> '';
UPDATE cleand SET `Training Date` = STR_TO_DATE(`Training Date`, '%d/%m/%Y');

COMMIT;

-- Remove duplicate records based on first and last names (keep lowest ID)
DELETE c1 
FROM cleand c1
JOIN (
    SELECT ID, ROW_NUMBER() OVER (PARTITION BY firstName, LastName ORDER BY ID) AS row_num
    FROM cleand
) AS dups ON c1.ID = dups.ID
WHERE dups.row_num > 1;


/***************************************
  SECTION 3: DATA EXPLORATION & VALIDATION
***************************************/

-- Date and age range checks
SELECT MIN(DOB) AS Earliest_DOB, MAX(DOB) AS Latest_DOB,
       MIN(Age) AS Youngest, MAX(Age) AS Oldest
FROM cleand;

-- Hiring and exit timeline
SELECT MIN(StartDate) AS First_Hiring, MAX(StartDate) AS Last_Hiring FROM cleand;
SELECT MIN(ExitDate) AS First_Resignation, MAX(ExitDate) AS Last_Resignation FROM cleand;

-- Performance score range validation
SELECT MIN(`Current Employee Rating`), MAX(`Current Employee Rating`),
       MIN(`Engagement Score`), MAX(`Engagement Score`),
       MIN(`Satisfaction Score`), MAX(`Satisfaction Score`),
       MIN(`Work-Life Balance Score`), MAX(`Work-Life Balance Score`)
FROM cleand;

-- Training metric ranges
SELECT MIN(`Training Date`), MAX(`Training Date`),
       MIN(`Training Duration(Days)`), MAX(`Training Duration(Days)`),
       MIN(`Training Cost`), MAX(`Training Cost`)
FROM cleand;

-- Categorical data consistency check
SELECT DISTINCT GenderCode, State, Title, EmployeeStatus FROM cleand;
SELECT DISTINCT Division, EmployeeType, EmployeeClassificationType, TerminationType FROM cleand;

-- Null check for key HR fields
SELECT * FROM cleand
WHERE COALESCE(GenderCode, State, Title, EmployeeStatus, Division) IS NULL;


/***************************************
  SECTION 4: DATA TRANSFORMATION
***************************************/

-- Create a view with standardized values for analysis
CREATE VIEW cleaned_data AS
SELECT *,
  -- Standardize state names
  CASE State
    WHEN 'AL' THEN 'Alabama' WHEN 'AZ' THEN 'Arizona' WHEN 'CA' THEN 'California'
    WHEN 'CO' THEN 'Colorado' WHEN 'CT' THEN 'Connecticut' WHEN 'FL' THEN 'Florida'
    WHEN 'GA' THEN 'Georgia' WHEN 'ID' THEN 'Idaho' WHEN 'IN' THEN 'Indiana'
    WHEN 'KY' THEN 'Kentucky' WHEN 'MA' THEN 'Massachusetts' WHEN 'ME' THEN 'Maine'
    WHEN 'MT' THEN 'Montana' WHEN 'NC' THEN 'North Carolina' WHEN 'ND' THEN 'North Dakota'
    WHEN 'NH' THEN 'New Hampshire' WHEN 'NY' THEN 'New York' WHEN 'OH' THEN 'Ohio'
    WHEN 'OR' THEN 'Oregon' WHEN 'PA' THEN 'Pennsylvania' WHEN 'RI' THEN 'Rhode Island'
    WHEN 'TN' THEN 'Tennessee' WHEN 'TX' THEN 'Texas' WHEN 'UT' THEN 'Utah'
    WHEN 'VA' THEN 'Virginia' WHEN 'VT' THEN 'Vermont' WHEN 'WA' THEN 'Washington'
    ELSE State END AS Standardized_State,

  -- Standardize titles
  CASE Title
    WHEN 'Production Technician I' THEN 'Junior Production Technician'
    WHEN 'Area Sales Manager' THEN 'Regional Sales Manager'
    WHEN 'Production Technician II' THEN 'Senior Production Technician'
    WHEN 'IT Support' THEN 'IT Support Specialist'
    WHEN 'Sr. Network Engineer' THEN 'Senior Network Engineer'
    WHEN 'Sr. DBA' THEN 'Senior Database Administrator'
    WHEN 'Data Analyst' THEN 'Data Analysis Specialist'
    WHEN 'CIO' THEN 'Chief Information Officer'
    WHEN 'BI Director' THEN 'Business Intelligence Director'
    WHEN 'President & CEO' THEN 'President and Chief Executive Officer'
    ELSE Title END AS Standardized_Title,

  -- Standardize division names
  CASE Division
    WHEN 'Aerial' THEN 'Aerial Operations'
    WHEN 'General - Sga' THEN 'General Admin Services'
    WHEN 'Finance & Accounting' THEN 'Finance and Accounting'
    WHEN 'Field Operations' THEN 'Field Operations Division'
    WHEN 'Executive' THEN 'Executive Management'
    WHEN 'Sales & Marketing' THEN 'Sales and Marketing Department'
    WHEN 'Wireless' THEN 'Wireless Services'
    WHEN 'Technology / It' THEN 'Technology and IT'
    ELSE Division END AS Standardized_Division

FROM cleand;

-- Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;


/***************************************
  SECTION 5: BUSINESS ANALYSIS & INSIGHTS
***************************************/

-- Top performing employees by age
SELECT Age, COUNT(*) AS Total_Employees
FROM cleand
WHERE EmployeeStatus = 'Active' AND TerminationType = 'Unk' AND `Current Employee Rating` BETWEEN 4 AND 5
GROUP BY Age ORDER BY Total_Employees DESC;

-- Manpower by state
SELECT State, COUNT(ID) AS Employee_Count
FROM cleand
WHERE EmployeeStatus = 'Active' AND TerminationType = 'Unk'
GROUP BY State ORDER BY Employee_Count DESC;

-- Age range vs rating
SELECT 
    CASE 
        WHEN Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '50-59'
        WHEN Age BETWEEN 60 AND 69 THEN '60-69'
        ELSE '70+' 
    END AS Age_Range,
    AVG(`Current Employee Rating`) AS Avg_Rating,
    COUNT(ID) AS Total
FROM cleand
WHERE EmployeeStatus = 'Active'
GROUP BY Age_Range
ORDER BY Avg_Rating DESC;

-- Supervisor performance
SELECT Supervisor,
       AVG(`Current Employee Rating`) AS Avg_Rating,
       COUNT(ID) AS Employee_Count
FROM cleand
WHERE EmployeeStatus = 'Active'
GROUP BY Supervisor
ORDER BY Avg_Rating DESC;

-- Division-wise headcount
SELECT Division, COUNT(ID) AS Employee_Count
FROM cleand
WHERE EmployeeStatus = 'Active' AND TerminationType = 'Unk'
GROUP BY Division
ORDER BY Employee_Count DESC;

-- Failed training cost per program
SELECT `Training Program Name`, ROUND(SUM(`Training Cost`), 0) AS Total_Cost
FROM cleand
WHERE `Training Outcome` = 'Failed' AND EmployeeStatus = 'Active' AND TerminationType = 'Unk'
GROUP BY `Training Program Name`
ORDER BY Total_Cost DESC;

-- Trainer performance
SELECT Trainer, `Training Program Name`,
       COUNT(CASE WHEN `Training Outcome` = 'Failed' THEN 1 END) AS Failures,
       SUM(`Training Cost`) AS Total_Cost
FROM cleand
WHERE `Training Outcome` = 'Failed' AND EmployeeStatus = 'Active' AND TerminationType = 'Unk'
GROUP BY Trainer, `Training Program Name`
ORDER BY Total_Cost DESC;

-- Training attendance metrics
SELECT 
    `Training Program Name`,
    COUNT(DISTINCT ID) AS Attendees,
    COUNT(CASE WHEN `Training Outcome` = 'Failed' THEN ID END) AS Failures,
    ROUND((COUNT(DISTINCT ID) * 100.0) / (SELECT COUNT(DISTINCT ID) FROM cleand WHERE EmployeeStatus = 'Active'), 2) AS Attendance_Percentage
FROM cleand
WHERE EmployeeStatus = 'Active'
GROUP BY `Training Program Name`
ORDER BY Attendance_Percentage DESC;

-- Training impact on employee rating
SELECT 
    CASE 
        WHEN ID IN (
            SELECT DISTINCT ID 
            FROM cleand 
            WHERE `Training Program Name` IN ('Project Management', 'Communication Skills')
        ) THEN 'Trained'
        ELSE 'Not Trained'
    END AS Training_Status,
    AVG(`Current Employee Rating`) AS Avg_Rating,
    COUNT(ID) AS Total
FROM cleand
WHERE EmployeeStatus = 'Active'
GROUP BY Training_Status
ORDER BY Avg_Rating DESC;

-- Overall company rating
SELECT AVG(`Current Employee Rating`) AS Avg_Company_Rating
FROM cleand
WHERE EmployeeStatus = 'Active';

-- Division performance (rating + engagement + satisfaction)
WITH DivisionMetrics AS (
    SELECT Division,
           AVG(`Current Employee Rating`) AS Avg_Rating,
           AVG(`Engagement Score`) AS Avg_Engagement,
           AVG(`Satisfaction Score`) AS Avg_Satisfaction
    FROM cleand
    WHERE EmployeeStatus = 'Active'
    GROUP BY Division
)
SELECT Division, 
       ROUND((Avg_Rating + Avg_Engagement + Avg_Satisfaction) / 3, 2) AS Overall_Score
FROM DivisionMetrics
ORDER BY Overall_Score DESC;

-- Ratings by employee type
SELECT EmployeeType,
       AVG(`Current Employee Rating`) AS Avg_Rating
FROM cleand
WHERE EmployeeStatus = 'Active'
GROUP BY EmployeeType
ORDER BY Avg_Rating DESC;

-- Rating by year of hiring
SELECT YEAR(StartDate) AS Hiring_Year, 
       AVG(`Current Employee Rating`) AS Avg_Rating
FROM cleand
GROUP BY YEAR(StartDate)
ORDER BY Avg_Rating DESC;

-- Rating by duration in company
SELECT 
    ROUND(DATEDIFF(NOW(), StartDate) / 365, 0) AS Years_Worked,
    AVG(`Current Employee Rating`) AS Avg_Rating
FROM cleand
WHERE EmployeeStatus = 'Active'
GROUP BY Years_Worked
ORDER BY Avg_Rating DESC;

/***************************************
  FINAL DATA VALIDATION SECTION
***************************************/

-- Verify cleaned data structure
SELECT * FROM cleand LIMIT 10;

-- Validate date format standardization
SELECT DOB, StartDate, ExitDate, `Training Date` 
FROM cleand 
LIMIT 5;

-- Confirm categorical data standardization
SELECT DISTINCT State, Title, Division FROM cleand;

