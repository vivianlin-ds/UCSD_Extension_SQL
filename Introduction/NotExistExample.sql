SELECT Name, Composer
FROM Track T
WHERE AlbumId = 99
AND NOT EXISTS(
	SELECT *
	FROM Track T2
	WHERE T2.AlbumId = 96
	AND T2.Name = T.Name
	)
ORDER BY Name

/* Same as following code, but EXISTS queries are more flexible
SELECT Name, Composer
FROM Track
WHERE AlbumId = 99

EXCEPT

SELECT Name, Composer
FROM Track
WHERE AlbumId = 96
ORDER BY Name */