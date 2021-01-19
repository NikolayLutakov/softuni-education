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

--11

SELECT MIN(AvgSalary) AS MInAverageSalary 
FROM (SELECT AVG(Salary) AS AvgSalary 
	FROM Employees
GROUP BY DepartmentID) AS SUB

--12


SELECT C.CountryCode, M.MountainRange, P.PeakName, P.Elevation FROM Countries AS C
JOIN MountainsCountries AS MC
ON MC.CountryCode = C.CountryCode
JOIN Mountains AS M
ON M.Id = MC.MountainId
JOIN Peaks AS P
ON P.MountainId = M.Id
WHERE C.CountryCode = 'BG' AND P.Elevation > 2835
ORDER BY P.Elevation DESC

--13

SELECT C.CountryCode, COUNT(M.MountainRange) AS MountainRanges FROM Countries AS C
JOIN MountainsCountries AS MC
ON C.CountryCode = MC.CountryCode
JOIN Mountains AS M
ON M.Id = MC.MountainId
WHERE C.CountryCode IN ('BG', 'US', 'RU')
GROUP BY C.CountryCode


--14

SELECT TOP(5) C.CountryName, R.RiverName FROM Countries AS C
LEFT JOIN CountriesRivers AS CR
ON CR.CountryCode = C.CountryCode
LEFT JOIN Rivers AS R
ON CR.RiverId = R.Id
WHERE C.ContinentCode = 'AF'
ORDER BY C.CountryName

--15

SELECT Usages.ContinentCode, Usages.CurrencyCode, Usages.Usage FROM
(SELECT ContinentCode, CurrencyCode, COUNT(*) AS Usage FROM Countries AS C
GROUP BY ContinentCode, CurrencyCode
HAVING COUNT(*) > 1) AS Usages
INNER JOIN
(SELECT usg.ContinentCode, MAX(usg.Usage) AS MaxUsage FROM
(SELECT ContinentCode, CurrencyCode, COUNT(*) AS Usage FROM Countries AS C
GROUP BY ContinentCode, CurrencyCode) AS usg
GROUP BY usg.ContinentCode) AS MaxUsages
ON MaxUsages.ContinentCode = Usages.ContinentCode AND MaxUsages.MaxUsage = Usages.Usage


--16

SELECT COUNT(C.CountryCode) AS [Count] FROM Countries AS C
LEFT JOIN MountainsCountries AS MC
ON MC.CountryCode = C.CountryCode
WHERE MC.MountainId IS NULL

--17

SELECT TOP(5) C.CountryName, MAX(P.Elevation) AS HighestPeakElevation, MAX(R.[Length]) AS LongestRiverLength FROM Countries AS C
LEFT JOIN MountainsCountries AS MC ON MC.CountryCode = C.CountryCode
LEFT JOIN Mountains AS M ON M.Id = MC.MountainId
LEFT JOIN Peaks AS P ON P.MountainId = M.Id
LEFT JOIN CountriesRivers AS CR ON CR.CountryCode = C.CountryCode
LEFT JOIN Rivers AS R ON R.Id = CR.RiverId
GROUP BY C.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, C.CountryName

--18

SELECT TOP(5) TopElevations.CountryName AS Country,
  ISNULL(PeaksMountains.PeakName, '(no highest peak)') AS HighestPeakName,
  ISNULL(TopElevations.HighestElevation, 0) AS HighestPeakElevation,	
  ISNULL(PeaksMountains.MountainRange, '(no mountain)') AS Mountain FROM
(SELECT PeaksMountains.CountryName, MAX(Elevation) AS HighestElevation
   FROM (SELECT c.CountryName, p.PeakName, p.Elevation, m.MountainRange
  FROM Countries AS c
  LEFT JOIN MountainsCountries as mc ON c.CountryCode = mc.CountryCode
  LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
  LEFT JOIN Peaks AS p ON p.MountainId = m.Id) AS PeaksMountains
   GROUP BY PeaksMountains.CountryName) AS TopElevations
LEFT JOIN
(SELECT c.CountryName, p.PeakName, p.Elevation, m.MountainRange
  FROM Countries AS c
  LEFT JOIN MountainsCountries as mc ON c.CountryCode = mc.CountryCode
  LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
  LEFT JOIN Peaks AS p ON p.MountainId = m.Id) AS PeaksMountains
ON TopElevations.CountryName = PeaksMountains.CountryName AND TopElevations.HighestElevation = PeaksMountains.Elevation
ORDER BY Country, HighestPeakName

--WITH PeaksMountains_CTE (Country, PeakName, Elevation, Mountain) AS (
--  SELECT c.CountryName, p.PeakName, p.Elevation, m.MountainRange
--  FROM Countries AS c
--  LEFT JOIN MountainsCountries as mc ON c.CountryCode = mc.CountryCode
--  LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
--  LEFT JOIN Peaks AS p ON p.MountainId = m.Id
--)
--SELECT TOP(5)
--  TopElevations.Country AS Country,
--  ISNULL(pm.PeakName, '(no highest peak)') AS HighestPeakName,
--  ISNULL(TopElevations.HighestElevation, 0) AS HighestPeakElevation,	
--  ISNULL(pm.Mountain, '(no mountain)') AS Mountain
--FROM 
--  (SELECT Country, MAX(Elevation) AS HighestElevation
--   FROM PeaksMountains_CTE 
--   GROUP BY Country) AS TopElevations
--LEFT JOIN PeaksMountains_CTE AS pm 
--ON (TopElevations.Country = pm.Country AND TopElevations.HighestElevation = pm.Elevation)
--ORDER BY Country, HighestPeakName