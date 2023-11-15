use Company_SD

--Problem 3: Calculate Average Project Hours per Employee Description: Calculate 
--the average number of hours each employee has worked on projects, and display 
--their names along with the calculated average hours
declare c3 cursor
for
	select e.Fname, avg(w.Hours)
	from Works_for w, Employee e
	where w.ESSn = e.SSN
	group by e.Fname
for read only
declare @hours int, @name varchar(50)
open c3
fetch c3 into @name, @hours
while @@FETCH_STATUS = 0
	begin
		select @name as Emp_Name, @hours as Average_Hours
		fetch c3 into @name, @hours
	end
close c3
deallocate c3

--Problem 4: in employee table Check if Gender='M' add 'Mr Befor Employee name    
--else if Gender='F' add Mrs Befor Employee name  then display all names  
--use cursor for update
declare c4 cursor
for
	select e.Fname, e.Sex
	from Employee e
for update
declare @names varchar(1000), @gender varchar(10)
open c4
fetch c4 into @names, @gender
while @@FETCH_STATUS = 0
	begin
		if @gender = 'F'
		begin
			update Employee
			set Fname = CONCAT('Mrs',' ',@names)
			where current of c4
		end
		else
		begin
			update Employee
			set Fname = CONCAT('Mr',' ',@names)
			where current of c4
		end
		fetch c4 into @names, @gender
	end
close c4
deallocate c4

select e.Fname
from Employee e