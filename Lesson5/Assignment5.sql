/* Name: Vivian Lin
ID: U09320143
Date: May 3, 2022
*/

--Question 1: Create single random number between 100-200.
SELECT CEILING(RAND()*100+100) AS RandomNumber

--Question 2: Assign random nuber to each row in Track table.
SELECT
	TrackId
	,Name
	,CEILING(RAND(CAST(NEWID() AS varbinary))*3000) AS RandomByRow
FROM Track
ORDER BY RandomByRow DESC

--Question 3: Assign random unique integer ID to each row in Artist table.
SELECT
	ArtistId
	,Name
	,ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomUniqueID
FROM Artist;

--Question 4: Find top all-time sales in Album table and rank them.
WITH CTE AS
(
SELECT 
	A.Name AS ArtistName
	,AL.Title AS AlbumTitle
	,SUM(IL.UnitPrice) AS TotalSales
	,CASE 
		WHEN MT.Name LIKE '%Video%' THEN 'Video' 
		ELSE 'Audio' END
		AS Media
FROM Album AL
JOIN Artist A ON A.ArtistId = AL.ArtistId
JOIN Track T ON T.AlbumId = AL.AlbumId
JOIN InvoiceLine IL ON IL.TrackId = T.TrackId
JOIN MediaType MT ON MT.MediaTypeId = T.MediaTypeId
GROUP BY A.Name, AL.Title, CASE WHEN MT.Name LIKE '%Video%' THEN 'Video' ELSE 'Audio' END
)
SELECT 
	*
	,RANK() OVER (PARTITION BY Media ORDER BY TotalSales DESC) AS Ranking
	,DENSE_RANK() OVER (PARTITION BY Media ORDER BY TotalSales DESC) AS DenseRanking
FROM CTE
WHERE TotalSales > 15;

--Question 5: Display top 3 albums for each genre.
WITH CTE AS
(
SELECT
	G.Name AS GenreName
	,AL.Title AS AlbumTitle
	,SUM(IL.UnitPrice) AS TotalSales
	,RANK() OVER (PARTITION BY G.Name ORDER BY SUM(IL.UnitPrice) DESC) AS Ranking
FROM Album AL
JOIN Track T ON T.AlbumId = AL.AlbumId
JOIN Genre G ON G.GenreId = T.GenreId
JOIN InvoiceLine IL ON IL.TrackId = T.TrackId
GROUP BY G.Name, AL.Title
HAVING SUM(IL.UnitPrice) > 15
)
SELECT *
FROM CTE
WHERE Ranking <= 3
ORDER BY GenreName, Ranking;

--Question 6: Display a running total of purchases by Artist.
SELECT
	A.Name AS ArtistName
	,SUM(IL.UnitPrice) AS TotalPrice
	,SUM(SUM(IL.UnitPrice)) OVER (ORDER BY A.Name) AS RunningTotal
FROM Artist A
JOIN Album AL ON AL.ArtistId = A.ArtistId
JOIN Track T ON T.AlbumId = AL.AlbumId
JOIN InvoiceLine IL ON IL.TrackId = T.TrackId
GROUP BY A.Name

--Question 7: Display total sales by country, group records by quintile.
SELECT
	BillingCountry
	,SUM(Total) AS TotalSales
	,NTILE(5) OVER (ORDER BY SUM(Total) DESC, BillingCountry) AS Quintile
FROM Invoice
GROUP BY BillingCountry

--Question 8: Display all Invoice purchases for customers by invoice date.
SELECT
	C.FirstName
	,C.LastName
	,C.Country
	,CAST(I.InvoiceDate as date) AS InvoiceDate
	,I.Total
	,SUM(Total) OVER (PARTITION BY C.CustomerId) AS TotalByCustomer
	,SUM(Total) OVER (PARTITION BY C.Country) AS TotalByCountry
FROM Customer C
JOIN Invoice I ON I.CustomerId = C.CustomerId
ORDER BY Country, LastName, Total

--Question 9: Display Track and Album play times for Artist 'Green Day'.
SELECT
	AL.Title AS AlbumTitle
	,CONVERT(varchar, DATEADD(ms, SUM(T.Milliseconds) OVER (PARTITION BY AL.Title), 0), 108) AS AlbumTime
	,ROW_NUMBER() OVER (PARTITION BY AL.Title ORDER BY CONVERT(varchar, DATEADD(ms, T.Milliseconds, 0), 108) DESC) AS TrackNumber
	,T.Name AS TrackName
	,COUNT(T.TrackId) OVER (PARTITION BY AL.Title) AS TrackCount
	,CONVERT(varchar, DATEADD(ms, T.Milliseconds, 0), 108) AS TrackTime
FROM Album AL
JOIN Track T ON T.AlbumId = AL.AlbumId
JOIN Artist A ON A.ArtistId = AL.ArtistId
WHERE A.Name = 'Green Day'
ORDER BY AlbumTitle

--Question 10: Display current and previous year invoice sales totals for each year by Country.
SELECT
	BillingCountry
	,YEAR(InvoiceDate) AS BillingYear
	,SUM(Total) AS CurrentYear
	,LAG(SUM(Total), 1, 0) OVER (PARTITION BY BillingCountry ORDER BY YEAR(InvoiceDate)) AS PriorYear
	,(SUM(Total) - LAG(SUM(Total), 1, 0) OVER (PARTITION BY BillingCountry ORDER BY YEAR(InvoiceDate))) AS YearDifference
FROM Invoice
GROUP BY BillingCountry, YEAR(InvoiceDate)
HAVING BillingCountry IN ('USA', 'Canada')