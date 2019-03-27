/**************************************************************
 Create the Data Warehouse
*************************************************************/

--****************** [DWEnrollmentTracker] *********************--
-- This file contains ETL code for use with the
-- [DWEnrollmentTracker] database.
--****************** Your Version ***************************--

USE [DWEnrollmentTracker];
Go

--********************************************************************--
-- Drop the FOREIGN KEY CONSTRAINTS and Clear the tables
--********************************************************************--
Alter Table FactCourseSessions
Drop Constraint fkFactClassSessionToDimCourses;

Alter Table FactCourseSessions
Drop Constraint fkFactClassSessionToDimClassrooms;

Alter Table FactEnrollments
Drop Constraint fkFactEnrollmentsToDimStudents;

Alter Table FactEnrollments
Drop Constraint fkFactEnrollmentsToDimCourses;

Truncate Table dbo.FactCourseSessions;
Truncate Table dbo.FactEnrollments;
Truncate Table dbo.DimStudents;
Truncate Table dbo.DimCourses;
Truncate Table dbo.DimClassrooms;

--********************************************************************--
-- FILL the Tables
--********************************************************************--

--Dimension tables

Insert Into DimClassrooms
(ClassroomID, ClassroomName, BuildingID, BuildingName)
  Select
  [ClassroomID] = ClassroomID
  ,[ClassroomName] = C.[Name]
  ,[BuildingID] = B.[BuildingID]
  ,[BuildingName] = B.[Name]
  From [EnrollmentTracker].[dbo].[Classrooms] as C
  Join [EnrollmentTracker].[dbo].[Buildings] as B
  On C.BuildingID = B.BuildingID
  Order By 1;
Go

Insert Into DimCourses
(CourseID, CourseName, CoursePrice)
  Select
  [CourseID] = CourseID
  ,[CourseName] = cast([Name] as nvarchar(100))
  ,[CoursePrice] = Price
  From [EnrollmentTracker].[dbo].[Courses]
  Order by 1;
Go

Insert Into DimStudents
(StudentID, StudentName, StudentEmail)
  Select
  [studentID] = studentID
  ,[StudentName] = cast(FName + ' ' + LName as nvarchar(100))
  ,[StudentEmail] = cast(Email as nvarchar(100))
  From [EnrollmentTracker].[dbo].[Students]
  Order by 1;
Go

--Fact tables
Insert Into FactCourseSessions
(CourseKey, ClassroomKey, CourseSessionDate, CourseSessionStartTime, CourseSessionEndTime)
  Select
  [CourseKey] = [CourseKey]
  ,[ClassroomKey] = [ClassroomKey]
  ,[CourseSessionDate] = CS.[Date]
  ,[CourseSessionStartTime] = CS.[Start]
  ,[CourseSessionEndTime] = CS.[End]
  From [EnrollmentTracker].[dbo].[CourseSessions] as CS
  Join [DWEnrollmentTracker].[dbo].[DimCourses] as DC
  On CS.CourseID = DC.CourseID
  Join [DWEnrollmentTracker].[dbo].[DimClassrooms] as DCL
  On CS.ClassroomID = DCL.ClassroomID
  Order by 3,1,2;
Go

Insert Into FactEnrollments
(EnrollmentID, CourseKey, StudentKey, EnrollmentDate, EnrollmentPrice)
  Select
  [EnrollmentID] = [EnrollmentID]
  ,[CourseKey] = [CourseKey]
  ,[StudentKey] = [StudentKey]
  ,[EnrollmentDate] = E.[EnrollmentDate]
  ,[StudentCoursesPrice] = [Price]
  From [EnrollmentTracker].[dbo].[Enrollments] as E
  Join [DWEnrollmentTracker].[dbo].[DimCourses] as DC
  On E.CourseID = DC.CourseID
  Join [DWEnrollmentTracker].[dbo].[DimStudents] as DS
  On E.StudentID = DS.StudentID
Go

--********************************************************************--
-- Re-Create the FOREIGN KEY CONSTRAINTS
--********************************************************************--

ALTER TABLE FactCourseSessions
ADD CONSTRAINT fkFactClassSessionToDimCourses
FOREIGN KEY (CourseKey) REFERENCES DimCourses(CourseKey)

ALTER TABLE FactCourseSessions
ADD CONSTRAINT fkFactClassSessionToDimClassrooms
FOREIGN KEY (ClassroomKey) REFERENCES DimClassrooms(ClassroomKey)

ALTER TABLE FactEnrollments
ADD CONSTRAINT fkFactEnrollmentsToDimCourses
FOREIGN KEY (CourseKey) REFERENCES DimCourses(CourseKey)

ALTER TABLE FactEnrollments
ADD CONSTRAINT fkFactEnrollmentsToDimStudents
FOREIGN KEY (StudentKey) REFERENCES DimStudents(StudentKey)

--********************************************************************--
-- Review the results of this script
--********************************************************************--
Select 'Database Created'
Select Name, xType, CrDate from SysObjects
Where xType in ('u', 'PK', 'F')
Order By xType desc, Name
