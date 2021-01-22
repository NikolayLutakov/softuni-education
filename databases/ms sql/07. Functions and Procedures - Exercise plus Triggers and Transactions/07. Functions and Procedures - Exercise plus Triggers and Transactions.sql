--01

CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
	SELECT FirstName, LastName FROM Employees
	WHERE Salary > 35000

EXEC usp_GetEmployeesSalaryAbove35000

--02

CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber @PARAMETER DECIMAL(18, 4)
AS
	SELECT FirstName, LastName FROM Employees
	WHERE Salary >= @PARAMETER

EXEC usp_GetEmployeesSalaryAboveNumber @PARAMETER = 30000

--03

CREATE PROCEDURE usp_GetTownsStartingWith @PARAM VARCHAR(50)
AS
	SELECT [Name] FROM Towns
	WHERE [Name] LIKE @PARAM + '%'

EXEC usp_GetTownsStartingWith @PARAM = BELL

--04

CREATE PROCEDURE usp_GetEmployeesFromTown @PARAM VARCHAR(30)
AS

	SELECT FirstName, LastName FROM Employees AS E
	JOIN Addresses AS A
	ON A.AddressID = E.AddressID
	JOIN Towns AS T
	ON T.TownID = A.TownID
	WHERE T.Name = @PARAM

EXEC usp_GetEmployeesFromTown @PARAM = ''


--05

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))  
RETURNS VARCHAR(20)   
AS     
BEGIN  
    DECLARE @RESULT VARCHAR(20)

	IF(@salary < 30000)
	BEGIN
		SET @RESULT = 'Low'
	END

	IF(@salary BETWEEN 30000 AND 50000)
	BEGIN
		SET @RESULT = 'Average'
	END
	
	IF(@salary > 50000)
	BEGIN
		SET @RESULT = 'High'
	END
	
    RETURN @RESULT;  
END; 

SELECT Salary, dbo.ufn_GetSalaryLevel(Salary) FROM Employees

--06

CREATE PROCEDURE usp_EmployeesBySalaryLevel @PARAM varchar(30)
AS
	SELECT FirstName, LastName FROM Employees
	WHERE dbo.ufn_GetSalaryLevel(Salary) = @PARAM

--07

CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(MAX), @word VARCHAR(MAX))
RETURNS BIT
AS
BEGIN
  DECLARE @isComprised bit = 0;
  DECLARE @currentIndex int = 1;
  DECLARE @currentChar char;

  WHILE(@currentIndex <= LEN(@word))
  BEGIN
    SET @currentChar = SUBSTRING(@word, @currentIndex, 1);
    IF(CHARINDEX(@currentChar, @setOfLetters) = 0)
      RETURN @isComprised;
    SET @currentIndex += 1;
  END
  RETURN @isComprised + 1;
END

--08

CREATE PROCEDURE usp_DeleteEmployeesFromDepartment(@departmentId INT)
AS
	ALTER TABLE Departments
	ALTER COLUMN ManagerID INT NULL

	UPDATE Departments
	SET ManagerID = NULL
	WHERE ManagerID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)

	DELETE EmployeesProjects
	WHERE EmployeeID IN (SELECT EmployeeID FROM Employees
	WHERE DepartmentID = @departmentId)

	UPDATE Employees
	SET ManagerID = NULL
	WHERE ManagerID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)

	DELETE Employees WHERE DepartmentID = @departmentId

	DELETE Departments
	WHERE DepartmentID = @departmentId

	SELECT COUNT(*) AS [Count] FROM Employees
	WHERE DepartmentID = @departmentId


EXEC usp_DeleteEmployeesFromDepartment @departmentId = 2

--09

CREATE PROCEDURE usp_GetHoldersFullName
AS
	SELECT CONCAT(FirstName, ' ', LastName) AS [Full Name] FROM AccountHolders

--10

CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan @param money
AS
	SELECT AH.FirstName, AH.LastName FROM AccountHolders AS AH
	JOIN Accounts AS A
	ON A.AccountHolderId = AH.Id
	GROUP BY AH.FirstName, AH.LastName
	HAVING SUM(A.Balance) > @param
	ORDER BY AH.FirstName, AH.LastName

--11

CREATE FUNCTION ufn_CalculateFutureValue(@sum decimal(18, 4), @yearlyInterestRate float, @numberOfYears int)
RETURNS DECIMAL(18, 4)
AS
BEGIN
	DECLARE @result DECIMAL(18, 4) = 0.0

	SET @result = @sum * (POWER(1 + @yearlyInterestRate, @numberOfYears))


	RETURN @result
END

--12

CREATE PROCEDURE usp_CalculateFutureValueForAccount @AccountId INT, @interest FLOAT
AS
	SELECT AC.Id AS [Account Id], FirstName AS [First Name], AC.LastName AS [Last Name], A.Balance AS [Current Balance], DBO.ufn_CalculateFutureValue(A.Balance, @interest, 5) AS [Balance in 5 years] FROM AccountHolders AS AC
	JOIN Accounts AS A
	ON A.AccountHolderId = AC.Id
	WHERE A.Id = @AccountId

EXEC usp_CalculateFutureValueForAccount 1, 0.1

--13

CREATE FUNCTION ufn_CashInUsersGames(@game varchar(max))
RETURNS TABLE
AS
RETURN
	SELECT SUM(Cash) AS [SumCash] FROM
	(SELECT Cash, ROW_NUMBER() OVER (ORDER BY Cash DESC)AS [Row Number] FROM UsersGames AS UG
	JOIN Games AS G
	ON G.Id = UG.GameId
	WHERE G.Name = @game) AS [Games]
	WHERE [Row Number] % 2 != 0

SELECT * FROM ufn_CashInUsersGames('Love in a mist')

--14

CREATE TABLE Logs(
LogId INT PRIMARY KEY IDENTITY,
AccountId INT NOT NULL REFERENCES Accounts(Id),
OldSum DECIMAL(18,2) NOT NULL,
NewSum DECIMAL(18,2) NOT NULL
)

CREATE TRIGGER tr_BalanceCahnge ON Accounts FOR UPDATE
AS
	BEGIN
		DECLARE @accountId INT = (SELECT Id FROM inserted)
		DECLARE @oldBalance DECIMAL(18,2) = (SELECT Balance FROM deleted)
		DECLARE @newBalance DECIMAL(18,2) = (SELECT Balance FROM inserted)

		IF(@oldBalance != @newBalance)
		BEGIN
			INSERT INTO Logs(AccountId, OldSum, NewSum)
			VALUES (@accountId, @oldBalance, @newBalance)
		END
END

--15

CREATE TABLE NotificationEmails(
Id INT PRIMARY KEY IDENTITY, 
Recipient INT NOT NULL, 
Subject VARCHAR(MAX), 
Body VARCHAR(MAX)
)

CREATE TRIGGER tr_SendEmail ON Logs FOR INSERT
AS
BEGIN
	DECLARE @Recipient  INT = (SELECT AccountId FROM inserted)
	DECLARE @OldBalance DECIMAL(18,2) = (SELECT OldSum FROM inserted)
	DECLARE @NewBalance DECIMAL(18,2) = (SELECT NewSum FROM inserted)
	DECLARE @Subject VARCHAR(MAX)  = CONCAT('Balance change for account: ', @Recipient)
	DECLARE @Body VARCHAR(MAX) = CONCAT('On ', GETDATE(), ' your balance was changed from ', @OldBalance, ' to ', @NewBalance, '.')

	INSERT INTO NotificationEmails(Recipient, Subject, Body)
	VALUES (@Recipient, @Subject, @Body)
END

SELECT * FROM Accounts
SELECT * FROM Logs
SELECT * FROM NotificationEmails
UPDATE Accounts
SET Balance = 123.12
WHERE Id = 1

--16

CREATE PROCEDURE usp_DepositMoney @AccountId INT, @MoneyAmount DECIMAL(18, 4)
AS
BEGIN
	BEGIN TRANSACTION
	UPDATE Accounts
	SET Balance += @MoneyAmount
	WHERE Id = @AccountId
		IF(@@ROWCOUNT != 1)
		BEGIN
			ROLLBACK
			RAISERROR ('Invalid account!', 16, 1);
			RETURN
		END
	COMMIT
END

--17

CREATE PROCEDURE usp_WithdrawMoney  @AccountId INT, @MoneyAmount DECIMAL(18, 4)
AS
BEGIN
	BEGIN TRANSACTION
	UPDATE Accounts
	SET Balance -= @MoneyAmount
	WHERE Id = @AccountId
		IF(@@ROWCOUNT != 1)
		BEGIN
			ROLLBACK
			RAISERROR ('Invalid account!', 16, 1);
			RETURN
		END
	COMMIT
END

--18

CREATE PROCEDURE usp_TransferMoney @SenderId INT, @ReceiverId INT, @Amount DECIMAL(18, 4)
AS
BEGIN
	BEGIN TRANSACTION 
		EXEC usp_WithdrawMoney @SenderId, @Amount
		EXEC usp_DepositMoney @ReceiverId, @Amount
	COMMIT
END

--19
-- TO BE SOLVED BY MYSELF WITHOUT HELP!!!
DECLARE @gameName nvarchar(50) = 'Safflower';
DECLARE @username nvarchar(50) = 'Stamat';
DECLARE @userGameId int = (
  SELECT ug.Id 
  FROM UsersGames AS ug
  JOIN Users AS u ON ug.UserId = u.Id
  JOIN Games AS g ON ug.GameId = g.Id
  WHERE u.Username = @username AND g.Name = @gameName
);
DECLARE @userGameLevel int = (SELECT Level FROM UsersGames WHERE Id = @userGameId);
DECLARE @itemsCost money, @availableCash money, @minLevel int, @maxLevel int;

-- Buy items from LEVEL 11-12
SET @minLevel = 11; SET @maxLevel = 12;
SET @availableCash = (SELECT Cash FROM UsersGames WHERE Id = @userGameId);
SET @itemsCost = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel);

/* begin transaction only if: enough game cash to buy all requested items & 
   high enough user game level to meet item minlevel requirement */
IF (@availableCash >= @itemsCost AND @userGameLevel >= @maxLevel) 
BEGIN 
  BEGIN TRANSACTION  
  UPDATE UsersGames SET Cash -= @itemsCost WHERE Id = @userGameId; 
  IF(@@ROWCOUNT <> 1) 
  BEGIN
    ROLLBACK; RAISERROR('Could not make payment', 16, 1); --RETURN;
  END
  ELSE
  BEGIN
    INSERT INTO UserGameItems (ItemId, UserGameId) 
    (SELECT Id, @userGameId FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) 
    IF((SELECT COUNT(*) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) <> @@ROWCOUNT)
    BEGIN
      ROLLBACK; RAISERROR('Could not buy items', 16, 1); --RETURN;
    END	
    ELSE COMMIT;
  END
END

-- Buy items from LEVEL 19-21
SET @minLevel = 19; SET @maxLevel = 21;
SET @availableCash = (SELECT Cash FROM UsersGames WHERE Id = @userGameId);
SET @itemsCost = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel);

/* begin transaction only if: enough game cash to buy all requested items & 
   high enough user game level to meet item minlevel requirement */
IF (@availableCash >= @itemsCost AND @userGameLevel >= @maxLevel) 
BEGIN 
  BEGIN TRANSACTION  
  UPDATE UsersGames SET Cash -= @itemsCost WHERE Id = @userGameId; 
  IF(@@ROWCOUNT <> 1) 
  BEGIN
    ROLLBACK; RAISERROR('Could not make payment', 16, 1); --RETURN;
  END
  ELSE
  BEGIN
    INSERT INTO UserGameItems (ItemId, UserGameId) 
    (SELECT Id, @userGameId FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) 
    IF((SELECT COUNT(*) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) <> @@ROWCOUNT)
    BEGIN
      ROLLBACK; RAISERROR('Could not buy items', 16, 1); --RETURN;
    END	
    ELSE COMMIT;
  END
END

-- select items in game
SELECT i.Name AS [Item Name]
FROM UserGameItems AS ugi
JOIN Items AS i ON i.Id = ugi.ItemId
JOIN UsersGames AS ug ON ug.Id = ugi.UserGameId
JOIN Games AS g ON g.Id = ug.GameId
WHERE g.Name = @gameName
ORDER BY [Item Name]

--20

CREATE PROCEDURE usp_AssignProject @emloyeeId INT, @projectID INT
AS
BEGIN
	BEGIN TRANSACTION	
		
		DECLARE @projectsCount INT = (SELECT COUNT(*) FROM Employees AS E
		JOIN EmployeesProjects AS EP
		ON E.EmployeeID = EP.EmployeeID
		JOIN Projects AS P
		ON P.ProjectID = EP.ProjectID
		WHERE E.EmployeeID = @emloyeeId)
		
		IF(@projectsCount >= 3)
		BEGIN
			RAISERROR('The employee has too many projects!', 16, 1)
			ROLLBACK;
			RETURN
		END
		ELSE
		BEGIN

		INSERT INTO EmployeesProjects(EmployeeID, ProjectID)
		VALUES (@emloyeeId, @projectID)
		END
		IF(@@ROWCOUNT != 1)
		BEGIN
		ROLLBACK
		RETURN
		END
	COMMIT
	RETURN
END
	
--21

CREATE TABLE Deleted_Employees(
EmployeeId INT PRIMARY KEY, 
FirstName VARCHAR(50), 
LastName VARCHAR(50), 
MiddleName VARCHAR(50), 
JobTitle VARCHAR(50), 
DepartmentId INT, 
Salary DECIMAL(18,2)
)
select * from Employees
DROP TRIGGER tr_Deleted_Employees
CREATE TRIGGER tr_Deleted_Employees ON Employees FOR DELETE
AS
	INSERT INTO Deleted_Employees SELECT FirstName, LastName, MiddleName, JobTitle, DepartmentID, Salary FROM deleted
