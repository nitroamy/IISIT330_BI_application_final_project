--*************************************************************************--
-- Title: Final Project
-- Author: Amy Hong
-- Desc: This file demonstrates how to create a data warehous database
-- Change Log: When,Who,What
-- 2019-03-13, Amy Hong, Created File
--**************************************************************************--

If Exists (Select * from master.dbo.Sysdatabases Where Name = 'DWEnrollmentTracker')
	Begin
		USE [master];
		ALTER DATABASE [DWEnrollmentTracker] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE [DWEnrollmentTracker];
	End
GO
Create Database [DWEnrollmentTracker];
Go
USE [DWEnrollmentTracker];
Go

--********************************************************************--
-- Create the Tables
--********************************************************************--


CREATE TABLE DimClassrooms
([ClassroomKey] int Not Null Identity Constraint pkDimClassrooms Primary Key
  ,[ClassroomID] int Not NULL
  ,[ClassroomName] nvarchar(100) Not NULL
  ,[BuildingID] int Not NULL
  ,[BuildingName] nvarchar(100) Not Null
);
Go

CREATE TABLE DimCourses
([CourseKey] int Not Null Identity Constraint pkDimCourses Primary Key
  ,[CourseID] int Not NULL
  ,[CourseName] nvarchar(100) Not NULL
  ,[CoursePrice] money Not Null
);
Go

CREATE TABLE DimStudents
([StudentKey] int Not Null Identity Constraint pkDimStudents Primary Key
  ,[StudentID] int Not Null
  ,[StudentName] nvarchar(200) Not Null
  ,[StudentEmail] nvarchar(100) Not Null
);
Go

CREATE TABLE FactCourseSessions
([CourseKey] int Not Null
  ,[ClassroomKey] int Not Null
  ,[CourseSessionDate] date Not NULL
  ,[CourseSessionStartTime] int Not Null
  ,[CourseSessionEndTime] int Not Null
  ,Constraint pkCourseSessions Primary Key (CourseKey, ClassroomKey, CourseSessionDate)
);
Go

CREATE TABLE FactEnrollments
([EnrollmentID] int Not Null
  ,[CourseKey] int Not Null
  ,[StudentKey] int Not Null
  ,[EnrollmentDate] date Not Null
  ,[EnrollmentPrice] money Not Null
  ,Constraint pkFactEnrollments Primary Key (EnrollmentID, CourseKey, StudentKey)
);
Go

--********************************************************************--
-- Create the FOREIGN KEY CONSTRAINTS
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
