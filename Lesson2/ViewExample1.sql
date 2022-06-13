/* Joining information from one table with another.
Easiest way to access without having to code the JOIN statement 
each time is to use the VIEWs.*/
CREATE VIEW ArtistAlbum_v AS 
SELECT
	A.ArtistId
	,A.Name AS ArtistName
	,AL.Title AS AlbumTitle
FROM Artist A
JOIN Album AL
	ON A.ArtistId = AL.ArtistId
GO

/* Check if view is successfully created/altered. */
SELECT *
FROM ArtistAlbum_v

GO

/* Alter view. Need the GO to separate them from batch. */
ALTER VIEW [dbo].[ArtistAlbum_v] AS 
SELECT
	A.ArtistId
	,A.Name AS ArtistName
	,AL.AlbumId 
	,AL.Title AS AlbumTitle
FROM Artist A
JOIN Album AL
	ON A.ArtistId = AL.ArtistId
GO

/* Alternative way to access the view. */
EXEC sp_helptext ArtistAlbum_v
