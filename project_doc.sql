CREATE DATABASE project_docs;
GO
USE project_docs;
GO

USE project_docs;
GO

CREATE TABLE team_members (
  member_id INT IDENTITY(1,1) PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email     VARCHAR(150) NOT NULL UNIQUE,
  role      VARCHAR(80)  NOT NULL,
  joined_at DATETIME     DEFAULT GETDATE()
);
GO


USE project_docs;
GO

INSERT INTO team_members (full_name, email, role) VALUES
('Amara Osei',    'amara@example.com',  'Project Manager'),
('Kwame Mensah',  'kwame@example.com',  'Backend Developer'),
('Fatima Bello',  'fatima@example.com', 'Frontend Developer'),
('Tunde Adeyemi', 'tunde@example.com',  'QA Engineer'),
('Ngozi Eze',     'ngozi@example.com',  'Data Engineer'),
('Chidi Okeke',   'chidi@example.com',  'DevOps Engineer'),
('Sola Adesanya', 'sola@example.com',   'UI Designer'),
('Emeka Nwosu',   'emeka@example.com',  'Database Admin'),
('Bisi Adeleke',  'bisi@example.com',   'Business Analyst'),
('Yemi Okonkwo',  'yemi@example.com',   'Scrum Master');
GO

USE project_docs;
GO
SELECT * FROM team_members;
GO


USE project_docs;
GO

CREATE TABLE projects (
  project_id  INT IDENTITY(1,1) PRIMARY KEY,
  name        VARCHAR(150) NOT NULL,
  description VARCHAR(255) NOT NULL,
  status      VARCHAR(20)  NOT NULL DEFAULT 'planning',
  start_date  DATE         NOT NULL,
  end_date    DATE         NOT NULL,
  created_at  DATETIME     DEFAULT GETDATE()
);
GO

INSERT INTO projects (name, description, status, start_date, end_date) VALUES
('Inventory System v2',      'Rebuild of the legacy warehouse app',        'active',    '2025-01-10', '2025-08-30'),
('Customer Portal',          'Self-service portal for B2B clients',        'planning',  '2025-03-01', '2025-12-01'),
('Data Pipeline Refactor',   'Migrate ETL jobs to Apache Airflow',         'completed', '2024-06-01', '2024-12-15'),
('HR Management System',     'Internal HR tool for staff management',      'active',    '2025-02-01', '2025-09-01'),
('Mobile App v3',            'Third version of the company mobile app',    'planning',  '2025-04-01', '2025-11-30'),
('Payment Gateway',          'Integrate new payment provider into app',    'active',    '2025-01-20', '2025-06-30'),
('Security Audit Tool',      'Automated security scanning platform',       'on_hold',   '2025-03-15', '2025-10-15'),
('Reporting Dashboard',      'Real-time analytics dashboard for managers', 'active',    '2025-02-10', '2025-07-10'),
('Email Notification System','Automated email alerts for all services',    'completed', '2024-09-01', '2024-12-01'),
('Cloud Migration',          'Move all services from on-premise to AWS',   'planning',  '2025-05-01', '2026-01-01');
GO

SELECT * FROM projects;
GO


USE project_docs;
GO

CREATE TABLE project_members (
  project_id   INT         NOT NULL,
  member_id    INT         NOT NULL,
  project_role VARCHAR(20) NOT NULL DEFAULT 'contributor',
  assigned_at  DATETIME    DEFAULT GETDATE(),
  PRIMARY KEY (project_id, member_id),
  FOREIGN KEY (project_id) REFERENCES projects(project_id),
  FOREIGN KEY (member_id)  REFERENCES team_members(member_id)
);
GO

INSERT INTO project_members (project_id, member_id, project_role) VALUES
(1,  1,  'owner'),
(1,  2,  'contributor'),
(2,  3,  'owner'),
(2,  4,  'reviewer'),
(3,  5,  'owner'),
(4,  6,  'contributor'),
(5,  7,  'owner'),
(6,  8,  'contributor'),
(7,  9,  'reviewer'),
(8,  10, 'owner');
GO

SELECT * FROM project_members;
GO


USE project_docs;
GO

CREATE TABLE documents (
  doc_id     INT          IDENTITY(1,1) PRIMARY KEY,
  project_id INT          NOT NULL,
  title      VARCHAR(200) NOT NULL,
  doc_type   VARCHAR(20)  NOT NULL,
  content    TEXT         NOT NULL,
  version    VARCHAR(20)  NOT NULL DEFAULT '1.0',
  created_by INT          NOT NULL,
  created_at DATETIME     DEFAULT GETDATE(),
  updated_at DATETIME     DEFAULT GETDATE(),
  FOREIGN KEY (project_id) REFERENCES projects(project_id),
  FOREIGN KEY (created_by) REFERENCES team_members(member_id)
);
GO

INSERT INTO documents (project_id, title, doc_type, content, version, created_by) VALUES
(1, 'System Requirements Spec',  'requirement',   'Detailed requirements for Inventory v2.',       '1.0', 1),
(1, 'Database Design',           'design',        'ER diagram and table definitions.',             '1.2', 2),
(2, 'Portal Wireframes',         'design',        'Lo-fi wireframes for client dashboard.',        '1.0', 3),
(2, 'Sprint 1 Meeting Notes',    'meeting_notes', 'Action items from first sprint planning.',      '1.0', 4),
(3, 'Pipeline Migration Report', 'report',        'Post-migration summary and metrics.',           '2.0', 5),
(4, 'HR System Requirements',    'requirement',   'Full requirements for HR management module.',   '1.0', 6),
(5, 'Mobile App Design Guide',   'design',        'UI and UX guidelines for mobile app v3.',       '1.1', 7),
(6, 'Payment Integration Doc',   'requirement',   'Steps to integrate the new payment provider.',  '1.0', 8),
(7, 'Security Audit Checklist',  'other',         'List of security checks and scan procedures.',  '1.0', 9),
(8, 'Dashboard Report Template', 'report',        'Standard template for analytics dashboard.',    '1.0', 10);
GO

SELECT * FROM documents;
GO


USE project_docs;
GO

CREATE TABLE doc_revisions (
  revision_id    INT          IDENTITY(1,1) PRIMARY KEY,
  doc_id         INT          NOT NULL,
  revised_by     INT          NOT NULL,
  version        VARCHAR(20)  NOT NULL,
  change_summary VARCHAR(255) NOT NULL,
  revised_at     DATETIME     DEFAULT GETDATE(),
  FOREIGN KEY (doc_id)     REFERENCES documents(doc_id),
  FOREIGN KEY (revised_by) REFERENCES team_members(member_id)
);
GO

INSERT INTO doc_revisions (doc_id, revised_by, version, change_summary) VALUES
(1,  2,  '1.1', 'Added non-functional requirements section'),
(2,  1,  '1.1', 'Updated indexes and foreign key constraints'),
(3,  4,  '1.1', 'Added mobile responsive wireframes'),
(4,  3,  '1.1', 'Updated action items after review'),
(5,  5,  '2.1', 'Fixed metrics calculation errors'),
(6,  6,  '1.1', 'Added payroll module requirements'),
(7,  7,  '1.2', 'Updated color palette and typography'),
(8,  8,  '1.1', 'Added fallback payment method steps'),
(9,  9,  '1.1', 'Added OWASP top 10 checklist items'),
(10, 10, '1.1', 'Revised chart types for better clarity');
GO

SELECT * FROM doc_revisions;
GO


USE project_docs;
GO
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
GO

SELECT *
FROM team_members

SELECT role, COUNT(*) AS total 
FROM team_members
GROUP BY role

SELECT * 
FROM projects

SELECT name, COUNT(*) AS total 
FROM projects
GROUP BY name

SELECT * 
FROM project_members

SELECT project_role, COUNT(*) AS total 
FROM project_members
GROUP BY project_role

SELECT * 
FROM documents

SELECT doc_type, COUNT(*) AS total 
FROM documents
GROUP BY doc_type

SELECT * 
FROM doc_revisions

SELECT revised_by, COUNT(*) AS total 
FROM doc_revisions
GROUP BY revised_by

--WHERE CLAUSE
-- Show only active projects
SELECT * FROM projects
WHERE status = 'planning';

-- Show projects that end before 2025-12-01
SELECT * FROM projects
WHERE end_date < '2025-12-01';

-- Show team members who are developers
SELECT * FROM team_members
WHERE role LIKE '%Developer%';

--ORDER CLAUSE
-- Show projects ordered by start date
SELECT * FROM projects
ORDER BY start_date ASC;

-- Show team members alphabetically
SELECT * FROM team_members
ORDER BY full_name ASC;

-- Show projects newest end date first
SELECT * FROM projects
ORDER BY end_date DESC;


--Aggregate functions
-- Count total number of projects
SELECT COUNT(*) AS total_projects FROM projects;

-- Count projects by status
SELECT status, COUNT(*) AS total
FROM projects
GROUP BY status;

-- Earliest and latest project start dates
SELECT MIN(start_date) AS earliest,
       MAX(start_date) AS latest
FROM projects;


--JOIN
-- Show each document with its project name
SELECT d.title, d.doc_type, p.name AS project_name
FROM documents d
JOIN projects p ON d.project_id = p.project_id;

-- Show each document with who created it
SELECT d.title, tm.full_name AS created_by, tm.role
FROM documents d
JOIN team_members tm ON d.created_by = tm.member_id;

-- Show project name, member name and their role
SELECT p.name AS project, tm.full_name AS member, pm.project_role
FROM project_members pm
JOIN projects p      ON pm.project_id = p.project_id
JOIN team_members tm ON pm.member_id  = tm.member_id;

USE project_docs;
GO
SELECT d.title, p.name AS project_name, tm.full_name AS created_by
FROM documents d
JOIN projects p      ON d.project_id = p.project_id
JOIN team_members tm ON d.created_by  = tm.member_id;
GO


--CTES
-- List projects with how many documents each has
WITH project_doc_count AS (
  SELECT project_id, COUNT(*) AS total_docs
  FROM documents
  GROUP BY project_id
)
SELECT p.name, pdc.total_docs
FROM projects p
JOIN project_doc_count pdc ON p.project_id = pdc.project_id
ORDER BY pdc.total_docs DESC;

-- Find members who are owners of projects
WITH project_owners AS (
  SELECT project_id, member_id
  FROM project_members
  WHERE project_role = 'owner'
)
SELECT p.name AS project, tm.full_name AS owner
FROM project_owners po
JOIN projects p      ON po.project_id = p.project_id
JOIN team_members tm ON po.member_id  = tm.member_id;