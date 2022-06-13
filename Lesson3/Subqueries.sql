/* Self-contained subquery in the WHERE clause.
Self-contained subquer - Independent query that can be executed by itself. */
SELECT *
FROM Invoice
WHERE customerId IN (
	SELECT CustomerId
	FROM Customer
	WHERE Country = 'India'
	)

/* Correlated subquery in the WHERE clause.
Correlated subquery - Dependent query that referencings the result/definition from another query. */
SELECT *
FROM Invoice I
WHERE EXISTS(
	SELECT *
	FROM Customer C
	WHERE Country = 'India'
	AND C.CustomerId = I.CustomerId
)

/* Subqueries in the FROM clause. 
Subqueries will be executed first (can be done independently), so the column aliases need to be used.
Need to name the subquery.
Any changes to the subquery will be reflected immediately. */
SELECT *
FROM
(
	SELECT 
		A.Name AS ArtistName
		,AL.Title AS AlbumTitle
		,T.Name AS TrackName
		,G.Name AS GenreType
	FROM Artist A
	JOIN Album AL
		ON Al.ArtistId = A.ArtistId
	JOIN Track T
		ON T.AlbumId = AL.AlbumId
	JOIN Genre G
		ON G.GenreId = T.GenreId
	WHERE G.Name != 'rock'
) TrackInfo
--TrackInfo is the name of the subquery.
--Once the queries are completed, able to make changes.
WHERE ArtistName = 'Iron Maiden'

/* Subqueries in the SELECT statement.
Subqueries need to be enclosed in (). */
SELECT
	A.Name AS ArtistName
	,(
		SELECT COUNT(*)
		FROM Album AL
		--WHERE clause makes this subquery correlated since it calls the A alias.
		WHERE AL.ArtistId = A.ArtistId
		) AS AlbumCountByArtist
	,(
		--Self-contained independent subquery.
		SELECT COUNT(*)
		FROM Album AL
		) AS TotalAlbumCount
FROM Artist A
ORDER BY AlbumCountByArtist DESC