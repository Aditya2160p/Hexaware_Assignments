-- Drop the database if it exists
IF DB_ID('CareerHub') IS NOT NULL
    DROP DATABASE CareerHub;
GO
CREATE DATABASE CareerHub;
GO
USE CareerHub;

-- Create Schema
CREATE SCHEMA CareerHubSchema;
GO

-- Create Companies Table
CREATE TABLE CareerHubSchema.Companies (
    CompanyID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyName VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL
);
GO

-- Create Jobs Table
CREATE TABLE CareerHubSchema.Jobs (
    JobID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyID INT FOREIGN KEY REFERENCES CareerHubSchema.Companies(CompanyID) ON DELETE CASCADE,
    JobTitle VARCHAR(100) NOT NULL,
    JobDescription TEXT NOT NULL,
    JobLocation VARCHAR(100) NOT NULL,
    Salary INT NOT NULL CHECK (Salary >= 0),
    JobType VARCHAR(50) NOT NULL
);
GO

-- Create Applicants Table
CREATE TABLE CareerHubSchema.Applicants (
    ApplicantID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    Resume TEXT NOT NULL,
    ExperienceYears INT CHECK (ExperienceYears >= 0),
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL
);
GO

-- Create Applications Table
CREATE TABLE CareerHubSchema.Applications (
    ApplicationID INT IDENTITY(1,1) PRIMARY KEY,
    JobID INT FOREIGN KEY REFERENCES CareerHubSchema.Jobs(JobID) ON DELETE CASCADE,
    ApplicantID INT FOREIGN KEY REFERENCES CareerHubSchema.Applicants(ApplicantID) ON DELETE CASCADE,
    ApplicationDate DATE NOT NULL,
    CoverLetter TEXT NOT NULL
);
GO

-- Insert into Companies
INSERT INTO CareerHubSchema.Companies (CompanyName, Location)
VALUES 
('TechNova', 'Bangalore'),
('InnoWare', 'Hyderabad'),
('SoftVision', 'Chennai'),
('CloudCore', 'CityX'),
('NextG Solutions', 'Pune');
GO

-- Insert into Jobs
INSERT INTO CareerHubSchema.Jobs (CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType)
VALUES
(1, 'Java Developer', 'Work with Spring Boot', 'Bangalore', 70000, 'Full-time'),
(2, 'Frontend Engineer', 'ReactJS and UI development', 'Hyderabad', 75000, 'Full-time'),
(3, 'System Analyst', 'System level analysis and documentation', 'Chennai', 65000, 'Contract'),
(4, 'Data Engineer', 'Big Data and ETL pipelines', 'CityX', 0, 'Internship'),
(1, 'Backend Developer', 'Java + SQL backend', 'Bangalore', 90000, 'Full-time'),
(5, 'QA Tester', 'Manual and Automation Testing', 'Pune', 50000, 'Part-time'),
(4, 'DevOps Engineer', 'CI/CD pipelines and cloud ops', 'CityX', 85000, 'Full-time');
GO

-- Insert into Applicants
INSERT INTO CareerHubSchema.Applicants (FirstName, LastName, Email, Phone, Resume, ExperienceYears, City, State)
VALUES 
('Ravi', 'Kumar', 'ravi.kumar@gmail.com', '9876543210', 'Experienced Java Dev', 4, 'Delhi', 'Delhi'),
('Anjali', 'Mehta', 'anjali.m@gmail.com', '8765432109', 'Frontend enthusiast', 2, 'Chennai', 'Tamil Nadu'),
('Amit', 'Roy', 'amit.roy@yahoo.com', '7654321098', 'Analyst with 3 years exp', 3, 'Mumbai', 'Maharashtra'),
('Sneha', 'Kapoor', 'sneha.k@gmail.com', '6543210987', 'Big data specialist', 5, 'CityX', 'StateX'),
('John', 'Dsouza', 'john.d@gmail.com', '5432109876', 'Fresher in QA', 1, 'Bangalore', 'Karnataka');
GO

-- Insert into Applications
INSERT INTO CareerHubSchema.Applications (JobID, ApplicantID, ApplicationDate, CoverLetter)
VALUES 
(1, 1, '2024-03-01', 'Looking forward to this opportunity.'),
(5, 1, '2024-03-05', 'Excited to join backend team.'),
(2, 2, '2024-03-02', 'Passionate about frontend work.'),
(3, 3, '2024-03-06', 'Analyst role fits my profile.'),
(4, 4, '2024-03-03', 'Interested in data engineering intern.'),
(7, 4, '2024-03-04', 'Great fit for DevOps responsibilities.'),
(7, 1, '2024-03-07', 'Flexible with relocation.'),
(5, 3, '2024-03-08', 'Strong experience in backend systems.'),
(6, 2, '2024-03-09', 'Willing to learn more in QA.');
GO

-- Select Queries
SELECT * FROM CareerHubSchema.Companies;
SELECT * FROM CareerHubSchema.Jobs;
SELECT * FROM CareerHubSchema.Applicants;
SELECT * FROM CareerHubSchema.Applications;

-- 5. Count applications per job (include jobs with zero applications)
SELECT j.JobTitle, COUNT(a.ApplicationID) AS ApplicationCount
FROM CareerHubSchema.Jobs j
LEFT JOIN CareerHubSchema.Applications a ON j.JobID = a.JobID
GROUP BY j.JobTitle;

SELECT 
    JobTitle,
    (
        SELECT COUNT(*) 
        FROM CareerHubSchema.Applications a 
        WHERE a.JobID = j.JobID
    ) AS ApplicationCount
FROM CareerHubSchema.Jobs j;

-- 6. Jobs in specified salary range
DECLARE @MinSalary DECIMAL(18,2) = 50000;
DECLARE @MaxSalary DECIMAL(18,2) = 100000;

SELECT 
    JobTitle,
    (SELECT CompanyName FROM CareerHubSchema.Companies c WHERE c.CompanyID = j.CompanyID) AS CompanyName,
    JobLocation,
    Salary
FROM CareerHubSchema.Jobs j
WHERE Salary BETWEEN @MinSalary AND @MaxSalary;

-- 7. Application history for a specific applicant
DECLARE @ApplicantID INT = 1;

SELECT j.JobTitle, c.CompanyName, a.ApplicationDate
FROM CareerHubSchema.Applications a
JOIN CareerHubSchema.Jobs j ON a.JobID = j.JobID
JOIN CareerHubSchema.Companies c ON j.CompanyID = c.CompanyID
WHERE a.ApplicantID = @ApplicantID;

-- 8. Average salary excluding zero salaries
SELECT AVG(Salary) AS AverageSalary
FROM CareerHubSchema.Jobs
WHERE Salary > 0;

-- 9. Company with most job listings.
WITH JobCounts AS 
(SELECT CompanyID, COUNT(*) AS JobCount
    FROM CareerHubSchema.Jobs
    GROUP BY CompanyID
)
SELECT c.CompanyName, jc.JobCount
FROM JobCounts jc
JOIN CareerHubSchema.Companies c ON jc.CompanyID = c.CompanyID
WHERE jc.JobCount = (
    SELECT MAX(JobCount) FROM JobCounts
);

-- 10. Applicants in 'CityX' with ≥3 years experience
SELECT *
FROM CareerHubSchema.Applicants 
WHERE ExperienceYears >= 3 AND City = 'CityX';

-- 11. Distinct job titles with salary between $60k–$80k
SELECT DISTINCT JobTitle, Salary
FROM CareerHubSchema.Jobs
WHERE Salary BETWEEN 60000 AND 80000;

-- 12. Jobs with no applications
SELECT j.*
FROM CareerHubSchema.Jobs j
LEFT JOIN CareerHubSchema.Applications a ON j.JobID = a.JobID
WHERE a.ApplicationID IS NULL;

SELECT * FROM CareerHubSchema.Jobs;
SELECT * FROM CareerHubSchema.Applications;
SELECT * FROM CareerHubSchema.Applicants;

-- Insert a new job with schema
INSERT INTO CareerHubSchema.Jobs (CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType)
VALUES (2, 'UI/UX Designer', 'Design interfaces and experiences', 'Hyderabad', 60000, 'Full-time');

-- 13. Applicants and the companies/positions they applied for
SELECT a.FirstName, a.LastName, c.CompanyName, j.JobTitle
FROM CareerHubSchema.Applications ap
JOIN CareerHubSchema.Applicants a ON ap.ApplicantID = a.ApplicantID
JOIN CareerHubSchema.Jobs j ON ap.JobID = j.JobID
JOIN CareerHubSchema.Companies c ON j.CompanyID = c.CompanyID;

-- 14. Companies with job count, even if no applications
SELECT c.CompanyName, COUNT(j.JobID) AS JobCount
FROM CareerHubSchema.Companies c
LEFT JOIN CareerHubSchema.Jobs j ON c.CompanyID = j.CompanyID
GROUP BY c.CompanyName;

-- 15. Applicants and jobs/companies they've applied to (include non-applicants)
SELECT a.FirstName, a.LastName, c.CompanyName, j.JobTitle
FROM CareerHubSchema.Applicants a
LEFT JOIN CareerHubSchema.Applications ap ON a.ApplicantID = ap.ApplicantID
LEFT JOIN CareerHubSchema.Jobs j ON ap.JobID = j.JobID
LEFT JOIN CareerHubSchema.Companies c ON j.CompanyID = c.CompanyID;

-- 16. Companies with jobs above average salary
SELECT DISTINCT c.CompanyName, j.Salary
FROM CareerHubSchema.Jobs j
JOIN CareerHubSchema.Companies c ON j.CompanyID = c.CompanyID
WHERE j.Salary > (SELECT AVG(Salary) FROM CareerHubSchema.Jobs WHERE Salary > 0);

-- 17. Applicants with concatenated city and state
SELECT FirstName, LastName, City + ', ' + State AS Location
FROM CareerHubSchema.Applicants;

-- 18. Jobs with title containing 'Developer' or 'Engineer'
SELECT *
FROM CareerHubSchema.Jobs
WHERE JobTitle LIKE '%Developer%' OR JobTitle LIKE '%Engineer%';

-- 19. Applicants and the jobs they applied for (include unmatched)
SELECT a.FirstName, a.LastName, j.JobTitle
FROM CareerHubSchema.Applicants a
FULL OUTER JOIN CareerHubSchema.Applications ap ON a.ApplicantID = ap.ApplicantID
FULL OUTER JOIN CareerHubSchema.Jobs j ON ap.JobID = j.JobID;

-- 20. All applicant–company combinations (City='Chennai', experience > 2)
SELECT a.FirstName, a.LastName, c.CompanyName
FROM CareerHubSchema.Applicants a
CROSS JOIN CareerHubSchema.Companies c
WHERE c.Location = 'Chennai' AND a.ExperienceYears > 2;
