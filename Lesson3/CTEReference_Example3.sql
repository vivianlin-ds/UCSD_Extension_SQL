/* Able to refer one CTE in another CTE as long as 
the referred CTE is already declared/defined. */

WITH AlbumTrackTotal AS
(
SELECT
	Al.ArtistId
	,AL.Title
	,COUNT(*) AS TrackCount
FROM Album AL
JOIN Track T 
	ON AL.AlbumId = T.AlbumId
GROUP BY Al.ArtistId, AL.Title
)
--Second CTE referencing the first one, cannot be defined before the referenced CTE is defined.
, ArtistTotal AS
(
SELECT
	A.Name AS ArtistName
	,ATT.Title AS AlbumTitle
	,ATT.TrackCount
FROM Artist A
JOIN AlbumTrackTotal AS ATT
	ON ATT.ArtistId = A.ArtistId
)

SELECT *
FROM ArtistTotal
WHERE ArtistName = 'Metallica'
