/* CTE: Common Table Expressions. */
--If using another statement with the CTE, need to include a ; to indicate end of statement.
USE Chinook;
--Create a CTE named TrackInfo, can also define the column aliases up here .
WITH TrackInfo 
--(ArtistName, AlbumTitle, TrackName)
AS
--Enclose query in ().
(
--Query that returns 3503 rows.
SELECT
	--Cannot have columns with the same name, so aliases are highly recommended.
	A.Name AS ArtistName
	,AL.Title AS AlbumName
	,T.Name AS TrackName
FROM Artist A
JOIN Album AL
	ON Al.ArtistId = A.ArtistId
JOIN Track T
	ON T.AlbumId = AL.AlbumId
--Cannot use coloumn aliases in the WHERE clause when column aliases are being defined.
WHERE A.Name = 'U2'
)
--Statement can be INSERT, DELETE, UPDATE, or SELECT.
SELECT *
FROM TrackInfo
--Able to use column aliases here because aliases has been defined for the CTE.
WHERE TrackName LIKE 'Zoo%'
--Can continue to use the column aliases that had been defined for the CTE.
ORDER BY TrackName DESC