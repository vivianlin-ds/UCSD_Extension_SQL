/* Name: Vivian LinUni
ID: U09320143
Date: April 11, 2022
*/

USE Chinook
IF OBJECT_ID('Track_v_vl') IS NOT NULL DROP VIEW Track_v_vl
IF OBJECT_ID('ArtistAlbum_fn_vl') IS NOT NULL DROP FUNCTION ArtistAlbum_fn_vl
IF OBJECT_ID('TracksByArtist_p_vl') IS NOT NULL DROP PROC TracksByArtist_p_vl
GO

--Question 1: Create new view.
CREATE VIEW Track_v_vl AS
SELECT
	T.*
	,G.Name AS GenreName
	,MT.Name AS MediaTypeName
FROM Track T
JOIN Genre G
	ON G.GenreId = T.GenreId
JOIN MediaType MT
	ON MT.MediaTypeId = T.MediaTypeId

GO

--Question 2: Create new function.
CREATE FUNCTION ArtistAlbum_fn_vl (@TrackId int)
RETURNS varchar(100)
AS
BEGIN
DECLARE @ArtistAlbum varchar(100)
SELECT
	@ArtistAlbum = CONCAT(A.Name, '-', AL.Title)
FROM Track T
JOIN Album AL
	ON AL.AlbumId = T.AlbumId
JOIN Artist A
	ON A.ArtistId = AL.ArtistId
WHERE TrackId = @TrackId
RETURN @ArtistAlbum
END

GO

--Question 3: Create new stored procedure.
CREATE PROC TracksByArtist_p_vl 
	@ArtistName varchar(100)
AS
SELECT
	A.Name AS ArtistName
	,AL.Title AS AlbumTitle
	,T.Name AS TrackName
FROM Artist A
JOIN Album AL
	ON AL.ArtistId = A.ArtistId
JOIN Track T
	ON T.AlbumId = AL.AlbumId
WHERE A.Name LIKE CONCAT('%', @ArtistName, '%')

GO

--Question 4: Write SELECT using created view.
SELECT
	Tv.Name
	,Tv.GenreName
	,Tv.MediaTypeName
	,AL.Title
FROM Track_v_vl Tv
JOIN Album AL
	ON AL.AlbumId = Tv.AlbumId
WHERE Tv.Name = 'Babylon'

--Question 5: Write SELECT using created view and function.
SELECT
	dbo.ArtistAlbum_fn_vl(TrackId) AS "Artist and Album"
	,Name AS TrackName
FROM Track_v_vl
WHERE GenreName = 'Opera'

--Question 6: Execute created procedure.
EXEC TracksByArtist_p_vl 'black'
EXEC TracksByArtist_p_vl 'white'

GO

--Question 7: Alter created procedure.
ALTER PROC TracksByArtist_p_vl
	@ArtistName varchar(100) = 'Scorpions'
AS
SELECT
	A.Name AS ArtistName
	,AL.Title AS AlbumTitle
	,T.Name AS TrackName
FROM Artist A
JOIN Album AL
	ON AL.ArtistId = A.ArtistId
JOIN Track T
	ON T.AlbumId = AL.AlbumId
WHERE A.Name LIKE CONCAT('%', @ArtistName, '%')

GO

--Question 8: Execute altered procedure.
EXEC TracksByArtist_p_vl

--Question 9: Begin a transaction and run a update statement.
BEGIN TRANSACTION
UPDATE Employee
SET LastName = 'Lin'
WHERE EmployeeId = 1

--Question 10: View results, rollback, view results again.
SELECT
	EmployeeId
	,LastName
FROM Employee
WHERE EmployeeId = 1

ROLLBACK TRANSACTION

SELECT
	EmployeeId
	,LastName
FROM Employee
WHERE EmployeeId = 1