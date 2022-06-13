/* Name: Vivian Lin
ID: U09320143
Date: April 16, 2022
*/

--Question 1: Create specified CTE named "AA" and display artist "AudioSlave".
WITH AA AS
(
SELECT 
	A.ArtistId
	,A.Name AS ArtistName
	,AL.AlbumId
	,AL.Title AS AlbumTitle
FROM Artist A
JOIN Album AL
	ON AL.ArtistId = A.ArtistId
WHERE A.Name = 'AudioSlave'
)
SELECT
	AA.ArtistName
	,AA.AlbumTitle
	,T.Name AS TrackName
FROM AA
JOIN Track T
	ON T.AlbumId = AA.AlbumId

--Question 2: Create subquery and display artist "Kiss".
SELECT
	AA.ArtistName
	,AA.AlbumTitle
	,T.Name AS TrackName
FROM (
	SELECT 
		A.ArtistId
		,A.Name AS ArtistName
		,AL.AlbumId
		,AL.Title AS AlbumTitle
	FROM Artist A
	JOIN Album AL
		ON AL.ArtistId = A.ArtistId
) AA
JOIN Track T
	ON T.AlbumId = AA.AlbumId
WHERE ArtistName = 'Kiss';

--Question 3: Create CTE "CTC"-Customer Total Cost and display customer names, rep last names, and total.
WITH CTC AS
(
SELECT
	C.FirstName + ' ' + C.LastName AS CustomerName
	,SUM(I.Total) AS SumTotal
	,C.SupportRepId
FROM Customer C
JOIN INVOICE I
	ON I.CustomerId = C.CustomerId
GROUP BY
	C.FirstName + ' ' + C.LastName
	,C.SupportRepId
)
SELECT 
	E.LastName AS SupportRep
	,CTC.CustomerName
	,CTC.SumTotal
FROM CTC
JOIN Employee E
	ON E.EmployeeId = CTC.SupportRepId
ORDER BY SumTotal DESC, SupportRep

--Question 4: Create a subquery to display "Iron Maiden" albums' track counts.
SELECT
	A.Name AS ArtistName
	,AL.Title AS AlbumTitle
	,( 
		SELECT COUNT(*)
		FROM Track T
		WHERE T.AlbumId = AL.AlbumId
	) AS TrackCount
FROM Artist A
JOIN Album AL
	ON AL.ArtistId = A.ArtistId
WHERE A.Name = 'Iron Maiden'
ORDER BY TrackCount;

--Question 5: Create a CTE "TC"-TrackCount to display "U2" albums' track counts.
WITH TC AS
(
SELECT
	T.AlbumId
	,COUNT(*) AS TrackCount
FROM Track T
GROUP BY T.AlbumId
)
SELECT
	A.Name AS ArtistName
	,AL.Title AS AlbumTitle
	,TC.TrackCount
FROM TC
JOIN Album AL
	ON AL.AlbumId = TC.AlbumId
JOIN Artist A
	ON A.ArtistId = AL.ArtistId
WHERE A.Name = 'U2'
ORDER BY TrackCount;

--Question 6: Use CTEs to gather birthdays for all employees.
WITH DOB AS
(
SELECT
	FirstName + ' ' + LastName AS FullName
	,FORMAT(BirthDate, 'MM-dd-yyyy') AS BirthDate
	,FORMAT(DATEADD(YEAR, (2021 - YEAR(BirthDate)), BirthDate), 'MM-dd-yyyy') AS BirthDay2021
FROM Employee
)
, Celebrate AS
(
SELECT
	FullName
	,BirthDate
	,BirthDay2021
	,FORMAT(CASE 
		WHEN (DATENAME(WEEKDAY, BirthDay2021) = 'Saturday') THEN DATEADD(DAY, 2, BirthDay2021)
		WHEN (DATENAME(WEEKDAY, BirthDay2021) = 'Sunday') THEN DATEADD(DAY, 1, BirthDay2021)
		ELSE BirthDay2021
		END, 'MM-dd-yyyy') AS CelebrationDate
FROM DOB
)
SELECT
	FullName
	,BirthDate
	,BirthDay2021
	,DATENAME(WEEKDAY, BirthDay2021) AS BirthDayOfWeek2021
	,CelebrationDate
	,DATENAME(WEEKDAY, CelebrationDate) AS CelebrationDayOfWeek2021
FROM Celebrate

--Prep for Question 7-10
GO
USE master
IF DB_ID('MyDB_vl') IS NOT NULL
BEGIN
	ALTER DATABASE MyDB_vl SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE MyDB_vl SET ONLINE;
	DROP DATABASE MyDB_vl;
END
CREATE DATABASE MyDB_vl
GO
USE MyDB_vl
--Create sample table.
SELECT *
INTO Staff
FROM Chinook.dbo.Employee
--Create log table.
SELECT
	CAST('' AS varchar(20)) AS DMLType
	,SYSDATETIME() AS DateUpdated
	,SYSTEM_USER AS UpdatedBy
	,*
INTO Staff_log
FROM Chinook.dbo.Employee
WHERE 1 = 2 --Table creation shortcut=> Created, but no data inserted.

--Question 7: Update Nancy Edwards title in the Staff table.
UPDATE Staff
SET Title = 'New General Manager'
OUTPUT 
	inserted.EmployeeId
	,deleted.Title AS TitleBefore
	,inserted.Title AS TitleAfter
WHERE FirstName = 'Nancy' AND LastName = 'Edwards'

--Question 8: Create Trigger on Staff table.
GO
CREATE TRIGGER Staff_trg
ON Staff
FOR UPDATE, DELETE
AS
BEGIN
INSERT INTO Staff_log
SELECT
	'deleted'
	,SYSDATETIME()
	,SYSTEM_USER
	,*
FROM deleted
INSERT INTO Staff_log
SELECT
	'inserted'
	,SYSDATETIME()
	,SYSTEM_USER
	,*
FROM inserted
END
GO

--Question 9: Delete Andrew Adams from Staff.
DELETE Staff
WHERE FirstName = 'Andrew' AND LastName = 'Adams'

--Question 10: Update Jane Peacock's Title to "New Sales Manager".
UPDATE Staff
SET Title = 'New Sales Manager'
WHERE FirstName = 'Jane' AND LastName = 'Peacock'

--Question 11: Show recrods from Staff and Staff_log.
SELECT *
FROM Staff

SELECT *
FROM Staff_log