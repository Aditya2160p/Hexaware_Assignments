/*Task 1. Database Design:  
1. Create the database named "SISDB" 
2. Define the schema for the Students, Courses, Enrollments, Teacher, and Payments tables based 
on the provided schema. Write SQL scripts to create the mentioned tables with appropriate data 
types, constraints, and relationships.  
a. Students  
b. Courses 
c. Enrollments  
d. Teacher  
e. Payments 
3. Create an ERD (Entity Relationship Diagram) for the database. 
4. Create appropriate Primary Key and Foreign Key constraints for referential integrity. 
5. Insert at least 10 sample records into each of the following tables. 
i.Students  
ii.Courses 
iii.Enrollments  
iv. Teacher  
v. Payments
*/


CREATE DATABASE SISDB;


USE SISDB; 


CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15)
);

CREATE TABLE Teacher (
    teacher_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    credits INT CHECK (credits >= 0),
    teacher_id INT FOREIGN KEY REFERENCES Teacher(teacher_id)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT FOREIGN KEY REFERENCES Students(student_id),
    course_id INT FOREIGN KEY REFERENCES Courses(course_id),
    enrollment_date DATE
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    student_id INT FOREIGN KEY REFERENCES Students(student_id),
    amount DECIMAL(10, 2) CHECK (amount >= 0),
    payment_date DATE
);

INSERT INTO Students VALUES 
(1, 'Arun', 'Kumar', '2000-05-12', 'arun.kumar@gmail.com', '9876543210'),
(2, 'Divya', 'Ramesh', '1999-03-22', 'divya.ramesh@gmail.com', '8765432109'),
(3, 'Kiran', 'Raj', '2001-08-15', 'kiran.raj@gmail.com', '7654321098'),
(4, 'Meena', 'Sridhar', '2002-07-01', 'meena.sridhar@gmail.com', '6543210987'),
(5, 'Ravi', 'Varma', '2000-11-30', 'ravi.varma@gmail.com', '5432109876'),
(6, 'Lakshmi', 'Narayana', '1998-09-17', 'lakshmi.n@gmail.com', '4321098765'),
(7, 'Suresh', 'Babu', '1999-12-05', 'suresh.babu@gmail.com', '3210987654'),
(8, 'Anitha', 'Venkatesh', '2001-01-29', 'anitha.v@gmail.com', '2109876543'),
(9, 'Vignesh', 'Murthy', '2002-04-18', 'vignesh.m@gmail.com', '1098765432'),
(10, 'Keerthi', 'Shankar', '2000-06-10', 'keerthi.s@gmail.com', '9988776655');


INSERT INTO Teacher VALUES
(1, 'Ram', 'Subramanian', 'ram.s@gmail.com'),
(2, 'Priya', 'Iyer', 'priya.iyer@gmail.com'),
(3, 'Ganesh', 'Krishnan', 'ganesh.k@gmail.com'),
(4, 'Deepa', 'Menon', 'deepa.menon@gmail.com'),
(5, 'Vikram', 'Reddy', 'vikram.reddy@gmail.com'),
(6, 'Swathi', 'Kumar', 'swathi.k@gmail.com'),
(7, 'Ramesh', 'Naidu', 'ramesh.naidu@gmail.com'),
(8, 'Anjali', 'Suresh', 'anjali.s@gmail.com'),
(9, 'Manoj', 'Das', 'manoj.das@gmail.com'),
(10, 'Bhavana', 'Mohan', 'bhavana.mohan@gmail.com');


INSERT INTO Courses VALUES
(101, 'Data Structures', 4, 1),
(102, 'Database Systems', 3, 2),
(103, 'Operating Systems', 4, 3),
(104, 'Computer Networks', 3, 4),
(105, 'Web Development', 3, 5),
(106, 'Machine Learning', 4, 6),
(107, 'Cloud Computing', 3, 7),
(108, 'Cyber Security', 3, 8),
(109, 'Artificial Intelligence', 4, 9),
(110, 'Mobile App Development', 3, 10);

INSERT INTO Enrollments VALUES
(1, 1, 101, '2024-01-10'),
(2, 2, 102, '2024-01-12'),
(3, 3, 103, '2024-01-15'),
(4, 4, 104, '2024-01-18'),
(5, 5, 105, '2024-01-20'),
(6, 6, 106, '2024-01-22'),
(7, 7, 107, '2024-01-25'),
(8, 8, 108, '2024-01-28'),
(9, 9, 109, '2024-01-30'),
(10, 10, 110, '2024-02-01');

INSERT INTO Payments VALUES
(1, 1, 15000.00, '2024-01-11'),
(2, 2, 14500.00, '2024-01-13'),
(3, 3, 16000.00, '2024-01-16'),
(4, 4, 15500.00, '2024-01-19'),
(5, 5, 14000.00, '2024-01-21'),
(6, 6, 16500.00, '2024-01-23'),
(7, 7, 15000.00, '2024-01-26'),
(8, 8, 14250.00, '2024-01-29'),
(9, 9, 17000.00, '2024-01-31'),
(10, 10, 13500.00, '2024-02-02');


--	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


--Tasks 2: Select, Where, Between, AND, LIKE: 

--1. Insert a new student:

INSERT INTO Students (student_id, first_name, last_name, date_of_birth, email, phone_number)
VALUES (11, 'Aditya', 'Kesavan', '2003-10-23', 'aditya@gmail.com', '9345093450');

SELECT * FROM Students;

--2. Enroll a student in a course:

INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date)
VALUES (11, 1, 101, GETDATE()); 

SELECT * FROM Enrollments;

--3. Update a teacher's email address:

UPDATE Teacher
SET email = 'new.email@hexaware.com'
WHERE teacher_id = 2;

SELECT * FROM Teacher;

--4. Delete a specific enrollment record:

DELETE FROM Enrollments
WHERE student_id = 1 AND course_id = 101;

--5. Assign a teacher to a course:

UPDATE Courses
SET teacher_id = 3
WHERE course_id = 102;

--6. Delete a student and their enrollments :

-- i. Delete related Payments (child of Students)
DELETE FROM Payments
WHERE student_id = 5;

-- ii. Delete from Enrollments (child of Students)
DELETE FROM Enrollments
WHERE student_id = 5;

-- iii. Now we can safely delete from Students
DELETE FROM Students
WHERE student_id = 5;

--7. Update payment amount for a specific record:

UPDATE Payments
SET amount = 7500.00
WHERE payment_id = 2;

SELECT * FROM Payments;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 

--Task 3. Aggregate functions, Having, Order By, GroupBy and Joins:  

--1. Total payments made by a specific student 

SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    SUM(p.amount) AS total_payment
FROM Students s
JOIN Payments p ON s.student_id = p.student_id
WHERE s.student_id = 3
GROUP BY s.student_id, s.first_name, s.last_name;

--2. Courses with count of enrolled students

SELECT 
    c.course_id,
    c.course_name,
    COUNT(e.student_id) AS student_count
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
ORDER BY student_count DESC;

--3. Students not enrolled in any course

SELECT 
    s.student_id,
    s.first_name,
    s.last_name
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
WHERE e.course_id IS NULL;

--4. Students and the courses they are enrolled in

SELECT 
    s.first_name,
    s.last_name,
    c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;

--5. Teachers and the courses they are assigned to

SELECT 
    t.first_name,
    t.last_name,
    c.course_name
FROM Teacher t
JOIN Courses c ON t.teacher_id = c.teacher_id;

--6. Students and their enrollment dates for a specific course 

SELECT 
    s.first_name,
    s.last_name,
    e.enrollment_date
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_id = 102;

SELECT * FROM Students;
Select * from courses;
select * from Enrollments;

--7. Students who have not made any payments

SELECT 
    s.student_id,
    s.first_name,
    s.last_name
FROM Students s
LEFT JOIN Payments p ON s.student_id = p.student_id
WHERE p.payment_id IS NULL;

--8. Courses that have no enrollments

SELECT 
    c.course_id,
    c.course_name
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
WHERE e.student_id IS NULL;

--9. Students enrolled in more than one course

SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    COUNT(e.course_id) AS course_count
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(e.course_id) > 1;

Select * from Enrollments;


--10. Teachers not assigned to any courses

SELECT 
    t.teacher_id,
    t.first_name,
    t.last_name
FROM Teacher t
LEFT JOIN Courses c ON t.teacher_id = c.teacher_id
WHERE c.course_id IS NULL;



--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

--Task 4. Subquery and its type:  

--1. Average number of students enrolled in each course (using subquery):

SELECT AVG(student_count) AS avg_students_per_course
FROM (
    SELECT course_id, COUNT(*) AS student_count
    FROM Enrollments
    GROUP BY course_id
) AS course_counts;

--2. Students who made the highest payment:

SELECT s.first_name, s.last_name, p.amount
FROM Payments p
JOIN Students s ON s.student_id = p.student_id
WHERE p.amount = (
    SELECT MAX(amount) FROM Payments
);

--3. Courses with the highest number of enrollments:

SELECT c.course_name, COUNT(e.student_id) AS enrollments
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.student_id) = (
    SELECT MAX(enrollment_count)
    FROM (
        SELECT COUNT(*) AS enrollment_count
        FROM Enrollments
        GROUP BY course_id
    ) AS counts
);

--4. Total payments to courses taught by each teacher:


SELECT t.first_name, 
       (SELECT SUM(p.amount)
        FROM Payments p
        JOIN Enrollments e ON p.student_id = e.student_id
        WHERE e.course_id IN (
            SELECT c.course_id 
            FROM Courses c 
            WHERE c.teacher_id = t.teacher_id
        )
       ) AS total_payments
FROM Teacher t;

--8. Courses with no enrollments:

SELECT course_name
FROM Courses
WHERE course_id NOT IN (
    SELECT DISTINCT course_id FROM Enrollments
);

SELECT * FROM Courses;
SELECT * FROM Enrollments;

SELECT DISTINCT course_id FROM Enrollments;

INSERT INTO Courses (course_id, course_name, teacher_id)
VALUES (99, 'Blockchain Basics', 1);

DELETE FROM Courses WHERE course_id=99;

--5. Students enrolled in all courses:
-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
SELECT s.student_id, s.first_name, s.last_name
FROM Students s
WHERE NOT EXISTS (
    SELECT c.course_id 
    FROM Courses c
    WHERE NOT EXISTS (
        SELECT e.course_id
        FROM Enrollments e
        WHERE e.course_id = c.course_id AND e.student_id = s.student_id
    )
);
select * from Courses;
select * from Enrollments;

INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date)
VALUES 
  (13, 1, 102, '2024-03-01'),
  (13, 1, 103, '2024-03-02'),
  (14, 1, 104, '2024-03-03'),
  (15, 1, 105, '2024-03-01'),
  (16, 1, 106, '2024-03-02'),
  (17, 1, 107, '2024-03-03'),
  (18, 1, 108, '2024-03-01'),
  (19, 1, 109, '2024-03-02'),
  (20, 1, 110, '2024-03-03');

--6. Teachers not assigned to any course:

SELECT first_name
FROM Teacher
WHERE teacher_id NOT IN (
    SELECT DISTINCT teacher_id FROM Courses
);

--7. Average age of all students (based on DOB):

SELECT AVG(DATEDIFF(YEAR, date_of_birth, GETDATE())) AS average_age
FROM Students;




--9. Total payments by each student for each course:


SELECT s.first_name, s.last_name, c.course_name,
       (SELECT SUM(p.amount)
        FROM Payments p
        WHERE p.student_id = s.student_id) AS total_payment
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;

--10. Students who made more than one payment:


SELECT s.first_name, s.last_name, COUNT(p.payment_id) AS payment_count
FROM Students s
JOIN Payments p ON s.student_id = p.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(p.payment_id) > 1;

-- First Payment
INSERT INTO Payments (payment_id, student_id, amount, payment_date)
VALUES (5, 1, 1000.00, '2024-03-01');
select * from Payments;
-- Second Payment
INSERT INTO Payments (payment_id, student_id, amount, payment_date)
VALUES (11, 1, 800.00, '2024-03-15');


--11. Total payments made by each student (using GROUP BY):


SELECT s.student_id, s.first_name, s.last_name, SUM(p.amount) AS total_paid
FROM Students s
JOIN Payments p ON s.student_id = p.student_id
GROUP BY s.student_id, s.first_name, s.last_name;

--12. Course names with student count (GROUP BY):


SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

SELECT * FROM COURSES;

--13. Average payment amount made by students:


SELECT s.student_id, s.first_name, s.last_name, AVG(p.amount) AS avg_payment
FROM Students s
JOIN Payments p ON s.student_id = p.student_id
GROUP BY s.student_id, s.first_name, s.last_name;

