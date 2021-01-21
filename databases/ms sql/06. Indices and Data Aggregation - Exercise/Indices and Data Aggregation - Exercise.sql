--01

SELECT COUNT(*) AS [Count] FROM WizzardDeposits

--02

SELECT MAX(MagicWandSize) AS [LongestMagicWand] FROM WizzardDeposits

--03

SELECT DepositGroup, MAX(MagicWandSize) AS [LongestMagicWand] FROM WizzardDeposits
GROUP BY DepositGroup

--04

SELECT TOP 2 DepositGroup FROM
(SELECT DepositGroup, AVG(MagicWandSize) AS [AVG] FROM WizzardDeposits
GROUP BY DepositGroup
) AS [Sizes]
ORDER BY [AVG]

--05

SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum] FROM WizzardDeposits
GROUP BY DepositGroup

--06

SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum] FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

--07

SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum] FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family' 
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY [TotalSum] DESC

--08

SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS [MinDepositCharge] FROM WizzardDeposits
GROUP BY MagicWandCreator, DepositGroup
ORDER BY MagicWandCreator, DepositGroup

--09 

SELECT 
	CASE 
		WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
		WHEN Age > 60 THEN '[61+]'
	END AS [AgeGroup], COUNT(*) AS [WizardCount]
FROM WizzardDeposits
GROUP BY
	CASE 
		WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
		WHEN Age > 60 THEN '[61+]'
	END
--10

SELECT LEFT(FirstName, 1) AS [FirstLetter] FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
GROUP BY LEFT(FirstName, 1)
ORDER BY [FirstLetter]

--11

SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) FROM WizzardDeposits
WHERE DepositStartDate > '1985-01-01'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired 

--12

DECLARE @SUM DECIMAL(10, 2) = 0
DECLARE @HOST DECIMAL(10, 2) = 0
DECLARE @GUEST DECIMAL(10, 2) = 0
DECLARE db_cursor CURSOR FOR
	SELECT DepositAmount FROM WizzardDeposits
OPEN db_cursor
	FETCH NEXT FROM db_cursor INTO @HOST

WHILE @@FETCH_STATUS = 0 
BEGIN
	FETCH NEXT FROM db_cursor INTO @GUEST
	SET @SUM = (@HOST - @GUEST)
END

CLOSE db_cursor  
DEALLOCATE db_cursor 

SELECT @SUM AS SumDifference

--13

SELECT DepartmentID, SUM(Salary) AS [TotalSalary] FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

--14 

SELECT DepartmentID, MIN(Salary) AS [MinimumSalary] FROM Employees
WHERE DepartmentID IN (2, 5, 7) AND HireDate > '2000-01-01'
GROUP BY DepartmentID

--15

SELECT * INTO [Task15Table] FROM Employees
WHERE Salary >30000

DELETE [Task15Table]
WHERE ManagerID = 42

UPDATE [Task15Table]
SET Salary += 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS [AverageSalary] FROM[Task15Table]
GROUP BY DepartmentID

--16

SELECT DepartmentID, MAX(Salary) AS [MaxSalary] FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000


--17

SELECT COUNT(Salary) AS [Count] FROM Employees
WHERE ManagerID IS NULL

--18

SELECT DepartmentID, Salary FROM
(SELECT DepartmentID, Salary, DENSE_RANK() OVER (PARTITION BY DepartmentId ORDER BY Salary DESC) AS Rank
FROM Employees
GROUP BY DepartmentID, Salary) AS [S]
WHERE S.Rank = 3

--19

SELECT TOP 10 FirstName, LastName, E.DepartmentID FROM Employees AS E 
JOIN
(SELECT DepartmentID, AVG(Salary) AS [AverageSalary] FROM Employees
GROUP BY DepartmentID) AS [S]
ON E.DepartmentID = S.DepartmentID
WHERE E.Salary > S.AverageSalary
ORDER BY E.DepartmentID