--01

SELECT TOP(5) E.EmployeeID, E.JobTitle, A.AddressID, A.AddressText FROM Employees AS E JOIN Addresses AS A
ON E.AddressID = A.AddressID
ORDER BY A.AddressID

--02

SELECT TOP(50) FirstName, LastName, T.Name, A.AddressText 
FROM Employees AS E 
JOIN Addresses AS A ON E.AddressID = A.AddressID
JOIN Towns AS T ON A.TownID = T.TownID
ORDER BY FirstName, LastName

--03

SELECT E.EmployeeID, E.FirstName, E.LastName, D.Name FROM Employees AS E
JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
WHERE D.Name = 'Sales'
ORDER BY EmployeeID

--04

SELECT TOP(5) E.EmployeeID, E.FirstName, E.Salary, D.Name FROM Employees AS E
JOIN Departments AS D
ON E.DepartmentID = D.DepartmentID
WHERE Salary > 15000
ORDER BY D.DepartmentID

--05

SELECT TOP(3) E.EmployeeID, E.FirstName FROM Employees AS E
FULL JOIN EmployeesProjects AS EP
ON EP.EmployeeID = E.EmployeeID
FULL JOIN Projects AS P
ON P.ProjectID = EP.ProjectID
WHERE EP.EmployeeID IS NULL AND E.EmployeeID IS NOT NULL
ORDER BY E.EmployeeID

SELECT TOP(3) E.EmployeeID, E.FirstName FROM Employees AS E
LEFT JOIN EmployeesProjects AS EP
ON EP.EmployeeID = E.EmployeeID
WHERE EP.EmployeeID IS NULL

--06

SELECT E.FirstName, E.LastName, E.HireDate, D.Name FROM Employees AS E
JOIN Departments AS D
ON D.DepartmentID = E.DepartmentID
WHERE E.HireDate > '1999.01.01' AND D.Name IN ('Sales', 'Finance')
ORDER BY HireDate

--07

SELECT TOP(5) E.EmployeeID, E.FirstName, P.Name AS ProjectName FROM Employees AS E
JOIN EmployeesProjects AS EP
ON EP.EmployeeID = E.EmployeeID
JOIN Projects AS P
ON P.ProjectID = EP.ProjectID
WHERE P.StartDate > '2002.08.13' AND EndDate IS NULL
ORDER BY EmployeeID

--08

SELECT E.EmployeeID, E.FirstName, 
CASE
	WHEN YEAR(P.StartDate) >= 2005 THEN NULL
	ELSE P.Name
	END
AS ProjectName FROM Employees AS E
JOIN EmployeesProjects AS EP
ON E.EmployeeID = EP.EmployeeID
JOIN Projects AS P
ON EP.ProjectID = P.ProjectID
WHERE E.EmployeeID = 24

--09

SELECT E.EmployeeID, E.FirstName, E.ManagerID, EM.FirstName FROM Employees AS E
JOIN Employees AS EM
ON E.ManagerID = EM.EmployeeID
WHERE E.ManagerID IN(3, 7)
ORDER BY E.EmployeeID

--10

SELECT TOP (50) E.EmployeeID, E.FirstName + ' ' + E.LastName AS EmployeeName, EM.FirstName + ' ' + EM.LastName AS ManagerName, D.Name FROM Employees AS E
JOIN Employees AS EM
ON E.ManagerID = EM.EmployeeID
JOIN Departments AS D
ON E.DepartmentID = D.DepartmentID
ORDER BY E.EmployeeID

