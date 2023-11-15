use ITI_new

--1.Create an index on column (Hiredate) that allow u to cluster the data in the 
--table Department. What will happen?  
create clustered index hire_index
	on department(manager_hiredate)

--2.Create an index that allows you to enter unique ages in the student table. 
--What will happen?
create unique index uni_index  
on student(st_age)

--3.create a non-clustered index on column(Dept_Manager) that allows you to enter 
--a unique instructor id in the table Department. 
create unique nonclustered index dept_index
on Department(Dept_manager)

--Problem 1: Calculate Total Salary for Each Department Description: Calculate the 
--total salary for each department and display the department name along with the 
--total salary
declare c1 cursor 
for
   select d.Dept_Id, d.Dept_Name, sum(i.Salary)
   from Instructor i, Department d
   where i.Dept_Id = d.Dept_Id
   group by d.Dept_Id, d.Dept_Name
for read only
declare @name varchar(20) , @total money = 0, @id int
open c1
fetch c1 into @id, @name, @total

while @@FETCH_STATUS=0
	begin
		select @id as Dept_Id, @name as Dept_Name,@total as Total_Salaries
		Fetch C1 into @id, @name, @total 
	end
close c1
deallocate c1

--Problem 2: Update Employee Salaries Based on Department Description: Update 
--employee salaries by increasing them by a certain percentage for a specific 
--department.
declare c2 cursor
for
	select d.Dept_Id, i.Salary
	from Instructor i, Department d
	where i.Dept_Id = d.Dept_Id
for update
declare @sal money, @idd int
open c2
fetch c2 into @idd, @sal
while @@FETCH_STATUS = 0
	begin
		if @idd = 30
			begin
				update Instructor
				set Salary = @sal * 1.2
				where current of c2
			end
		--select @idd, @sal
		fetch c2 into @idd, @sal
	end
close c2
deallocate c2

select i.Ins_Name, i.Salary
from Instructor i