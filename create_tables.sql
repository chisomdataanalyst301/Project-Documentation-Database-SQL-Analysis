-- ============================================
-- FILE: create_tables.sql
-- PROJECT: Project Documentation Database
-- DATABASE: Microsoft SQL Server
-- AUTHOR: Your Name
-- DATE: May 2026
-- DESCRIPTION: Creates all 5 tables for the
--              project documentation system
-- ============================================

-- Step 1: Create and select the database
CREATE DATABASE project_docs;
GO
USE project_docs;
GO

-- ============================================
-- TABLE 1: team_members
-- Stores all people working on projects
-- Created first because other tables depend on it
-- ============================================
CREATE TABLE team_members (
  member_id INT          IDENTITY(1,1) PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email     VARCHAR(150) NOT NULL UNIQUE,
  role      VARCHAR(80)  NOT NULL,
  joined_at DATETIME     DEFAULT GETDATE()
);
GO

-- ============================================
-- TABLE 2: projects
-- Stores all company projects
-- ============================================
CREATE TABLE projects (
  project_id  INT          IDENTITY(1,1) PRIMARY KEY,
  name        VARCHAR(150) NOT NULL,
  description VARCHAR(255) NOT NULL,
  status      VARCHAR(20)  NOT NULL DEFAULT 'planning',
  start_date  DATE         NOT NULL,
  end_date    DATE         NOT NULL,
  created_at  DATETIME     DEFAULT GETDATE()
);
GO

-- ============================================
-- TABLE 3: project_members
-- Junction table linking members to projects
-- One member can be on many projects
-- One project can have many members
-- ============================================
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

-- ============================================
-- TABLE 4: documents
-- Stores files and documents for each project
-- ============================================
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

-- ============================================
-- TABLE 5: doc_revisions
-- Tracks every edit made to a document
-- ============================================
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

-- ============================================
-- Confirm all tables were created successfully
-- ============================================
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
GO
