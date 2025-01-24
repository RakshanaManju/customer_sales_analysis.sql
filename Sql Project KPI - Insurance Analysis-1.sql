#Start of the project 
#creation of database
CREATE DATABASE raw_data_db;
USE raw_data_db;

#Create a table to store the raw data
CREATE TABLE Rawdata (
    Branch VARCHAR(255),
    Account_Exe_ID INT, -- Verify this column name
    Employee_Name VARCHAR(255),
    New_Role2 VARCHAR(255),
    New_Budget FLOAT,
    Cross_Sell_Budget FLOAT,
    Renewal_Budget FLOAT
);

#Insert first 5 rows
INSERT INTO Rawdata (Branch, Account_Exe_ID, Employee_Name, New_Role2, New_Budget, Cross_Sell_Budget, Renewal_Budget)
VALUES
    ('Ahmedabad', 1, 'Vinay', 'Hunter & Farmer', 12788092, 250000, 1500000),
    ('Ahmedabad', 2, 'Abhinav Shivam', 'Servicer', 129902, 129000, 1289000),
    ('Ahmedabad', 3, 'Animesh Rawat', 'Servicer', 1278023, 12365300, 12900),
    ('Ahmedabad', 4, 'Gilbert', 'BH', 1000000, 500000, 1010000),
    ('Ahmedabad', 5, 'Juli', 'Hunter & Farmer', 1250000, 3500000, 750000);

#Insert next 5 rows
INSERT INTO Rawdata (Branch, Account_Exe_ID, Employee_Name, New_Role2, New_Budget, Cross_Sell_Budget, Renewal_Budget)
VALUES
    ('Ahmedabad', 6, 'Ketan Jain', 'Hunter & Farmer', 500000, 1250000, 500000),
    ('Ahmedabad', 7, 'Manish Sharma', 'Hunter & Farmer', 1350000, 750000, 750000),
    ('Ahmedabad', 8, 'Mark', 'Servicer', 19888, 128777, 198882),
    ('Ahmedabad', 9, 'Vidit Shah', 'Farmer & Servicer', 12888, 1040000, 5010000),
    ('Ahmedabad', 10, 'Kumar Jha', 'Servicer Claims', 1345000, 170034, 1298673);

#Display the table 
SELECT * FROM Rawdata;

#Sum of values and union of fields
SELECT 
    'Target' AS k,
    SUM(Cross_Sell_Budget) AS `Cross sell`,
    SUM(New_Budget) AS `New`,
    SUM(Renewal_Budget) AS `Renewal`
FROM Rawdata
UNION ALL
SELECT 
    'Achieved' AS k,
    SUM(Cross_Sell_Budget) * (13041253.3 / 19673793) AS `Cross sell`, -- Example scaling factor
    SUM(New_Budget) * (3531629 / 20083111) AS `New`,                 -- Example scaling factor
    SUM(Renewal_Budget) * (18507270.6 / 12319455) AS `Renewal`       -- Example scaling factor
FROM Rawdata
UNION ALL
SELECT 
    'Invoice' AS k,
    SUM(Cross_Sell_Budget) * (2853842 / 19673793) AS `Cross sell`,   -- Example scaling factor
    SUM(New_Budget) * (569815 / 20083111) AS `New`,                 -- Example scaling factor
    SUM(Renewal_Budget) * (8244310 / 12319455) AS `Renewal`         -- Example scaling factor
FROM Rawdata;

#KPI - 1 CROSS SELL PLACED ACHIEVEMENT
-- Calculate Cross sell Achvmnt% (Achieved / Target) as a percentage
SELECT 
    CONCAT(ROUND(((SUM(Cross_Sell_Budget) * (13041253.3 / 19673793)) / SUM(Cross_Sell_Budget)) * 100, 2), '%') AS `Cross sell Achvmnt%`
FROM Rawdata;

#KPI - 2 CROSS SELL INVOICE ACHIEVEMENT
-- Calculate Cross sell Invoice Achvmnt% (Invoice / Target) as a percentage
SELECT 
    CONCAT(ROUND(((SUM(Cross_Sell_Budget) * (2853842 / 19673793)) / SUM(Cross_Sell_Budget)) * 100, 2), '%') AS `Cross sell Invoice Achvmnt%`
FROM Rawdata;


#KPI 3 - NEW PLACED ACHIEVEMENT
-- Calculate New Achvmnt% (Achieved / Target) as a percentage
SELECT 
    CONCAT(ROUND(((SUM(New_Budget) * (3531629 / 20083111)) / SUM(New_Budget)) * 100, 2), '%') AS `New Achvmnt%`
FROM Rawdata;

#KPI 4 - NEW INVOICE ACHIEVEMENT
-- Calculate New Invoice Achvmnt% (Invoice / Target) as a percentage
SELECT 
    CONCAT(ROUND(((SUM(New_Budget) * (569815 / 20083111)) / SUM(New_Budget)) * 100, 2), '%') AS `New Invoice Achvmnt%`
FROM Rawdata;

#KPI 5 - RENEWAL PLACED ACHIEVEMENT
-- Calculate Renewal Achvmnt% (Achieved / Target) as a percentage
SELECT 
    CONCAT(ROUND(((SUM(Renewal_Budget) * (18507270.6 / 12319455)) / SUM(Renewal_Budget)) * 100, 2), '%') AS `Renewal Achvmnt%`
FROM Rawdata;

#KPI 6 - RENEWAL INVOICE ACHIEVEMENT
-- Calculate Renewal Invoice Achvmnt% (Invoice / Target) as a percentage
SELECT 
    CONCAT(ROUND(((SUM(Renewal_Budget) * (8244310 / 12319455)) / SUM(Renewal_Budget)) * 100, 2), '%') AS `Renewal Invoice Achvmnt%`
FROM Rawdata;


#KPI 7 - NO-of-meetings
#Creating table for no.of meeting KPI 
CREATE TABLE meeting1 (
    Account_Exe_ID INT,
    Account_Executive VARCHAR(255),
    Branch_Name VARCHAR(255),
    Global_Attendees VARCHAR(255),
    Meeting_Date DATE
);

#Import table Meeting1 by using table wizard 
#Checking the data
SHOW TABLES IN raw_data_db;
DESCRIBE meeting1;

#Modying the data to fit the datatype corrcetly
ALTER TABLE meeting1
MODIFY Account_Exe_ID INT,
MODIFY Account_Executive VARCHAR(255),
MODIFY branch_name VARCHAR(255),
MODIFY global_attendees VARCHAR(255),
MODIFY meeting_date DATE;

#Displaying the imported data
SELECT * FROM raw_data_db.meeting1;

#Count Meetings in 2019:
SELECT COUNT(*) AS meetings_2019
FROM raw_data_db.meeting1
WHERE YEAR(meeting_date) = 2019;

#Count Meetings in 2020:
SELECT COUNT(*) AS meetings_2020
FROM raw_data_db.meeting1
WHERE YEAR(meeting_date) = 2020;

#Combination of both
SELECT 
    YEAR(meeting_date) AS year,
    COUNT(*) AS total_meetings
FROM raw_data_db.meeting1
WHERE YEAR(meeting_date) IN (2019, 2020)
GROUP BY YEAR(meeting_date);


#KPI 8 - NO-OF-INVOICES
#No.of.Invoices by Account Executives
#Create a table
CREATE TABLE invoice_data (
    invoice_number BIGINT PRIMARY KEY,
    account_executive VARCHAR(255),
    income_class VARCHAR(255),
    amount DECIMAL(15, 2)
);

#The data file has been imported 
-- Combined query to count invoices per executive and include overall totals
SELECT 
    account_executive,
    SUM(CASE WHEN income_class = 'Cross Sell' THEN 1 ELSE 0 END) AS cross_sell_count,
    SUM(CASE WHEN income_class = 'New' THEN 1 ELSE 0 END) AS new_count,
    SUM(CASE WHEN income_class = 'Renewal' THEN 1 ELSE 0 END) AS renewal_count,
    COUNT(invoice_number) AS grand_total
FROM 
    raw_data_db.invoice_data
GROUP BY 
    account_executive
WITH ROLLUP;

#KPI 9 - NO-of_Meetings per Exceutives
#Creation of table
CREATE TABLE meeting_data (
    account_exe_id INT,
    account_executive VARCHAR(255),
    meeting_date DATE
);

-- Query to calculate the count of meetings per executive
SELECT 
    account_executive,
    COUNT(meeting_date) AS meeting_count
FROM 
    raw_data_db.meeting_data
GROUP BY 
    account_executive;
    
    
#KPI 10 - REVENUE FUNNEL
#Table creation
CREATE TABLE revenue_data (
    stage VARCHAR(255),
    revenue_amount DECIMAL(15, 2),
    premium_amount DECIMAL(15, 2)
);

-- Query to calculate the sum of revenue and premium amounts by stage
SELECT 
    stage,
    SUM(revenue_amount) AS total_revenue
FROM 
    raw_data_db.revenue
GROUP BY 
    stage;

#KPI 11 - TOP 4 OPPORTUNITIES
CREATE TABLE top_opportunity_data (
    revenue_amount DECIMAL(15, 2),
    opportunity_name VARCHAR(255)
);
-- Query to calculate the top 4 opportunities by revenue
SELECT 
    opportunity_name, 
    revenue_amount
FROM 
    raw_data_db.top_opportunity_data
ORDER BY 
    revenue_amount DESC
LIMIT 4;