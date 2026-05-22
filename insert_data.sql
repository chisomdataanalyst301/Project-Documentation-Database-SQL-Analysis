-- ============================================
-- FILE: insert_data.sql
-- PROJECT: Project Documentation Database
-- DATABASE: Microsoft SQL Server
-- AUTHOR: CHISOM PRECIOUS
-- DATE: May 2026
-- DESCRIPTION: Inserts 10 rows into each of
--              the 5 tables. Run AFTER
--              create_tables.sql
-- ============================================

USE project_docs;
GO

-- ============================================
-- INSERT 1: team_members
-- Always insert this first — other tables
-- depend on member_id
-- ============================================
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

-- ============================================
-- INSERT 2: projects
-- Insert second — documents depend on project_id
-- ============================================
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

-- ============================================
-- INSERT 3: project_members
-- Links members to projects
-- ============================================
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

-- ============================================
-- INSERT 4: documents
-- Insert after projects and team_members
-- ============================================
INSERT INTO documents (project_id, title, doc_type, content, version, created_by) VALUES
(1, 'System Requirements Spec',  'requirement',   'Detailed requirements for Inventory v2.',      '1.0', 1),
(1, 'Database Design',           'design',        'ER diagram and table definitions.',            '1.2', 2),
(2, 'Portal Wireframes',         'design',        'Lo-fi wireframes for client dashboard.',       '1.0', 3),
(2, 'Sprint 1 Meeting Notes',    'meeting_notes', 'Action items from first sprint planning.',     '1.0', 4),
(3, 'Pipeline Migration Report', 'report',        'Post-migration summary and metrics.',          '2.0', 5),
(4, 'HR System Requirements',    'requirement',   'Full requirements for HR management module.',  '1.0', 6),
(5, 'Mobile App Design Guide',   'design',        'UI and UX guidelines for mobile app v3.',      '1.1', 7),
(6, 'Payment Integration Doc',   'requirement',   'Steps to integrate the new payment provider.', '1.0', 8),
(7, 'Security Audit Checklist',  'other',         'List of security checks and scan procedures.', '1.0', 9),
(8, 'Dashboard Report Template', 'report',        'Standard template for analytics dashboard.',   '1.0', 10);
GO

-- ============================================
-- INSERT 5: doc_revisions
-- Insert last — depends on documents
-- ============================================
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

-- ============================================
-- Confirm all tables have 10 rows each
-- ============================================
SELECT 'projects'        AS table_name, COUNT(*) AS total_rows FROM projects
UNION ALL
SELECT 'team_members',                  COUNT(*) FROM team_members
UNION ALL
SELECT 'documents',                     COUNT(*) FROM documents
UNION ALL
SELECT 'project_members',               COUNT(*) FROM project_members
UNION ALL
SELECT 'doc_revisions',                 COUNT(*) FROM doc_revisions;
GO
