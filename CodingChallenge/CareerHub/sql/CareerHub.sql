CREATE DATABASE CareerHubDB;

USE CareerHubDB;

CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY,
    CompanyName VARCHAR(100),
    Location VARCHAR(100)
);

CREATE TABLE JobListings (
    JobID INT PRIMARY KEY,
    CompanyID INT,
    JobTitle VARCHAR(100),
    JobDescription TEXT,
    JobLocation VARCHAR(100),
    Salary DECIMAL,
    JobType VARCHAR(50),
    PostedDate DATETIME,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

CREATE TABLE Applicants (
    ApplicantID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Resume VARCHAR(255)
);

CREATE TABLE Applications (
    ApplicationID INT PRIMARY KEY,
    JobID INT,
    ApplicantID INT,
    ApplicationDate DATETIME,
    CoverLetter TEXT,
    FOREIGN KEY (JobID) REFERENCES JobListings(JobID),
    FOREIGN KEY (ApplicantID) REFERENCES Applicants(ApplicantID)
);

select * from Companies;
select * from Applicants;
select * from JobListings;
select * from Applications;

INSERT INTO Companies (CompanyID, CompanyName, Location) VALUES
(2, 'Tata Consultancy Services', 'Mumbai'),
(3, 'Infosys', 'Bangalore'),
(4, 'Wipro', 'Hyderabad'),
(5, 'HCL Technologies', 'Noida'),
(6, 'Tech Mahindra', 'Pune'),
(7, 'Capgemini', 'Chennai'),
(8, 'Accenture', 'Bangalore'),
(9, 'IBM India', 'Kolkata'),
(10, 'Cognizant', 'Coimbatore'),
(11, 'Hexaware Technologies', 'Navi Mumbai');

INSERT INTO JobListings (JobID, CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType, PostedDate) VALUES
(3, 3, 'Data Analyst', 'Analyze business data trends.', 'Bangalore', 550000, 'Part-time', GETDATE()),
(4, 4, 'System Administrator', 'Maintain internal systems and networks.', 'Hyderabad', 600000, 'Full-time', GETDATE()),
(5, 5, 'Cloud Engineer', 'Deploy and manage cloud services.', 'Noida', 750000, 'Contract', GETDATE()),
(6, 6, 'Front-End Developer', 'Build responsive UI components.', 'Pune', 680000, 'Full-time', GETDATE()),
(7, 7, 'Java Developer', 'Develop backend applications using Java.', 'Chennai', 700000, 'Full-time', GETDATE()),
(8, 8, 'Project Manager', 'Manage software project timelines.', 'Bangalore', 900000, 'Full-time', GETDATE()),
(9, 9, 'AI/ML Engineer', 'Develop AI models for automation.', 'Kolkata', 950000, 'Full-time', GETDATE()),
(10, 10, 'QA Tester', 'Ensure application quality and performance.', 'Coimbatore', 500000, 'Part-time', GETDATE()),
(11, 11, 'DevOps Engineer', 'CI/CD pipeline and server maintenance.', 'Navi Mumbai', 800000, 'Full-time', GETDATE());

DELETE FROM JobListings
WHERE JobID = 2;
