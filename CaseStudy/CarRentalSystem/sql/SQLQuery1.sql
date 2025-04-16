CREATE DATABASE CarRentalSystem;

USE CarRentalSystem;

-- VEHICLE TABLE
CREATE TABLE Vehicle (
    vehicleID INT PRIMARY KEY IDENTITY(1,1),
    make VARCHAR(50),
    model VARCHAR(50),
    year INT,
    dailyRate DECIMAL(10,2),
    status VARCHAR(20),
    passengerCapacity INT,
    engineCapacity FLOAT
);

-- CUSTOMER TABLE
CREATE TABLE Customer (
    customerID INT PRIMARY KEY IDENTITY(1,1),
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    email VARCHAR(100),
    phoneNumber VARCHAR(15)
);

-- LEASE TABLE
CREATE TABLE Lease (
    leaseID INT PRIMARY KEY IDENTITY(1,1),
    vehicleID INT FOREIGN KEY REFERENCES Vehicle(vehicleID),
    customerID INT FOREIGN KEY REFERENCES Customer(customerID),
    startDate DATE,
    endDate DATE,
    type VARCHAR(20)
);

-- PAYMENT TABLE
CREATE TABLE Payment (
    paymentID INT PRIMARY KEY IDENTITY(1,1),
    leaseID INT FOREIGN KEY REFERENCES Lease(leaseID),
    paymentDate DATE,
    amount DECIMAL(10,2)
);

select * from Vehicle;
select * from Customer;
select * from Payment;
select * from Lease;

DELETE FROM Payment;
DELETE FROM Lease;
DELETE FROM Vehicle;
DELETE FROM Customer;

-- Reset IDs
DBCC CHECKIDENT ('Customer', RESEED, 0);
DBCC CHECKIDENT ('Vehicle', RESEED, 0);
DBCC CHECKIDENT ('Lease', RESEED, 0);
DBCC CHECKIDENT ('Payment', RESEED, 0);

INSERT INTO Vehicle (make, model, year, dailyRate, status, passengerCapacity, engineCapacity) VALUES
('Maruti Suzuki', 'Swift', 2022, 3500.00, 'available', 5, 1.2),
('Hyundai', 'Creta', 2023, 5000.00, 'available', 5, 1.5),
('Tata', 'Nexon', 2024, 4500.00, 'available', 5, 1.5),
('Mahindra', 'Thar', 2022, 6000.00, 'available', 4, 2.0),
('Kia', 'Seltos', 2023, 4800.00, 'available', 5, 1.4);

INSERT INTO Customer (firstName, lastName, email, phoneNumber) VALUES
('Aditya', 'K', 'aditya.k@example.com', '9876543210'),
('Sneha', 'Reddy', 'sneha.reddy@example.com', '9123456780'),
('Ravi', 'Patel', 'ravi.patel@example.com', '9012345678'),
('Priya', 'Sharma', 'priya.sharma@example.com', '9988776655'),
('Amit', 'Verma', 'amit.verma@example.com', '9845098450');

ALTER TABLE Lease
ADD totalCost DECIMAL(10,2);

ALTER TABLE Lease
DROP COLUMN totalCost;
