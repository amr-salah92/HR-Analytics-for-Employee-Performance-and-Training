/***********************************************
  HUMAN RESOURCE DATA ANALYSIS PROJECT
  --------------------------------------
  Project Overview:
  This project involves cleaning, transforming, 
  and analyzing human resource (HR) data to derive 
  key business insights. The dataset includes employee 
  demographics, job details, training records, 
  and performance metrics.

  Goals:
  1. Clean and standardize HR data to ensure consistency.
  2. Perform exploratory data analysis (EDA) to identify trends.
  3. Conduct business intelligence queries to gain insights 
     into workforce dynamics, training efficiency, and turnover rates.
  4. Ensure data accuracy by performing validation checks.

  Sections:
  - Database setup and configuration
  - Data cleaning and preparation
  - Data exploration and validation
  - Data transformation for consistency
  - Business analysis and insights generation
  - Final validation checks

  This project provides valuable insights to HR teams, 
  supporting data-driven decision-making for better 
  employee management and training optimization.

***********************************************/


/***************************************
  DATABASE SETUP & CONFIGURATION SECTION
***************************************/

-- Set default database context
USE human_resource;

-- Disable safe update mode for bulk operations
SET SQL_SAFE_UPDATES = 0;


/***************************************
  DATA CLEANING & PREPARATION SECTION
***************************************/

-- Preview raw data sample
SELECT * FROM cleand LIMIT 5;

-- Fix column name encoding issue
ALTER TABLE cleand
CHANGE COLUMN ï»؟ID ID INT;

-- Standardize date formats across all date columns
START TRANSACTION;

UPDATE cleand SET DOB = STR_TO_DATE(DOB, '%d/%m/%Y');
UPDATE cleand SET StartDate = STR_TO_DATE(StartDate, '%d/%m/%Y');
UPDATE cleand SET ExitDate = STR_TO_DATE(ExitDate, '%d/%m/%Y') 
  WHERE ExitDate IS NOT NULL AND ExitDate <> '';
UPDATE cleand SET `Training Date` = STR_TO_DATE(`Training Date`, '%d/%m/%Y');

COMMIT;


-- Remove duplicate records using name matching
DELETE c1 
FROM cleand c1
JOIN (
    SELECT ID, ROW_NUMBER() OVER (PARTITION BY firstName, LastName ORDER BY ID) AS row_num
    FROM cleand
) AS dups ON c1.ID = dups.ID
WHERE dups.row_num > 1;


/***************************************
  DATA EXPLORATION & VALIDATION SECTION
***************************************/

-- Basic data range analysis
SELECT 
    MIN(dob) AS EARLIEST_DOB, MAX(dob) AS NEWEST_DOB,
    MIN(age) AS YOUNGEST, MAX(age) AS OLDEST
FROM cleand;

-- Get the earliest and latest employee start dates
SELECT 
    MIN(StartDate) AS First_Hiring, 
    MAX(StartDate) AS Last_Hiring
FROM cleand;

-- Get the earliest and latest employee exit dates
SELECT 
   MIN(ExitDate) AS FIRST_RESIGN, 
   MAX(ExitDate) AS LAST_RESIGN
FROM cleand;

-- Score range analysis
SELECT 
    MIN(`Current Employee Rating`), MAX(`Current Employee Rating`),
    MIN(`Engagement Score`), MAX(`Engagement Score`),
    MIN(`Satisfaction Score`), MAX(`Satisfaction Score`),
    MIN(`Work-Life Balance Score`), MAX(`Work-Life Balance Score`)
FROM cleand;

-- Training metrics analysis
SELECT 
    MIN(`Training Date`), MAX(`Training Date`),
    MIN(`Training Duration(Days)`), MAX(`Training Duration(Days)`),
    MIN(`Training Cost`), MAX(`Training Cost`)
FROM cleand;

-- Data quality checks
-- Check categorical data consistency
SELECT DISTINCT GenderCode, State, Title, EmployeeStatus FROM cleand;
SELECT DISTINCT Division, EmployeeType, EmployeeClassificationType, TerminationType FROM cleand;

-- Check for missing values in key columns
SELECT * FROM cleand
WHERE COALESCE(GenderCode, State,Title,EmployeeStatus,Division) IS NULL;


/***************************************
  DATA TRANSFORMATION SECTION
***************************************/

-- Standardize state abbreviations to full names
CREATE VIEW cleaned_data AS
SELECT *,
  CASE State
    WHEN 'AL' THEN 'Alabama'
    WHEN 'AZ' THEN 'Arizona'
	WHEN 'CA' THEN 'California'
    WHEN 'CO' THEN 'Colorado'
    WHEN 'CT' THEN 'Connecticut'
    WHEN 'FL' THEN 'Florida'
    WHEN 'GA' THEN 'Georgia'
    WHEN 'ID' THEN 'Idaho'
    WHEN 'IN' THEN 'Indiana'
    WHEN 'KY' THEN 'Kentucky'
    WHEN 'MA' THEN 'Massachusetts'
    WHEN 'ME' THEN 'Maine'
    WHEN 'MT' THEN 'Montana'
    WHEN 'NC' THEN 'North Carolina'
    WHEN 'ND' THEN 'North Dakota'
    WHEN 'NH' THEN 'New Hampshire'
    WHEN 'NY' THEN 'New York'
    WHEN 'OH' THEN 'Ohio'
    WHEN 'OR' THEN 'Oregon'
    WHEN 'PA' THEN 'Pennsylvania'
    WHEN 'RI' THEN 'Rhode Island'
    WHEN 'TN' THEN 'Tennessee'
    WHEN 'TX' THEN 'Texas'
    WHEN 'UT' THEN 'Utah'
    WHEN 'VA' THEN 'Virginia'
    WHEN 'VT' THEN 'Vermont'
    WHEN 'WA' THEN 'Washington'
    ELSE State
    END AS Standardized_State,
  CASE Title
    WHEN 'Production Technician I' THEN 'Junior Production Technician'
    WHEN 'Area Sales Manager' THEN 'Regional Sales Manager'
    WHEN 'Production Technician II' THEN 'Senior Production Technician'
    WHEN 'IT Support' THEN 'IT Support Specialist'
    WHEN 'Network Engineer' THEN 'Network Engineer'
    WHEN 'Sr. Network Engineer' THEN 'Senior Network Engineer'
    WHEN 'Principal Data Architect' THEN 'Lead Data Architect'
    WHEN 'Enterprise Architect' THEN 'Enterprise Systems Architect'
    WHEN 'Sr. DBA' THEN 'Senior Database Administrator'
    WHEN 'Database Administrator' THEN 'Database Administrator'
    WHEN 'Data Analyst' THEN 'Data Analysis Specialist'
    WHEN 'Data Architect' THEN 'Data Infrastructure Architect'
    WHEN 'CIO' THEN 'Chief Information Officer'
    WHEN 'BI Director' THEN 'Business Intelligence Director'
    WHEN 'Sr. Accountant' THEN 'Senior Accountant'
    WHEN 'Software Engineering Manager' THEN 'Software Engineering Manager'
    WHEN 'Software Engineer' THEN 'Software Development Engineer'
    WHEN 'Shared Services Manager' THEN 'Shared Services Manager'
    WHEN 'Senior BI Developer' THEN 'Senior Business Intelligence Developer'
    WHEN 'Production Manager' THEN 'Production Operations Manager'
    WHEN 'President & CEO' THEN 'President and Chief Executive Officer'
    WHEN 'Administrative Assistant' THEN 'Administrative Assistant'
    WHEN 'Accountant I' THEN 'Junior Accountant'
    WHEN 'BI Developer' THEN 'Business Intelligence Developer'
    WHEN 'Sales Manager' THEN 'Sales Manager'
    WHEN 'IT Manager - Support' THEN 'IT Support Manager'
    WHEN 'IT Manager - Infra' THEN 'IT Infrastructure Manager'
    WHEN 'IT Manager - DB' THEN 'IT Database Manager'
    WHEN 'Director of Sales' THEN 'Sales Director'
    WHEN 'Director of Operations' THEN 'Operations Director'
    WHEN 'IT Director' THEN 'Information Technology Director'
    ELSE Title
  END AS Standardized_Title,
  CASE Division
    WHEN 'Aerial' THEN 'Aerial Operations'
    WHEN 'General - Sga' THEN 'General Administrative Services - SGA'
	WHEN 'Finance & Accounting' THEN 'Finance and Accounting Department'
    WHEN 'General - Con' THEN 'General Services - Construction'
    WHEN 'Field Operations' THEN 'Field Operations Division'
    WHEN 'General - Eng' THEN 'General Services - Engineering'
    WHEN 'Engineers' THEN 'Engineering Team'
    WHEN 'Executive' THEN 'Executive Management'
    WHEN 'Splicing' THEN 'Splicing Operations'
    WHEN 'Project Management - Con' THEN 'Project Management - Construction'
    WHEN 'Fielders' THEN 'Field Services'
    WHEN 'Project Management - Eng' THEN 'Project Management - Engineering'
    WHEN 'Shop (Fleet)' THEN 'Fleet and Shop Operations'
    WHEN 'Wireline Construction' THEN 'Wireline Construction Division'
    WHEN 'Catv' THEN 'Cable Television Services (CATV)'
    WHEN 'Yard (Material Handling)' THEN 'Material Handling Yard'
    WHEN 'Wireless' THEN 'Wireless Services'
    WHEN 'People Services' THEN 'Human Resources'
    WHEN 'Underground' THEN 'Underground Operations'
    WHEN 'Billable Consultants' THEN 'Consulting Services'
    WHEN 'Technology / It' THEN 'Technology and Information Technology'
    WHEN 'Sales & Marketing' THEN 'Sales and Marketing Department'
    WHEN 'Safety' THEN 'Safety Department'
    WHEN 'Isp' THEN 'Internet Service Provider (ISP) Services'
    WHEN 'Corp Operations' THEN 'Corporate Operations'
    ELSE Division
  END AS Standardized_Division
  FROM cleand;

-- Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;


/***************************************
  BUSINESS ANALYSIS & INSIGHTS SECTION
***************************************/

-- Training Program Analysis
-- Cost analysis for failed training programs
SELECT `Training Program Name`, ROUND(SUM(`Training Cost`), 0) AS TOTAL_COST
FROM cleand
WHERE `Training Outcome` = 'Failed' AND EmployeeStatus = 'Active' 
  AND TerminationType = 'Unk'
GROUP BY `Training Program Name`
ORDER BY TOTAL_COST DESC;

-- Trainer performance evaluation
SELECT Trainer, `Training Program Name`, 
       COUNT(CASE WHEN `Training Outcome` = 'Failed' THEN 1 END) AS FAIL_COUNT,
       SUM(`Training Cost`) AS TOTAL_COST
FROM cleand
WHERE `Training Outcome` = 'Failed' AND EmployeeStatus = 'Active'
  AND TerminationType = 'Unk'
GROUP BY Trainer, `Training Program Name`
ORDER BY TOTAL_COST DESC;

-- Employee Demographics Analysis
-- Age distribution of top performers
SELECT Age, COUNT(*) AS TOTAL_COUNT
FROM cleand
WHERE EmployeeStatus = 'Active' AND TerminationType = 'Unk' 
  AND `Current Employee Rating` BETWEEN 4 AND 5 
GROUP BY Age 
ORDER BY TOTAL_COUNT DESC;

-- Organizational Structure Analysis
-- Division performance metrics
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
       (Avg_Rating + Avg_Engagement + Avg_Satisfaction) / 3 AS Overall_Score
FROM DivisionMetrics
ORDER BY Overall_Score DESC;

-- Workforce Analytics
-- Turnover analysis by job title
WITH EmployeeCounts AS (
    SELECT Title, COUNT(*) OVER(PARTITION BY Title) AS Total_Employees,
           COUNT(CASE WHEN EmployeeStatus <> 'Active' THEN 1 END) OVER(PARTITION BY Title) AS Left_Employees
    FROM cleand
)
SELECT DISTINCT Title,
       ROUND((Left_Employees * 100.0 / Total_Employees), 2) AS Turnover_Rate
FROM EmployeeCounts
ORDER BY Turnover_Rate DESC;

-- Training ROI Analysis
-- Success rate vs cost analysis
SELECT `Training Program Name`, 
       ROUND(COUNT(CASE WHEN `Training Outcome` = 'Passed' THEN 1 END) * 100.0 / COUNT(*),0) AS Success_Rate,
       ROUND(SUM(`Training Cost`), 0) AS Total_Investment
FROM cleand
GROUP BY `Training Program Name`
ORDER BY Success_Rate DESC, Total_Investment DESC;


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

