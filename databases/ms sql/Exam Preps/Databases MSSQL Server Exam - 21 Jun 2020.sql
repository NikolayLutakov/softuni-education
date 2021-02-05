--CREATE DATABASE TripService
--USE TripService

--DDL
CREATE TABLE Cities(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(20) NOT NULL,
CountryCode VARCHAR(2) NOT NULL
)

CREATE TABLE Hotels(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(30) NOT NULL,
CityId INT NOT NULL REFERENCES Cities(Id),
EmployeeCount INT NOT NULL,
BaseRate DECIMAL(10,2)
)

CREATE TABLE Rooms(
Id INT PRIMARY KEY IDENTITY,
Price DECIMAL (10,2) NOT NULL,
Type NVARCHAR(20) NOT NULL,
Beds INT NOT NULL,
HotelId INT NOT NULL REFERENCES Hotels(Id)
)

CREATE TABLE Trips(
Id INT PRIMARY KEY IDENTITY,
RoomId INT NOT NULL REFERENCES Rooms(Id),
BookDate DATETIME NOT NULL,
ArrivalDate DATETIME NOT NULL,
ReturnDate DATETIME NOT NULL,
CancelDate DATETIME,
CONSTRAINT CK_BookDate CHECK (BookDate < ArrivalDate),
CONSTRAINT CK_ReturnDate CHECK (ArrivalDate < ReturnDate)
)

CREATE TABLE Accounts(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(50) NOT NULL,
MiddleName NVARCHAR(20),
LastName NVARCHAR(50) NOT NULL,
CityId INT NOT NULL REFERENCES Cities(Id),
BirthDate DATETIME NOT NULL,
Email VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE AccountsTrips(
AccountId INT NOT NULL,
TripId INT NOT NULL,
Luggage INT NOT NULL CHECK(Luggage >= 0) -- JUDJE WANTS CHECK, NOT DEFAULT!!!!,
PRIMARY KEY(AccountId, TripId),
FOREIGN KEY (AccountId) REFERENCES Accounts(Id),
FOREIGN KEY (TripId) REFERENCES Trips(Id)
)

--INSERT

INSERT INTO Accounts(FirstName, MiddleName, LastName, CityId, BirthDate, Email)
VALUES 
('John', 'Smith', 'Smith', 34, '1975-07-21',	'j_smith@gmail.com'),
('Gosho', NULL, 'Petrov', 11, '1978-05-16',	'g_petrov@gmail.com'),
('Ivan', 'Petrovich', 'Pavlov', 59,	'1849-09-26', 'i_pavlov@softuni.bg'),
('Friedrich', 'Wilhelm', 'Nietzsche', 2, '1844-10-15', 'f_nietzsche@softuni.bg')

INSERT INTO Trips (RoomId, BookDate, ArrivalDate, ReturnDate, CancelDate)
VALUES
(101, '2015-04-12',	'2015-04-14', '2015-04-20',	'2015-02-02'),
(102, '2015-07-07',	'2015-07-15', '2015-07-22',	'2015-04-29'),
(103, '2013-07-17',	'2013-07-23', '2013-07-24',	NULL),
(104, '2012-03-17',	'2012-03-31', '2012-04-01',	'2012-01-10'),
(109, '2017-08-07',	'2017-08-28', '2017-08-29',	NULL)


--UPDATE

UPDATE Rooms
SET Price *= 1.14
WHERE HotelId IN (5, 7, 9)

--DELETE

DELETE AccountsTrips
WHERE AccountId = 47

--Querying


SELECT A.FirstName, A.LastName, FORMAT(A.BirthDate, 'MM-dd-yyyy'), C.Name, A.Email FROM Accounts AS A
JOIN Cities AS C
ON A.CityId = C.Id
WHERE Email LIKE 'E%'
ORDER BY C.Name


SELECT C.Name AS 'City', COUNT(H.Id) AS 'Hotels' FROM Hotels AS H
JOIN Cities AS C ON
C.Id = H.CityId
GROUP BY C.Name
ORDER BY Hotels DESC, City

SELECT 
A.Id AS AccountId, 
CONCAT(A.FirstName, ' ', A.LastName) AS FullName,
MAX(DATEDIFF(DAY, T.ArrivalDate, T.ReturnDate)) AS LongestTrip,
MIN(DATEDIFF(DAY, T.ArrivalDate, T.ReturnDate)) AS ShortestTrip
FROM Accounts AS A
JOIN AccountsTrips AS AT
ON AT.AccountId = A.Id
JOIN Trips AS T
ON AT.TripId = T.Id 
WHERE T.CancelDate IS NULL AND A.MiddleName IS NULL
GROUP BY A.Id, CONCAT(A.FirstName, ' ', A.LastName)
ORDER BY  LongestTrip DESC, ShortestTrip

SELECT TOP(10) C.Id, C.Name AS City, C.CountryCode AS Country,COUNT(A.Id) AS Accounts FROM Cities AS C
JOIN Accounts AS A
ON A.CityId = C.Id
GROUP BY C.Id, C.Name, C.CountryCode
ORDER BY COUNT(A.Id) DESC


SELECT A.Id, A.Email, C.Name AS City, COUNT(AT.TripId) AS Trips
	FROM Accounts AS A
	JOIN AccountsTrips AS AT
	ON A.Id = AT.AccountId
	JOIN Trips AS T
	ON T.Id = AT.TripId
	JOIN Rooms AS R
	ON T.RoomId = R.Id
	JOIN Hotels AS H
	ON H.Id = R.HotelId
	JOIN Cities AS C
	ON C.Id = A.CityId
WHERE A.CityId = H.CityId
GROUP BY A.Id, A.Email, C.Name
HAVING COUNT(AT.TripId) > 0
ORDER BY COUNT(AT.TripId) DESC, A.Id

SELECT 
T.Id,
--CONCAT_WS(' ', A.FirstName, A.MiddleName, A.LastName) AS [Full Name],
CONCAT(a.FirstName, ' ', A.MiddleName, CASE WHEN A.MiddleName IS NULL THEN '' ELSE ' ' END, A.LastName) AS [Full Name],
AC.Name AS [From],
HC.Name AS [To],
CASE 
	WHEN T.CancelDate IS NOT NULL THEN 'Canceled'
	ELSE CONVERT(VARCHAR(50), DATEDIFF(DAY, t.ArrivalDate, t.ReturnDate)) + ' days' 
END
FROM Trips AS T
JOIN AccountsTrips AS AT
ON AT.TripId = T.Id
JOIN Accounts AS A
JOIN Cities AS AC
ON A.CityId = AC.Id
ON AT.AccountId = A.Id
JOIN Rooms AS R
ON T.RoomId = R.Id
JOIN Hotels AS H
ON R.HotelId = H.Id
JOIN Cities AS HC
ON H.CityId = HC.Id
ORDER BY [Full Name], T.Id

select * from Hotels

drop FUNCTION udf_GetAvailableRoom

CREATE FUNCTION udf_GetAvailableRoom(@HotelId INT, @Date DATE, @People INT)
RETURNS VARCHAR(max)
AS
BEGIN
	DECLARE @RESULT VARCHAR(max)= ''
	DECLARE @HOTELBASERATE DECIMAL(10,2) = (SELECT BaseRate FROM Hotels WHERE Id = @HotelId)
	
	DECLARE @ROOMSINTHEHOTEL TABLE (Id INT,
									Price DECIMAL (10,2),
									Type NVARCHAR(20),
									Beds INT,
									HotelId INT,
									TripSTART DATE,
									TripEND DATE,
									CANCEL DATE)

	INSERT INTO @ROOMSINTHEHOTEL(Id, Type, Price, Beds, HotelId, TripSTART, TripEND, CANCEL)
	SELECT R.Id, R.Type, R.Price, R.Beds, R.HotelId, T.ArrivalDate, T.ReturnDate, T.CancelDate FROM Hotels AS H 
								JOIN Rooms AS R 
								ON H.Id = R.HotelId
								JOIN Trips AS T ON R.Id = T.RoomId
								WHERE H.Id = @HotelId


	DECLARE @AVIALABLEROOMS TABLE(Id INT,
									TotalPrice DECIMAL (10,2),
									Type NVARCHAR(20),
									Beds INT
									)

	DECLARE @ID INT
	DECLARE @TYPE NVARCHAR(20)
	DECLARE @PRICE DECIMAL(10, 2)
	DECLARE @BEDS INT
	DECLARE @ROOMHOTELID INT
	DECLARE @START DATE
	DECLARE @END DATE
	DECLARE @CANCEL DATE
	
	DECLARE db_corsor CURSOR FOR SELECT Id, Type, Price, Beds, HotelId, TripSTART, TripEND, CANCEL FROM @ROOMSINTHEHOTEL
	OPEN db_corsor
		FETCH NEXT FROM db_corsor INTO @ID, @TYPE, @PRICE, @BEDS, @ROOMHOTELID, @START, @END, @CANCEL
		WHILE @@FETCH_STATUS = 0
			BEGIN

				DECLARE @DEBUG1 VARCHAR(10)
				DECLARE @DEBUG2 VARCHAR(10)
				DECLARE @DEBUG3 VARCHAR(10)
				DECLARE @DEBUG4 VARCHAR(10)
				DECLARE @DEBUG5 DATE
				DECLARE @DEBUG6 int
				DECLARE @DEBUG7 int

				DECLARE @ISROOMOCUPIED BIT = 0
				DECLARE @HAVEBEDS BIT = 0

				DECLARE @TOTALPRICE DECIMAL(10, 2)= (@HOTELBASERATE + @PRICE) * @People

				IF((@Date BETWEEN @START AND @END) AND (@CANCEL IS NULL) OR (YEAR(@Date) <> YEAR(@START)))
				BEGIN
					SET @ISROOMOCUPIED = 1
					SET @DEBUG1 = @START
					SET @DEBUG2 = @END
					SET @DEBUG3 = 'TUK'
					SET @DEBUG4 = @CANCEL
					SET @DEBUG5 = @Date
				END
				ELSE
				BEGIN
					SET @ISROOMOCUPIED = 0
					SET @DEBUG1 = @START
					SET @DEBUG2 = @END
					SET @DEBUG3 = 'TAM'
					SET @DEBUG4 = @CANCEL
					SET @DEBUG5 = @Date
					set @DEBUG6 = YEAR(@Date)
					set @DEBUG7 = YEAR(@START)
				END

				IF(@BEDS >= @People)
				BEGIN
					SET @HAVEBEDS = 1
				END


				IF(@ISROOMOCUPIED = 0 AND @HAVEBEDS = 1)
				BEGIN
					INSERT INTO @AVIALABLEROOMS(Id, TotalPrice, Type, Beds)
					VALUES (@ID, @TOTALPRICE, @TYPE, @BEDS)
				END
			FETCH NEXT FROM db_corsor INTO @ID, @TYPE, @PRICE, @BEDS, @ROOMHOTELID, @START, @END, @CANCEL

			END
		CLOSE db_corsor
	DEALLOCATE db_corsor
	


	

	DECLARE @IDTOSHOW INT = (SELECT TOP 1 Id FROM @AVIALABLEROOMS ORDER BY TotalPrice DESC)
	DECLARE @TYPETOSHOW NVARCHAR(20) = (SELECT TOP 1 Type FROM @AVIALABLEROOMS ORDER BY TotalPrice DESC)
	DECLARE @BEDSTOSHOW INT = (SELECT TOP 1 Beds FROM @AVIALABLEROOMS ORDER BY TotalPrice DESC)
	DECLARE @TOTALPRICETOSHOW DECIMAL(10, 2) = (SELECT TOP 1 TotalPrice FROM @AVIALABLEROOMS ORDER BY TotalPrice DESC)

	IF(@IDTOSHOW IS NOT NULL)
	BEGIN
	SET @RESULT = CONCAT('Room ' , CONVERT(VARCHAR(10), @IDTOSHOW)  , ': ' , @TYPETOSHOW , ' (' , CONVERT(VARCHAR(10), @BEDSTOSHOW) , ' beds) - $' , CONVERT(VARCHAR(20), @TOTALPRICETOSHOW))
	END
	ELSE
	BEGIN
	 SET @RESULT = 'No rooms available'
	END

	RETURN @RESULT
END

SELECT dbo.udf_GetAvailableRoom(112, '2011-12-17', 2)

SELECT dbo.udf_GetAvailableRoom(94, '2015-07-26', 3)

SELECT * FROM Rooms AS R 
JOIN Trips AS T ON T.RoomId = R.Id WHERE R.Id = 175 


	SELECT R.Id, R.Type, R.Price, R.Beds, R.HotelId, T.ArrivalDate, T.ReturnDate, T.CancelDate FROM Hotels AS H 
								JOIN Rooms AS R 
								ON H.Id = R.HotelId
								JOIN Trips AS T ON R.Id = T.RoomId
								WHERE H.Id = 94

								SELECT * FROM Rooms WHERE HotelId = 94