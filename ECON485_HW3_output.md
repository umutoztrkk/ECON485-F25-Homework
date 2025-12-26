
# ECON485 – Homework 3 (terminal output)

```
MariaDB [(none)]> USE econ485_hw;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed

-- Task 1: List students and their registered sections
MariaDB [econ485_hw]> SELECT
    s.FirstName,
    s.LastName,
    c.CourseCode,
    sec.SectionNumber
FROM Registrations r
JOIN Students s  ON r.StudentID = s.StudentID
JOIN Sections sec ON r.SectionID = sec.SectionID
JOIN Courses c   ON sec.CourseID = c.CourseID
ORDER BY s.LastName, s.FirstName, c.CourseCode, sec.SectionNumber;
+-----------+----------+------------+---------------+
| FirstName | LastName | CourseCode | SectionNumber |
+-----------+----------+------------+---------------+
| Zeynep    | Arslan   | ECON101    | 02            |
| Zeynep    | Arslan   | ECON201    | 01            |
| Ece       | Aydin    | ECON101    | 01            |
| Mert      | Celik    | ECON101    | 01            |
| Mert      | Celik    | ECON201    | 01            |
| Ayse      | Demir    | ECON101    | 01            |
| Ayse      | Demir    | MATH101    | 01            |
| Mehmet    | Kaya     | ECON101    | 01            |
| Mehmet    | Kaya     | ECON101    | 02            |
| Burak     | Kilic    | ECON201    | 01            |
| Selin     | Kurt     | MATH101    | 01            |
| Deniz     | Ozkan    | MATH101    | 01            |
| Can       | Yildiz   | ECON101    | 02            |
| Ali       | Yilmaz   | ECON101    | 01            |
| Ali       | Yilmaz   | ECON201    | 01            |
+-----------+----------+------------+---------------+
15 rows in set (0.008 sec)

-- Task 2: Show courses with total student counts
MariaDB [econ485_hw]> SELECT
    c.CourseCode,
    c.CourseTitle,
    COUNT(r.StudentID) AS TotalStudents
FROM Courses c
LEFT JOIN Sections sec
       ON sec.CourseID = c.CourseID
LEFT JOIN Registrations r
       ON r.SectionID = sec.SectionID
GROUP BY
    c.CourseID,
    c.CourseCode,
    c.CourseTitle
ORDER BY c.CourseCode;
+------------+---------------------------+--------------+
| CourseCode | CourseTitle               | TotalStudents|
+------------+---------------------------+--------------+
| ECON101    | Introduction to Economics | 8            |
| ECON201    | Intermediate Microeconomics| 4           |
| MATH101    | Calculus I                | 3            |
+------------+---------------------------+--------------+
3 rows in set (0.002 sec)

-- Task 3: List all prerequisites for each course
MariaDB [econ485_hw]> SELECT
    c_target.CourseCode  AS TargetCourseCode,
    c_target.CourseTitle AS TargetCourseTitle,
    c_req.CourseCode     AS RequiredCourseCode,
    c_req.CourseTitle    AS RequiredCourseTitle,
    p.MinimumGrade
FROM Courses c_target
LEFT JOIN Prerequisites p
       ON p.CourseID = c_target.CourseID
LEFT JOIN Courses c_req
       ON p.RequiredCourseID = c_req.CourseID
ORDER BY
    c_target.CourseCode,
    c_req.CourseCode;
+------------------+---------------------------+--------------------+---------------------------+--------------+
| TargetCourseCode | TargetCourseTitle         | RequiredCourseCode | RequiredCourseTitle       | MinimumGrade |
+------------------+---------------------------+--------------------+---------------------------+--------------+
| ECON101          | Introduction to Economics | NULL               | NULL                      | NULL         |
| ECON201          | Intermediate Microeconomics| ECON101           | Introduction to Economics | C            |
| ECON201          | Intermediate Microeconomics| MATH101           | Calculus I                | D            |
| MATH101          | Calculus I                | NULL               | NULL                      | NULL         |
+------------------+---------------------------+--------------------+---------------------------+--------------+
4 rows in set (0.001 sec)

-- Task 4: Identify students eligible to take ECON201 (CourseID = 2)
MariaDB [econ485_hw]> SELECT
    s.StudentID,
    s.FirstName,
    s.LastName,
    c_target.CourseCode AS TargetCourseCode,
    c_req.CourseCode    AS RequiredCourseCode,
    c_req.CourseTitle   AS RequiredCourseTitle,
    p.MinimumGrade,
    cc.Grade            AS StudentGrade,
    CASE
        WHEN cc.Grade IS NULL THEN 'NOT COMPLETED'
        WHEN cc.Grade >= p.MinimumGrade THEN 'OK'
        ELSE 'BELOW MINIMUM'
    END AS PrerequisiteStatus
FROM Students s
JOIN Prerequisites p
      ON p.CourseID = 2
JOIN Courses c_target
      ON c_target.CourseID = p.CourseID
JOIN Courses c_req
      ON c_req.CourseID = p.RequiredCourseID
LEFT JOIN CompletedCourses cc
      ON cc.StudentID = s.StudentID
     AND cc.CourseID = p.RequiredCourseID
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Prerequisites p2
        LEFT JOIN CompletedCourses cc2
               ON cc2.StudentID = s.StudentID
              AND cc2.CourseID = p2.RequiredCourseID
        WHERE p2.CourseID = 2
          AND (
                cc2.Grade IS NULL
             OR cc2.Grade < p2.MinimumGrade
          )
    )
  AND NOT EXISTS (
        SELECT 1
        FROM Registrations r
        JOIN Sections sec ON r.SectionID = sec.SectionID
        WHERE r.StudentID = s.StudentID
          AND sec.CourseID = 2
    )
ORDER BY s.LastName, s.FirstName, c_req.CourseCode;
Empty set (0.008 sec)

-- Task 5: Detect students who registered without meeting prerequisites
MariaDB [econ485_hw]> SELECT
    s.FirstName,
    s.LastName,
    c_target.CourseCode       AS TargetCourseCode,
    c_req.CourseCode          AS MissingOrFailedPrereqCode,
    c_req.CourseTitle         AS MissingOrFailedPrereqTitle,
    cc.Grade                  AS StudentGrade,
    p.MinimumGrade
FROM Registrations r
JOIN Sections sec
      ON r.SectionID = sec.SectionID
JOIN Courses c_target
      ON sec.CourseID = c_target.CourseID
JOIN Students s
      ON r.StudentID = s.StudentID
JOIN Prerequisites p
      ON p.CourseID = c_target.CourseID
LEFT JOIN CompletedCourses cc
      ON cc.StudentID = s.StudentID
     AND cc.CourseID = p.RequiredCourseID
JOIN Courses c_req
      ON c_req.CourseID = p.RequiredCourseID
WHERE
      cc.Grade IS NULL          -- prerequisite not completed
   OR cc.Grade < p.MinimumGrade -- or grade below minimum
ORDER BY s.LastName, s.FirstName, c_target.CourseCode, c_req.CourseCode;
+-----------+----------+------------------+----------------------------+-----------------------------+-------------+--------------+
| FirstName | LastName | TargetCourseCode | MissingOrFailedPrereqCode  | MissingOrFailedPrereqTitle  | StudentGrade| MinimumGrade |
+-----------+----------+------------------+----------------------------+-----------------------------+-------------+--------------+
| Zeynep    | Arslan   | ECON201          | ECON101                    | Introduction to Economics   | A           | C            |
| Zeynep    | Arslan   | ECON201          | MATH101                    | Calculus I                  | B           | D            |
| Mert      | Celik    | ECON201          | ECON101                    | Introduction to Economics   | NULL        | C            |
| Mert      | Celik    | ECON201          | MATH101                    | Calculus I                  | NULL        | D            |
| Burak     | Kilic    | ECON201          | ECON101                    | Introduction to Economics   | NULL        | C            |
| Burak     | Kilic    | ECON201          | MATH101                    | Calculus I                  | NULL        | D            |
| Ali       | Yilmaz   | ECON201          | ECON101                    | Introduction to Economics   | B           | C            |
| Ali       | Yilmaz   | ECON201          | MATH101                    | Calculus I                  | C           | D            |
+-----------+----------+------------------+----------------------------+-----------------------------+-------------+--------------+
8 rows in set (0.002 sec)
```
```
