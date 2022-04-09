SELECT Name, Composer
FROM Track
WHERE AlbumId = 99

-- Show only the records that appear in both datasets
INTERSECT
-- EXCEPT finds all records that exist only in dataset 1, not in dataset 2.
-- EXCEPT

SELECT Name, Composer
FROM Track
WHERE AlbumId = 96
ORDER BY Name