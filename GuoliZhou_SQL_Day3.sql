USE Northwind
GO

/*1.*/
/*SELECT p.ProductName AS Product, SUM(od.Quantity) AS TotalQuantity
FROM products p LEFT JOIN [Order Details] od on p.ProductID = od.ProductID
GROUP BY p.ProductName*/

CREATE VIEW view_product_order_zhou
AS
SELECT p.ProductName AS Product, SUM(od.Quantity) AS TotalQuantity
FROM products p LEFT JOIN [Order Details] od on p.ProductID = od.ProductID
GROUP BY p.ProductName

GO 

SELECT *
FROM view_product_order_zhou

/*2*/
GO 

CREATE PROC sp_product_order_quantity_zhou
@pID int,
@totalQ int OUT
AS
BEGIN 
	 SELECT @totalQ = dt.TotalQuantity
	 FROM
	(SELECT p.ProductID AS Product, SUM(od.Quantity) AS TotalQuantity
	FROM products p LEFT JOIN [Order Details] od on p.ProductID = od.ProductID
	GROUP BY p.ProductID) AS dt
	WHERE dt.Product = @pID
END

BEGIN
DECLARE @ans int
EXEC sp_product_order_quantity_zhou 1, @ans OUT
PRINT @ans
END

/*3*/
/*product name: input*/
GO

CREATE PROC sp_product_order_city_zhou
@pName INT,
@topCities varchar(20) OUT,
@totalQ INT OUT
AS
BEGIN
	SELECT TOP 5 @topCities = dt.City, @totalQ = dt.TotalQuantities
	FROM 
	(SELECT c.City AS City, SUM(od.Quantity) AS TotalQuantities, p.ProductName AS Product
	FROM Customers c LEFT JOIN Orders ord ON c.CustomerID = ord.CustomerID LEFT JOIN [Order Details] od ON ord.OrderID  = od.OrderID LEFT JOIN Products p ON od.ProductID = p.ProductID
	GROUP BY c.City,p.ProductName) dt
	WHERE dt.Product = @pName 
	
END
/*--*/

/*4*/
CREATE TABLE people_zhou
(
	ID int Primary Key,
	Name varchar(20),
	City int
)

INSERT INTO people_zhou
VALUES(1, 'Aaron Rodgers', 2)
INSERT INTO people_zhou
VALUES(2, 'Russell Wilson', 1)
INSERT INTO people_zhou
VALUES(3, 'Jody Nelson', 2)
/*SELECT *
FROM people_zhou*/

CREATE TABLE city_zhou
(
	ID int Primary Key,
	City varchar(20)
)

/*INSERT INTO Employee
VALUES(4, 'Fred', 45)*/

INSERT INTO city_zhou
VALUES(1, 'Seattle')

INSERT INTO city_zhou
VALUES(2, 'Green Bay')

SELECT *
FROM city_zhou

UPDATE city_zhou
SET City = 'Madison'
WHERE ID = 1

select *
from city_zhou

GO 

CREATE VIEW Packers_guoli
AS
SELECT pz.Name
FROM people_zhou pz JOIN city_zhou cz ON pz.City = cz.ID
WHERE cz.City = 'Green Bay'

SELECT *
FROM Packers_guoli

DROP TABLE city_zhou

DROP TABLE people_zhou

DROP VIEW Packers_guoli


/*5*/
SELECT MONTH(BirthDate)
FROM Employees

GO 

CREATE PROC sp_birthday_employees_zhou

AS
BEGIN

	SELECT dt.ID, dt.Name, dt.BirthMonth
	INTO birthday_employees_zhou
	FROM (SELECT EmployeeID AS ID, LastName + ' ' + FirstName AS Name,  MONTH(BirthDate) AS BirthMonth FROM Employees WHERE MONTH(BirthDate) = 2) dt

END

EXEC sp_birthday_employees_zhou

DROP TABLE birthday_employees_zhou

/*6*/
/**USING 'UNION' or If statement/