-- Project Management System Database Schema
-- MySQL 8.0 compatible

USE project_management;

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS task_comments;
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS project_members;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS users;

-- Create Users table
CREATE TABLE users (
                       id BIGINT AUTO_INCREMENT PRIMARY KEY,
                       name VARCHAR(100) NOT NULL,
                       email VARCHAR(255) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       role VARCHAR(50) DEFAULT 'MEMBER',
                       avatar_url VARCHAR(500),
                       join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Projects table
CREATE TABLE projects (
                          id BIGINT AUTO_INCREMENT PRIMARY KEY,
                          name VARCHAR(200) NOT NULL,
                          description TEXT,
                          owner_id BIGINT NOT NULL,
                          created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          due_date TIMESTAMP NULL,
                          status VARCHAR(50) DEFAULT 'PLANNING',
                          INDEX idx_owner (owner_id),
                          INDEX idx_status (status),
                          FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Project Members table
CREATE TABLE project_members (
                                 id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                 project_id BIGINT NOT NULL,
                                 user_id BIGINT NOT NULL,
                                 role VARCHAR(50) DEFAULT 'DEVELOPER',
                                 INDEX idx_project (project_id),
                                 INDEX idx_user (user_id),
                                 UNIQUE KEY unique_membership (project_id, user_id),
                                 FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
                                 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Tasks table
CREATE TABLE tasks (
                       id BIGINT AUTO_INCREMENT PRIMARY KEY,
                       project_id BIGINT NOT NULL,
                       title VARCHAR(300) NOT NULL,
                       description TEXT,
                       status VARCHAR(50) DEFAULT 'TODO',
                       priority VARCHAR(50) DEFAULT 'MEDIUM',
                       assignee_id BIGINT NULL,
                       due_date TIMESTAMP NULL,
                       created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       completion_date TIMESTAMP NULL,
                       INDEX idx_project (project_id),
                       INDEX idx_assignee (assignee_id),
                       INDEX idx_status (status),
                       INDEX idx_due_date (due_date),
                       INDEX idx_priority (priority),
                       FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
                       FOREIGN KEY (assignee_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Task Comments table
CREATE TABLE task_comments (
                               id BIGINT AUTO_INCREMENT PRIMARY KEY,
                               task_id BIGINT NOT NULL,
                               author_id BIGINT NOT NULL,
                               content TEXT NOT NULL,
                               created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               INDEX idx_task (task_id),
                               INDEX idx_author (author_id),
                               FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
                               FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;