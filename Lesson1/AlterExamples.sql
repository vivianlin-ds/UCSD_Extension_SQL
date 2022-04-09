/* Rename the database. 
Change where the tab is pointing to on left corner. 
From Chinook_Example to master from the dropdown. */
ALTER DATABASE Chinook_Example
MODIFY NAME = Example

/* Modify existing tables.
Need to make sure connection is to the database now instead of 'master'.
Add two columns to existing table Person. */
ALTER TABLE Person
ADD
MiddleName varchar(20) NULL
,Ethnicity varchar(50) NULL

/* Modifying existing column of a table.
Can only modify one column at a time. */
ALTER TABLE Person
ALTER COLUMN
MiddleName nvarchar(35)

ALTER TABLE Person
ALTER COLUMN
Ethnicity char(2)

/* Drop columns from table.
Can drop multiple columns at a time. */
ALTER TABLE Person
DROP COLUMN
MiddleName
,Ethnicity
