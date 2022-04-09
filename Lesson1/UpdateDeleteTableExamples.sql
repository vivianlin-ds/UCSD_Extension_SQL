/* Update to change existing statement.
Make all the first names in lower case and last name in upper case.
Delete all the Phone and Fax numbers. */
UPDATE Customer_Copy
SET FirstName = LOWER(FirstName)
,LastName = UPPER(LastName)
,Phone = NULL
,Fax = NULL
-- Use CASE statement to update value of a column (Company) to 'Google' if their email is gmail.
,Company = CASE WHEN Email LIKE '%gmail%' THEN 'Google' ELSE 'N/A' END

SELECT *
FROM Customer_Copy

/* Get the phone number and fax number back from the original table for customers in Canada. */
UPDATE CC
	SET Phone = C.Phone
	,Fax = C.Fax
FROM Customer_Copy CC
JOIN Customer C
	ON C.CustomerId = CC.CustomerId
WHERE CC.Country = 'Canada'

SELECT
	Country
	,Phone
	,Fax
FROM Customer_Copy

/* Delete the table from existence. */
DROP TABLE Customer_Copy