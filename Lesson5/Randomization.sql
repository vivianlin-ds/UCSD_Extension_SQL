--RAND() returns random value between 0 and 1, and can take int as parameter as seed.
SELECT RAND()
--RAND() with same seed will return the same number everytime it is ran.
SELECT RAND(100)
SELECT RAND(100)
--To create random numbers over a range:
SELECT RAND()*100
--Use CEILING/FLOOR function to round it up/down to int
SELECT CEILING(RAND()*100)
SELECT FLOOR(RAND()*100)
--NEWID() creates a random, unique identifier for each row.
SELECT NEWID()

--Adding randomizations to queries.
--This will give the same random number for all rows
SELECT *
	,RAND() AS RandomNbr
	,NEWID() AS RandomID
FROM Album

SELECT *
--Use NEWID() to generate diff random number for rows, but need to convert NEWID to var binary (a type of numeric).
,CEILING(RAND(CAST(NEWID() AS varbinary))*200) AS RandomID
FROM Album
ORDER BY RandomID

--Return top 5 rows.
SELECT TOP 5*
FROM Album
--Return a randomized 5 entries, will not work with RAND() since it gives same random number to all rows.
ORDER BY NEWID()