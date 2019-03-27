Select S.StudentName, C.CourseName, CL.BuildingName, CL.ClassroomName
,CS.CourseSessionDate, CS.CourseSessionStartTime, CS.CourseSessionEndTime
From FactEnrollments as FE
Inner Join DimStudents as S
On FE.StudentKey = S.StudentKey
Inner Join DimCourses as C
On FE.CourseKey = C.CourseKey
Inner Join FactCourseSessions as CS
On C.CourseKey = CS.CourseKey
Inner Join DimClassrooms as CL
On CS.ClassroomKey = CL.ClassroomKey  