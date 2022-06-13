--SUM() has to go with GROUP BY clause
SELECT
	BillingCountry
	,SUM(Total) SumTotal
FROM Invoice
GROUP BY BillingCountry
ORDER BY SumTotal DESC

--Using Ranking Functions
SELECT
	BillingCountry
	,SUM(Total) SumTotal
	--Adding row number, will apply randomly if tie is encountered.
	,ROW_NUMBER() OVER (ORDER BY SUM(Total) DESC) RowNumber
	--Ranking will give ties the same rank.
	,RANK() OVER (ORDER BY SUM(Total) DESC) Ranking
	--Dense ranking will not skip the next number used for the same rank.
	,DENSE_RANK() OVER (ORDER BY SUM(Total) DESC) DenseRanking
	--NTILE function divides result set into specified number of groups, uneven division will reduce the last group.
	,NTILE(5) OVER (ORDER BY SUM(Total) DESC) Quintile
FROM Invoice
GROUP BY BillingCountry
ORDER BY Ranking

SELECT
	AL.Title AS AlbumTitle
	,T.Name AS TrackName
	--Assign track numbers to each track based on album
	,ROW_NUMBER() OVER (PARTITION BY AL.Title ORDER BY T.Name) TrackNbr
FROM Artist A
JOIN Album AL ON A.ArtistId = AL.ArtistId
JOIN Track T ON T.AlbumId = AL.AlbumId
WHERE A.Name = 'Green Day'

SELECT
	A.Name AS ArtistName
	,AL.Title AS AlbumTitle
	,SUM(IL.UnitPrice) AS TotalSales
	,RANK() OVER (ORDER BY SUM(IL.UnitPrice) DESC) TopSellingAlbums
	--Dense rank can also be used to see how many unique total sales there are.
	,DENSE_RANK() OVER (ORDER BY SUM(IL.UnitPrice) DESC) TopSellingAlbumsD
FROM Artist A
JOIN Album AL ON A.ArtistId = AL.ArtistId
JOIN Track T ON T.AlbumId = AL.AlbumId
JOIN InvoiceLine IL ON IL.TrackId = T.TrackId
GROUP BY A.Name, AL.Title
--Show only the albums with total sales over $20.00
HAVING Sum(IL.UnitPrice) > 20
ORDER BY TotalSales DESC