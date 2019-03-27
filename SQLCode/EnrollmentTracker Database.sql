/************************************************************** 
Title: Enrollment Tracker Database
Dev: RRoot
ChangeLog: When,Who,What
2020-01-01,RRoot,Created Script
*************************************************************/

--[ Create database ]--
-- Run this script to create the database
If Exists(Select name from master.dbo.sysdatabases Where Name = 'EnrollmentTracker')
Begin
	Use [master];
	Alter Database EnrollmentTracker Set single_user with rollback immediate;
	Drop Database EnrollmentTracker;
End;
Go
Create Database EnrollmentTracker; 
Go
USE EnrollmentTracker;
Go

--[ Create Tables ]--
Create Table Students
(StudentID int Not Null Identity Constraint pkStudents Primary Key
,FName nvarchar(70) Not Null  
,LName nvarchar(60) Not Null  
,Email nvarchar(55) Not Null   
);
Go
Create Table Courses
([CourseID] int Not Null Identity Constraint pkCourses Primary Key
,[Name] nvarchar(80) Not Null  
,[Price] money Constraint ckCoursesPrice Check(Price > 0)
);
Go
Create Table Buildings
([BuildingID] int Not Null Identity(1,1) Constraint pkBuildings Primary Key
,[Name] nvarchar(100) Not Null   
);
Go
Create Table Classrooms
([ClassroomID] int Not Null Identity(100,100) Constraint pkClassrooms Primary Key
,[Name] nvarchar(100) Not Null
,[BuildingID] int Null Constraint fkClassroomsToBuildings Foreign Key
  References Buildings(BuildingID)    
);
Go
Create Table CourseSessions
([CourseID] int Not Null Constraint fkClassSessionToCourses Foreign Key
  References Courses(CourseID)
,[ClassroomID] int Not Null Constraint fkClassSessionToClassrooms Foreign Key
  References Classrooms(ClassroomID) 
,[Date] date Not Null 
,[Start] int Null 
,[End] int Null 
,Constraint pkCourseSessions Primary Key ([CourseID], [ClassroomID],[Date])
);
Go
Create Table Enrollments
([EnrollmentID] int Not Null Identity Constraint pkStudentCourses Primary Key
,[CourseID] int Not Null Constraint fkStudentCoursesToCourses Foreign Key
  References Courses(CourseID)
,[StudentID] int Not Null Constraint fkStudentCoursesToStudents Foreign Key
  References Students(StudentID)
,[Price] money Not Null Constraint ckStudentCoursesPrice Check(Price > 0)
,[EnrollmentDate] date Not Null 
);
Go
--[ Add Data ]--
Insert Into [dbo].[Courses]
 ([Name], [Price]) Values
 ('SQL1', 399.00)
,('SQL2', 399.00);
Go
Insert Into [dbo].[Students]
 ([FName], [LName], [Email]) Values
 ('Bob','Smith','BSmith@mail.com')
,('Sue','Jones','SJones@mail.com');
Go
Insert Into [dbo].[Enrollments]
([CourseID], [StudentID], [Price], [EnrollmentDate])
 Values
 (1,1,350.00,'20200102')
,(2,1,350.00,'20200102')
,(1,2,399.00,'20200103');

Insert Into [dbo].[Buildings]
([Name])
 Values
 ('Bld-A')
,('Bld-B')
Go

Insert Into [dbo].[Classrooms]
([Name],[BuildingID])
 Values
 ('Room 1A', 1)
,('Room 1B', 1)
,('Room 2A', 1)
,('Room 2B', 1)
,('Room 1A', 2)
,('Room 1B', 2)
;
Go

Insert Into [dbo].[CourseSessions]
([CourseID], [ClassroomID], [Date], [Start], [End])
 Values
 (1,100,'20200204','1800','2100')
,(1,100,'20200206','1800','2100')
,(1,200,'20200211','1800','2100')
,(2,400,'20200213','1800','2100')
,(2,400,'20200218','1800','2100')
,(2,400,'20200220','1800','2100');
Go

--[ Show Data ]--
Select * From [dbo].[Buildings];
Select * From [dbo].[Classrooms];
Select * From [dbo].[Courses];
Select * From [dbo].[Students];
Select * From [dbo].[CourseSessions];
Select * From [dbo].[Enrollments];

Go
--[ Show MetaData ]--
Select Name, Type From SysObjects Where xtype in ('u', 'pk', 'f') Order by 2 desc,1;
SELECT [TABLE_NAME]
      ,[COLUMN_NAME]
      ,[IS_NULLABLE]
      ,[DATA_TYPE]
      ,[CHARACTER_MAXIMUM_LENGTH]
      ,[NUMERIC_PRECISION]
      ,[NUMERIC_SCALE]
FROM [INFORMATION_SCHEMA].[COLUMNS];
Go






