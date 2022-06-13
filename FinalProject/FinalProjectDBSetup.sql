USE master
IF DB_ID('LSP_vl') IS NOT NULL
BEGIN
	ALTER DATABASE LSP_vl SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE LSP_vl SET ONLINE;
	DROP DATABASE LSP_vl;
END

CREATE DATABASE LSP_vl
GO
USE LSP_vl

--Step1: Import all csv files into separate database 'MyDB_VivianLin' as backup.
/* Import procdeure as follows:
SQL server using SSMS > Task > Import File
CSV file is comma-separated, but need to check for text delimiters (ie ").
Use suggested datatype and make sure all ID numbers are imported as strings.
*/

--Step2: Clean the data, make sure no empty cells are present. All empty cells should be NULL.
/* 
Using Transaction for all table-altering code to have the chance to roll back changes.
Using NULLIF().
Run this for all columns for all tables.
Also, check the address table for State with length > 2.
Created new country column for address in foreign countries.
*/
BEGIN TRANSACTION

UPDATE SectionsSU11_SU15
SET StartDate = NULLIF(StartDate, ''), EndDate = NULLIF(EndDate, '')
Days = NULLIF(Days, ''), SectionStatus = NULLIF(SectionStatus, '')
,RoomName = NULLIF(RoomName, ''), PrimaryInstructor = NULLIF(PrimaryInstructor, '')
,SecondaryInstructor = NULLIF(SecondaryInstructor, '')

SELECT *
FROM Persons19
WHERE LEN(PostalCode) != 2

ALTER TABLE Persons19
ADD Country varchar(10)

UPDATE Persons19
SET Country = 'USA', State = 'CA'
WHERE PersonID = 803

COMMIT TRANSACTION
ROLLBACK TRANSACTION

--Step3: Merge the same tables for SU11-SU15 and FA15-SU19.
/* Create working in progress tables for each table so 
identity columns can be added and duplicated columns/rows can be removed.
*/
SELECT
	C.*
INTO ClassList_temp
FROM (
	SELECT * FROM ClassListFA15_SU19
	UNION
	SELECT * FROM ClassListSU11_SU15) C

--Step4: Check for any duplicated records.
SELECT 
	*
FROM Address_temp
WHERE PersonID IN (SELECT PersonID FROM Address_temp GROUP BY PersonID HAVING COUNT(*) > 1)

DELETE FROM Person_temp
WHERE PersonID = 887 AND State IS NULL

--Step5: Set up the individual tables and set up tables as required by instruction.
SELECT
	IDENTITY(int, 1, 1) AS AddressID --Add in identity columns as needed.
	,PersonID
	,AddressLine, City, State, Country, PostalCode
INTO Address_temp
FROM Person_temp

UPDATE Address_temp
SET AddressType = 'home'

SELECT
	ROW_NUMBER() OVER (PARTITION BY AddressType	ORDER BY PersonID) AS AddressID
	,*
INTO Address
FROM Address_temp

SELECT IDENTITY(int, 1, 1) AS FacultyPaymentID ,*
INTO FacultyPayment
FROM FacultyPayment_temp
WHERE FacultyID IS NOT NULL
ORDER BY FacultyID

SELECT 
	IDENTITY(int, 1, 1) AS ClassListID,
	SectionID,
	PersonID,
	EnrollmentStatus,
	TuitionAmount,
	Grade
INTO ClassList
FROM ClassList_temp

BEGIN TRANSACTION
/* FacultyPayment table requires special set up since primary instructor and secondary instructor columns in Section table has initials.
*/
--Parse the 'F. Lastname' format into individual columns.
SELECT *, SUBSTRING(PrimaryInstructor, 1, CHARINDEX(' ', PrimaryInstructor) - 1) AS PFirstInitial
,SUBSTRING(PrimaryInstructor, CHARINDEX(' ', PrimaryInstructor) + 1, LEN(PrimaryInstructor) - CHARINDEX(' ', PrimaryInstructor)) AS PLastName
,SUBSTRING(SecondaryInstructor, 1, CHARINDEX(' ', SecondaryInstructor) - 1) AS SFirstInitial
,SUBSTRING(SecondaryInstructor, CHARINDEX(' ', SecondaryInstructor) + 1, LEN(SecondaryInstructor) - CHARINDEX(' ', SecondaryInstructor)) AS SLastName
INTO Section_temp2
FROM Section_temp

SELECT 
	*
FROM Section_temp2
SELECT
	ST.SectionID, ST.CourseID, ST.TermID, ST.RoomID, ST.PrimaryFacultyID
	, ST.PrimaryPayment, F.FacultyID AS SecondaryFacultyID, ST.SecondaryPayment, ST.StartDate, ST.EndDate, ST.Days, ST.SectionStatus
INTO Section_final
FROM Section_temp2 ST
LEFT JOIN Faculty_temp F ON F.FacultyName = ST.SecondaryInstructor

SELECT
	C.*
INTO FacultyPayment_temp
FROM (
SELECT SectionID, PrimaryFacultyID AS FacultyID, PrimaryPayment AS Payment
FROM Section_final
UNION ALL
SELECT SectionID, SecondaryFacultyID AS FacultyID, SecondaryPayment AS Payment
FROM Section_final) C

SELECT *, SUM(Payment) OVER (PARTITION BY FacultyID ORDER BY FacultyID DESC) AS TotalPayment
FROM FacultyPayment_temp
SELECT*
FROM FacultyPayment_temp
ORDER BY FacultyID DESC

SELECT *
FROM FacultyPayment_temp
ORDER BY SectionID

SELECT IDENTITY(int, 1, 1) AS FacultyPaymentID ,*
INTO FacultyPayment
FROM FacultyPayment_temp
WHERE FacultyID IS NOT NULL
ORDER BY FacultyID

COMMIT TRANSACTION
ROLLBACK TRANSACTION

--Step6: Copy table from backup database to target database LSP_vl.
SELECT *
INTO LSP_vl.dbo.Section_temp
FROM MyDB_VivianLin.dbo.Section_final

SELECT *
INTO LSP_vl.dbo.Faculty15
FROM MyDB_VivianLin.dbo.Faculty15

SELECT *
INTO LSP_vl.dbo.Persons15
FROM MyDB_VivianLin.dbo.Persons15

SELECT *
INTO LSP_vl.dbo.Rooms15
FROM MyDB_VivianLin.dbo.Rooms15

SELECT *
INTO LSP_vl.dbo.SectionsSU11_SU15
FROM MyDB_VivianLin.dbo.SectionsSU11_SU15

SELECT *
INTO LSP_vl.dbo.Terms15
FROM MyDB_VivianLin.dbo.Terms15

--Step7: Set up all the primary key and foreign key based on instructions.
/* Step 4 is extemely important since primary key must be unique.
Use SSMS primary key and relationship buttons to set these up.
*/

--Step8: Clean up any straggling tables in the target database and move all other tables to backup database.
SELECT *
INTO MyDB_VivianLin.dbo.ClassListFA15_SU19Cleaned
FROM LSP_vl.dbo.ClassListFA15_SU19

SELECT *
INTO MyDB_VivianLin.dbo.Courses19Cleaned
FROM LSP_vl.dbo.Courses19

SELECT *
INTO MyDB_VivianLin.dbo.Faculty19Cleaned
FROM LSP_vl.dbo.Faculty19

SELECT *
INTO MyDB_VivianLin.dbo.Persons19Cleaned
FROM LSP_vl.dbo.Persons19

SELECT *
INTO MyDB_VivianLin.dbo.Terms19Cleaned
FROM LSP_vl.dbo.Terms19

SELECT *
INTO MyDB_VivianLin.dbo.ClassListFA15_SU19Cleaned
FROM LSP_vl.dbo.ClassListFA15_SU19

SELECT *
INTO MyDB_VivianLin.dbo.ClassList_temp
FROM LSP_vl.dbo.ClassList_temp

SELECT *
INTO MyDB_VivianLin.dbo.Faculty_temp
FROM LSP_vl.dbo.Faculty_temp

SELECT *
INTO MyDB_VivianLin.dbo.FacultyPayment_temp
FROM LSP_vl.dbo.FacultyPayment_temp

SELECT *
INTO MyDB_VivianLin.dbo.Section_final
FROM LSP_vl.dbo.Section_final

--Step9: Create the ERD, views and procedures.