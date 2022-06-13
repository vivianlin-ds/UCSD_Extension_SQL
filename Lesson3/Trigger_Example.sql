/* 3 trigger examples. */
--Database Prep
IF DB_ID('Chinook_Temp') IS NOT NULL
BEGIN
	--Put the database offline and disconnect all connections.
	ALTER DATABASE Chinook_Temp SET OFFLINE WITH ROLLBACK IMMEDIATE;
	--Put database back online and drop it.
	ALTER DATABASE Chinook_Temp SET ONLINE;
	DROP DATABASE Chinook_Temp;
END

CREATE DATABASE Chinook_Temp

GO
USE Chinook_Temp

--Create 3 Tables
CREATE TABLE Art (
	ArtistId int IDENTITY(1, 1) PRIMARY KEY
	,Name nvarchar(160)
)

CREATE TABLE Alb (
	AlbumId int IDENTITY(1, 1) PRIMARY KEY
	,Title nvarchar(120)
	,ArtistId int
)

CREATE TABLE Art_log(
	--Store changes made to the Art table.
	ArtistId int
	,Name nvarchar(160)
	,LogType varchar(10)
)

--Populate the 3 Tables
--Allow insert of numbers into the identity column instead of letting it propagate automatically.
SET IDENTITY_INSERT Art ON

INSERT INTO Art (ArtistId, Name)
SELECT 
	ArtistId
	,Name
FROM Chinook..Artist

--Only one Identity_insert can be ON at one time.
SET IDENTITY_INSERT Art OFF
SET IDENTITY_INSERT Alb ON

INSERT INTO Alb (AlbumId, Title, ArtistId)
SELECT
	AlbumId
	,Title
	,ArtistId
FROM Chinook..Album

SET IDENTITY_INSERT Alb OFF

--Create the triggers.

GO
CREATE Trigger Art_insert_trg
--Create trigger on the Art table.
ON Art
FOR INSERT
AS
BEGIN
INSERT INTO Alb (ArtistId, Title)
SELECT
	ArtistId
	,CONCAT('NewArtist: ', Name, ' -- AlbumTitle: Pending')
/* inserted vs deleted tables
Contain info related to the insertion/deletion of data when query is ran.
If identity column is used, inserted table will automatically use and store it. */
FROM inserted
END

GO
/* When things are deleted from the artist table, 
the corresponding record in the Album table will also be deleted. */
CREATE Trigger Art_delete_trg
ON Art
FOR DELETE
AS
BEGIN
DELETE Alb
FROM Alb
JOIN deleted 
	ON deleted.ArtistId = Alb.ArtistId
END

GO
/* Trigger executes on both deletion and insertion.
Keeping a log on these actions through the Art_log table. */
CREATE Trigger Art_log_trg
ON Art
FOR DELETE, INSERT
AS
BEGIN
INSERT INTO Art_log (ArtistId, Name, LogType)
SELECT
	--COALESCE() check to see whether one of its parameters is NULL.
	COALESCE(deleted.ArtistId, inserted.ArtistId)
	,COALESCE(deleted.Name, inserted.Name)
	,CASE WHEN EXISTS (
		SELECT * 
		FROM deleted)
		THEN 'deleted' ELSE 'inserted' END
/* For anything INSERT INTO, only the deleted table will be created. 
Unlike UPDATE statements, where both deleted and inserted tables will be created. */
FROM deleted
FULL JOIN inserted
	ON inserted.ArtistId = deleted.ArtistId
END
GO
