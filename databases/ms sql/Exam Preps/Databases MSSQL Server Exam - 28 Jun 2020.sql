--Create database ColonialJourney
--use ColonialJourney

create table Planets
(
Id int primary key identity,
Name varchar(30) not null

)

create table Spaceports(
Id int primary key identity,
Name varchar (50) not null,
PlanetId int not null references Planets(Id)
)

create table Spaceships(
Id int primary key identity,
Name varchar(50) not null,
Manufacturer varchar(30) not null,
LightSpeedRate int default 0

)

create table Colonists(
Id int primary key identity,
FirstName varchar(20) not null,
LastName varchar(20) not null,
Ucn varchar(10) not null,
BirthDate date not null
)

create table Journeys(
Id int primary key identity,
JourneyStart datetime not null,
JourneyEnd datetime not null,
Purpose varchar(11) check (Purpose in ('Medical', 'Technical', 'Educational', 'Military'))not null,
DestinationSpaceportId int not null references Spaceports(Id),
SpaceshipId int not null references Spaceships(Id)

)

create table TravelCards(
Id int primary key identity,
CardNumber varchar(10) not null unique,
JobDuringJourney varchar(80) check (JobDuringJourney in ('Pilot','Engineer', 'Trooper', 'Cleaner', 'Cook')),
ColonistId int not null references Colonists(Id),
JourneyId int not null references Journeys(Id)

)

insert into Planets(Name)
values
('Mars'),
('Earth'),
('Jupiter'),
('Saturn')

insert into Spaceships(Name, Manufacturer, LightSpeedRate)
values
('Golf', 'VW', 3),
('WakaWaka', 'Wakanda',	4),
('Falcon9',	'SpaceX', 1),
('Bed', 'Vidolov',	6)


update Spaceships
set LightSpeedRate += 1
where Id between 8 and 12

delete TravelCards
where JourneyId in (1, 2, 3)

delete Journeys
where id in (1,2,3)

select Id, format(JourneyStart, 'dd/MM/yyyy') as JourneyStart, format(JourneyEnd, 'dd/MM/yyyy') as JourneyEnd 
from Journeys where Purpose = 'Military'
order by JourneyStart

select c.Id, c.FirstName + ' ' + c.LastName as [full_name] from Colonists as c
join TravelCards as tc
on c.Id = tc.ColonistId
where tc.JobDuringJourney = 'Pilot'
order by c.Id

select count(*) as [count] from Colonists as c
join TravelCards as tc
on c.Id = tc.ColonistId
join Journeys as j
on j.Id = tc.JourneyId
where j.Purpose = 'Technical'

select s.Name, s.Manufacturer from Colonists as c
join TravelCards as tc
on c.Id = tc.ColonistId
join Journeys as j
on j.Id = tc.JourneyId
join Spaceships as s
on j.SpaceshipId = s.Id
where (tc.JobDuringJourney = 'Pilot') and (datediff(year, c.BirthDate, '2019-01-01') < 30)
order by s.Name

select p.Name as PlanetName, count(*) as JourneysCount from Planets as p
join Spaceports as sp on p.Id =sp.PlanetId
join Journeys as j on j.DestinationSpaceportId = sp.Id
group by p.Name
order by JourneysCount desc, PlanetName

select JobDuringJourney, a.FirstName + ' ' + a.LastName as [FullName], rank as [JobRank] from(
select c.FirstName, c.LastName,c.BirthDate, tc.JobDuringJourney ,dense_rank() over (partition by tc.JobDuringJourney order by c.BirthDate) as rank from Colonists as c
join TravelCards as tc on tc.ColonistId = c.Id
group by tc.JobDuringJourney, c.FirstName, c.LastName, c.BirthDate) as a
where a.rank = 2

create function dbo.udf_GetColonistsCount(@PlanetName VARCHAR(30))
returns int
as
begin
	--declare @PlanetName VARCHAR(30) = 'Otroyphus'
	
	declare @result int

	declare @planetId int
	
	select @planetId=Id from Planets
	where Name = @PlanetName

	set @result = (select count(*) as count from Planets as p
	join Spaceports as sp on sp.PlanetId = p.Id
	join Journeys as j on j.DestinationSpaceportId = sp.Id
	join TravelCards as tc on j.Id = tc.JourneyId
	join Colonists as c on tc.ColonistId = c.Id
	where p.Id = @planetId)

	return @result
end

SELECT dbo.udf_GetColonistsCount('Otroyphus')


create procedure usp_ChangeJourneyPurpose(@JourneyId int, @NewPurpose varchar(11))
as
begin 
	if not exists (select * from Journeys where Id = @JourneyId)
		throw 50001, 'The journey does not exist!', 1
	else if (select Purpose from Journeys where id = @JourneyId) = @NewPurpose
		throw 50002, 'You cannot change the purpose!', 1

	update Journeys
	set Purpose = @NewPurpose
	where Id = @JourneyId
end