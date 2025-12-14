# Project Management System

A full-featured Project Management Project built with **Jakarta EE 11**, **Hibernate 6**, and **Tailwind CSS**. This application allows teams to track projects, manage tasks with a Kanban board, and collaborate effectively.

## 🚀 Features

*   **User Management**: Registration, Login, and Session Management.
*   **Project Workspace**: Create and manage multiple projects with start/due dates.
*   **Task Tracking**:
    *   Create tasks with Priorities (High, Medium, Low) and Deadlines.
    *   Assign tasks to team members.
    *   **Kanban Board**: Visual drag-and-drop style columns (Todo, In Progress, Done).
*   **Collaboration**: Comment on tasks to discuss requirements.
*   **Dashboard**: Real-time overview of active projects, task statistics, and upcoming deadlines.
*   **Team Management**: Add/Remove users from projects with specific roles.
*   **REST API**: Full JSON API for external integrations.

## 🛠️ Technology Stack

*   **Backend**: Jakarta EE 11 (Servlets, JAX-RS), Java 17+
*   **ORM**: Hibernate 6 (JPA)
*   **Database**: MySQL 8.0
*   **Frontend**: JSP, JSTL, JSF (Faces), Tailwind CSS (CDN), FontAwesome
*   **Build Tool**: Maven

## 📋 Prerequisites

Ensure you have the following installed:
*   **Java JDK 17** or higher
*   **Maven 3.8+**
*   **MySQL Server 8.0+**

## ⚙️ Installation & Setup

### 1. Database Configuration
1.  Create a MySQL database named `project_management`:
    ```sql
    CREATE DATABASE project_management;
    ```
2.  Open `src/main/resources/META-INF/persistence.xml`.
3.  Update the `jakarta.persistence.jdbc.user` and `jakarta.persistence.jdbc.password` properties with your MySQL credentials.

### 2. Build the Application
Open a terminal in the project root directory:

```bash
mvn clean install
```

## ▶️ How to Run

The project is pre-configured with the **Jetty Maven Plugin** for easy development.

1.  Run the application:
    ```bash
    mvn jetty:run
    ```
2.  Access the application in your browser: [http://localhost:8080/project-management](http://localhost:8080/project-management)

## 📖 User Guide

### Getting Started
1.  **Register**: Creating a new account at `/auth/register.jsp`.
2.  **Login**: Access your dashboard.

### Managing Projects
1.  Click **"Projects"** in the sidebar.
2.  Click **"Create Project"**, enter details, and Save.
3.  Click on the project name to view the **Project Detail** page.
4.  Use the **"Add Member"** button to add other registered users to your team.

### Working with Tasks
1.  Inside a project, click **"Add Task"**.
2.  Fill in the Title, Description, Priority, and Assignee.
3.  Go to **"Kanban Board"** in the sidebar to visualize all your tasks.
4.  Click on a task to view details, update status, or **add comments**.

## 🔌 API Documentation

The functionality is exposed via a REST API at `/api/*`.

**Base URL**: `http://localhost:8080/project-management/api`

| Resource | Endpoints | Description |
| :--- | :--- | :--- |
| **Projects** | `GET /projects`, `POST /projects` | Manage projects |
| **Tasks** | `POST /tasks`, `PUT /tasks/{id}` | Manage task lifecycle |
| **Comments** | `POST /tasks/{id}/comments` | Add discussion to tasks |
| **Dashboard** | `GET /dashboard` | Fetch logic-aggregated stats |

