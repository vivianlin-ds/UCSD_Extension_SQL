--Verify that both Art and Alb tables are created succesfully.
SELECT *
FROM Art
ORDER BY ArtistId DESC

SELECT *
FROM Alb
ORDER BY AlbumId DESC

--Test insertion trigger for the Art table.
INSERT INTO Art(Name)
VALUES
	('Billy Idol')
	,('Depeche Mode')
/* Result will have 3 (2 rows affected) because
1) one insert to the Art table
2) one insert to the Alb table
3) one insert to the Art_log table
due to the trigger set up. */

--Test deletion trigger for the Art table.
DELETE Art
WHERE ArtistId % 2 = 1
/* Result will have 3 completion statements because
1) one insert to the Art table
2) one insert to the Alb table
3) one insert to the Art_log table
due to the trigger set up. */

--Check the Art_log for a history of changes made to the tables.
SELECT *
FROM Art_log
ORDER BY ArtistId