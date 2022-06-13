/* Create another view that joins a view with a table.
However, this may be difficult to understand if used too frequently. */
CREATE VIEW ArtistAlbumTrack_v AS
SELECT
	--Get everything from the view.
	AA.*
	--Limit columns from Track.
	,T.TrackId
	,T.Name AS TrackName
FROM ArtistAlbum_v AA
JOIN Track T
	ON T.AlbumId = AA.AlbumId
GO

SELECT *
FROM ArtistAlbumTrack_v

DROP VIEW ArtistAlbumTrack_v