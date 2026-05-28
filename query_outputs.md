# SQL Query Output Expectations and Validation

This document summarizes the expected behavior and dataset validation for the implemented queries.

### Basic Retrieval
* **Q1 (Active Students):**
    * **Sample Output:** `101 | John Doe | john@email.com | 2 | 2024-01-15`
    * **Validation Note:** Accurately filters out students who have dropped out or graduated by strict string matching on `enrollment_status`.
* **Q2 (Invalid Emails):**
    * **Sample Output:** `142 | Jane Smith | janesmith_no_domain`
    * **Validation Note:** Uses SQL `LIKE` wildcard matching to ensure at least one `@` and one `.` exist, catching raw dataset anomalies effectively.
* **Q5 (Unsuccessful Submissions):**
    * **Sample Output:** `5021 | 105 | Runtime Error`
    * **Validation Note:** Excludes the 'Accepted' string to aggregate logical errors, timeouts, and compile failures into one diagnostic view.

### Joins
* **Q7 (All Students & Enrollments):**
    * **Sample Output:** `110 | Mark V. | NULL | NULL`
    * **Validation Note:** The `LEFT JOIN` correctly preserves student records from the master table even if they haven't been mapped in the `enrollments` table yet (e.g., newly imported students).
* **Q10 (Enrolled but No Submissions for Course):**
    * **Sample Output:** `205 | Alice G. | Data Structures`
    * **Validation Note:** Validates complex cross-referencing. It connects course catalogs to student submissions via the `problems` table to find engagement gaps.

### Aggregation and HAVING
* **Q11 (Status Counts):**
    * **Sample Output:** `Accepted: 1200 | Time Limit Exceeded: 340`
    * **Validation Note:** Grouping by status gives an exact distribution of platform health and algorithmic difficulty.
* **Q14 (Success Rate < 40%):**
    * **Sample Output:** `Problem 12 | 25.50%`
    * **Validation Note:** Converts conditional sums into a percentage float (`* 100.0`), successfully isolating "Hard" problems based on empirical data rather than catalog tags.

### Subqueries / Set Logic
* **Q16 (Above Average Students):**
    * **Sample Output:** `155 | 88.5`
    * **Validation Note:** Dynamically calculates the global threshold dataset average at runtime rather than hardcoding a passing score. 
* **Q19 (Python AND Java Users):**
    * **Sample Output:** `108`
    * **Validation Note:** Uses `INTERSECT` (or conditional aggregation) to ensure only students existing in both distinct language subsets are returned.
