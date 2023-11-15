use ITI_new

--1.Identifying the Top Instructors by Average Evaluation Score:
--Run these queries first:
--Use the "Ins_Course" table to calculate the average evaluation score for each 
--instructor.
--Rank the instructors based on their average evaluation scores and identify 
--the top instructors with the highest scores.
alter table Ins_Course add  evaluation_int int
update Ins_Course set evaluation_int =100 where evaluation='Good' 
update Ins_Course set evaluation_int =200 where evaluation='VGood'
update Ins_Course set evaluation_int =400 where evaluation='Distinct'

with cte 
as 
(
	 select * , avg(ic.Evaluation_int) over 
	 (PARTITION by ic.ins_id)
	 as av
	 from Ins_Course ic
)
select ic.av, i.Ins_Name,c.Crs_Name , ROW_NUMBER() 
over(order by ic.av desc) as orderd
from cte ic, Instructor i, Course c
where i.Ins_Id = ic.Ins_Id and c.Crs_Id = ic.crs_id

--2.Identifying the Top Topics by the Number of Courses:
--Use the "Topic" and "Course" tables to count the number of courses available 
--for each topic.
--Rank the topics based on the count of courses and identify the most popular 
--topics with the highest number of courses.
with cte
as
(
	select t.Top_Name, c.Crs_Name,COUNT(c.Crs_Id) over(partition by t.Top_Name)
	as number
	from Topic t, Course c
	where t.Top_Id = c.Top_Id
)
select *, dense_rank() over(order by number desc) as ordered 
from cte

--3.Finding Students with the Highest Overall Grades:
--Use the "Stud_Course" table to calculate the total grades for each student 
--across all courses.
--Rank the students based on their total grades and identify the students with 
--the highest overall grades.
with cte
as
(
	select sc.St_Id, sum(sc.Grade) as total
	from Stud_Course sc
	group by sc.St_Id
)
select c.* , s.St_Fname, dense_rank() over(order by total desc) as top_students
from cte c, Student s
where c.st_id = s.St_Id

