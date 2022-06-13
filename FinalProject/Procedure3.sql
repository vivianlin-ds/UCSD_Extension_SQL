--Question3: Create a procedure that displays the course history for a selected person.

CREATE PROC StudentHistory_p
	@PersonID int
AS
SELECT
	P.FirstName + ' ' + P.LastName AS StudentName
	,S.SectionID
	,C.CourseCode
	,C.CourseTitle
	,F.FacultyFirstName + ' ' + F.FacultyLastName AS PrimaryInstructorName
	,T.TermCode
	,S.StartDate
	,CL.TuitionAmount
	,CL.Grade
FROM Person P
JOIN ClassList CL ON CL.PersonID = P.PersonID
JOIN Sections S ON S.SectionID = CL.SectionID
JOIN Faculty F ON F.FacultyID = S.PrimaryFacultyID
JOIN Term T ON T.TermID = S.TermID
JOIN Course C ON C.CourseID = S.CourseID
WHERE P.PersonID = @PersonID

EXEC StudentHistory_p 1400