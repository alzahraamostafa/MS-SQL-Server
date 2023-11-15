use ITI_new

--1.Create a stored procedure to show the total number of students 
--per department
go
CREATE PROC total_students
as
SELECT d.Dept_Id, count(s.St_Id)as total 
FROM Student s, Department d
where s.Dept_Id = d.Dept_Id
group by d.Dept_Id

exec total_students

--2.Create a trigger to prevent anyone from inserting a new record in 
--the Department table. Print a message for the user to tell him that 
--“he can’t insert a new record in that table
go
CREATE TRIGGER t1
ON Department
INSTEAD OF INSERT
AS 
SELECT 'You can’t insert a new record in that table'

insert into Department (Dept_Id, Dept_Name)
values (333, 'CS')

--3.Create a trigger on student table after insert to add Row in a 
--Student Audit table (Server User Name, Date, Note) where the note 
--will be “username Insert New Row with Key=Id in table student”
go
create table student_audit
(
	username varchar(100),
	dateadded date,
	note varchar(100)
)
go
create trigger t2
on student
after insert
as
INSERT INTO student_audit
 SELECT SUSER_NAME(), GETDATE(),
 'username Insert New Row with Key=Id in table student'

insert into Student(St_Id,St_Fname)
values (222222,'zahar')
insert into Student(St_Id,St_Fname)
values (2222232,'zahar')

select * from student_audit

