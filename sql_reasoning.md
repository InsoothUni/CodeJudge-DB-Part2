# SQL Reasoning Explanations

**1. Explain one query where using `LEFT JOIN` is more appropriate than `INNER JOIN`.**
In **Query 7** (Display all students and their enrollments), a `LEFT JOIN` is essential. If an `INNER JOIN` were used, the query would strictly return students who have at least one enrollment record. By using `LEFT JOIN`, we guarantee that all students in the master `students` table are returned, and those without enrollments simply show `NULL` for the course columns. This is vital for auditing "inactive" or newly onboarded students.

**2. Explain one query where `HAVING` is required instead of `WHERE`.**
In **Query 13** (Find students with > 5 submissions), `HAVING` is required because we are filtering based on an aggregated value: `COUNT(submission_id)`. The `WHERE` clause filters rows *before* they are grouped, meaning it cannot evaluate aggregate functions. `HAVING` evaluates the condition *after* the `GROUP BY` clause has organized the data.

**3. Explain one situation where a subquery helped solve the problem.**
In **Query 16** (Find students whose average score is greater than the overall average score), a subquery is critical. We need to compare a student's individual grouped average against the global average of the entire table. The subquery `(SELECT AVG(score) FROM submissions)` calculates that single, dynamic global scalar value so the `HAVING` clause has a baseline to compare against.

**4. Explain one situation where your query output could be misleading if duplicate records exist.**
In **Query 8** (Count enrolled students per course), if the raw `enrollments` table contained duplicate rows for the same student and course (e.g., due to a system glitch or accidental double-click during import), `COUNT(e.student_id)` would count that student twice, inflating the course population. Using `COUNT(DISTINCT e.student_id)` would safeguard against this specific anomaly.

**5. Explain one edge case you considered while writing any query.**
In **Query 14** (Success rate below 40%), I considered the edge case of **integer division**. In many SQL dialects, dividing two integers drops the decimal (e.g., 1/3 = 0). By multiplying the sum by `100.0`, it forces the engine to cast the result as a decimal/float, ensuring accurate percentage calculations (e.g., 33.33% instead of 0%). I also considered the edge case of zero total submissions, which would cause a `Division by Zero` error, though a `HAVING` clause inherently implies at least one row exists for the group.
