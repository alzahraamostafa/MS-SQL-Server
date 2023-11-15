use ITI_new

--1.Table-Valued Function - Get Instructors with Null Evaluation: 
--This function returns a table containing the details of instructors who have 
--null evaluations for any course.
create or alter function Getinstructors()
returns @t table (Fname varchar(30), degree varchar(10), salary money, eval varchar(10) )
as
 BEGIN
     insert @t
	 select distinct i.Ins_Name, i.Ins_Degree, i.Salary, ic.Evaluation
	 from Instructor i , Ins_Course ic
	 where i.Ins_Id = ic.Ins_Id and ic.Evaluation is null
	
	 RETURN
 end
 
 select * from Getinstructors()

--2.Table-Valued Function - Get Top Students: This function returns a table 
--containing the top students based on their average grades.
create or alter function Getgrades()
returns @t table (Fname varchar(30), grade int)
as
 BEGIN
     insert @t
	 select top 3 s.St_Fname, AVG(sc.Grade)
	 from Student s, Stud_Course sc
	 where s.St_Id = sc.St_Id
	 group by s.St_Fname
	 order by AVG(sc.Grade) desc
	 RETURN
 end
 
 select * from Getgrades()

 --3.Table-Valued Function - Get Students without Courses: This function 
 --returns a table containing details of students who are not registered for 
 --any course.
 create or alter function Getstudents()
returns @t table (id int, Fname varchar(30), lname varchar(30),ad nvarchar(30),age int, deptno int, super varchar(30))
as
 BEGIN
     insert @t
	 select * 
	 from Student 
	 where St_Id not in 
	(
		select s.St_Id
		from Stud_Course sc, Student s 
		where s.St_Id = sc.St_Id
	)
	return
 end
 
 select * from Getstudents()