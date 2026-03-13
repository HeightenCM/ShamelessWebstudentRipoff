CREATE TABLE Students (
    StudentID   INT           IDENTITY(1,1) PRIMARY KEY,
    Name        NVARCHAR(100) NOT NULL,
    Email       NVARCHAR(150) NOT NULL UNIQUE,
    GroupName   NVARCHAR(20)  NOT NULL
);
GO

CREATE TABLE Courses (
    CourseID        INT           IDENTITY(1,1) PRIMARY KEY,
    CourseName      NVARCHAR(100) NOT NULL,
    ProfessorName   NVARCHAR(100) NOT NULL,
    DayOfWeek       NVARCHAR(10)  NOT NULL,
    StartTime       TIME          NOT NULL,
    EndTime         TIME          NOT NULL,
    Room            NVARCHAR(20)  NOT NULL
);
GO

CREATE TABLE Grades (
    GradeID     INT  IDENTITY(1,1) PRIMARY KEY,
    StudentID   INT  NOT NULL REFERENCES Students(StudentID) ON DELETE CASCADE,
    CourseID    INT  NOT NULL REFERENCES Courses(CourseID)   ON DELETE CASCADE,
    Grade       DECIMAL(4,2) NOT NULL CHECK (Grade BETWEEN 1 AND 10),
    GradeDate   DATE NOT NULL DEFAULT GETDATE()
);
GO

INSERT INTO Students (Name, Email, GroupName) VALUES
    (N'Ana Ionescu',   'ana.ionescu@uni.ro',   '3A1'),
    (N'Mihai Popescu', 'mihai.popescu@uni.ro', '3A1'),
    (N'Elena Radu',    'elena.radu@uni.ro',    '2B2'),
    (N'Andrei Stan',   'andrei.stan@uni.ro',   '2B2');
GO

INSERT INTO Courses (CourseName, ProfessorName, DayOfWeek, StartTime, EndTime, Room) VALUES
    (N'Mathematics',        N'Prof. Georgescu', 'Monday',    '08:00', '10:00', 'A101'),
    (N'Computer Networks',  N'Prof. Dumitru',   'Tuesday',   '10:00', '12:00', 'B203'),
    (N'Databases',          N'Prof. Marinescu', 'Wednesday', '12:00', '14:00', 'A105'),
    (N'Web Programming',    N'Prof. Popa',      'Thursday',  '14:00', '16:00', 'C301');
GO

INSERT INTO Grades (StudentID, CourseID, Grade, GradeDate) VALUES
    (1, 1, 8.50, '2024-11-10'),
    (1, 2, 9.00, '2024-11-12'),
    (1, 3, 7.50, '2024-11-15'),
    (2, 1, 6.00, '2024-11-10'),
    (2, 3, 8.00, '2024-11-15'),
    (3, 2, 10.0, '2024-11-12'),
    (3, 4, 9.50, '2024-11-18'),
    (4, 1, 5.00, '2024-11-10'),
    (4, 4, 7.00, '2024-11-18');
GO

CREATE PROCEDURE sp_GetAllGrades
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        g.GradeID,
        s.StudentID,
        s.Name          AS StudentName,
        s.GroupName,
        c.CourseID,
        c.CourseName,
        c.ProfessorName,
        g.Grade,
        g.GradeDate
    FROM  Grades   g
    JOIN  Students s ON s.StudentID = g.StudentID
    JOIN  Courses  c ON c.CourseID  = g.CourseID
    ORDER BY s.Name, c.CourseName;
END
GO

CREATE PROCEDURE sp_GetGradesByStudent
    @StudentID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        g.GradeID,
        c.CourseName,
        c.ProfessorName,
        g.Grade,
        g.GradeDate
    FROM  Grades  g
    JOIN  Courses c ON c.CourseID = g.CourseID
    WHERE g.StudentID = @StudentID
    ORDER BY c.CourseName;
END
GO

CREATE PROCEDURE sp_InsertGrade
    @StudentID  INT,
    @CourseID   INT,
    @Grade      DECIMAL(4,2),
    @GradeDate  DATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Grades (StudentID, CourseID, Grade, GradeDate)
    VALUES (@StudentID, @CourseID, @Grade, @GradeDate);
END
GO

CREATE PROCEDURE sp_UpdateGrade
    @GradeID    INT,
    @Grade      DECIMAL(4,2),
    @GradeDate  DATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Grades
    SET    Grade     = @Grade,
           GradeDate = @GradeDate
    WHERE  GradeID   = @GradeID;
END
GO

CREATE PROCEDURE sp_DeleteGrade
    @GradeID INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM Grades
    WHERE  GradeID = @GradeID;
END
GO

CREATE PROCEDURE sp_GetCourseAverages
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        c.CourseName,
        ROUND(AVG(g.Grade), 2)  AS AverageGrade,
        COUNT(g.GradeID)        AS StudentCount
    FROM  Grades  g
    JOIN  Courses c ON c.CourseID = g.CourseID
    GROUP BY c.CourseName
    ORDER BY c.CourseName;
END
GO

CREATE PROCEDURE sp_GetSchedule
    @DayOfWeek NVARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        CourseID,
        CourseName,
        ProfessorName,
        DayOfWeek,
        StartTime,
        EndTime,
        Room
    FROM  Courses
    WHERE (@DayOfWeek IS NULL OR DayOfWeek = @DayOfWeek)
    ORDER BY
        CASE DayOfWeek
            WHEN 'Monday'    THEN 1
            WHEN 'Tuesday'   THEN 2
            WHEN 'Wednesday' THEN 3
            WHEN 'Thursday'  THEN 4
            WHEN 'Friday'    THEN 5
            ELSE 6
        END,
        StartTime;
END
GO