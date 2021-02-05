--create database WMS
--use WMS
--drop database WMS
create table Clients(
ClientId int primary key,
FirstName varchar(50) not null,
LastName varchar(50) not null,
Phone varchar (12) check (len(Phone) = 12) not null

)


create table Mechanics(
MechanicId int primary key ,
FirstName varchar(50) not null,
LastName varchar(50) not null,
Address varchar(255) not null

)

create table Models(
ModelId int primary key ,
Name varchar(50) unique not null
)

create table Jobs(
JobId int primary key ,
ModelId int references Models(ModelId) not null,
Status varchar(11) not null check (Status in('Pending', 'In Progress', 'Finished' )),
ClientId int references Clients(ClientId) not null,
MechanicId int references Mechanics(MechanicId),
IssueDate date not null,
FinishDate date

)


create table Orders(
OrderId int primary key ,
JobId int references Jobs(JobId) not null,
IssueDate date,
Delivered bit default 0

)

create table Vendors(
VendorId int primary key ,
Name varchar(50) unique
)

create table Parts(
PartId int primary key ,
SerialNumber varchar(50) unique not null,
Description varchar(255),
Price decimal(10, 2) check (Price > 0.0),
VendorId int references Vendors(VendorId),
StockQty int not null check (StockQty >= 0) default 0

)

create table OrderParts(
OrderId int not null,
PartId int not null,
Quantity int check (Quantity > 0) default 1,
primary key (OrderId, PartId),
foreign key (OrderId) references Orders(OrderId),
foreign key (PartId) references Parts(PartId)
)

create table PartsNeeded(
JobId int not null,
PartId int not null,
Quantity int check (Quantity > 0) default 1,
primary key (JobId, PartId),
foreign key (JobId) references Jobs(JobId),
foreign key (PartId) references Parts(PartId)
)

---

insert into Clients(FirstName,	LastName,	Phone)
values 
('Teri',	'Ennaco',	'570-889-5187'),
('Merlyn',	'Lawler',	'201-588-7810'),
('Georgene'	,'Montezuma',	'925-615-5185'),
('Jettie'	,'Mconnell'	,'908-802-3564'),
('Lemuel',	'Latzke'	,'631-748-6479'),
('Melodie',	'Knipp'	,'805-690-1682'),
('Candida'	,'Corbley'	,'908-275-8357')

insert into Parts( SerialNumber, Description, Price, VendorId)
values
('WP8182119', 'Door Boot Seal', 117.86,2),
('W10780048', 'Suspension Rod', 42.81,1),
('W10841140', 'Silicone Adhesive ',6.77 ,4),
('WPY055980', 'High Temperature Adhesive',13.94 ,3)



select * from Mechanics
update Jobs
set MechanicId = 3, Status = 'In Progress'
where Status = 'Pending'

select * from Parts

select * from Orders
select * from OrderParts

delete OrderParts
where  OrderId = 19

delete Orders
where OrderId= 19

select m.FirstName + ' ' + m.LastName as Mechanic, 
j.Status,
j.IssueDate
from Mechanics as m
join jobs as j
on j.MechanicId = m.MechanicId
order by m.MechanicId, j.IssueDate, j.JobId

select c.FirstName + ' ' + c.LastName as Client,
datediff(day, j.IssueDate, '2017-04-24') as [Days going],
j.Status
from Clients as c
join Jobs as j on j.ClientId = c.ClientId
where j.Status in ('In Progress', 'Pending')
order by [Days going] desc, j.ClientId asc


select g.Mechanic, g.[Average Days] from(select m.MechanicId, m.FirstName + ' ' + m.LastName as Mechanic ,
avg(DATEDIFF(day, j.IssueDate, j.FinishDate)) as [Average Days]
from Mechanics as m
join Jobs as j on j.MechanicId = m.MechanicId
where j.Status = 'Finished'
group by m.MechanicId, m.FirstName + ' ' + m.LastName) as g
order by g.MechanicId

select *, m.FirstName + ' ' + m.LastName from Jobs as j
left join Mechanics as m
on j.MechanicId = m.MechanicId
where j.Status not in ( 'Pending', 'In Progress')
group by m.FirstName + ' ' + m.LastName

select g.Mechanic from(select m.MechanicId, m.FirstName + ' ' + m.LastName as Mechanic
from Jobs as j
full outer join Mechanics as m on j.MechanicId = m.MechanicId
where m.MechanicId not in (select Mechanics.MechanicId from Mechanics Join jobs on Jobs.MechanicId = Mechanics.MechanicId where Status in ('Pending', 'In Progress'))
group by m.MechanicId, m.FirstName + ' ' + m.LastName) as g
order by g.MechanicId

select j.JobId, isnull(sum(p.Price * op.Quantity), 0.00) as Total from Jobs as j
left join Orders as o
on o.JobId = j.JobId
left join OrderParts as op
on o.OrderId = op.OrderId
left join Parts as p
on op.PartId = p.PartId
where j.Status = 'Finished'
group by j.JobId
order by sum(p.Price * op.Quantity) desc, j.JobId



SELECT P.PartId, P.Description, PN.Quantity 'Required', P.StockQty 'In Stock', 0 'Ordered' FROM Parts P
	JOIN PartsNeeded PN ON PN.PartId=P.PartId
	JOIN Jobs J ON J.JobId = PN.JobId
	WHERE J.Status != 'Finished' AND P.StockQty < PN.Quantity
	ORDER BY P.PartId



CREATE PROC usp_PlaceOrder(@JobsId INT, @PartSerial VARCHAR(50), @Quantity INT)
AS
BEGIN
	IF @Quantity<=0
		THROW 50012, 'Part quantity must be more than zero!', 1
	ELSE IF NOT EXISTS(SELECT * FROM Jobs J WHERE J.JobId=@JobsId)
		THROW 50013, 'Job not found!', 1
	ELSE IF EXISTS(SELECT * FROM Jobs J WHERE J.JobId=@JobsId AND J.Status='Finished')
		THROW 50011, 'This job is not active!', 1
	ELSE IF NOT EXISTS(SELECT * FROM Parts P WHERE P.SerialNumber=@PartSerial)
		THROW 50014, 'Part not found!', 1

		DECLARE @PartId INT
					SELECT @PartId=P.PartId FROM Parts P
						WHERE P.SerialNumber=@PartSerial


	DECLARE @ExistingOrderId INT
	SELECT @ExistingOrderId=O.OrderId FROM Orders O
		JOIN Jobs J ON J.JobId=O.JobId
		JOIN OrderParts OP ON OP.OrderId=O.OrderId
		WHERE O.IssueDate IS NULL AND J.JobId=@JobsId AND OP.PartId=@PartId

	IF (@ExistingOrderId IS NULL)
		BEGIN
			INSERT INTO Orders(JobId, IssueDate)
			VALUES
			(@JobsId, NULL)

			SELECT @ExistingOrderId=O.OrderId FROM Orders O
				JOIN Jobs J ON J.JobId=O.JobId
				WHERE O.IssueDate IS NULL AND J.JobId=@JobsId

					

					INSERT INTO OrderParts(OrderId,PartId,Quantity)
					VALUES
					(@ExistingOrderId, @PartId, @Quantity)
		END
	ELSE
		BEGIN
			UPDATE OrderParts
				SET Quantity+=@Quantity
				WHERE OrderId=@ExistingOrderId
		END
END

create procedure usp_PlaceOrder(@JobId INT, @PartSerial VARCHAR(50), @Quantity INT)
as
begin
	if (@Quantity <= 0)
		throw 50012, 'Part quantity must be more than zero!', 1
	else if (not exists(select * from jobs where JobId = @JobId))
		throw 50013, 'Job not found!', 1
	else if (exists(select * from Jobs where JobId = @JobId and Status = 'Finished'))
		throw 50011, 'This job is not active!', 1
	else if (not exists (select * from Parts where SerialNumber = @PartSerial))
		throw 50014, 'Part not found!', 1
	

	declare @partId int = (select PartId from Parts where SerialNumber = @PartSerial)

	declare @existingOrderId int = (select o.OrderId from Orders as o join Jobs as j on j.JobId = o.JobId
									join OrderParts as op on op.OrderId = o.OrderId
									where o.IssueDate is null and j.JobId = @JobId and op.PartId = @partId)
	

	if(@existingOrderId is null)
		begin
			insert into Orders(JobId, IssueDate)
			values(@JobId, null)


			set @ExistingOrderId = (select top 1 o.OrderId FROM Orders as o
				JOIN Jobs as j on j.JobId = o.JobId
				WHERE o.IssueDate is null and j.JobId = @JobId
				order by o.OrderId desc)

			insert into OrderParts(OrderId, PartId, Quantity)
			values(@ExistingOrderId, @partId, @Quantity)
		end
	else
		begin
			update OrderParts
			set Quantity += @Quantity
			where OrderId = @existingOrderId
		end
end

create function udf_GetCost(@jobid int)
returns decimal(10,2)
as
begin
	declare @result decimal(10,2) = (select sum(p.Price * op.Quantity) from Jobs as j
	join Orders as o 
	on o.JobId = j.JobId
	join OrderParts as op
	on op.OrderId = o.OrderId
	join Parts as p
	on p.PartId = op.PartId where j.JobId = @jobid)
	
	if(@result is null)
	set @result = 0

	return @result
end

SELECT dbo.udf_GetCost(1)