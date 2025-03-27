-- Drop the database if it exists
IF DB_ID('CareerHub') IS NOT NULL
    DROP DATABASE CareerHub;
GO
CREATE DATABASE CareerHub;
GO
USE CareerHub;

-- Insert into Companies
INSERT INTO Companies (CompanyName, Location)
VALUES 
('TechNova', 'Bangalore'),
('InnoWare', 'Hyderabad'),
('SoftVision', 'Chennai'),
('CloudCore', 'CityX'),
('NextG Solutions', 'Pune');

-- Insert into Jobs
INSERT INTO Jobs (CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType)
VALUES
(1, 'Java Developer', 'Work with Spring Boot', 'Bangalore', 70000, 'Full-time'),
(2, 'Frontend Engineer', 'ReactJS and UI development', 'Hyderabad', 75000, 'Full-time'),
(3, 'System Analyst', 'System level analysis and documentation', 'Chennai', 65000, 'Contract'),
(4, 'Data Engineer', 'Big Data and ETL pipelines', 'CityX', 0, 'Internship'),
(1, 'Backend Developer', 'Java + SQL backend', 'Bangalore', 90000, 'Full-time'),
(5, 'QA Tester', 'Manual and Automation Testing', 'Pune', 50000, 'Part-time'),
(4, 'DevOps Engineer', 'CI/CD pipelines and cloud ops', 'CityX', 85000, 'Full-time');

-- Insert into Applicants
INSERT INTO Applicants (FirstName, LastName, Email, Phone, Resume, ExperienceYears, City, State)
VALUES 
('Ravi', 'Kumar', 'ravi.kumar@gmail.com', '9876543210', 'Experienced Java Dev', 4, 'Delhi', 'Delhi'),
('Anjali', 'Mehta', 'anjali.m@gmail.com', '8765432109', 'Frontend enthusiast', 2, 'Chennai', 'Tamil Nadu'),
('Amit', 'Roy', 'amit.roy@yahoo.com', '7654321098', 'Analyst with 3 years exp', 3, 'Mumbai', 'Maharashtra'),
('Sneha', 'Kapoor', 'sneha.k@gmail.com', '6543210987', 'Big data specialist', 5, 'CityX', 'StateX'),
('John', 'Dsouza', 'john.d@gmail.com', '5432109876', 'Fresher in QA', 1, 'Bangalore', 'Karnataka');

-- Insert into Applications
INSERT INTO Applications (JobID, ApplicantID, ApplicationDate, CoverLetter)
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

-- Check Companies
SELECT * FROM Companies;

-- Check Jobs
SELECT * FROM Jobs;

-- Check Applicants
SELECT * FROM Applicants;

-- Check Applications
SELECT * FROM Applications;


--5. Count applications per job (include jobs with zero applications)

SELECT j.JobTitle, COUNT(a.ApplicationID) AS ApplicationCount
FROM Jobs j
LEFT JOIN Applications a ON j.JobID = a.JobID
GROUP BY j.JobTitle;


SELECT 
    JobTitle,
    (
        SELECT COUNT(*) 
        FROM Applications a 
        WHERE a.JobID = j.JobID
    ) AS ApplicationCount
FROM Jobs j;


--6. Jobs in specified salary range

DECLARE @MinSalary DECIMAL(18,2) = 50000;
DECLARE @MaxSalary DECIMAL(18,2) = 100000;
/*SELECT j.JobTitle, c.CompanyName, j.JobLocation, j.Salary
FROM Jobs j
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE j.Salary BETWEEN @MinSalary AND @MaxSalary;*/

SELECT 
    JobTitle,
    (SELECT CompanyName FROM Companies c WHERE c.CompanyID = j.CompanyID) AS CompanyName,
    JobLocation,
    Salary
FROM Jobs j
WHERE Salary BETWEEN @MinSalary AND @MaxSalary;

--7. Application history for a specific applicant

DECLARE @ApplicantID INT = 1;

SELECT j.JobTitle, c.CompanyName, a.ApplicationDate
FROM Applications a
JOIN Jobs j ON a.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE a.ApplicantID = @ApplicantID;


--8. Average salary excluding zero salaries

SELECT AVG(Salary) AS AverageSalary
FROM Jobs
WHERE Salary > 0;

--9. Company with most job listings (handle ties)

WITH JobCounts AS 
(SELECT CompanyID, COUNT(*) AS JobCount
    FROM Jobs
    GROUP BY CompanyID
	)
SELECT c.CompanyName, jc.JobCount
FROM JobCounts jc
JOIN Companies c ON jc.CompanyID = c.CompanyID
WHERE jc.JobCount = (
    SELECT MAX(JobCount) FROM JobCounts
);

--10. Applicants in 'CityX' with ≥3 years experience

SELECT *
FROM Applicants 
WHERE ExperienceYears >= 3 AND City = 'CityX';


--11. Distinct job titles with salary between $60k–$80k

SELECT DISTINCT JobTitle
FROM Jobs
WHERE Salary BETWEEN 60000 AND 80000;

--12. Jobs with no applications

SELECT j.*
FROM Jobs j
LEFT JOIN Applications a ON j.JobID = a.JobID
WHERE a.ApplicationID IS NULL;

--13. Applicants and the companies/positions they applied for

SELECT a.FirstName, a.LastName, c.CompanyName, j.JobTitle
FROM Applications ap
JOIN Applicants a ON ap.ApplicantID = a.ApplicantID
JOIN Jobs j ON ap.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID;

--14. Companies with job count, even if no applications

SELECT c.CompanyName, COUNT(j.JobID) AS JobCount
FROM Companies c
LEFT JOIN Jobs j ON c.CompanyID = j.CompanyID
GROUP BY c.CompanyName;

--15. Applicants and jobs/companies they've applied to (include non-applicants)

SELECT a.FirstName, a.LastName, c.CompanyName, j.JobTitle
FROM Applicants a
LEFT JOIN Applications ap ON a.ApplicantID = ap.ApplicantID
LEFT JOIN Jobs j ON ap.JobID = j.JobID
LEFT JOIN Companies c ON j.CompanyID = c.CompanyID;

--16. Companies with jobs above average salary

SELECT DISTINCT c.CompanyName
FROM Jobs j
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE j.Salary > (SELECT AVG(Salary) FROM Jobs WHERE Salary > 0);

--17. Applicants with concatenated city and state

SELECT FirstName, LastName, City + ', ' + State AS Location
FROM Applicants;

--18. Jobs with title containing 'Developer' or 'Engineer'

SELECT *
FROM Jobs
WHERE JobTitle LIKE '%Developer%' OR JobTitle LIKE '%Engineer%';

--19. Applicants and the jobs they applied for (include unmatched)

SELECT a.FirstName, a.LastName, j.JobTitle
FROM Applicants a
FULL OUTER JOIN Applications ap ON a.ApplicantID = ap.ApplicantID
FULL OUTER JOIN Jobs j ON ap.JobID = j.JobID;

--20. All applicant–company combinations (City='Chennai', experience > 2)

SELECT a.FirstName, a.LastName, c.CompanyName
FROM Applicants a
CROSS JOIN Companies c
WHERE c.Location = 'Chennai' AND a.ExperienceYears > 2;