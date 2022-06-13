--Show the total sales by year.
SELECT
	YEAR(InvoiceDate) AS SalesYear
	,SUM(Total) AS TotalSales
FROM Invoice
GROUP BY YEAR(InvoiceDate)

--Using Analytic functions to look forward and backward in the data table.
SELECT
	YEAR(InvoiceDate) AS SalesYear
	,SUM(Total) AS TotalSales
	/* LAG/LEAD takes three parameters:
	1st: What column is being returned
	2nd: How far back/foward in rows
	3rd: (Optional) Default value if no row is found. If not specified, NULL will be default. */
	,LAG(SUM(Total), 1, 0) OVER (ORDER BY YEAR(InvoiceDate)) AS PriorYear
	,LEAD(SUM(Total), 1, 0) OVER (ORDER BY YEAR(InvoiceDate)) AS NextYear

	--FIRST_VALUE selects the first row of the dataset.
	,FIRST_VALUE(SUM(Total)) OVER (ORDER BY YEAR(InvoiceDate)) AS FirstYear
	--LAST_VALUE to select the last row of the dataset, need to specify a range. Otherwise, it will go down row by row.
	,LAST_VALUE(SUM(Total)) OVER (ORDER BY YEAR(InvoiceDate)
	--Specify the range for the LAST_VALUE. UNBOUNDED PRECEDING/FOLLOWING means the whole table.
	ROWS between UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING) AS LastYear
	
	--Aggregate functions
	,MAX(SUM(Total)) OVER() MaxYearSales
	,MIN(SUM(Total)) OVER() MinYearSales
FROM Invoice
GROUP BY YEAR(InvoiceDate)