USE [master]
GO
/****** Object:  Database [LSP_vl]    Script Date: 6/6/2022 12:23:43 PM ******/
CREATE DATABASE [LSP_vl]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'LSP_vl', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\LSP_vl.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'LSP_vl_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\LSP_vl_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [LSP_vl] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [LSP_vl].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [LSP_vl] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [LSP_vl] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [LSP_vl] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [LSP_vl] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [LSP_vl] SET ARITHABORT OFF 
GO
ALTER DATABASE [LSP_vl] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [LSP_vl] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [LSP_vl] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [LSP_vl] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [LSP_vl] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [LSP_vl] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [LSP_vl] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [LSP_vl] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [LSP_vl] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [LSP_vl] SET  ENABLE_BROKER 
GO
ALTER DATABASE [LSP_vl] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [LSP_vl] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [LSP_vl] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [LSP_vl] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [LSP_vl] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [LSP_vl] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [LSP_vl] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [LSP_vl] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [LSP_vl] SET  MULTI_USER 
GO
ALTER DATABASE [LSP_vl] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [LSP_vl] SET DB_CHAINING OFF 
GO
ALTER DATABASE [LSP_vl] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [LSP_vl] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [LSP_vl] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [LSP_vl] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [LSP_vl] SET QUERY_STORE = OFF
GO
USE [LSP_vl]
GO
/****** Object:  Table [dbo].[ClassList]    Script Date: 6/6/2022 12:23:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClassList](
	[ClassListID] [int] IDENTITY(1,1) NOT NULL,
	[SectionID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
	[EnrollmentStatus] [char](2) NOT NULL,
	[TuitionAmount] [decimal](18, 2) NULL,
	[Grade] [char](1) NULL,
 CONSTRAINT [PK_ClassList] PRIMARY KEY CLUSTERED 
(
	[ClassListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sections]    Script Date: 6/6/2022 12:23:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sections](
	[SectionID] [int] NOT NULL,
	[CourseID] [int] NOT NULL,
	[TermID] [int] NOT NULL,
	[RoomID] [int] NULL,
	[PrimaryFacultyID] [int] NULL,
	[SecondaryFacultyID] [int] NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[Days] [varchar](10) NULL,
	[SectionStatus] [char](2) NULL,
 CONSTRAINT [PK_Sections] PRIMARY KEY CLUSTERED 
(
	[SectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Course]    Script Date: 6/6/2022 12:23:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course](
	[CourseID] [int] IDENTITY(1,1) NOT NULL,
	[CourseCode] [char](7) NOT NULL,
	[CourseTitle] [varchar](55) NOT NULL,
	[TotalWeeks] [int] NULL,
	[TotalHours] [float] NULL,
	[FullCourseFee] [decimal](18, 2) NULL,
	[CourseDescription] [varchar](335) NOT NULL,
 CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED 
(
	[CourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CourseRevenue_v]    Script Date: 6/6/2022 12:23:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CourseRevenue_v] AS
WITH SectClass AS
(
SELECT CL.SectionID, S.CourseID, S.SectionStatus, SUM(TuitionAmount) AS SectionRevenue
FROM ClassList CL
JOIN Sections S ON S.SectionID = CL.SectionID
GROUP BY CL.SectionID, S.SectionStatus, S.CourseID
HAVING SectionStatus != 'CN'
)
, CO AS
(
SELECT 
	C.CourseCode
	,C.CourseTitle
	,COUNT(SC.SectionID) AS SectionCount
	,SUM(SC.SectionRevenue)  AS TotalGrossRevenue
	,CAST((SUM(SC.SectionRevenue) / COUNT(SC.SectionID)) AS DECIMAL(18,2)) AS AvgPerSection
FROM Course C
JOIN SectClass SC ON SC.CourseID = C.CourseID
GROUP BY C.CourseCode, C.CourseTitle
)
SELECT *
FROM CO
GO
/****** Object:  Table [dbo].[Term]    Script Date: 6/6/2022 12:23:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Term](
	[TermID] [int] NOT NULL,
	[TermCode] [char](4) NOT NULL,
	[TermName] [varchar](15) NOT NULL,
	[CalendarYear] [int] NOT NULL,
	[AcademicYear] [int] NOT NULL,
 CONSTRAINT [PK_Term] PRIMARY KEY CLUSTERED 
(
	[TermID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FacultyPayment]    Script Date: 6/6/2022 12:23:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FacultyPayment](
	[FacultyPaymentID] [int] IDENTITY(1,1) NOT NULL,
	[FacultyID] [int] NOT NULL,
	[SectionID] [int] NOT NULL,
	[Payment] [decimal](18, 2) NULL,
 CONSTRAINT [PK_FacultyPayment] PRIMARY KEY CLUSTERED 
(
	[FacultyPaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[TuitionFacultyByYear_v]    Script Date: 6/6/2022 12:23:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TuitionFacultyByYear_v] AS
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
GO
/****** Object:  Table [dbo].[Address]    Script Date: 6/6/2022 12:23:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Address](
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[AddressType] [char](4) NOT NULL,
	[AddressLine] [varchar](34) NULL,
	[City] [varchar](25) NULL,
	[State] [char](2) NULL,
	[Country] [varchar](10) NULL,
	[PostalCode] [varchar](10) NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_AddressID] UNIQUE NONCLUSTERED 
(
	[AddressType] ASC,
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Faculty]    Script Date: 6/6/2022 12:23:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Faculty](
	[FacultyID] [int] IDENTITY(1,1) NOT NULL,
	[FacultyFirstName] [varchar](9) NOT NULL,
	[FacultyLastName] [varchar](13) NOT NULL,
	[FacultyEmail] [varchar](34) NOT NULL,
	[PrimaryPhone] [char](12) NOT NULL,
	[AlternatePhone] [char](12) NULL,
	[FacultyAddressLine] [varchar](24) NOT NULL,
	[FacultyCity] [varchar](11) NOT NULL,
	[FacultyState] [char](2) NOT NULL,
	[FacultyPostalCode] [char](5) NOT NULL,
 CONSTRAINT [PK_Faculty] PRIMARY KEY CLUSTERED 
(
	[FacultyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 6/6/2022 12:23:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[PersonID] [int] IDENTITY(3544,1) NOT NULL,
	[LastName] [varchar](13) NULL,
	[FirstName] [varchar](11) NOT NULL,
	[MiddleName] [varchar](11) NULL,
	[Gender] [char](1) NULL,
	[Phone] [char](12) NULL,
	[Email] [varchar](29) NULL,
 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Room]    Script Date: 6/6/2022 12:23:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Room](
	[RoomID] [int] IDENTITY(1,1) NOT NULL,
	[RoomName] [varchar](15) NOT NULL,
	[Capacity] [int] NOT NULL,
 CONSTRAINT [PK_Room] PRIMARY KEY CLUSTERED 
(
	[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK_Address_Person]
GO
ALTER TABLE [dbo].[ClassList]  WITH CHECK ADD  CONSTRAINT [FK_ClassList_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[ClassList] CHECK CONSTRAINT [FK_ClassList_Person]
GO
ALTER TABLE [dbo].[ClassList]  WITH CHECK ADD  CONSTRAINT [FK_ClassList_Sections] FOREIGN KEY([SectionID])
REFERENCES [dbo].[Sections] ([SectionID])
GO
ALTER TABLE [dbo].[ClassList] CHECK CONSTRAINT [FK_ClassList_Sections]
GO
ALTER TABLE [dbo].[FacultyPayment]  WITH CHECK ADD  CONSTRAINT [FK_FacultyPayment_Faculty] FOREIGN KEY([FacultyID])
REFERENCES [dbo].[Faculty] ([FacultyID])
GO
ALTER TABLE [dbo].[FacultyPayment] CHECK CONSTRAINT [FK_FacultyPayment_Faculty]
GO
ALTER TABLE [dbo].[FacultyPayment]  WITH CHECK ADD  CONSTRAINT [FK_FacultyPayment_Sections] FOREIGN KEY([SectionID])
REFERENCES [dbo].[Sections] ([SectionID])
GO
ALTER TABLE [dbo].[FacultyPayment] CHECK CONSTRAINT [FK_FacultyPayment_Sections]
GO
ALTER TABLE [dbo].[Sections]  WITH CHECK ADD  CONSTRAINT [FK_Sections_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[Sections] CHECK CONSTRAINT [FK_Sections_Course]
GO
ALTER TABLE [dbo].[Sections]  WITH CHECK ADD  CONSTRAINT [FK_Sections_PFaculty] FOREIGN KEY([PrimaryFacultyID])
REFERENCES [dbo].[Faculty] ([FacultyID])
GO
ALTER TABLE [dbo].[Sections] CHECK CONSTRAINT [FK_Sections_PFaculty]
GO
ALTER TABLE [dbo].[Sections]  WITH CHECK ADD  CONSTRAINT [FK_Sections_Room] FOREIGN KEY([RoomID])
REFERENCES [dbo].[Room] ([RoomID])
GO
ALTER TABLE [dbo].[Sections] CHECK CONSTRAINT [FK_Sections_Room]
GO
ALTER TABLE [dbo].[Sections]  WITH CHECK ADD  CONSTRAINT [FK_Sections_SFaculty] FOREIGN KEY([SecondaryFacultyID])
REFERENCES [dbo].[Faculty] ([FacultyID])
GO
ALTER TABLE [dbo].[Sections] CHECK CONSTRAINT [FK_Sections_SFaculty]
GO
ALTER TABLE [dbo].[Sections]  WITH CHECK ADD  CONSTRAINT [FK_Sections_Term] FOREIGN KEY([TermID])
REFERENCES [dbo].[Term] ([TermID])
GO
ALTER TABLE [dbo].[Sections] CHECK CONSTRAINT [FK_Sections_Term]
GO
/****** Object:  StoredProcedure [dbo].[InsertPerson_p]    Script Date: 6/6/2022 12:23:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[InsertPerson_p]
	@LastName varchar(13)
	,@FirstName varchar(11)
	,@AddressType char(4)
	,@AddressLine varchar(34)
	,@City varchar(25)
AS
INSERT INTO Person (LastName, FirstName)
	VALUES(@LastName, @FirstName)
INSERT INTO Address (PersonID, AddressType, AddressLine, City)
	VALUES(
		(SELECT PersonID FROM Person WHERE FirstName = @FirstName AND LastName = @LastName),
		@AddressType, @AddressLine, @City)
GO
/****** Object:  StoredProcedure [dbo].[StudentHistory_p]    Script Date: 6/6/2022 12:23:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[StudentHistory_p]
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
GO
USE [master]
GO
ALTER DATABASE [LSP_vl] SET  READ_WRITE 
GO
