-- ECON485 – Homework 3
-- JOIN-based reporting and validation on econ485_hw

USE econ485_hw;

-- Task 1 – List students and their registered sections
SELECT
    s.FirstName,
    s.LastName,
    c.CourseCode,
    sec.SectionNumber
FROM Registrations r
JOIN Students s  ON r.StudentID = s.StudentID
JOIN Sections sec ON r.SectionID = sec.SectionID
JOIN Courses c   ON sec.CourseID = c.CourseID
ORDER BY s.LastName, s.FirstName, c.CourseCode, sec.SectionNumber;

-- Task 2 – Show courses with total student counts
SELECT
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

-- Task 3 – List all prerequisites for each course
SELECT
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

-- Task 4 – Identify students eligible to take ECON201 (CourseID = 2)
SELECT
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

-- Task 5 – Detect students who registered without meeting prerequisites
SELECT
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
      cc.Grade IS NULL       -- prerequisite not completed
   OR cc.Grade < p.MinimumGrade  -- or grade below minimum
ORDER BY s.LastName, s.FirstName, c_target.CourseCode, c_req.CourseCode;
