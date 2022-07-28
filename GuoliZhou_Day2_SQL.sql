USE AdventureWorks2019
GO

/*1*/
SELECT cr.Name as Country, sp.Name as Province
FROM Person.StateProvince sp JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode;

/*2*/
SELECT cr.Name as Country, sp.Name as Province
FROM Person.StateProvince sp JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name = 'Germany' or cr.Name = 'Canada';

USE Northwind
GO
/*3*/
/*SELECT *
FROM Products

SELECT *
FROM Orders

SELECT *
FROM [Order Details]

SELECT *
FROM Products*/

SELECT p.ProductName
FROM [Order Details] od JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
HAVING COUNT(od.OrderID) >=1


/*4*/
----

/*ctrl k c ctrl k u*/ 

SELECT TOP 5 c.PostalCode
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.PostalCode
ORDER BY COUNT(o.OrderID) DESC

/*5*/
SELECT DISTINCT City AS CityName, COUNT(CustomerID) AS NumCustomers
FROM Customers 
GROUP BY City

/*6*/
SELECT DISTINCT City AS CityName, COUNT(CustomerID) AS NumCustomers
FROM Customers 
GROUP BY City
HAVING COUNT(CustomerID) > 2

/*7*/
SELECT c.ContactName, COUNT(o.OrderID) AS NumProducts
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName

/*8*/
SELECT c.CustomerID, SUM(od.Quantity) AS NumProducts
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING SUM(od.Quantity) >100

/*9*/
/*SELECT ShipVia
FROM Orders

SELECT *
FROM Shippers*/
SELECT s.CompanyName AS [Supplier Company Name], ship.CompanyName AS[Shipping Company Name]
FROM Suppliers s JOIN Products p ON s.SupplierID = p.SupplierID  JOIN [Order Details] od ON p.ProductID = od.ProductID JOIN Orders ods ON od.OrderID = ods.OrderID JOIN Shippers ship ON ods.ShipVia = ship.ShipperID

/*10*/
SELECT p.ProductName, o.OrderDate
FROM Orders o LEFT JOIN [Order Details] od ON o.OrderID  = od.OrderID LEFT JOIN Products p ON od.ProductID = p.ProductID

/*11*/
/*SELECT *
FROM Employees;*/

SELECT DISTINCT(e1.LastName + ' ' + e1.FirstName) AS EmployeeName, e1.Title
FROM Employees e1, Employees e2
WHERE e1.Title = e2.Title
AND e1.EmployeeID <> e2.EmployeeID

/*12*/
SELECT *
FROM Employees;

SELECT (e1.LastName + ' ' + e1.FirstName) AS Manager, COUNT(e2.ReportsTo) AS ReportEmployee
FROM Employees e1 JOIN Employees e2
ON e1.EmployeeID = e2.ReportsTo
GROUP BY (e1.LastName + ' ' + e1.FirstName)
HAVING COUNT(e2.ReportsTo) > 2

/*13*/
/*SELECT *
FROM Suppliers*/

/*14*/
SELECT City FROM Customers
UNION
SELECT City FROM Employees

/*15*/
/*method a*/
SELECT DISTINCT c.City
FROM Customers c
WHERE c.City NOT IN (SELECT City FROM Employees)
/*method b*/
SELECT DISTINCT c.City 
FROM Customers c LEFT JOIN Employees e ON c.City = e.City
WHERE e.City IS NULL

/*16*/
SELECT p.ProductID, p.ProductName, SUM(od.Quantity) AS TotalQuantities
FROM Products p LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName

/*17?*/
/*USE UNION*/
SELECT c1.City FROM Customers c1 GROUP BY c1.City HAVING COUNT(c1.CustomerID) >= 2
UNION 
SELECT c2.City FROM Customers c2 GROUP BY c2.City HAVING COUNT(c2.CustomerID) >= 2

/*NOT USE UNION*/

SELECT City, COUNT(CustomerID) AS CustoemrNumber
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) >=2

/*18*/
/*Select *
From [Order Details]*/
SELECT DISTINCT c.City, t.NumofDiffProduct
FROM Customers c LEFT JOIN 
Orders o ON c.CustomerID = o.CustomerID 
LEFT JOIN 
(SELECT OrderID, COUNT(DISTINCT(ProductID)) As NumofDiffProduct
FROM [Order Details]
GROUP BY OrderID
HAVING COUNT(DISTINCT(ProductID)) >= 2) AS t 
ON o.OrderID = t.OrderID
WHERE t.NumofDiffProduct IS NOT NULL

/*19*/
SELECT *
FROM Products

SELECT *
FROM [Order Details]

/*start from order details*/
SELECT TOP 5 c.City, (t.TotalPrice/t.TotalQuantity) AS AVG_Price, t.TotalQuantity
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID 
JOIN (SELECT OrderID, ProductID, SUM(Quantity) AS TotalQuantity, SUM(UnitPrice*Quantity) AS TotalPrice
FROM [Order Details] GROUP BY ProductID,OrderID) AS t 
ON o.OrderID = t.OrderID
ORDER BY t.TotalQuantity DESC

/*20 List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is,(count orderid)
and also the city of most total quantity of products ordered(join)
from. (tip: join  sub-query)*/

SELECT t1.City, t1.SoldOrder, t3.TotalOrderQuantity
FROM
(SELECT e.City, e.EmployeeID, COUNT(o.OrderID) AS SoldOrder
FROM Employees e LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.City,e.EmployeeID) AS t1 
JOIN
(SELECT t2.City, SUM(t2.OrderQuantity) AS TotalOrderQuantity
FROM (SELECT c.City, od.OrderID, SUM(od.Quantity) AS OrderQuantity
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY od.OrderID, c.City) AS t2
GROUP BY t2.City) AS t3
ON t1.City = t3.City
ORDER BY t1.SoldOrder DESC, t3.TotalOrderQuantity DESC /*Need to fix*/


/*21*/
/*Using Distinct clause or using self join and where clause or subquery. Depending of the complexity of the problem.*/

