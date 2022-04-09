SELECT Name, Composer
FROM Track
WHERE AlbumId = 99
-- UNION gets only the distinct records from the two datasets.
-- Use UNION ALL to get everything (regardless of duplicates).
UNION ALL

SELECT Name, Composer
FROM Track
WHERE AlbumId = 96
-- ORDER BY has to be at the end of the query.
ORDER BY Name
