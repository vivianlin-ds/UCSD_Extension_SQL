/* Create a stored procedure with parameters. */
CREATE PROC ArtistGenre_p
	@ArtistName varchar(50)
	,@GenreName varchar(50)
AS
SELECT
	A.Name AS ArtistName
	,T.Name AS TrackName
	,G.Name AS GenreName
FROM Artist A
--Join four tables, Artist, Album, Track, and Genre together.
JOIN Album AL
	ON AL.ArtistId = A.ArtistId
JOIN Track T
	ON T.AlbumId = AL.AlbumId
JOIN Genre G
	ON G.GenreId = T.GenreId
--Filter by artistname and genrename (two parameters of the procedure).
WHERE A.Name = @ArtistName
	AND G.Name = @GenreName
GO

/* Executing procedures with parameters if no default has been set for them.
Two parameters must be listed in the same order as when they were defined. */
EXEC ArtistGenre_p 'U2', 'Rock'
GO

/* Add default values for the two parameters.*/
ALTER PROC ArtistGenre_p
	--Default value for artist is set to 'U2'.
	@ArtistName varchar(50) = 'U2'
	-- Default value for the genre is set to 'Rock'.
	,@GenreName varchar(50) = 'Rock'
AS
SELECT
	A.Name AS ArtistName
	,T.Name AS TrackName
	,G.Name AS GenreName
FROM Artist A
--Join four tables, Artist, Album, Track, and Genre together.
JOIN Album AL
	ON AL.ArtistId = A.ArtistId
JOIN Track T
	ON T.AlbumId = AL.AlbumId
JOIN Genre G
	ON G.GenreId = T.GenreId
--Filter by artistname and genrename (two parameters of the procedure).
WHERE A.Name = @ArtistName
	AND G.Name = @GenreName
GO

/* Once the default has been define, able to execute without providing parameters.*/
EXEC ArtistGenre_p
GO

/* Can switch the order of parameters if explicitly define the names of the parameter. */
EXEC ArtistGenre_p @GenreName = 'Blues', @ArtistName = 'Iron Maiden'
GO