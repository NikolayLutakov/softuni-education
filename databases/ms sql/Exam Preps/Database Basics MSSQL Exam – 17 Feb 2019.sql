--CREATE DATABASE School
--USE School

--01

CREATE TABLE Students
(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(30) NOT NULL,
MiddleName NVARCHAR(25),
LastName NVARCHAR(30) NOT NULL,
Age INT CHECK (Age BETWEEN 5 AND 100) NOT NULL,
Address NVARCHAR(50),
Phone NCHAR(10)
)

CREATE TABLE Subjects
(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(20) NOT NULL,
Lessons INT NOT NULL CHECK (Lessons > 0)
)

CREATE TABLE StudentsSubjects
(
Id INT PRIMARY KEY IDENTITY,
StudentId INT NOT NULL REFERENCES Students(Id),
SubjectId INT NOT NULL REFERENCES Subjects(Id),
Grade DECIMAL(18,2) NOT NULL CHECK (Grade BETWEEN 2 AND 6)
)

CREATE TABLE Exams
(
Id INT PRIMARY KEY IDENTITY,
Date DATETIME,
SubjectId INT NOT NULL REFERENCES Subjects(Id)

)

CREATE TABLE StudentsExams
(
StudentId INT NOT NULL REFERENCES Students(Id),
ExamId INT NOT NULL REFERENCES Exams(Id),
Grade DECIMAL(18,2) NOT NULL CHECK (Grade BETWEEN 2 AND 6)
PRIMARY KEY (StudentId, ExamId)

)

CREATE TABLE Teachers
(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(20) NOT NULL,
LastName NVARCHAR(20) NOT NULL,
Address NVARCHAR(20) NOT NULL,
Phone NCHAR(10),
SubjectId INT NOT NULL REFERENCES Subjects(Id)
)

CREATE TABLE StudentsTeachers
(
StudentId INT NOT NULL REFERENCES Students(Id),
TeacherId INT NOT NULL REFERENCES Teachers(Id)
PRIMARY KEY (StudentId, TeacherId)
)

--02

INSERT INTO Teachers(FirstName,LastName, Address, Phone, SubjectId)
VALUES
('Ruthanne', 'Bamb', '84948 Mesta Junction', 3105500146, 6),
('Gerrard', 'Lowin', '370 Talisman Plaza', 3324874824, 2),
('Merrile', 'Lambdin', '81 Dahle Plaza', 4373065154, 5),
('Bert', 'Ivie', '2 Gateway Circle', 4409584510, 4)

INSERT INTO Subjects(Name, Lessons)
VALUES
('Geometry', 12),
('Health', 10),
('Drama', 7),
('Sports', 9)

--03

UPDATE StudentsSubjects
SET Grade = 6.00
WHERE SubjectId IN (1, 2) AND Grade >= 5.50

--04

DELETE StudentsTeachers
WHERE TeacherId IN (SELECT Id FROM Teachers WHERE Phone LIKE '%72%')

DELETE Teachers
WHERE Phone LIKE '%72%'

--05

SELECT FirstName, LastName, Age FROM Students WHERE Age >= 12
ORDER BY FirstName, LastName

--06

SELECT S.FirstName, S.LastName, COUNT(ST.TeacherId) AS TeachersCount FROM Students AS S
JOIN StudentsTeachers AS ST ON S.Id = ST.StudentId
GROUP BY S.FirstName, S.LastName

--07

SELECT S.FirstName + ' ' + S.LastName AS [Full Name] FROM Students AS S
LEFT JOIN StudentsExams AS SE ON S.Id = SE.StudentId
WHERE SE.ExamId IS NULL
ORDER BY [Full Name]

--08

SELECT TOP 10 S.FirstName, S.LastName, FORMAT(AVG(SE.Grade), 'N2') FROM Students AS S
JOIN StudentsExams AS SE ON S.Id = SE.StudentId
GROUP BY S.FirstName, S.LastName
ORDER BY AVG(SE.Grade) DESC, S.FirstName, S.LastName

--09

SELECT S.FirstName + ' ' + ISNULL(S.MiddleName + ' ', '') + S.LastName AS [Full Name] FROM Students AS S
LEFT JOIN StudentsSubjects AS SJ ON SJ.StudentId = S.Id
WHERE SJ.Id IS NULL
ORDER BY [Full Name]

--10

SELECT A.Name, A.Avg FROM 
(SELECT S.Id ,S.Name ,AVG(Grade) AS [Avg] FROM Subjects AS S
JOIN StudentsSubjects AS SJ ON S.Id = SJ.SubjectId 
GROUP BY S.Id ,S.Name) AS A
ORDER BY A.Id

--11
GO

CREATE FUNCTION udf_ExamGradesToUpdate(@studentId INT, @grade DECIMAL(10,2))
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @result NVARCHAR(MAX)
		
	IF (NOT EXISTS (SELECT * FROM Students WHERE Id = @studentId))
	BEGIN
		SET @result = 'The student with provided id does not exist in the school!'
		RETURN @result
	END

	IF(@grade > 6.00)
	BEGIN
		SET @result = 'Grade cannot be above 6.00!'
		RETURN @result
	END
		
	DECLARE @fName NVARCHAR(MAX) = (SELECT FirstName FROM Students WHERE Id = @studentId)
	DECLARE @gradesCount INT = (SELECT COUNT(*) FROM Students AS S JOIN StudentsExams AS SE ON SE.StudentId = S.Id
								WHERE (Grade BETWEEN @grade AND  (@grade + 0.50)) AND S.Id = @studentId)
	
	SET @result = 'You have to update ' + CONVERT(NVARCHAR(MAX), @gradesCount) + ' grades for the student ' + @fName
	RETURN @result
END

GO

SELECT dbo.udf_ExamGradesToUpdate(12, 6.20)
SELECT dbo.udf_ExamGradesToUpdate(12, 5.50)
SELECT dbo.udf_ExamGradesToUpdate(121, 5.50)

--12
GO

CREATE PROC usp_ExcludeFromSchool(@StudentId INT)
AS
BEGIN

	IF(NOT EXISTS(SELECT * FROM Students WHERE Id = @StudentId))
		THROW 50001, 'This school has no student with the provided id!', 1

	DELETE StudentsTeachers WHERE StudentId = @StudentId
	DELETE StudentsSubjects WHERE StudentId = @StudentId
	DELETE StudentsExams WHERE StudentId = @StudentId
	DELETE Students WHERE Id = @StudentId


END

GO