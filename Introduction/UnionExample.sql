SELECT LastName, FirstName, 'Cust' AS RecordType
FROM Customer
UNION
-- Since the first line already specified the name of third column, no need to do it again.
SELECT LastName, FirstName, 'Emp'
FROM Employee