--01 Find number of users for email provider from the largest to smallest, 
--then by Email Provider in ascending order. 

SELECT SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS Provider, COUNT(*) AS Count FROM Users
GROUP BY SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email))
ORDER BY COUNT(*)DESC, SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email))

--02 Find all user in games with information about them. 
--Display the game name, game type, username, level, cash and character name. 
--Sort the result by level in descending order, then by username and game in alphabetical order. 
--Submit your query statement as Prepare DB & run queries in Judge.

SELECT G.Name, GT.Name, U.Username, UG.Level, UG.Cash, C.Name FROM Games AS G
JOIN GameTypes AS GT ON GT.Id = G.GameTypeId
JOIN UsersGames AS UG ON G.Id = UG.GameId
JOIN Characters AS C ON C.Id = UG.CharacterId
JOIN Users AS U ON U.Id = UG.UserId
ORDER BY UG.Level DESC, U.Username, G.Name

--03 Find all users in games with their items count and items price. Display the username, game name, 
--items count and items price. Display only user in games with items count more or equal to 10. 
--Sort the results by items count in descending order then by price in descending order
--and by username in ascending order. Submit your query statement as Prepare DB & run queries in Judge.


SELECT U.Username, G.Name, COUNT(UGI.ItemId), SUM(I.Price) FROM Users AS U
JOIN UsersGames AS UG ON U.Id = UG.UserId
JOIN Games AS G ON G.Id = UG.GameId
JOIN UserGameItems AS UGI ON UGI.UserGameId = UG.Id
JOIN Items AS I ON UGI.ItemId = I.Id
GROUP BY U.Username, G.Name
HAVING COUNT(UGI.ItemId) >= 10
ORDER BY COUNT(UGI.ItemId) DESC, SUM(I.Price) DESC, Username



SELECT * FROM Games
ORDER BY Name

--04

--05

SELECT 
AVG(Mind) AS AvgMind, 
AVG(Speed) AS AvgSpeed, 
AVG(Luck) AS AvgLuck
FROM [Statistics]

SELECT I.Name, I.Price, I.MinLevel, S.Strength, S.Defence, S.Speed, S.Luck, S.Mind FROM Items AS I
JOIN [Statistics] AS S ON S.Id = I.StatisticId
WHERE 
	S.Mind > (SELECT AVG(Mind) AS AvgMind FROM [Statistics]) 
	AND 
	S.Luck > (SELECT AVG(Luck) AS AvgMind FROM [Statistics]) 
	AND 
	S.Speed > (SELECT AVG(Speed) AS AvgMind FROM [Statistics])
ORDER BY I.Name

--06

SELECT I.Name, I.Price, I.MinLevel, GT.Name FROM Items AS I
LEFT JOIN GameTypeForbiddenItems AS FG ON I.Id = FG.ItemId
LEFT JOIN GameTypes AS GT ON GT.Id = FG.GameTypeId
ORDER BY GT.Name DESC, I.Name

--07

SELECT * FROM Users AS U
JOIN UsersGames AS UG ON UG.UserId = U.Id
JOIN UserGameItems AS UGI ON UGI.UserGameId = UG.Id
WHERE Username = 'ALEX' AND UG.GameId = 221

SELECT * FROM Games WHERE Name = 'EDINBURGH'
SELECT * FROM UsersGames WHERE Id = 235
SELECT * FROM Items 
WHERE Name IN ('Blackguard', 'Bottomless Potion of Amplification', 'Eye of Etlich (Diablo III)', 'Gem of Efficacious Toxin', 'Golden Gorget of Leoric', 'Hellfire Amulet')

--GAME ID = 221
--USER ID = 5
--CASH = 7659.00
--SUMPRICEITEMS = 2957.00
--ITEMS IDS (51, 71, 157, 184, 197, 223)
--USERGAMEID = 235
SELECT 7659.00 - 2957.00 

--ACTUAL SOLUTION SUBMIT IN JUDGE
INSERT INTO UserGameItems(UserGameId, ItemId)
VALUES
(235, 51),
(235, 71),
(235, 157),
(235, 184),
(235, 197),
(235, 223)

UPDATE UsersGames
SET Cash = 4702.00
WHERE Id = 235

SELECT U.Username, G.Name, UG.Cash, I.Name FROM Users AS U
JOIN UsersGames AS UG ON UG.UserId = U.Id
JOIN UserGameItems AS UGI ON UGI.UserGameId = UG.Id
JOIN Items AS I ON UGI.ItemId = I.Id
JOIN Games AS G ON G.Id = UG.GameId
WHERE G.Id = 221
ORDER BY I.Name

--08

SELECT P.PeakName, M.MountainRange, P.Elevation FROM Peaks AS P
JOIN Mountains AS M ON M.Id = P.MountainId
ORDER BY P.Elevation DESC, P.PeakName

--09

SELECT P.PeakName, M.MountainRange, C.CountryName, CO.ContinentName FROM Peaks AS P
JOIN Mountains AS M ON M.Id = P.MountainId
JOIN MountainsCountries AS MC ON MC.MountainId = M.Id
JOIN Countries AS C ON MC.CountryCode = C.CountryCode
JOIN Continents AS CO ON CO.ContinentCode = C.ContinentCode
ORDER BY P.PeakName, C.CountryName

--10

SELECT SUB.CountryName, CO.ContinentName, SUB.RiversCount, ISNULL(SUB.TotalLength, '0') AS TotalLength FROM 
	(SELECT C.CountryName, C.ContinentCode, COUNT(R.Id) AS RiversCount, SUM(R.Length) AS TotalLength FROM Countries AS C
	LEFT JOIN CountriesRivers AS CR ON CR.CountryCode = C.CountryCode
	LEFT JOIN Rivers AS R ON R.Id = CR.RiverId
	GROUP BY C.CountryName, C.ContinentCode) AS SUB
JOIN Continents AS CO ON SUB.ContinentCode = CO.ContinentCode 
ORDER BY SUB.RiversCount DESC, SUB.TotalLength DESC, SUB.CountryName

--11

SELECT C.CurrencyCode, C.Description AS Currency, COUNT(COU.CountryCode) AS NumberOfCountries FROM Currencies AS C
LEFT JOIN Countries AS COU ON C.CurrencyCode = COU.CurrencyCode
GROUP BY C.CurrencyCode, C.Description
ORDER BY COUNT(COU.CountryCode) DESC, C.Description

--12

SELECT CON.ContinentName, SUM(C.AreaInSqKm) AS CountriesArea, SUM(CONVERT(BIGINT, C.[Population])) AS CountriesPopulation FROM Continents AS CON
JOIN Countries AS C ON CON.ContinentCode = C.ContinentCode
GROUP BY CON.ContinentName
ORDER BY CountriesPopulation DESC

--13

ALTER TABLE Countries
ADD IsDeleted BIT DEFAULT 0



CREATE TABLE Monasteries
(
Id INT PRIMARY KEY IDENTITY, 
Name NVARCHAR(50), 
CountryCode CHAR(2) NOT NULL REFERENCES Countries(CountryCode)
)

INSERT INTO Monasteries(Name, CountryCode) VALUES
('Rila Monastery “St. Ivan of Rila”', 'BG'), 
('Bachkovo Monastery “Virgin Mary”', 'BG'),
('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
('Kopan Monastery', 'NP'),
('Thrangu Tashi Yangtse Monastery', 'NP'),
('Shechen Tennyi Dargyeling Monastery', 'NP'),
('Benchen Monastery', 'NP'),
('Southern Shaolin Monastery', 'CN'),
('Dabei Monastery', 'CN'),
('Wa Sau Toi', 'CN'),
('Lhunshigyia Monastery', 'CN'),
('Rakya Monastery', 'CN'),
('Monasteries of Meteora', 'GR'),
('The Holy Monastery of Stavronikita', 'GR'),
('Taung Kalat Monastery', 'MM'),
('Pa-Auk Forest Monastery', 'MM'),
('Taktsang Palphug Monastery', 'BT'),
('Sümela Monastery', 'TR')

UPDATE Countries
SET IsDeleted = 1
WHERE CountryCode IN (
SELECT A.CountryCode FROM
(SELECT C.CountryCode, COUNT(R.Id) AS COUNT FROM Countries AS C
JOIN CountriesRivers AS CR ON C.CountryCode = CR.CountryCode
JOIN Rivers AS R ON R.Id = CR.RiverId
GROUP BY C.CountryCode
HAVING COUNT(R.Id) > 3) AS A)


SELECT M.Name AS Monastery, C.CountryName AS Country FROM Monasteries AS M
JOIN Countries AS C ON M.CountryCode = C.CountryCode
WHERE IsDeleted = 0
ORDER BY M.Name


--14


UPDATE Countries
SET CountryName = 'Burma'
WHERE CountryName = 'Myanmar'


INSERT INTO Monasteries(Name, CountryCode)
VALUES
	('Hanga Abbey', 'TZ'),
	('Myin-Tin-Daik', (SELECT TOP(1) C.CountryCode FROM Countries C WHERE C.CountryName='Myanmar'))


SELECT CON.ContinentName, C.CountryName, COUNT(M.Id) AS MonasteriesCount FROM Continents AS CON
LEFT JOIN Countries AS C ON C.ContinentCode = CON.ContinentCode
LEFT JOIN Monasteries AS M ON M.CountryCode= C.CountryCode
WHERE C.IsDeleted = 0
GROUP BY CON.ContinentName, C.CountryName
ORDER BY COUNT(M.Id) DESC, C.CountryName 