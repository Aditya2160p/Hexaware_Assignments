--TechShop, an electronic gadgets shop 

/*You are working as a database administrator for a fictional company named "TechShop," which sells 
electronic gadgets. TechShop maintains data related to their products, customers, and orders. Your task 
is to design and implement a database for TechShop based on the following requirements:*/

--Task:1. Database Design:  

--1. Create the database named "TechShop"

CREATE DATABASE TechShop;
USE TechShop;

/*2. Define the schema for the Customers, Products, Orders, OrderDetails and Inventory tables 
based on the provided schema.
4. Create appropriate Primary Key and Foreign Key constraints for referential integrity. */ 

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(50),
    Phone VARCHAR(20),
    Address VARCHAR(200)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Description VARCHAR(200),
    Price INT
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount INT DEFAULT 0,
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY,
    ProductID INT UNIQUE,
    QuantityInStock INT,
    LastStockUpdate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Inventory_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

exec sp_columns Customers;
exec sp_columns Orders;
exec sp_columns OrderDetails;
exec sp_columns Inventory;
exec sp_columns Products;

--5. Insert at least 10 sample records into each of the following tables. 
INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone, Address)
VALUES
(1, 'Amit', 'Sharma', 'amit.sharma@email.com', '9876543210', '123 MG Road, Delhi'),
(2, 'Priya', 'Verma', 'priya.verma@email.com', '8765432109', '456 Park Street, Mumbai'),
(3, 'Rahul', 'Gupta', 'rahul.gupta@email.com', '7654321098', '789 Nehru Nagar, Kolkata'),
(4, 'Sneha', 'Rao', 'sneha.rao@email.com', '6543210987', '101 JP Nagar, Bengaluru'),
(5, 'Vikas', 'Patel', 'vikas.patel@email.com', '5432109876', '202 Law Garden, Ahmedabad'),
(6, 'Anjali', 'Iyer', 'anjali.iyer@email.com', '4321098765', '303 T Nagar, Chennai'),
(7, 'Suresh', 'Kumar', 'suresh.kumar@email.com', '3210987654', '404 Jubilee Hills, Hyderabad'),
(8, 'Meera', 'Das', 'meera.das@email.com', '2109876543', '505 Bhawanipur, Kolkata'),
(9, 'Rajesh', 'Singh', 'rajesh.singh@email.com', '1098765432', '606 Banjara Hills, Hyderabad'),
(10, 'Kavita', 'Joshi', 'kavita.joshi@email.com', '9876012345', '707 Andheri West, Mumbai');

DELETE FROM Customers;

INSERT INTO Products (ProductID, ProductName, Description, Price)
VALUES 
(1, 'Laptop', 'High-performance laptop', 1200),
(2, 'Smartphone', 'Latest model smartphone', 800),
(3, 'Tablet', '10-inch screen tablet', 600),
(4, 'Smartwatch', 'Wearable smartwatch', 250),
(5, 'Headphones', 'Noise-canceling headphones', 150),
(6, 'Keyboard', 'Mechanical keyboard', 100),
(7, 'Mouse', 'Wireless mouse', 50),
(8, 'Monitor', '24-inch LED monitor', 200),
(9, 'Speakers', 'Bluetooth speakers', 180),
(10, 'External HDD', '1TB external hard drive', 90);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES 
(1, 1, '2025-03-01', 2400),
(2, 2, '2025-03-02', 1600),
(3, 3, '2025-03-03', 800),
(4, 4, '2025-03-04', 250),
(5, 5, '2025-03-05', 300),
(6, 6, '2025-03-06', 1200),
(7, 7, '2025-03-07', 400),
(8, 8, '2025-03-08', 500),
(9, 9, '2025-03-09', 150),
(10, 10, '2025-03-10', 90);

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity)
VALUES 
(1, 1, 1, 2),  
(2, 2, 2, 2), 
(3, 3, 3, 1), 
(4, 4, 4, 1), 
(5, 5, 5, 2),  
(6, 6, 1, 1),  
(7, 7, 6, 2),  
(8, 8, 7, 5), 
(9, 9, 5, 1), 
(10, 10, 10, 1); 

INSERT INTO Inventory (InventoryID, ProductID, QuantityInStock, LastStockUpdate)
VALUES 
(1, 1, 50, '2025-03-01'),
(2, 2, 100, '2025-03-02'),
(3, 3, 30, '2025-03-03'),
(4, 4, 25, '2025-03-04'),
(5, 5, 60, '2025-03-05'),
(6, 6, 70, '2025-03-06'),
(7, 7, 90, '2025-03-07'),
(8, 8, 40, '2025-03-08'),
(9, 9, 55, '2025-03-09'),
(10, 10, 80, '2025-03-10');

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;
SELECT * FROM Inventory;

--Tasks 2: Select, Where, Between, AND, LIKE: 

--1. Write an SQL query to retrieve the names and emails of all customers.  

SELECT FirstName, LastName, Email FROM Customers;

--2. Write an SQL query to list all orders with their order dates and corresponding customer names.

/*3. Write an SQL query to insert a new customer record into the "Customers" table. Include 
customer information such as name, email, and address.*/ 

INSERT INTO Customers (CustomerId,FirstName, LastName, Email, Phone, Address)
VALUES (11,'Rahul', 'Sharma', 'rahul.sharma@email.com', '9876543210', 'Mumbai, India');

/*4. Write an SQL query to update the prices of all electronic gadgets in the "Products" table by 
increasing them by 10%.*/

UPDATE Products
SET Price = Price * 1.10
WHERE ProductName IN ('Laptop', 'Smartphone', 'Tablet', 'Smartwatch');

/*5. Write an SQL query to delete a specific order and its associated order details from the 
"Orders" and "OrderDetails" tables. Allow users to input the order ID as a parameter. */

DELETE FROM OrderDetails WHERE OrderID = 1;
DELETE FROM Orders WHERE OrderID = 2;

/*6. Write an SQL query to insert a new order into the "Orders" table. Include the customer ID, 
order date, and any other necessary information.*/

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES (1001, 2, '2025-03-05', 1500);

/*7. Write an SQL query to update the contact information (e.g., email and address) of a specific 
customer in the "Customers" table. Allow users to input the customer ID and new contact 
information. */

UPDATE Customers
SET Email = 'abc@gmail.com', Address = 'New Delhi, India'
WHERE CustomerID = 1;

/*8. Write an SQL query to recalculate and update the total cost of each order in the "Orders" 
table based on the prices and quantities in the "OrderDetails" table. */



/*9. Write an SQL query to delete all orders and their associated order details for a specific 
customer from the "Orders" and "OrderDetails" tables. Allow users to input the customer ID 
as a parameter. */


/*10. Write an SQL query to insert a new electronic gadget product into the "Products" table, 
including product name, category, price, and any other relevant details. */

INSERT INTO Products (ProductID, ProductName, Description, Price)  
VALUES (11, 'Wireless Earbuds', 'High-quality Bluetooth earbuds', 2500.00);

/*11. Write an SQL query to update the status of a specific order in the "Orders" table (e.g., from 
"Pending" to "Shipped"). Allow users to input the order ID and the new status.*/

ALTER TABLE Orders  
ADD Status VARCHAR(50) DEFAULT 'Pending';

UPDATE Orders  
SET Status = 'Shipped'  
WHERE OrderID = 1;

/*12. Write an SQL query to calculate and update the number of orders placed by each customer 
in the "Customers" table based on the data in the "Orders" table.*/

ALTER TABLE Customers  
ADD OrderCount INT DEFAULT 0;

UPDATE Customers
SET OrderCount = (
    SELECT COUNT(OrderID)
    FROM Orders
    WHERE Orders.CustomerID = Customers.CustomerID
);
SELECT CustomerID, FirstName, LastName, OrderCount FROM Customers;

