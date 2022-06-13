WITH TrackInfo AS
(
SELECT
	T.TrackId
	,A.Name AS ArtistName
	,AL.Title AS AlbumName
	,T.Name AS TrackName
	,G.Name AS GenreName
FROM Artist A
JOIN Album AL
	ON AL.ArtistId = A.ArtistId
JOIN Track T
	ON T.AlbumId = AL.AlbumId
JOIN Genre G
	ON G.GenreId = T.GenreId
--WHERE 1=2
)

--Create a temp table from th CTE.
/*
SELECT *
INTO TrackInfo_temp
FROM TrackInfo
*/

--Statement can also be INSERT statement.
/*
INSERT INTO TrackInfo_temp (TrackId, ArtistName, AlbumName, TrackName)
SELECT
	TrackId
	,ArtistName
	,AlbumName
	,TrackName
FROM TrackInfo
*/

--Statement can also be UPDATE statement.
/*
UPDATE TT
SET GenreName = T.GenreName
FROM TrackInfo T
JOIN TrackInfo_temp TT
	ON TT.TrackId = T.TrackId
*/

--Statement can also be DELETE statement.
DELETE TT
FROM TrackInfo T
JOIN TrackInfo_temp TT
	ON TT.TrackId = T.TrackId