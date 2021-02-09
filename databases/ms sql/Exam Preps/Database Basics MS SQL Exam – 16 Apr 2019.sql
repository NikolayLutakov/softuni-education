--CREATE DATABASE Airport
--USE Airport

--01

CREATE TABLE Planes
(
Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(30) NOT NULL,
Seats INT NOT NULL,
Range INT NOT NULL
)

CREATE TABLE Flights
(
Id INT PRIMARY KEY IDENTITY,
DepartureTime DATETIME,
ArrivalTime DATETIME,
Origin VARCHAR(50) NOT NULL,
Destination VARCHAR(50) NOT NULL,
PlaneId INT NOT NULL REFERENCES Planes(Id)
)

CREATE TABLE Passengers
(
Id INT PRIMARY KEY IDENTITY,
FirstName VARCHAR(30) NOT NULL,
LastName VARCHAR(30) NOT NULL,
Age INT NOT NULL,
Address VARCHAR(30) NOT NULL,
PassportId VARCHAR(11) NOT NULL
)

CREATE TABLE LuggageTypes
(
Id INT PRIMARY KEY IDENTITY,
Type VARCHAR(30) NOT NULL
)

CREATE TABLE Luggages
(
Id INT PRIMARY KEY IDENTITY,
LuggageTypeId INT NOT NULL REFERENCES LuggageTypes(Id),
PassengerId INT NOT NULL REFERENCES Passengers(Id)
)

CREATE TABLE Tickets
(
Id INT PRIMARY KEY IDENTITY,
PassengerId INT NOT NULL REFERENCES Passengers(Id),
FlightId INT NOT NULL REFERENCES Flights(Id),
LuggageId INT NOT NULL REFERENCES Luggages(Id),
Price DECIMAL(15,2) NOT NULL
)

--02

INSERT INTO Planes(Name, Seats, Range)
VALUES 
('Airbus 336', 112, 5132),
('Airbus 330', 432, 5325),
('Boeing 369', 231, 2355),
('Stelt 297', 254, 2143),
('Boeing 338', 165, 5111),
('Airbus 558', 387, 1342),
('Boeing 128', 345, 5541)


INSERT INTO LuggageTypes(Type)
VALUES
('Crossbody Bag'),
('School Backpack'),
('Shoulder Bag')

--03

SELECT * FROM Flights WHERE Destination = 'Carlsbad'

UPDATE Tickets
SET Price = Price * 1.13
WHERE FlightId = 41

--04

DELETE Tickets WHERE FlightId = 30


DELETE Flights
WHERE Destination = 'Ayn Halagim'

--05

SELECT * FROM Planes
WHERE Name LIKE '%TR%'
ORDER BY Id, Name, Seats, Range

--06

SELECT F.Id AS FlightId, SUM(T.Price) AS Price FROM Flights AS F
JOIN Tickets AS T ON T.FlightId = F.Id
GROUP BY F.Id
ORDER BY SUM(T.Price) DESC, F.Id

--07

SELECT 
P.FirstName + ' ' + P.LastName AS [Full Name],
F.Origin,
F.Destination
FROM Passengers AS P
JOIN Tickets AS T ON P.Id = T.PassengerId
JOIN Flights AS F ON T.FlightId = F.Id
ORDER BY [Full Name], Origin, Destination

--08

SELECT P.FirstName, P.LastName, P.Age FROM Passengers AS P
LEFT JOIN Tickets AS T ON P.Id = T.PassengerId
WHERE T.Id IS NULL
ORDER BY Age DESC, FirstName, LastName

--09

SELECT 
P.FirstName + ' ' + P.LastName AS [Full Name],
PL.Name AS [Plane Name],
F.Origin + ' - ' + F.Destination AS [Trip],
LT.Type AS [Luggage Type]
FROM Passengers AS P
JOIN Tickets AS T ON T.PassengerId = P.Id
JOIN Luggages AS L ON T.LuggageId = L.Id
JOIN LuggageTypes AS LT ON L.LuggageTypeId = LT.Id
JOIN Flights AS F ON T.FlightId = F.Id
JOIN Planes AS PL ON F.PlaneId = PL.Id
ORDER BY [Full Name], [Plane Name], F.Origin, F.Destination, [Luggage Type]

--10

SELECT PL.Name, PL.Seats, COUNT(P.Id) AS [Passengers Count] FROM Planes AS PL
LEFT JOIN Flights AS F ON PL.Id = F.PlaneId
LEFT JOIN Tickets AS T ON T.FlightId = F.Id
LEFT JOIN Passengers AS P ON T.PassengerId = P.Id
GROUP BY PL.Name, PL.Seats
ORDER BY COUNT(P.Id) DESC, PL.Name, PL.Seats

--11
GO

CREATE FUNCTION udf_CalculateTickets(@origin VARCHAR(MAX), @destination VARCHAR(MAX), @peopleCount INT) 
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @result VARCHAR(MAX)

	IF(@peopleCount <= 0)
	BEGIN
		SET @result ='Invalid people count!'
		RETURN @result
	END

	IF(NOT EXISTS (SELECT * FROM Flights WHERE Origin = @origin AND Destination = @destination))
	BEGIN
		SET @result = 'Invalid flight!'
		RETURN @result
	END

	DECLARE @price DECIMAL(15,2) = (SELECT TOP 1 T.Price FROM Tickets AS T 
						JOIN Flights AS F ON F.Id = T.FlightId
						WHERE Origin = @origin AND Destination = @destination) * @peopleCount
	SET @result = 'Total price ' + CONVERT(VARCHAR(MAX), @price)

	RETURN @result
END

GO
SELECT dbo.udf_CalculateTickets('Kolyshley','Rancabolang', 33)

SELECT dbo.udf_CalculateTickets('Kolyshley','Rancabolang', -1)

SELECT dbo.udf_CalculateTickets('Invalid','Rancabolang', 33)

GO

CREATE PROC usp_CancelFlights
AS
BEGIN

UPDATE Flights
SET ArrivalTime = NULL, DepartureTime = NULL
WHERE ArrivalTime > DepartureTime

END

GO

UPDATE Flights
SET ArrivalTime = NULL, DepartureTime = NULL
WHERE ArrivalTime > DepartureTime

