use My_Test

--3.Return the result of this XML data as table (XML shredding (From XML To Table))
--Create a table according to the returned tabular data and insert the result on 
--it (Search for: Create table as select statement).
declare @xml xml =
	'<books>
	<book genre="VB" publicationdate="2010">
	   <title>Writing VB Code</title>
	   <author>
		  <firstname>ITI</firstname>
		  <lastname>ITI</lastname>
	   </author>
	   <price>44.99</price>
	</book>
	</books>'

declare @a int
Exec sp_xml_preparedocument @a output, @xml

select * INTO My_Table
FROM OPENXML (@a, '//book')
WITH (book varchar(10) '@genre',
	  puplication_date int '@publicationdate', 
	  title varchar(10) 'title',
	  author_fname varchar(10) 'author/firstname',
	  author_sname varchar(10) 'author/lastname',
	  price money 'price')

Exec sp_xml_removedocument @a

select * from My_Table

BACKUP DATABASE My_Test
TO DISK = 'E:\my_db_backup.bak';