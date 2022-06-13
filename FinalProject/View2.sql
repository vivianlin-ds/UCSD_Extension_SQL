--Question2: Create View that displays gross revenue from tuition as well as faculty payments for each academic year.
CREATE VIEW TuitionFacultyByYear_v AS
WITH FacPayment AS
(
SELECT AcademicYear, SUM(Payment) AS FacultyPayment
FROM FacultyPayment FP
JOIN Sections S ON S.SectionID = FP.SectionID
JOIN Term T ON T.TermID = S.TermID
GROUP BY AcademicYear
)
, Revenue AS
(
SELECT T.AcademicYear, SUM(CL.TuitionAmount) AS TermTotal
FROM Sections S
JOIN ClassList CL ON CL.SectionID = S.SectionID
JOIN Term T ON T.TermID = S.TermID
GROUP BY T.AcademicYear, S.SectionStatus
HAVING S.SectionStatus != 'CN'
)
SELECT
	R.AcademicYear
	,R.TermTotal AS GrossTuitionRevenue
	,FP.FacultyPayment
FROM Revenue R
JOIN FacPayment FP ON FP.AcademicYear = R.AcademicYear

SELECT * FROM TuitionFacultyByYear_v ORDER BY AcademicYear