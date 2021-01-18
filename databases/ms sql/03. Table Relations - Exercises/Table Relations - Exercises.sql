--01

CREATE TABLE Persons(
PersonID INT NOT NULL,
FirstName NVARCHAR(20),
Sallary DECIMAL(20, 2),
PassportID INT
)

CREATE TABLE Passports(
PassportID INT NOT NULL,
PassportNumber NVARCHAR(20)
)

ALTER TABLE Passports
ADD CONSTRAINT PK_PassportID PRIMARY KEY(PassportID)

ALTER TABLE Persons
ADD CONSTRAINT PK_PersonID PRIMARY KEY(PersonID),
CONSTRAINT FK_PassportID_PassportID FOREIGN KEY (PassportID) REFERENCES Passports(PassportID)

INSERT INTO Passports(PassportID, PassportNumber)
VALUES
	(101, 'N34FG21B'),
	(102, 'K65LO4R7'),
	(103, 'ZE657QP2')

INSERT INTO Persons(PersonID, FirstName, Sallary, PassportID)
VALUES
	(1, 'Roberto', 43300, 102),
	(2, 'Tom', 56100, 103),
	(3, 'Yana', 60200, 101)


--02

CREATE TABLE Manufacturers(
ManufacturerID INT NOT NULL,
Name NVARCHAR(20) NOT NULL,
EstablishedOn DATE
)

CREATE TABLE Models(
ModelID INT NOT NULL,
Name NVARCHAR(20) NOT NULL,
ManufacturerID INT NOT NULL
)

ALTER TABLE Manufacturers
ADD CONSTRAINT PK_Manufacturers PRIMARY KEY(ManufacturerID)

ALTER TABLE Models
ADD CONSTRAINT PK_Models PRIMARY KEY(ModelID),
CONSTRAINT FK_Models_Manufacturers FOREIGN KEY(ManufacturerID) REFERENCES Manufacturers(ManufacturerID)


INSERT INTO Manufacturers
VALUES
	(1, 'BMW', '19160703'),
	(2, 'Tesla', '20030101'),
	(3, 'Lada', '19660501')

	
INSERT INTO Models
VALUES
	(101, 'X1', 1),
	(102, 'i6', 1),
	(103, 'Model S', 2),
	(104, 'Model X', 2),
	(105, 'Model 3', 2),
	(106, 'Nova', 3)


--03

CREATE TABLE Students(
StudentID INT PRIMARY KEY,
Name NVARCHAR(20) NOT NULL
)

CREATE TABLE Exams(
ExamID INT PRIMARY KEY,
Name NVARCHAR(20) NOT NULL
)

CREATE TABLE StudentsExams(
StudentID INT NOT NULL,
ExamID INT NOT NULL,
PRIMARY KEY(StudentID, ExamID),
FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
)

INSERT INTO Students
VALUES
	(1, 'Mila'),
	(2, 'Toni'),
	(3, 'Ron')

INSERT INTO Exams
VALUES
	(101, 'SpringMVC'),
	(102, 'Neo4j'),
	(103, 'Oracle 11g')

INSERT INTO StudentsExams
VALUES
	(1, 101),
	(1, 102),
	(2, 101),
	(3, 103),
	(2, 102),
	(2, 103)

--04

CREATE TABLE Teachers(
TeacherID INT PRIMARY KEY,
Name NVARCHAR(50) NOT NULL,
ManagerID INT REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers
VALUES
	(101, 'John', NULL),
	(102, 'Maya', 106),
	(103, 'Silvia', 106),
	(104, 'Ted', 105),
	(105, 'Mark', 101),
	(106, 'Greta', 101)


--05

CREATE TABLE Cities(
CityID INT PRIMARY KEY,
Name VARCHAR(50)
)

CREATE TABLE Customers(
CustomerID INT PRIMARY KEY,
Name VARCHAR(50),
Birthday DATE,
CityID INT REFERENCES Cities(CityID)
)

CREATE TABLE Orders(
OrderID INT PRIMARY KEY,
CustomerID INT REFERENCES Customers(CustomerID)
)

CREATE TABLE ItemTypes(
ItemTypeID INT PRIMARY KEY,
Name VARCHAR(50)
)

CREATE TABLE Items(
ItemID INT PRIMARY KEY,
Name VARCHAR(50),
ItemTypeID INT REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE OrderItems(
OrderID INT NOT NULL,
ItemID INT NOT NULL,
PRIMARY KEY(OrderID, ItemID),
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
)

--06

CREATE TABLE Subjects(
SubjectID INT PRIMARY KEY,
SubjectName NVARCHAR(50)
)


CREATE TABLE Majors(
MajorID INT PRIMARY KEY,
Name NVARCHAR(50)
)

CREATE TABLE Students(
StudentID INT PRIMARY KEY,
StudentNumber INT,
StudentName NVARCHAR(50),
MajorID INT REFERENCES Majors(MajorID)
)

CREATE TABLE Payments(
PaimentID INT PRIMARY KEY,
PaymentDate DATE,
PaymentAmount DECIMAL,
StudentID INT REFERENCES Students(StudentID)
)

CREATE TABLE Agenda(
StudentID INT NOT NULL,
SubjectID INT NOT NULL,
PRIMARY KEY (StudentID, SubjectID),
FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
)

--09

SELECT M.MountainRange, P.PeakName, P.Elevation FROM Peaks AS P
JOIN Mountains AS M ON P.MountainId = M.Id
WHERE M.Id = 17
ORDER BY P.Elevation DESC