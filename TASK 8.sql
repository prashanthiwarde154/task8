-- Drop previous database if it exists and create a new one
DROP DATABASE IF EXISTS ajay;
CREATE DATABASE ajay;
USE ajay;

-- Create Customers table
CREATE TABLE Customers (
  customer_id INT PRIMARY KEY,
  name VARCHAR(100),
  city VARCHAR(50)
);

-- Create Orders table
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  amount DECIMAL(10, 2),
  order_date DATE,
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Insert data into Customers
INSERT INTO Customers VALUES
(1, 'Ajay', 'Pune'),
(2, 'Shivam', 'Mumbai'),
(3, 'Rohan', 'Delhi'),
(4, 'Prashant', 'Pune');

-- Insert data into Orders
INSERT INTO Orders VALUES
(101, 1, 500.00, '2024-06-01'),
(102, 2, 150.00, '2024-06-02'),
(103, 1, 300.00, '2024-06-05'),
(104, 3, 800.00, '2024-06-08');

-- ✅ Create a View to show customer names and total amount spent
CREATE VIEW CustomerOrderSummary AS
SELECT 
    C.customer_id,
    C.name AS customer_name,
    SUM(O.amount) AS total_spent
FROM 
    Customers C
JOIN 
    Orders O ON C.customer_id = O.customer_id
GROUP BY 
    C.customer_id, C.name;

-- ✅ Function: Get total amount spent by a customer using customer_id
DELIMITER //
CREATE FUNCTION GetTotalSpent(cust_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10,2);
  SELECT SUM(amount) INTO total
  FROM Orders
  WHERE customer_id = cust_id;
  RETURN IFNULL(total, 0.00);
END //
DELIMITER ;

-- ✅ Stored Procedure: Insert a new customer and their first order
DELIMITER //
CREATE PROCEDURE AddCustomerAndOrder(
    IN p_customer_id INT,
    IN p_name VARCHAR(100),
    IN p_city VARCHAR(50),
    IN p_order_id INT,
    IN p_amount DECIMAL(10,2),
    IN p_order_date DATE
)
BEGIN
    INSERT INTO Customers(customer_id, name, city)
    VALUES (p_customer_id, p_name, p_city);

    INSERT INTO Orders(order_id, customer_id, amount, order_date)
    VALUES (p_order_id, p_customer_id, p_amount, p_order_date);
END //
DELIMITER ;

-- ✅ Call the procedure (example):
-- CALL AddCustomerAndOrder(5, 'Karan', 'Nashik', 105, 250.00, '2024-06-10');

-- ✅ Use the function (example):
-- SELECT GetTotalSpent(1) AS TotalSpentByAmit;
