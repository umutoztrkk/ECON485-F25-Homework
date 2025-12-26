# ECON485 – Homework 2 (Terminal Output)

## All parts

```sql
MariaDB [(none)]> CREATE DATABASE econ485_hw;
Query OK, 1 row affected (0.006 sec)

MariaDB [(none)]> USE econ485_hw;
Database changed

MariaDB [econ485_hw]> CREATE TABLE Students (
    StudentID      INT PRIMARY KEY,
    StudentNumber  VARCHAR(20) NOT NULL,
    FirstName      VARCHAR(50) NOT NULL,
    LastName       VARCHAR(50) NOT NULL,
    Major          VARCHAR(50),
    EntryYear      INT
);
Query OK, 0 rows affected (0.049 sec)

MariaDB [econ485_hw]> CREATE TABLE Courses (
    CourseID     INT PRIMARY KEY,
    CourseCode   VARCHAR(20) NOT NULL,
    CourseTitle  VARCHAR(100) NOT NULL,
    LocalCredits INT,
    ECTS         INT
);
Query OK, 0 rows affected (0.020 sec)

MariaDB [econ485_hw]> CREATE TABLE Sections (
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
Query OK, 0 rows affected (0.019 sec)

MariaDB [econ485_hw]> CREATE TABLE Registrations (
    RegistrationID   INT PRIMARY KEY,
    StudentID        INT NOT NULL,
    SectionID        INT NOT NULL,
    RegistrationDate DATE,
    CONSTRAINT fk_registrations_student
      FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT fk_registrations_section
      FOREIGN KEY (SectionID) REFERENCES Sections(SectionID)
);
Query OK, 0 rows affected (0.023 sec)

Part 1b – Insert Example Data
MariaDB [econ485_hw]> INSERT INTO Courses (CourseID, CourseCode, CourseTitle, LocalCredits, ECTS)
VALUES (1, 'ECON101', 'Introduction to Economics', 3, 6),
       (2, 'ECON201', 'Intermediate Microeconomics', 3, 6),
       (3, 'MATH101', 'Calculus I', 4, 7);
Query OK, 3 rows affected (0.010 sec)
Records: 3  Duplicates: 0  Warnings: 0

MariaDB [econ485_hw]> INSERT INTO Sections (SectionID, CourseID, Semester, Year, SectionNumber, Capacity, InstructorName)
VALUES (1, 1, 'Fall', 2025, '01', 40, 'Dr. Acar'),
       (2, 1, 'Fall', 2025, '02', 40, 'Dr. Demir'),
       (3, 2, 'Fall', 2025, '01', 35, 'Dr. Yilmaz'),
       (4, 3, 'Fall', 2025, '01', 45, 'Dr. Kaya');
Query OK, 4 rows affected (0.002 sec)

MariaDB [econ485_hw]> INSERT INTO Students (StudentID, StudentNumber, FirstName, LastName, Major, EntryYear)
VALUES
(1, '20250001', 'Ali', 'Yilmaz', 'Economics', 2025),
(2, '20250002', 'Ayse', 'Demir', 'Economics', 2025),
(3, '20250003', 'Mehmet', 'Kaya', 'Business', 2024),
(4, '20250004', 'Zeynep', 'Arslan', 'Economics', 2023),
(5, '20250005', 'Deniz', 'Ozkan', 'Math', 2025),
(6, '20250006', 'Ece', 'Aydin', 'Economics', 2024),
(7, '20250007', 'Can', 'Yildiz', 'CS', 2023),
(8, '20250008', 'Burak', 'Kilic', 'Economics', 2022),
(9, '20250009', 'Selin', 'Kurt', 'Business', 2024),
(10, '20250010', 'Mert', 'Celik', 'Economics', 2025);
Query OK, 10 rows affected (0.002 sec)
Records: 10  Duplicates: 0  Warnings: 0
-- Add actions
MariaDB [econ485_hw]> INSERT INTO Registrations (RegistrationID, StudentID, SectionID, RegistrationDate)
VALUES (16, 1, 3, '2025-09-04');
Query OK, 1 row affected (0.002 sec)

MariaDB [econ485_hw]> INSERT INTO Registrations (RegistrationID, StudentID, SectionID, RegistrationDate)
VALUES (17, 2, 4, '2025-09-04');
Query OK, 1 row affected (0.000 sec)

MariaDB [econ485_hw]> INSERT INTO Registrations (RegistrationID, StudentID, SectionID, RegistrationDate)
VALUES (18, 3, 2, '2025-09-04');
Query OK, 1 row affected (0.000 sec)

-- Drop actions
MariaDB [econ485_hw]> DELETE FROM Registrations WHERE RegistrationID = 2;
Query OK, 1 row affected (0.004 sec)

MariaDB [econ485_hw]> DELETE FROM Registrations WHERE RegistrationID = 4;
Query OK, 1 row affected (0.001 sec)

MariaDB [econ485_hw]> DELETE FROM Registrations WHERE RegistrationID = 6;
Query OK, 1 row affected (0.001 sec)

MariaDB [econ485_hw]> SELECT * FROM Registrations ORDER BY RegistrationID;
+----------------+-----------+-----------+------------------+
| RegistrationID | StudentID | SectionID | RegistrationDate |
+----------------+-----------+-----------+------------------+
| 1              | 1         | 1         | 2025-09-01       |
| 3              | 2         | 1         | 2025-09-01       |
| 5              | 3         | 1         | 2025-09-02       |
| 7              | 4         | 2         | 2025-09-02       |
| 8              | 4         | 3         | 2025-09-02       |
| 9              | 5         | 4         | 2025-09-02       |
| 10             | 6         | 1         | 2025-09-03       |
| 11             | 7         | 2         | 2025-09-03       |
| 12             | 8         | 3         | 2025-09-03       |
| 13             | 9         | 4         | 2025-09-03       |
| 14             | 10        | 1         | 2025-09-03       |
| 15             | 10        | 3         | 2025-09-03       |
| 16             | 1         | 3         | 2025-09-04       |
| 17             | 2         | 4         | 2025-09-04       |
| 18             | 3         | 2         | 2025-09-04       |
+----------------+-----------+-----------+------------------+
15 rows in set (0.001 sec)
MariaDB [econ485_hw]> SELECT
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
+-----------+----------+------------+---------------+----------+------+------------------+
| FirstName | LastName | CourseCode | SectionNumber | Semester | Year | RegistrationDate |
+-----------+----------+------------+---------------+----------+------+------------------+
| Zeynep    | Arslan   | ECON101    | 02            | Fall     | 2025 | 2025-09-02       |
| Zeynep    | Arslan   | ECON201    | 01            | Fall     | 2025 | 2025-09-02       |
| Ece       | Aydin    | ECON101    | 01            | Fall     | 2025 | 2025-09-03       |
| Mert      | Celik    | ECON101    | 01            | Fall     | 2025 | 2025-09-03       |
| Mert      | Celik    | ECON201    | 01            | Fall     | 2025 | 2025-09-03       |
| Ayse      | Demir    | ECON101    | 01            | Fall     | 2025 | 2025-09-01       |
| Ayse      | Demir    | MATH101    | 01            | Fall     | 2025 | 2025-09-04       |
| Mehmet    | Kaya     | ECON101    | 01            | Fall     | 2025 | 2025-09-02       |
| Mehmet    | Kaya     | ECON101    | 02            | Fall     | 2025 | 2025-09-04       |
| Burak     | Kilic    | ECON201    | 01            | Fall     | 2025 | 2025-09-03       |
| Selin     | Kurt     | MATH101    | 01            | Fall     | 2025 | 2025-09-03       |
| Deniz     | Ozkan    | MATH101    | 01            | Fall     | 2025 | 2025-09-02       |
| Can       | Yildiz   | ECON101    | 02            | Fall     | 2025 | 2025-09-03       |
| Ali       | Yilmaz   | ECON101    | 01            | Fall     | 2025 | 2025-09-01       |
| Ali       | Yilmaz   | ECON201    | 01            | Fall     | 2025 | 2025-09-04       |
+-----------+----------+------------+---------------+----------+------+------------------+
15 rows in set (0.003 sec)
MariaDB [econ485_hw]> SELECT
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
+------------------+--------------------+---------------------------+--------------+
| TargetCourseCode | RequiredCourseCode | RequiredCourseTitle       | MinimumGrade |
+------------------+--------------------+---------------------------+--------------+
| ECON201          | ECON101            | Introduction to Economics | C            |
| ECON201          | MATH101            | Calculus I                | D            |
+------------------+--------------------+---------------------------+--------------+
2 rows in set (0.001 sec)

MariaDB [econ485_hw]> SELECT
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
+-----------+-----------+----------+------------------+--------------------+---------------------------+--------------+--------------+--------------------+
| StudentID | FirstName | LastName | TargetCourseCode | RequiredCourseCode | RequiredCourseTitle       | MinimumGrade | StudentGrade | PrerequisiteStatus |
+-----------+-----------+----------+------------------+--------------------+---------------------------+--------------+--------------+--------------------+
| 1         | Ali       | Yilmaz   | ECON201          | ECON101            | Introduction to Economics | C            | B            | BELOW MINIMUM      |
| 1         | Ali       | Yilmaz   | ECON201          | MATH101            | Calculus I                | D            | C            | BELOW MINIMUM      |
+-----------+-----------+----------+------------------+--------------------+---------------------------+--------------+--------------+--------------------+
2 rows in set (0.001 sec)
