-- Select the database to use
USE human_resource;


-- Turn off safe updates mode to allow changes to the database
SET SQL_SAFE_UPDATES = 0;

-- Display the first 5 records from the cleand table
SELECT * FROM cleand 
LIMIT 5;

-- Alter the table to rename the ID column
ALTER TABLE cleand
CHANGE COLUMN ï»؟ID ID INT;

-- Update the DOB column to standard format YYYY-MM-DD
UPDATE cleand
SET DOB = STR_TO_DATE(DOB, '%d/%m/%Y');

-- Update the StartDate column to standard format YYYY-MM-DD
UPDATE cleand
SET StartDate = STR_TO_DATE(StartDate, '%d/%m/%Y');

-- Update the ExitDate column to standard format YYYY-MM-DD
UPDATE cleand
SET ExitDate = STR_TO_DATE(ExitDate, '%d/%m/%Y')
WHERE ExitDate IS NOT NULL AND ExitDate <> '';


-- Update the Training Date column to standard format YYYY-MM-DD
UPDATE cleand
SET `Training Date` = STR_TO_DATE(`Training Date`, '%d/%m/%Y');



-- Find duplicates and delete them
WITH DUPLICATES AS (
    SELECT 
        ID,
        firstName,
        LastName,
        ROW_NUMBER() OVER (PARTITION BY firstName, LastName ORDER BY ID) AS ROW_NUM
    FROM 
        cleand
)
DELETE FROM cleand
WHERE ID IN (
    SELECT ID 
    FROM DUPLICATES 
    WHERE ROW_NUM > 1
);

-- Display cleaned Data
SELECT * FROM cleand;


-- Check for typos, NULLs, and inconsistent categorical data

-- Check distinct values in GenderCode column
SELECT DISTINCT GenderCode 
FROM cleand;

-- Check distinct values in State column
SELECT DISTINCT State 
FROM cleand;

-- Check distinct values in Title column
SELECT DISTINCT Title 
FROM cleand;

-- Check distinct values in EmployeeStatus column
SELECT DISTINCT EmployeeStatus 
FROM cleand;

-- Check for NULL values in key columns
SELECT *
FROM cleand
WHERE GenderCode IS NULL OR State IS NULL OR Title IS NULL OR EmployeeStatus IS NULL;

-- Check distinct values in Division column
SELECT DISTINCT Division 
FROM cleand;

-- Check distinct values in EmployeeType column
SELECT DISTINCT EmployeeType 
FROM cleand;

-- Check distinct values in EmployeeClassificationType column
SELECT DISTINCT EmployeeClassificationType 
FROM cleand;

-- Check distinct values in TerminationType column
SELECT DISTINCT TerminationType 
FROM cleand;

-- Check for NULL values in additional key columns
SELECT *
FROM cleand
WHERE Division IS NULL OR EmployeeType IS NULL OR EmployeeClassificationType IS NULL OR TerminationType IS NULL;

-- Check distinct values in TerminationDescription column
SELECT DISTINCT TerminationDescription 
FROM cleand;

-- Check distinct values in Supervisor column
SELECT DISTINCT Supervisor 
FROM cleand;

-- Check distinct values in Training Program Name column
SELECT DISTINCT `Training Program Name` 
FROM cleand;

-- Check distinct values in Training Type column
SELECT DISTINCT `Training Type` 
FROM cleand; 

-- Check distinct values in Training Outcome column
SELECT DISTINCT `Training Outcome` 
FROM cleand;

-- Check distinct values in Location column
SELECT DISTINCT Location 
FROM cleand;

-- Check distinct values in Trainer column
SELECT DISTINCT Trainer 
FROM cleand;

-- Check for NULL values in training and supervision-related columns
SELECT *
FROM cleand
WHERE `Training Type` IS NULL OR `Training Outcome` IS NULL OR Location IS NULL OR Trainer IS NULL OR `Training Program Name` IS NULL OR Supervisor IS NULL OR TerminationDescription IS NULL;

-- Update the State column to use full state names
UPDATE cleand
SET State = 
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
  END;

-- Update the Title column to use more descriptive titles
UPDATE cleand
SET Title = 
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
  END;

-- Update the Division column to use more descriptive division names
UPDATE cleand
SET Division = 
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
  END;

-- Turn safe updates mode back on
SET SQL_SAFE_UPDATES = 1;

-- Calculate the total training cost for failed training programs for curret active employees
SELECT 
    `Training Program Name`, 
    ROUND(SUM(`Training Cost`), 2) AS TOTAL_COST
FROM 
    cleand
WHERE 
    `Training Outcome` = 'Failed' AND EmployeeStatus = 'Active'
GROUP BY 
    `Training Program Name`
ORDER BY 
    TOTAL_COST DESC;
        
-- Identify the worst trainer based on the highest number of failing active employees and total training cost
SELECT 
    Trainer,
    `Training Program Name`, 
    COUNT(CASE WHEN `Training Outcome` = 'Failed' THEN 1 ELSE 0 END) AS COUNT_FAILED_EMPLOYEES,
    SUM(`Training Cost`) AS TOTAL_COST
FROM 
    cleand
WHERE 
    `Training Outcome` = 'Failed' AND EmployeeStatus = 'Active'
GROUP BY 
    Trainer, `Training Program Name`
ORDER BY 
    TOTAL_COST DESC;

-- Determine the best training program based on successful training outcomes and total training cost
SELECT 
    `Training Program Name`, 
    ROUND(SUM(`Training Cost`), 2) AS TOTAL_COST
FROM 
    cleand
WHERE 
    `Training Outcome` = 'Passed' AND EmployeeStatus = 'Active'
GROUP BY 
    `Training Program Name`
ORDER BY 
    TOTAL_COST DESC;
        
-- Evaluate if the company should redirect investment from internal to external training based on training outcomes and costs
SELECT 
    `Training Type`,
    `Training Outcome`,
    ROUND(SUM(`Training Cost`), 2) AS TOTAL_COST
FROM 
    cleand
WHERE 
    EmployeeStatus = 'Active' AND `Training Outcome` = 'Passed'
GROUP BY 
    `Training Type`, 
    `Training Outcome`
ORDER BY
     `Training Type` DESC;
 
-- Identify the training programs with the highest success rate
 SELECT `Training Program Name`, 
       COUNT(CASE WHEN `Training Outcome` = 'Passed' THEN 1 END) * 100.0 / COUNT(*) AS Success_Rate
FROM cleand
GROUP BY `Training Program Name`
ORDER BY Success_Rate DESC;

 
    
-- Hiring trend Per Years
SELECT 
    YEAR(StartDate) AS Hire_Year,
    COUNT(*) AS Num_Hires
FROM 
    cleand
WHERE 
    `Current Employee Rating` = 5 AND EmployeeStatus = 'Active' 
GROUP BY 
    Hire_Year
ORDER BY 
    Hire_Year DESC;
    

-- With CTE to rank supervisors based on total scores
WITH TOP_SUPER AS (
    SELECT 
        Supervisor,
		ROUND(AVG(`Current Employee Rating`),0) AS `Current Employee Rating`,
        ROUND(AVG(`Engagement Score`),0) AS `Engagement Score`,
        ROUND(AVG(`Satisfaction Score`),0) AS `Satisfaction Score`,
        ROUND(AVG(`Work-Life Balance Score`),0) AS `Work-Life Balance Score`,
        ROUND((AVG(`Current Employee Rating`) + AVG(`Engagement Score`) + AVG(`Satisfaction Score`) + AVG(`Work-Life Balance Score`)),0) AS TotalScore,
        DENSE_RANK() OVER (ORDER BY 
        (AVG(`Current Employee Rating`) + AVG(`Engagement Score`) + AVG(`Satisfaction Score`) + AVG(`Work-Life Balance Score`)) DESC) AS RANKS
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active'
    GROUP BY 
        Supervisor
)

-- Select top 10 supervisors
SELECT 
    Supervisor,
    `Current Employee Rating`,
    `Engagement Score`,
    `Satisfaction Score`,
    `Work-Life Balance Score`,
    RANKS,
    TotalScore
FROM 
    TOP_SUPER
WHERE 
    RANKS <= 10
ORDER BY 
    RANKS;


-- Total cost for passed Active Employees per states
SELECT 
    State ,
    `Training Outcome` ,
    ROUND(SUM(`Training Cost`), 0) AS TOTAL_COST
FROM 
    cleand
WHERE 
    EmployeeStatus = 'Active' AND `Training Outcome` = 'Passed'
GROUP BY 
  State
ORDER BY
    TOTAL_COST DESC;
    
-- Total cost for Failed Active Employees per states 
SELECT 
    State ,
    `Training Outcome` ,
    ROUND(SUM(`Training Cost`), 0) AS TOTAL_COST
FROM 
    cleand
WHERE 
    EmployeeStatus = 'Active' AND `Training Outcome` = 'Failed'
GROUP BY 
  State
ORDER BY
    TOTAL_COST DESC;
    
    
-- top 5 supervisors with the highest employee retention rate.
SELECT Supervisor, 
       COUNT(CASE WHEN EmployeeStatus = 'Active' THEN 1 END) * 1.0 / COUNT(*) AS Retention_Rate
FROM cleand
GROUP BY Supervisor
ORDER BY Retention_Rate DESC
LIMIT 5;

-- the average Satisfaction Score for each Current Employee Rating .
SELECT `Current Employee Rating`, 
       AVG(`Satisfaction Score`) AS Avg_Satisfaction
FROM cleand
GROUP BY `Current Employee Rating`
ORDER BY Avg_Satisfaction DESC;


-- age Analysis (Best Rating Age )
SELECT Age ,
COUNT(*) AS TOTAL_COUNT
FROM cleand
WHERE EmployeeStatus = 'Active'  AND `Current Employee Rating` BETWEEN 4 AND 5 
GROUP BY Age ;


-- age Analysis (Best Rating Age Bucket)
SELECT  
CASE  
WHEN Age BETWEEN 23 AND 29  THEN '20_BUCKET' 
WHEN Age BETWEEN 30 AND 39  THEN '30_BUCKET' 
WHEN Age BETWEEN 40 AND 49 THEN '40_BUCKET' 
WHEN Age BETWEEN 50 AND 59  THEN '50_BUCKET' 
WHEN Age BETWEEN 60 AND 69  THEN '60_BUCKET' 
WHEN Age BETWEEN 70 AND 79 THEN '70_BUCKET' 
WHEN Age BETWEEN 80 AND 89 THEN '80_BUCKET' 
ELSE 'OTHERS'
END AS AGE_BUCKET,
COUNT(*) AS TOTAL_COUNT
FROM cleand
WHERE EmployeeStatus = 'Active'  AND `Current Employee Rating` BETWEEN 4 AND 5 
GROUP BY AGE_BUCKET 
ORDER BY TOTAL_COUNT DESC;



-- Define the CTE to calculate the total sum of employees
WITH TotalEmployees AS (
    SELECT COUNT(*) AS TOTAL_SUM
    FROM cleand
    WHERE EmployeeStatus = 'Active' AND `Current Employee Rating` BETWEEN 4 AND 5
),
AgeBuckets AS (
    SELECT 
        CASE 
            WHEN Age BETWEEN 23 AND 29 THEN '20_BUCKET'
            WHEN Age BETWEEN 30 AND 39 THEN '30_BUCKET'
            WHEN Age BETWEEN 40 AND 49 THEN '40_BUCKET'
            WHEN Age BETWEEN 50 AND 59 THEN '50_BUCKET'
            WHEN Age BETWEEN 60 AND 69 THEN '60_BUCKET'
            WHEN Age BETWEEN 70 AND 79 THEN '70_BUCKET'
            WHEN Age BETWEEN 80 AND 89 THEN '80_BUCKET'
            ELSE 'OTHER'
        END AS AGE_BUCKET,
        COUNT(*) AS TOTAL_COUNT
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active' 
        AND `Current Employee Rating` BETWEEN 4 AND 5
    GROUP BY 
        AGE_BUCKET
)
-- Calculate the percentage of each age bucket
SELECT 
    a.AGE_BUCKET,
    a.TOTAL_COUNT,
    ROUND((a.TOTAL_COUNT / t.TOTAL_SUM) * 100, 2) AS PERCENTAGE
FROM 
    AgeBuckets a, TotalEmployees t
ORDER BY 
    PERCENTAGE DESC;
