--01

--CREATE DATABASE Bitbucket
--USE Bitbucket

CREATE TABLE Users
(
Id INT PRIMARY KEY IDENTITY,
Username VARCHAR(30) NOT NULL,
Password VARCHAR(30) NOT NULL,
Email VARCHAR(50) NOT NULL

)


CREATE TABLE Repositories
(
Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL

)


CREATE TABLE RepositoriesContributors
(
RepositoryId INT NOT NULL REFERENCES Repositories(Id),
ContributorId INT NOT NULL REFERENCES Users(Id)
PRIMARY KEY (RepositoryId, ContributorId)

)

CREATE TABLE Issues
(
Id INT PRIMARY KEY IDENTITY,
Title VARCHAR(255) NOT NULL,
IssueStatus CHAR(6) NOT NULL,
RepositoryId INT NOT NULL REFERENCES Repositories(Id),
AssigneeId INT NOT NULL REFERENCES Users(Id)

)

CREATE TABLE Commits
(
Id INT PRIMARY KEY IDENTITY,
Message  VARCHAR(255) NOT NULL,
IssueId INT REFERENCES Issues(Id),
RepositoryId INT NOT NULL REFERENCES Repositories(Id),
ContributorId INT NOT NULL REFERENCES Users(Id)

)

CREATE TABLE Files
(
Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(100) NOT NULL,
Size DECIMAL(18,2) NOT NULL,
ParentId INT REFERENCES Files(Id),
CommitId INT NOT NULL REFERENCES Commits(Id)

)

--02

INSERT INTO Files(Name, Size, ParentId, CommitId)
VALUES 
('Trade.idk', 2598.0, 1, 1),
('menu.net', 9238.31, 2, 2),
('Administrate.soshy', 1246.93, 3, 3),
('Controller.php', 7353.15, 4, 4),
('Find.java', 9957.86, 5, 5),
('Controller.json', 14034.87, 3, 6),
('Operate.xix', 7662.92, 7, 7)


INSERT INTO Issues(Title, IssueStatus, RepositoryId, AssigneeId)
VALUES
('Critical Problem with HomeController.cs file', 'open', 1, 4),
('Typo fix in Judge.html', 'open', 4, 3),
('Implement documentation for UsersService.cs', 'closed', 8, 2),
('Unreachable code in Index.cs', 'open', 9, 8)


--03

UPDATE Issues
SET IssueStatus = 'closed'
WHERE AssigneeId = 6

--04

-- ID = 3
--SELECT * FROM RepositoriesContributors
--SELECT * FROM Issues
SELECT Id FROM Commits WHERE RepositoryId = 3
SELECT * FROM Files

DELETE RepositoriesContributors
WHERE RepositoryId = 3

UPDATE Files
SET ParentId = NULL
WHERE CommitId IN (SELECT Id FROM Commits WHERE RepositoryId = 3)

DELETE Files 
WHERE CommitId IN (SELECT Id FROM Commits WHERE RepositoryId = 3)

DELETE Commits
WHERE RepositoryId = 3

DELETE Issues
WHERE RepositoryId = 3

DELETE Repositories
WHERE Id = 3

--05

SELECT Id, Message, RepositoryId, ContributorId FROM Commits
ORDER BY Id, Message, RepositoryId, ContributorId

--06

SELECT Id, Name, Size FROM Files
WHERE Size > 1000 AND Name LIKE '%HTML%'
ORDER BY Size DESC, Id, Name

--07

SELECT I.Id, CONCAT(U.Username, ' : ', I.Title) AS IssueAssignee FROM Issues AS I
JOIN Users AS U ON I.AssigneeId = U.Id
ORDER BY I.Id DESC, I.AssigneeId 

--08
SELECT * FROM Files

SELECT Id, Name, CONVERT(VARCHAR(MAX), Size) + 'KB' AS Size FROM Files
WHERE Id NOT IN (SELECT DISTINCT ISNULL(ParentId, 0) FROM Files)
ORDER BY Id, Name, Size DESC

--09

SELECT * FROM Commits WHERE RepositoryId = 2

SELECT TOP(5) R.Id, R.Name, COUNT(*) AS Commits FROM Repositories AS R
JOIN Commits AS C ON C.RepositoryId = R.Id
JOIN RepositoriesContributors AS RC ON RC.RepositoryId = R.Id
JOIN Users AS U ON U.Id = RC.ContributorId
GROUP BY R.Id, R.Name
ORDER BY COUNT(*) DESC, R.Id, R.Name

--10
SELECT A.Username, [AVG] AS Size FROM
(SELECT U.Id, U.Username, AVG(F.Size) AS [AVG] FROM Users AS U
JOIN Commits AS C ON U.Id = C.ContributorId
JOIN Files AS F ON F.CommitId = C.Id
GROUP BY U.Id, U.Username) AS A
ORDER BY A.AVG DESC, A.Username

--11
GO
CREATE FUNCTION udf_AllUserCommits(@username VARCHAR(30))
RETURNS INT
AS
BEGIN
	DECLARE @result int

	SET @result = (select COUNT(*) FROM Users AS U JOIN Commits AS C ON U.Id = C.ContributorId WHERE U.Username = @username)

	RETURN @result
END
GO
SELECT dbo.udf_AllUserCommits('UnderSinduxrein')

--12
GO

CREATE OR ALTER PROC usp_SearchForFiles(@fileExtension VARCHAR(MAX))
AS
BEGIN
	SELECT Id, Name, (CONVERT(VARCHAR(MAX),Size) + 'KB') AS Size FROM Files WHERE Name LIKE ('%.' + @fileExtension)
	ORDER BY Id, Name, Size DESC
END

EXEC usp_SearchForFiles 'txt'