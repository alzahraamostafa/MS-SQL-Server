use Company_SD

--1.Create Scalar function name GetEmployeeSupervisor Type: Scalar Description: 
--Returns the name of an employee's supervisor based on their SSN.
create or alter function GetEmployeeSupervisor(@id int)
returns varchar(20)
  begin 
    DECLARE @name VARCHAR(20)
       select @name = s.Fname
	   from Employee e, Employee s
	   where e.SSN = @id and s.SSN= e.Superssn
	   return @name
  end 
SELECT dbo.GetEmployeeSupervisor(112233)

--2.Create Inline Table-Valued Function GetHighSalaryEmployees
--Description: Returns a table of employees with salaries higher than 
--a specified amount.
create function GetHighSalaryEmployees(@x int)
returns table
as 
return 
(
 SELECT e.Fname
 FROM Employee e
 WHERE e.Salary > @x
)

select * from GetHighSalaryEmployees(2000)

--3.Create function with name GetTotalSalary Type: Scalar Function Description: 
--Calculates and returns the total salary of all employees in the specified 
--department.
create or alter function GetTotalSalary(@deptid int)
returns int
  begin 
    DECLARE @sal int
       SELECT @sal = SUM(e.Salary) 
	   FROM Employee e, Departments
	   WHERE e.Dno = @deptid 
	   RETURN @sal
  end

select dbo.GetTotalSalary(10) as Total_Sal

--4.Create function with GetDepartmentManager Type: Inline Table-Valued Function 
--Description: Returns the manager's name and details for a specific department.

create or alter function GetDepartmentManager(@deptno int)
returns table
as 
return 
(
 SELECT e.Fname, e.Lname, e.Bdate, e.Address, e.Sex, e.Salary, d.Dnum
 FROM Employee e, Departments d
 WHERE e.SSN = d.MGRSSN and d.Dnum = @deptno
)

select * from GetDepartmentManager(10)

--6.Create multi-statements table-valued function that takes a string parameter
--If string='first name' returns student first name
--If string='last name' returns student last name 
--If string='full name' returns Full Name from student table 
--Note: Use “ISNULL()” function
create or alter function Getname(@input varchar(20))
returns @t table (Fname varchar(30))
as
 BEGIN
     IF @input = 'first name'
	 BEGIN 
		 INSERT @t 
		 SELECT ISNULL(e.Fname, 'NA')
		 FROM Employee e
      END
    ELSE IF @input = 'last name'
	 BEGIN 
		 INSERT @t 
		 SELECT ISNULL(e.Lname, 'NA')
		 FROM Employee e
      END
	  ELSE IF  @input = 'full name'
      BEGIN 
		 INSERT @t 
		 SELECT isnull(e.Fname+' '+ e.Lname,'NA')
		 FROM Employee e
      END

	 RETURN
 end
 
 select * from Getname('last name')