use Company_SD

--Create a view that shows the project number and name along with the total number
--of hours worked on each project.
Create view Vproject
as
	Select p.Pnumber, sum(w.Hours) as hoursCount, p.Pname
	from Project p, Works_for w
	where p.Pnumber = w.Pno
	group by p.Pnumber, p.Pname

--Create a view that displays the project number and name along with the name 
--of the department managing the project, ordered by project number.
Create view Vprojectdept
as
	Select p.Pnumber, p.Pname, d.Dname
	from Project p, Departments d
	where d.Dnum = p.Dnum

select * from Vprojectdept order by Pnumber

--Create a view that shows the project name and location along with the total 
--number of employees working on each project.
create view Vprojectloc
as
	select p.Pname, p.Plocation, count(e.SSN) as employeeNum
	from Project p, Employee e
	where p.Dnum = e.Dno
	group by p.Pname, p.Plocation

--Create a view that displays the department number, name, and the number of 
--employees in each department.
create view Vdeptemp
as
	select d.Dnum, d.Dname, count(e.SSN) as empnums
	from Departments d, Employee e
	where d.Dnum = e.Dno
	group by d.Dnum, d.Dname

--Create a view that shows the names of employees who work on more than one 
--project, along with the count of projects they work on.
create view emprojects
as
	select e.Fname, COUNT(p.Pnumber) projCount
	from Employee e, Project p
	where e.Dno = p.Dnum 
	group by e.Fname
	having COUNT(p.Pnumber) >= 1

--Create a view that displays the average salary of employees in each department, 
--along with the department name.
create view avgslary
as
	select avg(e.Salary) as averageSalary, d.Dname
	from Employee e, Departments d
	where e.Dno = d.Dnum
	group by d.Dname

--Create a view that lists the names and age of employees and their dependents in
--a single result set. The age should be calculated based on the current date.
create view empInfo
as
	select e.Fname, year(GETDATE())- year(e.Bdate) as empage, d.Dependent_name
	,year(GETDATE())- year(d.Bdate) as depage
	from Employee e, Dependent d
	where e.SSN = d.ESSN

--Create a view that displays the names of employees who have dependents, 
--along with the number of dependents each employee has.
create view empdepend
as
	select e.Fname, COUNT(d.Dependent_name) as dependCount
	from Employee e, Dependent d
	where e.SSN = d.ESSN
	group by e.Fname

--Create a new user defined data type named loc with the following Criteria:
--nchar(2)
--default: NY 
--create a rule for this data type : values in (NY,DS,KW)) and associate it to 			
--the location column in new table named project2 with (name ,location)
CREATE TYPE loc1 FROM nchar(2);

create rule r1 as @values IN ('NY', 'DS', 'KW')
sp_bindrule r1, loc1

create default def1 as 'NY'
sp_bindefault def1, loc1

create table project2
(
	name nchar(10),
	location loc1
	constraint c1 check(location in ('NY', 'DS', 'KW'))
)

--Create a view that displays the full name (first name and last name), 
--salary, and the name of the department for employees working in the department 
--with the highest average salary.
create view fullinfo
as
	select concat(e.Fname,' ',e.Lname) as Fullname, d.Dname,
	avg(e.Salary) as salary
	from Employee e, Departments d
	where e.Dno = d.Dnum
	group by concat(e.Fname,' ',e.Lname), d.Dname

select Fullname, Dname, MAX(salary) from fullinfo
group by Fullname, Dname

select MAX(salary) from fullinfo group by salary
--select jointid,max(fitupdetailid),max(weldetaildid) from <yourviewname>
--group by jointid

--Create a view that displays the names and salaries of employees who earn 
--more than the average salary of their department.
create view empinfo
as
	select e.Fname, e.Salary, d.Dnum
	from Employee e, Departments d
	where e.Dno = d.Dnum 
	group by e.Fname,d.Dnum
	having e.Salary > AVG(e.Salary)
