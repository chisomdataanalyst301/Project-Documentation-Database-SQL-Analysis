-- ============================================
-- FILE: queries.sql
-- PROJECT: Project Documentation Database
-- DATABASE: Microsoft SQL Server
-- AUTHOR:CHISOM PRECIOUS
-- DATE: May 2026
-- DESCRIPTION: Practice queries covering
--              WHERE, ORDER BY, Aggregates,
--              JOINs and CTEs
-- ============================================

USE project_docs;
GO

-- ============================================
-- SECTION 1: WHERE CLAUSE
-- Used to filter rows based on a condition
-- ============================================

-- 1.1 Show only active projects
SELECT * FROM projects
WHERE status = 'active';

-- 1.2 Show projects ending before December 2025
SELECT * FROM projects
WHERE end_date < '2025-12-01';

-- 1.3 Show team members who are developers
SELECT * FROM team_members
WHERE role LIKE '%Developer%';

-- 1.4 Show completed projects only
SELECT name, start_date, end_date FROM projects
WHERE status = 'completed';

-- 1.5 Show documents of type 'design'
SELECT title, version, created_at FROM documents
WHERE doc_type = 'design';
GO

-- ============================================
-- SECTION 2: ORDER BY
-- Used to sort results ascending or descending
-- ============================================

-- 2.1 Show projects ordered by start date (oldest first)
SELECT * FROM projects
ORDER BY start_date ASC;

-- 2.2 Show projects ordered by end date (latest first)
SELECT * FROM projects
ORDER BY end_date DESC;

-- 2.3 Show team members alphabetically
SELECT * FROM team_members
ORDER BY full_name ASC;

-- 2.4 Show documents ordered by version
SELECT title, version FROM documents
ORDER BY version DESC;

-- 2.5 Show revisions ordered by most recent
SELECT * FROM doc_revisions
ORDER BY revised_at DESC;
GO

-- ============================================
-- SECTION 3: AGGREGATE FUNCTIONS
-- Used to calculate totals, counts, min, max
-- ============================================

-- 3.1 Count total number of projects
SELECT COUNT(*) AS total_projects
FROM projects;

-- 3.2 Count projects grouped by status
SELECT status, COUNT(*) AS total
FROM projects
GROUP BY status;

-- 3.3 Earliest and latest project start dates
SELECT MIN(start_date) AS earliest_start,
       MAX(start_date) AS latest_start
FROM projects;

-- 3.4 Count how many documents each member created
SELECT created_by, COUNT(*) AS docs_created
FROM documents
GROUP BY created_by;

-- 3.5 Count members per project role
SELECT project_role, COUNT(*) AS total
FROM project_members
GROUP BY project_role;
GO

-- ============================================
-- SECTION 4: JOINS
-- Used to combine data from multiple tables
-- ============================================

-- 4.1 INNER JOIN — Show each document with its project name
SELECT d.title, d.doc_type, d.version,
       p.name AS project_name
FROM documents d
JOIN projects p ON d.project_id = p.project_id;

-- 4.2 INNER JOIN — Show each document with who created it
SELECT d.title, tm.full_name AS created_by, tm.role
FROM documents d
JOIN team_members tm ON d.created_by = tm.member_id;

-- 4.3 INNER JOIN — Show project name, member name and role
SELECT p.name        AS project,
       tm.full_name  AS member,
       pm.project_role
FROM project_members pm
JOIN projects      p  ON pm.project_id = p.project_id
JOIN team_members  tm ON pm.member_id  = tm.member_id;

-- 4.4 INNER JOIN — Show full revision history with names
SELECT d.title        AS document,
       tm.full_name   AS revised_by,
       dr.version,
       dr.change_summary,
       dr.revised_at
FROM doc_revisions dr
JOIN documents    d  ON dr.doc_id     = d.doc_id
JOIN team_members tm ON dr.revised_by = tm.member_id;

-- 4.5 LEFT JOIN — Show all projects even if they have no documents
SELECT p.name AS project_name,
       d.title AS document_title
FROM projects p
LEFT JOIN documents d ON p.project_id = d.project_id;

-- 4.6 THREE TABLE JOIN — Document, project and author in one result
SELECT d.title        AS document,
       p.name         AS project,
       tm.full_name   AS created_by,
       d.doc_type,
       d.version
FROM documents d
JOIN projects      p  ON d.project_id = p.project_id
JOIN team_members  tm ON d.created_by  = tm.member_id
ORDER BY p.name;
GO

-- ============================================
-- SECTION 5: CTEs (Common Table Expressions)
-- Used to write cleaner and more readable queries
-- Think of a CTE as a temporary named result
-- ============================================

-- 5.1 Count documents per project using a CTE
WITH project_doc_count AS (
  SELECT project_id, COUNT(*) AS total_docs
  FROM documents
  GROUP BY project_id
)
SELECT p.name, pdc.total_docs
FROM projects p
JOIN project_doc_count pdc ON p.project_id = pdc.project_id
ORDER BY pdc.total_docs DESC;

-- 5.2 Find all project owners using a CTE
WITH project_owners AS (
  SELECT project_id, member_id
  FROM project_members
  WHERE project_role = 'owner'
)
SELECT p.name    AS project,
       tm.full_name AS owner
FROM project_owners po
JOIN projects      p  ON po.project_id = p.project_id
JOIN team_members  tm ON po.member_id  = tm.member_id;

-- 5.3 Find members who are on more than one project
WITH member_project_count AS (
  SELECT member_id, COUNT(*) AS total_projects
  FROM project_members
  GROUP BY member_id
)
SELECT tm.full_name, mpc.total_projects
FROM member_project_count mpc
JOIN team_members tm ON mpc.member_id = tm.member_id
WHERE mpc.total_projects > 1;

-- 5.4 Show active projects with their document count
WITH active_projects AS (
  SELECT project_id, name
  FROM projects
  WHERE status = 'active'
),
doc_counts AS (
  SELECT project_id, COUNT(*) AS total_docs
  FROM documents
  GROUP BY project_id
)
SELECT ap.name AS project, dc.total_docs
FROM active_projects ap
LEFT JOIN doc_counts dc ON ap.project_id = dc.project_id;

-- 5.5 Show latest revision for each document
WITH latest_revision AS (
  SELECT doc_id, MAX(revised_at) AS last_revised
  FROM doc_revisions
  GROUP BY doc_id
)
SELECT d.title AS document,
       lr.last_revised
FROM latest_revision lr
JOIN documents d ON lr.doc_id = d.doc_id
ORDER BY lr.last_revised DESC;
GO
