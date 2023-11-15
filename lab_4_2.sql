use Company_SD

--4.Create a stored procedure that will be used in case there is an 
--old employee has left the project and a new one become instead of 
--him. The procedure should take 3 parameters 
--(old Emp. SSN, new Emp. SSN and the project number) and it will be 
--used to update works_for table.
go
alter PROC old_employee @oldemp_id int, @newemp_id int, @pnum int
as
	if exists(select * from Works_for where @oldemp_id = ESSn and @pnum = Pno)
		begin
			update Works_for
			set ESSn = @newemp_id, Pno = @pnum
			where ESSn = @oldemp_id
		end
	else
		begin
			print 'Employee not found'
		end

exec old_employee 112233, 521634, 100
exec old_employee 223344, 5667, 344

--5.Create an Audit table with the following structure
--This table will be used to audit the update trials on the Hours 
--column (works_for table, Company DB)
--Example: If a user updated the Hours column then the project number,
--the user name that made that update, the date of the modification 
--and the value of the old and the new Hours will be inserted into the
--Audit table
--Note: This process will take place only if the user updated the 
--Hours column
go
create table audit_hours
(
	ProjectNo int,
	UserName varchar(100),
	ModifiedDate date,
	Hours_Old int,
	Hours_New int
)
go
create TRIGGER t1
ON works_for 
AFTER UPDATE
AS
IF UPDATE(hours)
begin
	declare @old int, @new int, @no int
	SELECT @no = Pno from inserted
	select @old = hours from deleted
	select @new = hours from inserted
	INSERT INTO audit_hours 
	VALUES(@no, SUSER_NAME() , GETDATE() , @old , @new)
end

update Works_for
set Hours = 300
where Pno = 100
select * from audit_hours

--6.Create a trigger that prevents users from altering any table in 
--Company DB
go
create trigger t2
on database
for alter_table 
as 
select'Not allowd to alter any table '
rollback
go

ALTER TABLE audit_hours ADD Age INT

select * from audit_hours