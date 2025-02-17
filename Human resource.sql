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




-- max & min dob and age 
SELECT MIN(dob) AS EARLIST_DOB,
MAX(dob) AS NEWEST_DOB ,
MIN(age) AS YOUNGEST,
MAX(age)  AS OLDEST
FROM cleand;

-- max & min StartDate and ExitDate
SELECT MIN(StartDate) AS FIRST_HIRING,
MAX(StartDate) AS LAST_HIRING ,
MIN(ExitDate) AS FIRST_RESIGN,
MAX(ExitDate)  AS LAST_RESIGN
FROM cleand;

-- MIN & MAX Current Employee Rating 
SELECT MIN(`Current Employee Rating`) ,
MAX(`Current Employee Rating`)  
FROM cleand;

-- MIN & MAX Engagement Score
SELECT MIN(`Engagement Score`) ,
MAX(`Engagement Score`)  
FROM cleand;

-- MIN & MAX Satisfaction Score
SELECT MIN(`Satisfaction Score`) ,
MAX(`Satisfaction Score`)  
FROM cleand;

-- MIN & MAX Work-Life Balance Score
SELECT MIN(`Work-Life Balance Score`) ,
MAX(`Work-Life Balance Score`)  
FROM cleand;

-- MIN & MAX Training Date
SELECT MIN(`Training Date`) ,
MAX(`Training Date`)  
FROM cleand;

-- MIN & MAX Training Duration(Days)
SELECT MIN(`Training Duration(Days)`) ,
MAX(`Training Duration(Days)`)  
FROM cleand;

-- MIN & MAX Training Cost
SELECT MIN(`Training Cost`) ,
MAX(`Training Cost`)  
FROM cleand;


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
    ROUND(SUM(`Training Cost`), 0) AS TOTAL_COST
FROM 
    cleand
WHERE 
    `Training Outcome` = 'Failed' AND EmployeeStatus = 'Active' AND TerminationType = 'Unk'
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
    `Training Outcome` = 'Failed' AND EmployeeStatus = 'Active' AND TerminationType = 'Unk'
GROUP BY 
    Trainer, `Training Program Name`
ORDER BY 
    TOTAL_COST DESC;

-- Determine the best training program based on successful training outcomes and total training cost
SELECT 
    `Training Program Name`, 
    ROUND(SUM(`Training Cost`), 0) AS TOTAL_COST
FROM 
    cleand
WHERE 
    `Training Outcome` = 'Passed' AND EmployeeStatus = 'Active' AND TerminationType = 'Unk'
GROUP BY 
    `Training Program Name`
ORDER BY 
    TOTAL_COST DESC;
        
-- Determine the most important training program based on the number of participants
-- Define the CTE to calculate the total number of active employees
WITH TotalEmployees AS (
    SELECT 
        COUNT(*) AS TOTAL_EMPLOYEES
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active' AND TerminationType = 'Unk'
),
TrainingProgramCounts AS (
    SELECT 
        `Training Program Name`, 
        COUNT(*) AS TOTAL_Participants
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active' AND TerminationType = 'Unk'
        AND (`Training Outcome` = 'Passed' OR `Training Outcome` = 'Complete' OR `Training Outcome` = 'Incomplete')
    GROUP BY 
        `Training Program Name`
)
-- Calculate the percentage of participants for each training program
SELECT 
    t.`Training Program Name`,
    t.TOTAL_Participants,
    ROUND((t.TOTAL_Participants / e.TOTAL_EMPLOYEES) * 100, 2) AS Percentage_of_Total
FROM 
    TrainingProgramCounts t
JOIN 
    TotalEmployees e
ORDER BY 
    Percentage_of_Total DESC;

 -- Identify the training programs with the highest success rate
 SELECT `Training Program Name`, 
       ROUND(COUNT(CASE WHEN `Training Outcome` = 'Passed'  THEN 1 END) * 100.0 / COUNT(*),0) AS Success_Rate
FROM cleand
GROUP BY `Training Program Name`
ORDER BY Success_Rate DESC;     
        
        
-- Evaluate if the company should redirect investment from internal to external training based on training outcomes and costs
SELECT 
    `Training Type`,
    `Training Outcome`,
    ROUND(SUM(`Training Cost`), 0) AS TOTAL_COST
FROM 
    cleand
WHERE 
    EmployeeStatus = 'Active' AND `Training Outcome` = 'Passed' AND TerminationType = 'Unk'
GROUP BY 
    `Training Type`, 
    `Training Outcome`
ORDER BY
     TOTAL_COST DESC;
 
 -- Evaluate internal & external training based on training outcomes and costs of former employees results 
SELECT 
    `Training Type`,
    `Training Outcome`,
    ROUND(SUM(`Training Cost`), 0) AS TOTAL_COST
FROM 
    cleand
WHERE 
    `Training Outcome` = 'Failed' AND TerminationType <> 'Unk'
GROUP BY 
    `Training Type`, 
    `Training Outcome`
ORDER BY
     TOTAL_COST DESC;

   
-- calculate the number of employees passing the training program and the percentage of these employees with an above-average Current Employee Rating
-- Define the CTE to calculate the average rating
WITH AvgRating AS (
    SELECT 
        AVG(`Current Employee Rating`) AS Avg_Rating
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active' AND TerminationType = 'Unk'
),
PassedTraining AS (
    SELECT 
        `Training Program Name`,
        COUNT(*) AS TOTAL_Participants
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active' 
        AND `Training Outcome` = 'Passed' AND TerminationType = 'Unk'
    GROUP BY 
        `Training Program Name`
),
AboveAverage AS (
    SELECT 
        `Training Program Name`,
        COUNT(*) AS Num_Above_Avg
    FROM 
        cleand c
    JOIN 
        AvgRating ar ON c.`Current Employee Rating` > ar.Avg_Rating
    WHERE 
        c.EmployeeStatus = 'Active' 
        AND `Training Outcome` = 'Passed' AND TerminationType = 'Unk'
    GROUP BY 
        `Training Program Name`
)
-- Calculate the number and percentage of employees passing the training program with above-average ratings
SELECT 
    p.`Training Program Name`,
    p.TOTAL_Participants,
    a.Num_Above_Avg,
    ROUND((a.Num_Above_Avg / p.TOTAL_Participants) * 100, 2) AS Percentage_Above_Avg
FROM 
    PassedTraining p
JOIN 
    AboveAverage a ON p.`Training Program Name` = a.`Training Program Name`
ORDER BY 
    Percentage_Above_Avg DESC;
 
 
-- Hiring trend for top rating currently active employees Per Years
SELECT 
    YEAR(StartDate) AS Hire_Year,
    COUNT(*) AS Num_Hires
FROM 
    cleand
WHERE 
    `Current Employee Rating` = 5 AND EmployeeStatus = 'Active'  AND TerminationType = 'Unk'
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
        EmployeeStatus = 'Active' AND TerminationType = 'Unk'
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


-- Total cost & percent for in Training (passed training - complete training - incomplete training )  Active Employees per states
-- Define the CTE to calculate the total training cost
WITH TotalTrainingCost AS (
    SELECT 
        SUM(`Training Cost`) AS TotalCost
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active' AND TerminationType = 'Unk' AND `Training Outcome` = 'Passed' OR `Training Outcome` = 'Completed' OR `Training Outcome` = 'Incomplete'
),
StateTrainingCost AS (
    SELECT 
        State,
        ROUND(SUM(`Training Cost`), 0) AS TotalCostPerState
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active' AND TerminationType = 'Unk' AND `Training Outcome` = 'Passed' OR `Training Outcome` = 'Completed' OR `Training Outcome` = 'Incomplete'
    GROUP BY 
        State
)
-- Calculate the percentage of training cost for each state
SELECT 
    s.State,
    s.TotalCostPerState,
    ROUND((s.TotalCostPerState / t.TotalCost) * 100, 2) AS Percentage
FROM 
    StateTrainingCost s, TotalTrainingCost t
ORDER BY 
    Percentage DESC;

    
-- calculates the total training cost for failed active employees per state
-- Define the CTE to calculate the total cost of training for all failed active employees
WITH TotalFailedTrainingCost AS (
    SELECT 
        ROUND(SUM(`Training Cost`), 0) AS Grand_Total_Cost
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active' 
        AND `Training Outcome` = 'Failed' 
        AND TerminationType = 'Unk'
),
StateTrainingCost AS (
    SELECT 
        State,
        ROUND(SUM(`Training Cost`), 0) AS TOTAL_COST
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active' 
        AND `Training Outcome` = 'Failed' 
        AND TerminationType = 'Unk'
    GROUP BY 
        State
)
-- Calculate the total cost and percentage of total cost per state
SELECT 
    s.State,
    s.TOTAL_COST,
    ROUND((s.TOTAL_COST / t.Grand_Total_Cost) * 100, 2) AS Percentage_of_Total_Cost
FROM 
    StateTrainingCost s
JOIN 
    TotalFailedTrainingCost t ON 1=1
ORDER BY 
    s.TOTAL_COST DESC;




 -- turnover rate in failed employees  
-- Define the CTE to calculate total employees who failed the training
WITH FailedTraining AS (
    SELECT 
        COUNT(*) AS TOTAL_FAILED
    FROM 
        cleand
    WHERE 
        `Training Outcome` = 'Failed' 
),
TurnoverFailedTraining AS (
    SELECT 
        COUNT(*) AS TOTAL_LEFT
    FROM 
        cleand
    WHERE 
        `Training Outcome` = 'Failed' 
        AND EmployeeStatus <> 'Active' AND TerminationType <> 'Unk'
)
-- Calculate the turnover rate
SELECT 
    f.TOTAL_FAILED,
    t.TOTAL_LEFT,
    ROUND((t.TOTAL_LEFT / f.TOTAL_FAILED) * 100, 2) AS Turnover_Rate
FROM 
    FailedTraining f, TurnoverFailedTraining t;
   
  

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
WHERE EmployeeStatus = 'Active' AND TerminationType = 'Unk' AND `Current Employee Rating` BETWEEN 4 AND 5 
GROUP BY Age 
ORDER BY TOTAL_COUNT DESC;



-- age buckets and percent
-- Define the CTE to calculate the total sum of employees
WITH TotalEmployees AS (
    SELECT COUNT(*) AS TOTAL_SUM
    FROM cleand
    WHERE EmployeeStatus = 'Active' AND TerminationType = 'Unk' AND `Current Employee Rating` BETWEEN 4 AND 5
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
        EmployeeStatus = 'Active' AND TerminationType = 'Unk'
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


-- Number of employees in each division 
-- Define the CTE to calculate the total number of active employees
WITH TotalEmployees AS (
    SELECT 
        COUNT(*) AS TOTAL_SUM
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active' AND TerminationType = 'Unk'
),
DivisionCounts AS (
    SELECT 
        Division,
        COUNT(*) AS TOTAL_COUNT
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active' AND TerminationType = 'Unk'
    GROUP BY 
        Division
)
-- Calculate the percentage of employees in each division
SELECT 
    d.Division,
    d.TOTAL_COUNT,
    ROUND((d.TOTAL_COUNT / t.TOTAL_SUM) * 100, 2) AS PERCENTAGE
FROM 
    DivisionCounts d
JOIN 
    TotalEmployees t
ORDER BY 
    d.TOTAL_COUNT DESC;


-- percent of Top Rated Employees for each division with age bucket 
-- Define the CTE to calculate the total sum of employees in each division
WITH TotalEmployees AS (
    SELECT 
        Division,
        COUNT(*) AS TOTAL_SUM
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active' AND  TerminationType = 'Unk' AND `Current Employee Rating` BETWEEN 4 AND 5
    GROUP BY 
        Division
),
AgeBuckets AS (
    SELECT 
        Division,
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
        EmployeeStatus = 'Active' AND TerminationType = 'Unk'
        AND `Current Employee Rating` BETWEEN 4 AND 5
    GROUP BY 
        Division, AGE_BUCKET
)
-- Calculate the percentage of each age bucket within each division
SELECT 
    a.Division,
    a.AGE_BUCKET,
    a.TOTAL_COUNT,
    ROUND((a.TOTAL_COUNT / t.TOTAL_SUM) * 100, 2) AS PERCENTAGE
FROM 
    AgeBuckets a
JOIN 
    TotalEmployees t ON a.Division = t.Division
ORDER BY 
    a.Division, PERCENTAGE DESC;


-- Calculate the average ratings for each division
WITH AvgRatings AS (
    SELECT 
        Division,
        AVG(`Current Employee Rating`) AS Avg_Current_Employee_Rating,
        AVG(`Engagement Score`) AS Avg_Engagement_Score,
        AVG(`Satisfaction Score`) AS Avg_Satisfaction_Score,
        AVG(`Work-Life Balance Score`) AS Avg_Work_Life_Balance_Score
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active'
    GROUP BY 
        Division
)
-- Calculate the total average of the average ratings
SELECT 
    Division,
    Avg_Current_Employee_Rating,
    Avg_Engagement_Score,
    Avg_Satisfaction_Score,
    Avg_Work_Life_Balance_Score,
    (Avg_Current_Employee_Rating + Avg_Engagement_Score + Avg_Satisfaction_Score + Avg_Work_Life_Balance_Score) / 4 AS TOTAL_AVG
FROM 
    AvgRatings
ORDER BY 
    TOTAL_AVG DESC;


-- EMPLOYEES ABOVE THE AVERAE 
-- Define the CTE to calculate the average rating
WITH AvgRating AS (
    SELECT 
        AVG(`Current Employee Rating`) AS Avg_Rating
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active' AND TerminationType = 'Unk'
),
DivisionCounts AS (
    SELECT 
        Division,
        COUNT(*) AS TOTAL_COUNT
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active' AND TerminationType = 'Unk'
    GROUP BY 
        Division
),
DivisionAboveAvg AS (
    SELECT 
        c.Division,
        COUNT(*) AS Num_Employees_Above_Average
    FROM 
        cleand c
    JOIN 
        AvgRating ar ON c.`Current Employee Rating` > ar.Avg_Rating
    WHERE 
        c.EmployeeStatus = 'Active' AND TerminationType = 'Unk'
    GROUP BY 
        c.Division
)
-- Calculate the number and percentage of employees in each division with a rating above the average
SELECT 
    d.Division,
    d.Num_Employees_Above_Average,
    ROUND((d.Num_Employees_Above_Average / dc.TOTAL_COUNT) * 100, 2) AS Percentage_Above_Average
FROM 
    DivisionAboveAvg d
JOIN 
    DivisionCounts dc ON d.Division = dc.Division
ORDER BY 
    Percentage_Above_Average DESC;
    
-- Years of experience in the company and rating
SELECT 
    FLOOR(DATEDIFF(CURDATE(), StartDate) / 365) AS Y_EXPERIENCE,
    COUNT(*) AS TOTAL_COUNT,
    AVG(`Current Employee Rating`) AS AVG_RATING
FROM 
    cleand
WHERE 
    EmployeeStatus = 'Active' AND TerminationType = 'Unk'
GROUP BY 
    Y_EXPERIENCE
ORDER BY AVG_RATING DESC;

-- Years of experience in the company and satisfaction score
SELECT 
    FLOOR(DATEDIFF(CURDATE(), StartDate) / 365) AS Y_EXPERIENCE,
    COUNT(*) AS TOTAL_COUNT,
    AVG(`Satisfaction Score`) AS AVG_SAT_RATING
FROM 
    cleand
WHERE 
    EmployeeStatus = 'Active' AND TerminationType = 'Unk'
GROUP BY 
    Y_EXPERIENCE
ORDER BY AVG_SAT_RATING DESC;

-- employee type and satisfaction score
SELECT 
    `EmployeeType`,
    AVG(`Satisfaction Score`) AS AVG_SAT_RATING
FROM 
    cleand
WHERE 
    EmployeeStatus = 'Active' AND TerminationType = 'Unk'
GROUP BY 
    `EmployeeType`
ORDER BY AVG_SAT_RATING DESC;

 
-- Calculate the number of active employees per title
-- Define the CTE to calculate the total number of active employees
WITH TotalActiveEmployees AS (
    SELECT 
        COUNT(*) AS TOTAL_ACTIVE
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active' AND TerminationType = 'Unk'
),
TitleActiveEmployees AS (
    SELECT 
        Title,
        COUNT(*) AS Num_Active_Employees
    FROM 
        cleand
    WHERE 
        EmployeeStatus = 'Active' AND TerminationType = 'Unk'
    GROUP BY 
        Title
)
-- Calculate the percentage of active employees for each title
SELECT 
    t.Title,
    t.Num_Active_Employees,
    ROUND((t.Num_Active_Employees / e.TOTAL_ACTIVE) * 100, 2) AS Percentage_of_Total
FROM 
    TitleActiveEmployees t
JOIN 
    TotalActiveEmployees e
ORDER BY 
    Percentage_of_Total DESC;
    
-- turnover per title    
-- Define the CTE to calculate the total number of employees per title
WITH TotalPerTitle AS (
    SELECT 
        Title,
        COUNT(*) AS Total_Per_Title
    FROM 
        cleand
    GROUP BY 
        Title
),
LeftPerTitle AS (
    SELECT 
        Title,
        COUNT(*) AS Total_Left
    FROM 
        cleand
    WHERE 
        EmployeeStatus <> 'Active' AND TerminationType <> 'Unk'
    GROUP BY 
        Title
)
-- Calculate the turnover rate per title
SELECT 
    t.Title,
    t.Total_Per_Title,
    l.Total_Left,
    ROUND((l.Total_Left / t.Total_Per_Title) * 100, 2) AS Turnover_Rate
FROM 
    TotalPerTitle t
JOIN 
    LeftPerTitle l ON t.Title = l.Title
ORDER BY 
    Turnover_Rate DESC;

