/* Building CTE with two queries.
Tabbing the queries for clarity. */

--First CTE is called T.
WITH T AS
(
	SELECT
		Name AS TrackName
		,GenreId
	FROM Track
)
--Second CTE is called G.
--Do not need the WITH statement again, but include a comma.
,G AS
(
	SELECT
		GenreId
		,Name AS GenreName
	FROM Genre
)
--Statement is included as normal.
SELECT
	T.TrackName
	,G.GenreName
FROM T
JOIN G
	ON G.GenreId = T.GenreId