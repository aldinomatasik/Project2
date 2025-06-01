-- AXON CLASSIC MODEL --
USE classicmodels;
SHOW TABLES;

-- 1. 'customers table'
DESCRIBE customers;
SELECT * FROM customers;

SELECT COUNT(DISTINCT customerNumber) AS total_customers FROM customers;
SELECT customerNumber FROM customers WHERE customerNumber IS NULL;

-- 2. 'employees table'
DESCRIBE employees;
SELECT * FROM employees;

SELECT COUNT(DISTINCT employeeNumber) AS Total_Employees FROM employees;
SELECT employeeNumber FROM employees WHERE employeeNumber IS NULL;

-- 3. 'offices Table'
DESCRIBE offices;
SELECT * FROM offices;

SELECT COUNT(DISTINCT officeCode) AS Total_Offices FROM offices;

SELECT country, COUNT(officeCode) AS Total_Offices FROM offices 
GROUP BY country
ORDER BY Total_Offices DESC;

-- 4. 'Orderdetails Table'
DESCRIBE orderdetails;
SELECT * FROM orderdetails;

SELECT COUNT(DISTINCT orderNumber) AS Total_Orders FROM orders;

-- 5. 'Orders Table'
DESCRIBE orders;
SELECT * FROM orders;

SELECT  
  YEAR(orderDate) AS Year,
  MONTH(orderDate) AS Month,
  MONTHNAME(orderDate) AS Month_Name,
  COUNT(orderNumber) AS Total_orders,
  SUM(COUNT(orderNumber)) OVER (PARTITION BY YEAR(orderDate) ORDER BY MONTH(orderDate)) AS Sum_Of_Orders
FROM orders
GROUP BY Year, Month, Month_Name
ORDER BY Year, Month;

SELECT status, COUNT(orderNumber) AS Total_Orders 
FROM orders 
WHERE status = 'Shipped';

-- 6. 'Payments Table'
DESCRIBE payments;
SELECT * FROM payments;

SELECT SUM(amount) AS Total_Amount FROM payments;

SELECT customerNumber, SUM(amount) AS Total_Payment
FROM payments 
GROUP BY customerNumber;

SELECT 
  YEAR(paymentDate) AS Year,
  SUM(amount) AS Total_Amount,
  SUM(SUM(amount)) OVER (ORDER BY YEAR(paymentDate)) AS Sum_Of_Amount
FROM payments
GROUP BY Year
ORDER BY Year;

SELECT 
  YEAR(paymentDate) AS Year,
  MONTHNAME(paymentDate) AS Month_Name,
  SUM(amount) AS Total_Amount
FROM payments
GROUP BY Year, MONTH(paymentDate), Month_Name 
ORDER BY Year, MONTH(paymentDate);

-- 7. 'Productlines Table'
DESCRIBE productlines;
SELECT * FROM productlines;

SELECT COUNT(DISTINCT productLine) AS total_productLine FROM productlines;

-- 8. 'products Table'
DESCRIBE products;
SELECT * FROM products;

SELECT COUNT(DISTINCT productCode) AS Total_Products FROM products;

SELECT productLine, COUNT(productCode) AS Total_Products
FROM products
GROUP BY productLine;

SELECT productLine, SUM(quantityInStock) AS Quantity_In_Stock 
FROM products 
GROUP BY productLine;

SELECT COUNT(DISTINCT productVendor) AS Total_Vendors FROM products;

-- Queries 1-26
SELECT CONCAT(contactfirstname, ' ', contactlastname) AS FullName FROM customers;

SELECT Country, COUNT(*) AS Total_Customers
FROM customers
GROUP BY country
ORDER BY Total_Customers DESC
LIMIT 1;

SELECT City, COUNT(*) AS Total_Customers
FROM customers 
GROUP BY city
ORDER BY Total_Customers DESC
LIMIT 2;

SELECT State, COUNT(*) AS Total_Customers
FROM customers
WHERE state IS NOT NULL
GROUP BY State
ORDER BY Total_Customers DESC
LIMIT 1;

SELECT Customernumber, customername, city, country
FROM customers
WHERE state IS NULL;

SELECT customernumber, customername 
FROM customers 
WHERE creditlimit > 100000;

SELECT customernumber, customername
FROM customers
WHERE creditlimit BETWEEN 50000 AND 200000;

SELECT customernumber, customername, creditlimit
FROM customers
WHERE creditlimit = (SELECT MAX(creditlimit) FROM customers);

SELECT customernumber, customername, creditlimit
FROM customers
WHERE creditlimit = (SELECT MIN(creditlimit) FROM customers);

SELECT e.employeenumber, CONCAT(e.firstname, ' ', e.lastname) AS FullName, COUNT(*) AS Total_customers
FROM customers c 
JOIN employees e ON c.salesrepemployeenumber = e.employeenumber
WHERE c.salesrepemployeenumber IS NOT NULL
GROUP BY e.employeenumber
ORDER BY Total_customers DESC;

SELECT c.customernumber, c.customername, CONCAT(e.firstname, ' ', e.lastname) AS Employee_Name
FROM customers c 
JOIN employees e ON c.salesrepemployeenumber = e.employeenumber
WHERE c.salesrepemployeenumber IS NOT NULL;

SELECT customernumber, customername, country, city
FROM customers
WHERE salesRepEmployeeNumber IS NULL;

SELECT customername, CONCAT(contactfirstname, ' ', contactlastname) AS ContactName 
FROM customers 
WHERE LOWER(contactfirstname) IN ('arnold', 'sarah');

SELECT reportsto, COUNT(*) AS Employees
FROM employees
WHERE reportsto IS NOT NULL
GROUP BY reportsto
ORDER BY Employees DESC;

SELECT customername, DATEDIFF(shippeddate, orderdate) AS Total_Days
FROM customers c 
JOIN orders o ON c.customernumber = o.customernumber
WHERE shippeddate IS NOT NULL;

SELECT employeenumber, CONCAT(firstname, ' ', lastname) AS EmployeeName, jobtitle 
FROM employees
WHERE jobtitle LIKE '%VP%' OR jobtitle LIKE '%Manager%';

SELECT YEAR(shippeddate) AS Year, COUNT(*) AS Total_shipped
FROM orders
WHERE shippeddate IS NOT NULL
GROUP BY YEAR(shippeddate);

SELECT customernumber, COUNT(*) AS Total_Orders
FROM orders
GROUP BY customernumber
ORDER BY Total_Orders DESC;

SELECT productvendor, COUNT(DISTINCT p.productcode) AS Total_Products, SUM(quantityordered) AS Total_quantity,
SUM(quantityordered * priceeach) AS Total_price 
FROM products p 
JOIN orderdetails od ON p.productcode = od.productcode
GROUP BY productvendor
ORDER BY Total_Products DESC;

SELECT p.productcode, productname, SUM(quantityordered) AS Total_quantity 
FROM products p 
JOIN orderdetails od ON p.productcode = od.productcode
GROUP BY p.productcode, productname
ORDER BY Total_quantity DESC;

SELECT p.productName, CONCAT(c.contactFirstName, ' ', c.contactLastName) AS c_name 
FROM customers c 
JOIN orders o ON c.customernumber = o.customernumber
JOIN orderdetails od ON o.ordernumber = od.ordernumber
JOIN products p ON od.productcode = p.productcode
WHERE c.Contactfirstname LIKE 'Thomas%';

SELECT customername, CONCAT(Contactfirstname, ' ', contactlastname) AS Contact_Name, COUNT(*) AS Total_Products 
FROM customers c 
JOIN orders o ON c.customernumber = o.customernumber
JOIN orderdetails od ON o.ordernumber = od.ordernumber
JOIN products p ON od.productcode = p.productcode
GROUP BY customername, Contact_Name
ORDER BY Total_Products DESC 
LIMIT 1;

SELECT p.Productcode, productname, COUNT(DISTINCT c.customernumber) AS Total_customers 
FROM customers c 
JOIN orders o ON c.customernumber = o.customernumber
JOIN orderdetails od ON o.ordernumber = od.ordernumber
JOIN products p ON p.productcode = od.productcode
GROUP BY p.Productcode, productname
ORDER BY Total_customers DESC
LIMIT 1;

SELECT c.customernumber, customername, SUM(amount) AS amount  
FROM customers c 
JOIN payments p ON c.customernumber = p.customernumber
GROUP BY c.customernumber, customername
HAVING amount > (SELECT AVG(amount) FROM payments);

SELECT status, o.customernumber, customername, od.ordernumber, COUNT(productcode) AS Total_products,
SUM(quantityordered * priceeach) AS Total_Price 
FROM orders o 
JOIN payments p ON o.customernumber = p.customernumber
JOIN orderdetails od ON o.ordernumber = od.ordernumber
JOIN customers c ON p.customernumber = c.customernumber
WHERE status = 'On Hold'
GROUP BY status, o.customernumber, customername, od.ordernumber;

SELECT 
  customerNumber,
  CONCAT(contactFirstName, ' ', contactLastName) AS Full_Name,
  creditlimit,
  CASE 
    WHEN creditLimit < 10000 THEN 'Low Credit Limit'
    WHEN creditLimit BETWEEN 10000 AND 75000 THEN 'Medium Credit Limit'
    WHEN creditLimit > 75000 THEN 'High Credit Limit'
  END AS Customer_Credit_Status
FROM customers;


-- 27. Stored Procedure Customer_Details
DROP PROCEDURE IF EXISTS Customer_Details;

DELIMITER //

CREATE PROCEDURE Customer_Details(IN customer_name VARCHAR(250))
BEGIN
  SELECT o.customerNumber,
         c.customerName,
         CONCAT(e.firstName, ' ', e.lastName) AS Sales_Representative,
         COUNT(DISTINCT o.orderNumber) AS Total_Orders,
         MAX(pd.productLine) AS Product_Line
  FROM customers c 
  INNER JOIN orders o ON o.customerNumber = c.customerNumber
  INNER JOIN orderdetails od ON od.orderNumber = o.orderNumber
  INNER JOIN products pd ON pd.productCode = od.productCode
  INNER JOIN payments p ON p.customerNumber = c.customerNumber
  INNER JOIN employees e ON e.employeeNumber = c.salesRepEmployeeNumber
  WHERE c.customerName = customer_name
  GROUP BY o.customerNumber, c.customerName, Sales_Representative;
END //

DELIMITER ;

CALL Customer_Details('Euro+ Shopping Channel');


-- 28. Stored Procedure Product_Details
DROP PROCEDURE IF EXISTS Product_Details;

DELIMITER //

CREATE PROCEDURE Product_Details(IN ProductCode VARCHAR(20))
BEGIN
  SELECT pd.productCode,
         pd.productName,
         COUNT(DISTINCT od.orderNumber) AS Total_Orders,
         ROUND(SUM(od.quantityOrdered * od.priceEach) / 1000, 2) AS Total_Amount
  FROM products pd
  INNER JOIN orderdetails od ON pd.productCode = od.productCode
  INNER JOIN orders o ON o.orderNumber = od.orderNumber
  WHERE pd.productCode = ProductCode
  GROUP BY pd.productCode, pd.productName;
END //

DELIMITER ;

CALL Product_Details('S18_3232');
