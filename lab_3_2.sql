use Company_SD

--1.Employee Ranking within Departments: Challenge: You want to rank employees 
--within each department based on their salaries
select e.*, dense_rank() over(partition by d.dnum order by e.salary desc)
as highest_employee
from Employee e, Departments d
where e.Dno = d.Dnum

--2.Employee Ranking by Project Contributions: Challenge: You want to rank 
--employees based on the number of hours they worked on each project.
select e.Fname, e.Lname, w.Hours, w.Pno, 
dense_RANK() over(partition by w.pno order by w.hours desc) as proj_hours
from Employee e, Works_for w
where e.SSN = w.ESSn

--3.Project Ranking by Employee Contributions: Challenge: You want to rank 
--projects based on the total number of hours worked on each project.
select w.Pno, p.Pname, w.Hours, 
dense_RANK() over(partition by p.pname order by w.hours desc) as proj_hours
from Project p, Works_for w
where p.Pnumber = w.Pno

--4.Department Ranking by Project Count: Challenge: You want to rank departments 
--based on the number of projects they have. 
SELECT *, ROW_NUMBER() over(order by number_of_projects desc)as ordered
 FROM
 (SELECT p.Pname, COUNT(P.Pnumber) as number_of_projects
 FROM Departments D , Project P
 where d.Dnum=p.Dnum
 group by p.Pname) as ordered_table

--5.Employee Age Ranking: Challenge: You want to rank employees based on their ages
select *, year(getdate()) - year(e.bdate) as age,
DENSE_RANK() over(order by year(getdate()) - year(e.bdate) desc) as ordered
from Employee e