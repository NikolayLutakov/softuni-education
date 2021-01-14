-- 04

insert into Towns
values
	(1, 'Sofia'),
	(2, 'Plovdiv'),
	(3, 'Varna')

insert into Minions
values
	(1, 'Kevin', 22, 1),
	(2, 'Bob', 15, 3),
	(3, 'Steward', NULL, 2)
	

-- 07

create table People(
Id int identity primary key,
Name nvarchar(200) not null,
Picture varbinary(8000) null,
Height decimal(10, 2) null,
Weight decimal(10, 2) null,
Gender char(1) not null check (Gender in ('f', 'm')),
Birthdate datetime not null,
Biography nvarchar(max)
)

insert into People(Name, Gender, Birthdate)
values
	('Name1', 'm', GETDATE()),
	('Name2', 'f', GETDATE()),
	('Name3', 'm', GETDATE()),
	('Name4', 'f', GETDATE()),
	('Name5', 'm', GETDATE())
	

--08

create table Users(
Id int identity primary key,
Username varchar(30) unique not null,
Password varchar(26) not null,
ProfilPicture varbinary(max),
LastLogInTime datetime,
IsDeleted char(5) not null check (IsDeleted in ('true', 'false'))
)

insert into Users(Username, Password, IsDeleted)
values
	('username1', 'pass1', 'false'),
	('username2', 'pass2', 'false'),
	('username3', 'pass3', 'false'),
	('username4', 'pass4', 'false'),
	('username5', 'pass5', 'true')
	
	
--13

create table Directors (
Id int primary key, 
DirectorName nvarchar(50) not null, 
Notes nvarchar(max)
)

create table Genres (
Id int primary key, 
GenreName nvarchar(20) not null, 
Notes nvarchar(max)
)

create table Categories (
Id int primary key, 
CategoryName nvarchar(20) not null, 
Notes nvarchar(max)
)

create table Movies (
Id int primary key, 
Title nvarchar(20) not null, 
DirectorId int not null, 
CopyrightYear date not null, 
Length int not null, 
GenreId int not null, 
CategoryId int not null,
Rating int, 
Notes nvarchar(max)
)

insert into Directors(Id, DirectorName)
values
	(1, 'dir1'),
	(2, 'dir2'),
	(3, 'dir3'),
	(4, 'dir4'),
	(5, 'dir5')

insert into Genres(Id, GenreName)
values
	(1, 'dir1'),
	(2, 'dir2'),
	(3, 'dir3'),
	(4, 'dir4'),
	(5, 'dir5')

insert into Categories(Id, CategoryName)
values
	(1, 'dir1'),
	(2, 'dir2'),
	(3, 'dir3'),
	(4, 'dir4'),
	(5, 'dir5')

Insert into Movies(Id, DirectorId, CopyrightYear, Length, GenreId, CategoryId, Title)
values 
	(1, 1, GETDATE(), 120, 1, 1, 'tit'),
	(2, 1, GETDATE(), 120, 1, 1, 'tit'),
	(3, 1, GETDATE(), 120, 1, 1, 'tit'),
	(4, 1, GETDATE(), 120, 1, 1, 'tit'),
	(5, 1, GETDATE(), 120, 1, 1, 'tit')
	
	
--14

create table Categories(
Id int not null identity(1, 1), 
CategoryName nvarchar(20) not null, 
DailyRate int not null, 
WeeklyRate int not null, 
MonthlyRate int not null, 
WeekendRate int not null
)

alter table Categories
add constraint PK_Categories
primary key(Id)

create table Cars (
Id int not null identity(1, 1), 
PlateNumber int not null unique, 
Manufacturer nvarchar(20) not null, 
Model nvarchar(20) not null, 
CarYear date not null, 
CategoryId int not null, 
Doors int not null, 
Picture varbinary(max), 
Condition nvarchar(20), 
Avaialable varchar check(Avaialable in ('yes', 'no'))
)

alter table Cars
alter column Avaialable varchar(3)



alter table Cars
add constraint PK_Cars
primary key(Id),
constraint df_Avilable default 'yes' for Avaialable

alter table Cars
add constraint FK_Cars_Categories
foreign key(CategoryId) references Categories(Id)

create table Employees (
Id int not null identity(1, 1), 
FirstName nvarchar(10) not null, 
LastName nvarchar(10) not null, 
Title nvarchar(10) not null, 
Notes nvarchar(max)
)

alter table Employees
add constraint PK_Emplyees
primary key(Id)

create table Customers (
Id int not null identity(1, 1), 
DriverLicenceNumber nvarchar(20) not null, 
FullName nvarchar(50) not null, 
Address nvarchar(30) not null, 
City nvarchar(10) not null, 
ZIPCode int not null, 
Notes nvarchar(max)
)

alter table Customers
add constraint PK_Custommers
primary key(Id)

create table RentalOrders (
Id int not null identity(1, 1), 
EmployeeId int not null, 
CustomerId int not null, 
CarId int not null, 
TankLevel int not null, 
KilometrageStart int not null, 
KilometrageEnd int not null, 
TotalKilometrage int not null, 
StartDate date not null, 
EndDate date not null, 
TotalDays int not null, 
RateApplied int not null, 
TaxRate int not null, 
OrderStatus nvarchar(20) not null, 
Notes nvarchar(max)
)

alter table RentalOrders
add constraint PK_RentalOrders primary key(Id),
constraint FK_RentalOrder_Employee foreign key (EmployeeId) references Employees(Id),
constraint FK_RentalOrder_Customer foreign key (CustomerId) references Customers(Id),
constraint FK_RentalOrder_Car foreign key(CarId) references Cars(Id)


insert into Categories(CategoryName, DailyRate, WeeklyRate, WeekendRate, MonthlyRate)
values
	('cat1', 1, 1, 1, 1),
	('cat2', 2, 2, 2, 2),
	('cat3', 3, 3, 3, 3)


insert into Cars(PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors)
values
	(1111, 'man1', 'mod1', '1990', 1, 5),
	(2222, 'man2', 'mod2', '1991', 2, 3),
	(3333, 'man3', 'mod3', '1992', 3, 2)

insert into Employees(FirstName, LastName, Title)
values
	('fName1', 'lName1', 'Title1'),
	('fName2', 'fName2', 'Title2'),
	('fName3', 'fName3', 'Title3')

insert into Customers(DriverLicenceNumber, FullName, Address, City, ZIPCode)
values
	(1111, 'name1', 'address1', 'city1', 1111),
	(2222, 'name2', 'address2', 'city2', 2222),
	(3333, 'name3', 'address3', 'city3', 3333)

insert into RentalOrders(EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus)
values
	(1, 1, 1, 1, 2, 1, 1, '2000-01-01', '2000-01-02', 1, 1 , 1, 'unknown'),
	(2, 2, 2, 1, 2, 1, 1, '2000-01-01', '2000-01-02', 1, 1 , 1, 'unknown'),
	(3, 3, 3, 1, 2, 1, 1, '2000-01-01', '2000-01-02', 1, 1 , 1, 'unknown')
	

--15

create table Employees(
Id int not null identity(1, 1),
FirstName nvarchar(20) not null,
LastName nvarchar(20) not null,
Title nvarchar(10) not null,
Notes nvarchar(max)
)

alter table Employees
add constraint PK_Employees primary key(Id)

insert into Employees(FirstName, LastName, Title)
values
	('fname1', 'secname1', 'title'),
	('fname2', 'secname2', 'title'),
	('fname3', 'secname3', 'title')

create table Customers(
AccountNumber int not null,
FirstName nvarchar(20) not null,
LastName nvarchar(20) not null,
PhoneNumber nvarchar(20) not null,
EmergencyName nvarchar(20),
EmergencyNumber nvarchar(20),
Notes nvarchar(max)
)

alter table Customers
add constraint PK_Customers primary key(AccountNumber)

insert into Customers(AccountNumber, FirstName, LastName, PhoneNumber)
values
	(1, 'custFName1', 'custLName1', 'phone1'),
	(2, 'custFName2', 'custLName2', 'phone2'),
	(3, 'custFName3', 'custLName3', 'phone3')

create table RoomStatus(
RoomStatus nvarchar(8) not null primary key check(RoomStatus in('free', 'occupied', 'cleaning')),
Notes nvarchar(max)
)
insert into RoomStatus
values
	('free', ''),
	('occupied', ''),
	('cleaning', '')
	

create table RoomTypes(
RoomType nvarchar(8) not null primary key check(RoomType in('app', 'double', 'single')),
Notes nvarchar(max)
)


insert into RoomTypes
values
	('app', ''),
	('double', ''),
	('single', '')

create table BedTypes(
BedType nvarchar(8) not null primary key check(BedType in('single', 'double', 'unknown')),
Notes nvarchar(max)
)

insert into BedTypes
values
	('single', ''),
	('double', ''),
	('unknown', '')

create table Rooms(
RoomNumber int not null primary key,
RoomType nvarchar(8) not null foreign key references RoomTypes(RoomType),
BedType nvarchar(8) not null foreign key references BedTypes(BedType),
Rate int,
RoomStatus nvarchar(8) not null foreign key references RoomStatus(RoomStatus),
Notes nvarchar(max)
)
insert into Rooms(RoomNumber, RoomType, BedType, RoomStatus)
values 
	(1, 'single', 'single', 'free'),
	(2, 'single', 'single', 'free'),
	(3, 'single', 'single', 'free')

create table Payments(
Id int not null primary key, 
EmployeeId int not null foreign key references Employees(Id), 
PaymentDate date not null, 
AccountNumber int not null foreign key references Customers(AccountNumber), 
FirstDateOccupied date, 
LastDateOccupied date, 
TotalDays int, 
AmountCharged decimal, 
TaxRate int, 
TaxAmount int, 
PaymentTotal decimal, 
Notes nvarchar(max)
)


insert into Payments(Id, EmployeeId, PaymentDate, AccountNumber)
values
	(1, 1, '2000-01-01', 1),
	(2, 1, '2000-01-01', 2),
	(3, 1, '2000-01-01', 3)

create table Occupancies (
Id int not null primary key, 
EmployeeId int not null foreign key references Employees(Id), 
DateOccupied date , 
AccountNumber int not null foreign key references Customers(AccountNumber), 
RoomNumber int not null foreign key references Rooms(RoomNumber), 
RateApplied int, 
PhoneCharge decimal, 
Notes nvarchar(max)
)

insert into Occupancies(Id, EmployeeId, DateOccupied, AccountNumber, RoomNumber)
values 
	(1, 1, '2000-01-01', 1, 1),
	(2, 1, '2000-01-01', 1, 2),
	(3, 1, '2000-01-01', 1, 3)
	

--19

select * from Towns
select * from Departments
select * from Employees


--20

select * from Towns
order by Name

select * from Departments
order by Name asc

select * from Employees
order by Salary desc


--21

select Name from Towns
order by Name

select Name from Departments
order by Name asc

select FirstName, LastName, JobTitle, Salary from Employees
order by Salary desc


--22

update Employees
set Salary = Salary * 1.1

select Salary from Employees


--23

update Payments
set TaxRate = TaxRate - (TaxRate * 0.03)

select Taxrate from Payments


--24

truncate table Occupancies