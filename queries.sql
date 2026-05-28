-- ==========================================
-- BASIC RETRIEVAL AND FILTERING
-- ==========================================

-- 1. List all active students with student ID, name, email, batch, and admission date.
SELECT student_id, full_name, email, batch_id, admission_date 
FROM students 
WHERE enrollment_status = 'Enrolled';

-- 2. Find students whose email is missing or appears invalid.
SELECT student_id, full_name, email 
FROM students 
WHERE email IS NULL OR email NOT LIKE '%@%.%';

-- 3. List all problems with difficulty level Easy or Medium.
SELECT problem_id, title, difficulty 
FROM problems 
WHERE difficulty IN ('Easy', 'Medium');

-- 4. Display the latest 20 submissions based on submission timestamp.
SELECT submission_id, student_id, problem_id, submitted_at 
FROM submissions 
ORDER BY submitted_at DESC 
LIMIT 20;

-- 5. Find submissions where the status is not successful.
SELECT submission_id, student_id, status 
FROM submissions 
WHERE status NOT IN ('Accepted', 'Success');

-- ==========================================
-- JOINS
-- ==========================================

-- 6. Display each submission with student name, problem title, language, status, score, and submitted time.
SELECT s.submission_id, st.full_name, p.title, s.language, s.status, s.score, s.submitted_at 
FROM submissions s 
JOIN students st ON s.student_id = st.student_id 
JOIN problems p ON s.problem_id = p.problem_id;

-- 7. Display all students and their enrollments, including students who are not enrolled in any course.
SELECT s.student_id, s.full_name, e.course_id, e.enrollment_status 
FROM students s 
LEFT JOIN enrollments e ON s.student_id = e.student_id;

-- 8. Display all courses with the number of enrolled students.
SELECT c.course_title, COUNT(e.student_id) AS enrolled_count 
FROM courses c 
LEFT JOIN enrollments e ON c.course_id = e.course_id 
GROUP BY c.course_id, c.course_title;

-- 9. Display test-case results for each submission, including problem title and student name.
SELECT tr.result_id, st.full_name, p.title, tr.result_status, tr.awarded_points 
FROM test_results tr 
JOIN submissions s ON tr.submission_id = s.submission_id 
JOIN students st ON s.student_id = st.student_id 
JOIN problems p ON s.problem_id = p.problem_id;

-- 10. Find students who are enrolled in a course but have not submitted any solution for that course.
SELECT DISTINCT st.student_id, st.full_name, c.course_title 
FROM students st 
JOIN enrollments e ON st.student_id = e.student_id 
JOIN courses c ON e.course_id = c.course_id 
LEFT JOIN (
    SELECT sub.student_id, p.course_id 
    FROM submissions sub 
    JOIN problems p ON sub.problem_id = p.problem_id
) student_course_subs ON st.student_id = student_course_subs.student_id AND c.course_id = student_course_subs.course_id
WHERE student_course_subs.student_id IS NULL;

-- ==========================================
-- AGGREGATION AND HAVING
-- ==========================================

-- 11. Count submissions by status.
SELECT status, COUNT(*) AS status_count 
FROM submissions 
GROUP BY status;

-- 12. Calculate average score per problem.
SELECT problem_id, ROUND(AVG(score), 2) AS avg_score 
FROM submissions 
GROUP BY problem_id;

-- 13. Find students with more than a chosen number of submissions (e.g., > 5).
SELECT student_id, COUNT(submission_id) AS total_submissions 
FROM submissions 
GROUP BY student_id 
HAVING COUNT(submission_id) > 5;

-- 14. Find problems where the success rate is below 40%.
SELECT problem_id, 
       ROUND((SUM(CASE WHEN status IN ('Accepted', 'Success') THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS success_rate 
FROM submissions 
GROUP BY problem_id 
HAVING success_rate < 40;

-- 15. Find the top 10 most attempted problems.
SELECT problem_id, COUNT(submission_id) AS attempt_count 
FROM submissions 
GROUP BY problem_id 
ORDER BY attempt_count DESC 
LIMIT 10;

-- ==========================================
-- SUBQUERIES / SET LOGIC
-- ==========================================

-- 16. Find students whose average score is greater than the overall average score.
SELECT student_id, ROUND(AVG(score), 2) AS student_avg 
FROM submissions 
GROUP BY student_id 
HAVING AVG(score) > (SELECT AVG(score) FROM submissions);

-- 17. Find problems that have never been attempted.
SELECT problem_id, title 
FROM problems 
WHERE problem_id NOT IN (
    SELECT DISTINCT problem_id FROM submissions
);

-- 18. Find students who have enrolled but never submitted any solution.
SELECT student_id, full_name 
FROM students 
WHERE student_id IN (SELECT student_id FROM enrollments) 
  AND student_id NOT IN (SELECT student_id FROM submissions);

-- 19. Find students who submitted solutions in both Python and Java.
SELECT student_id 
FROM submissions 
WHERE language = 'Python'
INTERSECT
SELECT student_id 
FROM submissions 
WHERE language = 'Java';

-- 20. Find the second-highest score for a selected problem (e.g., problem_id = 1).
SELECT MAX(score) AS second_highest_score 
FROM submissions 
WHERE problem_id = 1 
  AND score < (SELECT MAX(score) FROM submissions WHERE problem_id = 1);
