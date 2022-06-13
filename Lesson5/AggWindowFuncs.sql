SELECT
	BillingCountry
	--Summed total for each country.
	,SUM(Total) SumTotal
FROM Invoice
GROUP BY BillingCountry

--Using OVER() with partitions
SELECT
	BillingCountry, CustomerId, InvoiceDate, Total
	--Add a total of each country while still retaining individual invoices.
	,SUM(Total) OVER (PARTITION BY BillingCountry) TotalbyCountry
	--Add a total of each customer while still retaining individual invoices.
	,SUM(Total) OVER (PARTITION BY CustomerId) TotalbyCustomer
	--Works without partition as well -> Give grand total
	,SUM(Total) OVER () GrandTotal
FROM Invoice

--Using OVER() with ORDER BY
SELECT
	BillingCountry, CustomerId, InvoiceDate, Total
	--Add a running sum of the invoice total by date invoice was created.
	,SUM(Total) OVER (ORDER BY InvoiceDate) RunningTotal
	--Add a running sum of the invoice total by year invoice was created.
	,SUM(Total) OVER (ORDER BY YEAR(InvoiceDate)) YearTotal
	--Can have running total by year, reset by year with PARTITION BY.
	,SUM(Total) OVER (PARTITION BY YEAR(InvoiceDate) ORDER BY InvoiceDate) RunningTotalbyYear
	,SUM(Total) OVER () GrandTotal
FROM Invoice

--Using OVER() with PARTITION BY ORDER BY and WHERE clause
SELECT
	BillingCountry
	,CustomerId
	,InvoiceDate
	,Total
	--Add a total number of invoices from each customer.
	,COUNT(Total) OVER (PARTITION BY CustomerId) PartitionBYct
	--Add a running count of invoices for each cutsomer.
	,COUNT(Total) OVER (PARTITION BY CustomerId ORDER BY InvoiceDate) RunningCount
	--Identify the lowest invoices from each customer.
	,MIN(Total) OVER (PARTITION BY CustomerId) PartitionBYmin
	--Identify the lowest invoices as it goes down the rows of invoices for each cutsomer.
	,MIN(Total) OVER (PARTITION BY CustomerId ORDER BY InvoiceDate) RunningMin
	--Identify the highest invoices from each customer.
	,MAX(Total) OVER (PARTITION BY CustomerId) PartitionBYmax
	--Identify the highest invoices as it goes down the rows of invoices for each cutsomer.
	,MAX(Total) OVER (PARTITION BY CustomerId ORDER BY InvoiceDate) RunningMax
	--Identify the average invoices from each customer.
	,AVG(Total) OVER (PARTITION BY CustomerId) PartitionBYavg
	--Identify the running average as it goes down the rows of invoices for each cutsomer.
	,AVG(Total) OVER (PARTITION BY CustomerId ORDER BY InvoiceDate) RunningAvg
	--Overall average of the records.
	,AVG(Total) OVER () OverallAvg
FROM Invoice
WHERE BillingCountry = 'India'