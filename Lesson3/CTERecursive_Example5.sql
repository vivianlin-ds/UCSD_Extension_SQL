/* Recursive CTEs are good for org charts (with hierarchy). */

WITH cteReports (EmpID, FirstName, LastName, MgrID, EmpLevel)
AS
(
	--Anchor member - Tells the CTE where to start (aka the highest level of hierarchy.
	SELECT
		EmployeeId
		,FirstName
		,LastName
		,ReportsTo
		,1
	FROM Employee
	WHERE ReportsTo IS NULL
--Combine these individual SELECT results into one by UNION ALL.
UNION ALL
	--Calling the CTE recursively, but increment the EmpLevel by 1 every iteration.
	SELECT
		e.EmployeeId
		,e.FirstName
		,e.LastName
		,e.ReportsTo
		,r.EmpLevel + 1
	FROM Employee e
		INNER JOIN cteReports r
			ON e.ReportsTo = r.EmpID
)

SELECT
	FirstName + ' ' + LastName AS FullName
	,EmpLevel
	--Including a simple subquery to identify the manager names.
	,(SELECT FirstName + ' ' + LastName FROM Employee
		WHERE EmployeeId = cteReports.MgrID) AS Manager
FROM cteReports
ORDER BY EmpLevel, MgrID
