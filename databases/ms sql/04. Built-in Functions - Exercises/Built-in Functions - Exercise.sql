--01

SELECT FirstName, LastName FROM Employees
WHERE LEFT(FirstName, 2) = 'SA'


SELECT FirstName, LastName FROM Employees
WHERE FirstName LIKE 'SA%'

--02

SELECT FirstName, LastName FROM Employees
WHERE LastName LIKE '%EI%'

--03

SELECT FirstName FROM Employees
WHERE DepartmentID IN (3, 10) AND YEAR(HireDate) BETWEEN 1995 AND 2005

--04

SELECT FirstName, LastName FROM Employees
WHERE JobTitle NOT LIKE '%ENGINEER%'

--05

SELECT Name FROM Towns
WHERE LEN(Name) IN (5, 6)
ORDER BY Name

--06

SELECT * FROM Towns
WHERE LEFT(Name, 1) IN ('M', 'K', 'B', 'E')
ORDER BY Name

--07

SELECT * FROM Towns
WHERE LEFT(Name, 1) NOT IN ('R', 'B', 'D')
ORDER BY Name

--08

CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName FROM Employees
WHERE YEAR(HireDate) > 2000

--09

SELECT FirstName, LastName FROM Employees
WHERE LEN(LastName) = 5


--10

SELECT EmployeeID, FirstName, LastName, Salary, DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS Rank FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC

--11

SELECT * FROM
(SELECT EmployeeID, FirstName, LastName, Salary, DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS Rank FROM Employees
WHERE Salary BETWEEN 10000 AND 50000) AS A
WHERE Rank = 2
ORDER BY Salary DESC

--12
SELECT * FROM Countries

SELECT CountryName, IsoCode FROM Countries
WHERE LEN(CountryName) - LEN(REPLACE(CountryName, 'A', '')) >= 3
ORDER BY IsoCode

SELECT CountryName, IsoCode FROM Countries
WHERE CountryName LIKE '%A%A%A%'
ORDER BY IsoCode

--13

SELECT PeakName, RiverName, LOWER(PeakName + RIGHT(RiverName, LEN(RiverName) - 1)) AS Mix from Peaks, Rivers
WHERE RIGHT(PeakName, 1) = LEFT(RiverName, 1)
ORDER BY Mix

--14

SELECT TOP(50) Name, CONVERT(VARCHAR, Start, 23) AS Start FROM Games
WHERE YEAR(Start) IN ('2011', '2012')
ORDER BY Start, Name

--15

SELECT Username, SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email) - LEFT(CHARINDEX('@', Email), LEN(Email) - CHARINDEX('@', Email))+1) AS [Email Provider] FROM Users
ORDER BY [Email Provider], Username

--16

SELECT Username, IpAddress FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

--17

SELECT 
	[Name] AS 'Game',
	CASE 
		WHEN DATEPART(HOUR ,Start) BETWEEN 0 AND 11 THEN 'Morning'
		WHEN DATEPART(HOUR ,Start) BETWEEN 12 AND 17 THEN 'Afternoon'
		WHEN DATEPART(HOUR ,Start) BETWEEN 18 AND 23 THEN 'Evening'
	END AS 'Part of the Day', 
CASE 
		WHEN Duration <= 3 THEN 'Extra Short'
		WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
		WHEN Duration > 6 THEN 'Long'
		ELSE 'Extra Long'
	END AS 'Duration'
FROM Games
ORDER BY [Name], Duration

--18

SELECT ProductName, OrderDate, DATEADD(DAY, 3, OrderDate) AS [Pay Due], DATEADD(MONTH, 1, OrderDate) AS [Delivery Due] FROM Orders

--19

CREATE TABLE People(
Id INT not null PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50),
Birthdate DATE
)

INSERT INTO People([Name], Birthdate)
VALUES
	('Victor', '2000-12-07'),
	('Steven', '1992-09-10'),
	('Stephen', '1910-09-19'),
	('John', '2010-01-06')

SELECT 
	[Name],
	DATEDIFF(YEAR, Birthdate, GETDATE()) AS 'Age in Years',
	DATEDIFF(MONTH, Birthdate, GETDATE()) AS 'Age in Months',
	DATEDIFF(DAY, Birthdate, GETDATE()) AS 'Age in Days',
	DATEDIFF(MINUTE, Birthdate, GETDATE()) AS 'Age in Minutes'
FROM People
