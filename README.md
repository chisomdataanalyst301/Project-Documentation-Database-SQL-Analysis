# Project-Documentation-Database-SQL-Analysis

# 📁 Project Documentation Database — SQL Analysis

![SQL Server](https://img.shields.io/badge/Microsoft%20SQL%20Server-CC2927?style=for-the-badge&logo=microsoft%20sql%20server&logoColor=white)
![SSMS](https://img.shields.io/badge/SSMS-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)

---

## 📌 Project Overview

This project contains SQL scripts for a **Project Documentation System** built with **Microsoft SQL Server**. It simulates a real-world company database that tracks projects, team members, documents, project assignments, and document revision history.

The goal of this project is to practice and demonstrate core SQL skills including table creation, data insertion, filtering, sorting, aggregation, joins, and common table expressions (CTEs).

---

## 🗄️ Database Schema

The database is called `project_docs` and contains **5 tables**:

| Table | Description |
|---|---|
| `projects` | Stores all company projects with status and dates |
| `team_members` | Stores all people working on projects |
| `documents` | Stores files and documents belonging to each project |
| `project_members` | Junction table linking team members to projects |
| `doc_revisions` | Tracks every edit and revision made to a document |

---

## 🔗 Entity Relationship Diagram

```
projects ──────────────── documents ──────── doc_revisions
   │                          │                    │
   │                          └──── team_members ──┘
   │
   └──── project_members ──── team_members
```

**Key Relationships:**
- A **project** can have many **documents**
- A **document** can have many **revisions**
- A **project** can have many **team members** (through `project_members`)
- A **team member** can belong to many **projects**

---

## 🛠️ Tools Used

- **Microsoft SQL Server** — database engine
- **SQL Server Management Studio (SSMS)** — query editor and database management
- **GitHub** — version control and project documentation

---

## 📚 SQL Concepts Covered

- `CREATE DATABASE` and `CREATE TABLE`
- `INSERT INTO` — adding rows of data
- `SELECT` with `WHERE` clause — filtering data
- `ORDER BY` — sorting results ascending and descending
- Aggregate functions — `COUNT()`, `MIN()`, `MAX()`
- `GROUP BY` and `HAVING`
- `INNER JOIN` and `LEFT JOIN` — combining multiple tables
- CTEs — Common Table Expressions using `WITH`
- Foreign keys and referential integrity
- `IDENTITY(1,1)` for auto-incrementing primary keys
- `INFORMATION_SCHEMA` — viewing table metadata

---

## 📂 Project Files

| File | Description |
|---|---|
| `README.md` | Project documentation (this file) |
| `create_tables.sql` | Scripts to create all 5 tables |
| `insert_data.sql` | Scripts to insert 10 rows into each table |
| `queries.sql` | All practice queries — WHERE, JOIN, CTE, aggregates |

---

## 🚀 How to Run This Project

Follow these steps to run the project on your own machine:

**Step 1** — Install [Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) and [SSMS](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)

**Step 2** — Open SSMS and connect to your local server using Windows Authentication

**Step 3** — Open a new query window and run `create_tables.sql` first

**Step 4** — Run `insert_data.sql` to populate the tables with sample data

**Step 5** — Open `queries.sql` and run any query to explore the data

> **Note:** Always run `USE project_docs;` at the top of every query window before running any script.

---

## 🔍 Sample Queries

### 1. Show all active projects
```sql
SELECT * FROM projects
WHERE status = 'active';
```

### 2. Show each document with its project name and author
```sql
SELECT d.title, p.name AS project_name, tm.full_name AS created_by
FROM documents d
JOIN projects p      ON d.project_id = p.project_id
JOIN team_members tm ON d.created_by  = tm.member_id;
```

### 3. Count documents per project using a CTE
```sql
WITH project_doc_count AS (
  SELECT project_id, COUNT(*) AS total_docs
  FROM documents
  GROUP BY project_id
)
SELECT p.name, pdc.total_docs
FROM projects p
JOIN project_doc_count pdc ON p.project_id = pdc.project_id
ORDER BY pdc.total_docs DESC;
```

---

## 💡 Key Learnings

- How to design a relational database with foreign keys
- How to use JOIN to combine data from multiple tables
- How to use CTEs to write cleaner and more readable queries
- How to use aggregate functions to summarize data
- The difference between INNER JOIN and LEFT JOIN
- How SQL Server differs from MySQL (IDENTITY vs AUTO_INCREMENT, GETDATE() vs NOW())

---

## 👤 Author

*CHISOM PRECIOUS**
- GitHub: [@yourusername](https://github.com/yourusername)
- LinkedIn: [(https://www.linkedin.com/in/chisom-precious-8685b4282)


## 📅 Date

May 2026


*This project was built as part of a personal SQL learning journey to practice database design and querying skills.*
