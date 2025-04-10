-- Create the SISDB database
CREATE DATABASE StudentInformationSystem;
GO

-- Use the SISDB database
USE StudentInformationSystem;
GO

-- 1. Students Table
CREATE TABLE Students (
    student_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15) NOT NULL
);

-- 2. Teachers Table
CREATE TABLE Teachers (
    teacher_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 3. Courses Table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY IDENTITY(1,1),
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    teacher_id INT,  -- Nullable to allow course creation before assignment
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id)
);

-- 4. Enrollments Table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY IDENTITY(1,1),
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    CONSTRAINT UC_StudentCourse UNIQUE (student_id, course_id) -- Avoid duplicate enrollments
);

-- 5. Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    student_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE
);


select * from Students;
select * from Teachers;
select * from Courses;
select * from Enrollments;
select * from Payments;

--generate_enrollment_report_by_course
SELECT s.student_id, s.first_name, s.last_name, e.enrollment_date
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
WHERE e.course_id = 1;

--generate_payment_report_by_student
SELECT amount, payment_date
FROM Payments
WHERE student_id = 1;

ALTER TABLE Payments
ADD course_id INT FOREIGN KEY REFERENCES Courses(course_id)


delete from Payments where payment_id=2;

INSERT INTO Teachers (first_name, last_name, email)
VALUES 
('Anand', 'Krishnan', 'anand.krishnan@example.com'),
('Meena', 'Ravi', 'meena.ravi@example.com'),
('Suresh', 'Kumar', 'suresh.kumar@example.com');

INSERT INTO Courses (course_name, credits, teacher_id)
VALUES
('Python Programming', 4, 1),
('Data Structures', 3, 2),
('Database Systems', 3, 3),
('Web Development', 4, 1),
('Operating Systems', 3, 2);

INSERT INTO Students (first_name, last_name, date_of_birth, email, phone_number)
VALUES
('Arjun', 'Ramesh', '2001-05-14', 'arjun.ramesh@example.com', '9876543210'),
('Divya', 'Narayan', '2002-11-23', 'divya.narayan@example.com', '9876543211'),
('Karthik', 'Vijay', '2000-02-08', 'karthik.vijay@example.com', '9876543212'),
('Lakshmi', 'Balan', '1999-07-19', 'lakshmi.balan@example.com', '9876543213'),
('Hari', 'Sankar', '2001-09-25', 'hari.sankar@example.com', '9876543214');

INSERT INTO Enrollments (student_id, course_id, enrollment_date)
VALUES
(1, 1, '2023-06-01'),
(1, 2, '2023-06-01'),
(2, 2, '2023-06-05'),
(2, 3, '2023-06-06'),
(3, 1, '2023-06-07'),
(3, 4, '2023-06-08'),
(4, 5, '2023-06-10'),
(5, 3, '2023-06-12'),
(5, 4, '2023-06-13');

INSERT INTO Payments (student_id, course_id, amount, payment_date)
VALUES
(1, 1, 10000.00, '2023-06-15'),
(1, 2, 8000.00, '2023-06-16'),
(2, 2, 8000.00, '2023-06-17'),
(2, 3, 7500.00, '2023-06-18'),
(3, 1, 10000.00, '2023-06-19'),
(3, 4, 9500.00, '2023-06-20'),
(4, 5, 9000.00, '2023-06-21'),
(5, 3, 7500.00, '2023-06-22'),
(5, 4, 9500.00, '2023-06-23');
