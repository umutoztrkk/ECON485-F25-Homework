-- ECON485 – Homework 2
-- Simple course registration system + prerequisite support

CREATE DATABASE IF NOT EXISTS econ485_hw;
USE econ485_hw;

-- Part 1a – Base tables

CREATE TABLE IF NOT EXISTS Students (
  StudentID      INT PRIMARY KEY,
  StudentNumber  VARCHAR(20) NOT NULL,
  FirstName      VARCHAR(50) NOT NULL,
  LastName       VARCHAR(50) NOT NULL,
  Major          VARCHAR(50),
  EntryYear      INT
);

CREATE TABLE IF NOT EXISTS Courses (
  CourseID     INT PRIMARY KEY,
  CourseCode   VARCHAR(20) NOT NULL,
  CourseTitle  VARCHAR(100) NOT NULL,
  LocalCredits INT,
  ECTS         INT
);

CREATE TABLE IF NOT EXISTS Sections (
  SectionID      INT PRIMARY KEY,
  CourseID       INT NOT NULL,
  Semester       VARCHAR(10) NOT NULL,
  Year           INT NOT NULL,
  SectionNumber  VARCHAR(10) NOT NULL,
  Capacity       INT,
  InstructorName VARCHAR(100),
  CONSTRAINT fk_sections_course
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE IF NOT EXISTS Registrations (
  RegistrationID   INT PRIMARY KEY,
  StudentID        INT NOT NULL,
  SectionID        INT NOT NULL,
  RegistrationDate DATE,
  CONSTRAINT fk_registrations_student
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  CONSTRAINT fk_registrations_section
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID)
);

-- Part 1b – Example data

INSERT INTO Courses (CourseID, CourseCode, CourseTitle, LocalCredits, ECTS) VALUES
  (1, 'ECON101', 'Introduction to Economics', 3, 6),
  (2, 'ECON201', 'Intermediate Microeconomics', 3, 6),
  (3, 'MATH101', 'Calculus I', 4, 7);

INSERT INTO Sections (SectionID, CourseID, Semester, Year, SectionNumber, Capacity, InstructorName) VALUES
  (1, 1, 'Fall', 2025, '01', 40, 'Dr. Acar'),
  (2, 1, 'Fall', 2025, '02', 40, 'Dr. Demir'),
  (3, 2, 'Fall', 2025, '01', 35, 'Dr. Yilmaz'),
  (4, 3, 'Fall', 2025, '01', 45, 'Dr. Kaya');

INSERT INTO Students (StudentID, StudentNumber, FirstName, LastName, Major, EntryYear) VALUES
  (1,  '20250001', 'Ali',    'Yilmaz',  'Economics', 2025),
  (2,  '20250002', 'Ayse',   'Demir',   'Economics', 2025),
  (3,  '20250003', 'Mehmet', 'Kaya',    'Business',  2024),
  (4,  '20250004', 'Zeynep', 'Arslan',  'Economics', 2023),
  (5,  '20250005', 'Deniz',  'Ozkan',   'Math',      2025),
  (6,  '20250006', 'Ece',    'Aydin',   'Economics', 2024),
  (7,  '20250007', 'Can',    'Yildiz',  'CS',        2023),
  (8,  '20250008', 'Burak',  'Kilic',   'Economics', 2022),
  (9,  '20250009', 'Selin',  'Kurt',    'Business',  2024),
  (10, '20250010', 'Mert',   'Celik',   'Economics', 2025);

INSERT INTO Registrations (RegistrationID, StudentID, SectionID, RegistrationDate) VALUES
  (1,  1, 1, '2025-09-01'),
  (2,  1, 4, '2025-09-01'),
  (3,  2, 1, '2025-09-01'),
  (4,  2, 3, '2025-09-01'),
  (5,  3, 1, '2025-09-02'),
  (6,  3, 4, '2025-09-02'),
  (7,  4, 2, '2025-09-02'),
  (8,  4, 3, '2025-09-02'),
  (9,  5, 4, '2025-09-02'),
  (10, 6, 1, '2025-09-03'),
  (11, 7, 2, '2025-09-03'),
  (12, 8, 3, '2025-09-03'),
  (13, 9, 4, '2025-09-03'),
  (14, 10,1, '2025-09-03'),
  (15, 10,3, '2025-09-03');

-- Part 1c – Add and Drop actions

-- Adds
INSERT INTO Registrations (RegistrationID, StudentID, SectionID, RegistrationDate)
VALUES (16, 1, 3, '2025-09-04');

INSERT INTO Registrations (RegistrationID, StudentID, SectionID, RegistrationDate)
VALUES (17, 2, 4, '2025-09-04');

INSERT INTO Registrations (RegistrationID, StudentID, SectionID, RegistrationDate)
VALUES (18, 3, 2, '2025-09-04');

-- Drops
DELETE FROM Registrations WHERE RegistrationID = 2;
DELETE FROM Registrations WHERE RegistrationID = 4;
DELETE FROM Registrations WHERE RegistrationID = 6;

-- Part 1d – Final registrations report

SELECT
  s.FirstName,
  s.LastName,
  c.CourseCode,
  sec.SectionNumber,
  sec.Semester,
  sec.Year,
  r.RegistrationDate
FROM Registrations r
JOIN Students s  ON r.StudentID = s.StudentID
JOIN Sections sec ON r.SectionID = sec.SectionID
JOIN Courses c   ON sec.CourseID = c.CourseID
ORDER BY s.LastName, s.FirstName, c.CourseCode, sec.SectionNumber;

-- Part 2a – Prerequisite-related tables

CREATE TABLE IF NOT EXISTS Prerequisites (
  PrerequisiteID   INT PRIMARY KEY,
  CourseID         INT NOT NULL,
  RequiredCourseID INT NOT NULL,
  MinimumGrade     CHAR(2) NOT NULL,
  CONSTRAINT fk_prereq_course
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
  CONSTRAINT fk_prereq_required_course
    FOREIGN KEY (RequiredCourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE IF NOT EXISTS CompletedCourses (
  CompletedID  INT PRIMARY KEY,
  StudentID    INT NOT NULL,
  CourseID     INT NOT NULL,
  Grade        CHAR(2) NOT NULL,
  CONSTRAINT fk_completed_student
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  CONSTRAINT fk_completed_course
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Prerequisites (PrerequisiteID, CourseID, RequiredCourseID, MinimumGrade) VALUES
  (1, 2, 1, 'C'),
  (2, 2, 3, 'D');

INSERT INTO CompletedCourses (CompletedID, StudentID, CourseID, Grade) VALUES
  (1, 1, 1, 'B'),
  (2, 1, 3, 'C'),
  (3, 2, 1, 'D'),
  (4, 2, 3, 'C'),
  (5, 3, 1, 'C'),
  (6, 4, 1, 'A'),
  (7, 4, 3, 'B');

-- Part 2c – Assistive SQL: list prerequisites for a course

SELECT
  c_target.CourseCode       AS TargetCourseCode,
  c_req.CourseCode          AS RequiredCourseCode,
  c_req.CourseTitle         AS RequiredCourseTitle,
  p.MinimumGrade
FROM Prerequisites p
JOIN Courses c_target
      ON p.CourseID = c_target.CourseID
JOIN Courses c_req
      ON p.RequiredCourseID = c_req.CourseID
WHERE p.CourseID = 2;

-- Part 2c – Assistive SQL: check if a student passed prerequisites

SELECT
  s.StudentID,
  s.FirstName,
  s.LastName,
  c_target.CourseCode       AS TargetCourseCode,
  c_req.CourseCode          AS RequiredCourseCode,
  c_req.CourseTitle         AS RequiredCourseTitle,
  p.MinimumGrade,
  cc.Grade                  AS StudentGrade,
  CASE
    WHEN cc.Grade IS NULL THEN 'NOT COMPLETED'
    WHEN cc.Grade >= p.MinimumGrade THEN 'OK'
    ELSE 'BELOW MINIMUM'
  END AS PrerequisiteStatus
FROM Prerequisites p
JOIN Courses c_target
      ON p.CourseID = c_target.CourseID
JOIN Courses c_req
      ON p.RequiredCourseID = c_req.CourseID
LEFT JOIN CompletedCourses cc
      ON cc.CourseID = p.RequiredCourseID
     AND cc.StudentID = 1
JOIN Students s
      ON s.StudentID = 1
WHERE p.CourseID = 2;
