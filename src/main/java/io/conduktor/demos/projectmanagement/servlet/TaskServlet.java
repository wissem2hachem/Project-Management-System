package io.conduktor.demos.projectmanagement.servlet;

import io.conduktor.demos.projectmanagement.entity.*;
import io.conduktor.demos.projectmanagement.service.*;
import io.conduktor.demos.projectmanagement.util.DatabaseUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/tasks/*")
public class TaskServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        // Services initialized per request
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getPathInfo();
        TaskService taskService = new TaskService(DatabaseUtil.getEntityManager());

        if (path == null || path.equals("/")) {
            // List all tasks for current user
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user != null) {
                request.setAttribute("tasks", taskService.getUserTasks(user.getId()));

                request.setAttribute("pageTitle", "My Tasks");
                request.setAttribute("contentPage", "/views/tasks/list.jsp");
                request.getRequestDispatcher("/WEB-INF/templates/base.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            }
        } else if (path.equals("/kanban")) {
            // Show Kanban board
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null) {
                request.setAttribute("todoTasks", taskService.getTasksByStatus(user.getId(), "TODO"));
                request.setAttribute("inProgressTasks", taskService.getTasksByStatus(user.getId(), "IN_PROGRESS"));
                request.setAttribute("doneTasks", taskService.getTasksByStatus(user.getId(), "DONE"));

                request.setAttribute("pageTitle", "Kanban Board");
                request.setAttribute("contentPage", "/views/tasks/kanban.jsp");
                request.getRequestDispatcher("/WEB-INF/templates/base.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            }
        } else if (path.equals("/create")) {
            // Show task creation form
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null) {
                // Fetch user's projects to populate the dropdown
                ProjectService projectService = new ProjectService(DatabaseUtil.getEntityManager());
                request.setAttribute("projects", projectService.getUserProjects(user.getId()));

                request.setAttribute("pageTitle", "Create Task");
                request.setAttribute("contentPage", "/views/tasks/create.jsp");
                request.getRequestDispatcher("/WEB-INF/templates/base.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            }
        } else if (path != null && path.startsWith("/edit/")) {
            // Show task edit form
            try {
                Long taskId = Long.parseLong(path.substring(6));
                Task task = taskService.getTaskById(taskId);
                request.setAttribute("task", task);

                request.setAttribute("pageTitle", "Edit Task");
                request.setAttribute("contentPage", "/views/tasks/edit.jsp");
                request.getRequestDispatcher("/WEB-INF/templates/base.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (path != null) {
            // Task detail page
            try {
                Long taskId = Long.parseLong(path.substring(1));
                Task task = taskService.getTaskById(taskId);
                request.setAttribute("task", task);

                request.setAttribute("pageTitle", "Task Details");
                request.setAttribute("contentPage", "/views/tasks/detail.jsp");
                request.getRequestDispatcher("/WEB-INF/templates/base.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        TaskService taskService = new TaskService(DatabaseUtil.getEntityManager());
        ProjectService localProjectService = new ProjectService(DatabaseUtil.getEntityManager());

        if ("create".equals(action)) {
            // Enhanced validation for task creation
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String priority = request.getParameter("priority");
            String dueDateStr = request.getParameter("dueDate");
            String projectIdStr = request.getParameter("projectId");
            String assigneeIdStr = request.getParameter("assigneeId");

            // Validation errors
            StringBuilder errors = new StringBuilder();

            // Validate required fields
            if (title == null || title.trim().isEmpty()) {
                errors.append("Title is required. ");
            } else if (title.length() > 200) {
                errors.append("Title must be less than 200 characters. ");
            }

            if (projectIdStr == null || projectIdStr.trim().isEmpty()) {
                errors.append("Project is required. ");
            }

            // Validate project ID format and existence
            Long projectId = null;
            Project project = null;
            if (projectIdStr != null && !projectIdStr.trim().isEmpty()) {
                try {
                    projectId = Long.parseLong(projectIdStr);
                    project = localProjectService.getProjectById(projectId);
                    if (project == null) {
                        errors.append("Invalid project selected. ");
                    }
                } catch (NumberFormatException e) {
                    errors.append("Invalid project ID format. ");
                }
            }

            // Validate assignee if provided
            Long assigneeId = null;
            User assignee = user; // Default to current user
            if (assigneeIdStr != null && !assigneeIdStr.trim().isEmpty()) {
                try {
                    assigneeId = Long.parseLong(assigneeIdStr);
                    // In a real app, verify assignee is part of the project team
                } catch (NumberFormatException e) {
                    errors.append("Invalid assignee ID format. ");
                }
            }

            // Validate due date
            java.time.LocalDate dueDate = null;
            if (dueDateStr != null && !dueDateStr.trim().isEmpty()) {
                try {
                    dueDate = java.time.LocalDate.parse(dueDateStr);
                    // Check if date is in the past
                    if (dueDate.isBefore(java.time.LocalDate.now())) {
                        errors.append("Due date cannot be in the past. ");
                    }
                } catch (Exception e) {
                    errors.append("Invalid date format. ");
                }
            }

            // Validate status
            if (status != null && !status.trim().isEmpty()) {
                if (!status.equals("TODO") && !status.equals("IN_PROGRESS") && !status.equals("DONE")) {
                    errors.append("Invalid status value. ");
                }
            } else {
                status = "TODO"; // Default status
            }

            // Validate priority
            if (priority != null && !priority.trim().isEmpty()) {
                if (!priority.equals("LOW") && !priority.equals("MEDIUM") && !priority.equals("HIGH")) {
                    errors.append("Invalid priority value. ");
                }
            } else {
                priority = "MEDIUM"; // Default priority
            }

            // If there are errors, redirect back with error message
            if (errors.length() > 0) {
                session.setAttribute("error", errors.toString());
                session.setAttribute("formData", request.getParameterMap());
                response.sendRedirect(request.getContextPath() + "/tasks/create");
                return;
            }

            // Create the task
            try {
                taskService.createTask(title, description, project, assignee);
                session.setAttribute("success", "Task created successfully!");
                response.sendRedirect(request.getContextPath() + "/tasks/");
            } catch (Exception e) {
                session.setAttribute("error", "Failed to create task: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/tasks/create");
            }

        } else if ("update".equals(action)) {
            // Enhanced validation for task update
            String taskIdStr = request.getParameter("taskId");
            String status = request.getParameter("status");

            StringBuilder errors = new StringBuilder();

            // Validate task ID
            Long taskId = null;
            if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
                errors.append("Task ID is required. ");
            } else {
                try {
                    taskId = Long.parseLong(taskIdStr);
                } catch (NumberFormatException e) {
                    errors.append("Invalid task ID format. ");
                }
            }

            // Validate status
            if (status == null || status.trim().isEmpty()) {
                errors.append("Status is required. ");
            } else if (!status.equals("TODO") && !status.equals("IN_PROGRESS") && !status.equals("DONE")) {
                errors.append("Invalid status value. ");
            }

            // If there are errors, redirect back with error message
            if (errors.length() > 0) {
                session.setAttribute("error", errors.toString());
                response.sendRedirect(request.getContextPath() + "/tasks/" + taskIdStr);
                return;
            }

            // Update the task
            try {
                taskService.updateTaskStatus(taskId, status);
                session.setAttribute("success", "Task status updated successfully!");
                response.sendRedirect(request.getContextPath() + "/tasks/" + taskId);
            } catch (Exception e) {
                session.setAttribute("error", "Failed to update task: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/tasks/" + taskIdStr);
            }

        } else if ("comment".equals(action)) {
            // Enhanced validation for comment
            String taskIdStr = request.getParameter("taskId");
            String content = request.getParameter("content");

            StringBuilder errors = new StringBuilder();

            // Validate task ID
            Long taskId = null;
            if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
                errors.append("Task ID is required. ");
            } else {
                try {
                    taskId = Long.parseLong(taskIdStr);
                } catch (NumberFormatException e) {
                    errors.append("Invalid task ID format. ");
                }
            }

            // Validate comment content
            if (content == null || content.trim().isEmpty()) {
                errors.append("Comment cannot be empty. ");
            } else if (content.length() > 1000) {
                errors.append("Comment must be less than 1000 characters. ");
            }

            // If there are errors, redirect back with error message
            if (errors.length() > 0) {
                session.setAttribute("error", errors.toString());
                response.sendRedirect(request.getContextPath() + "/tasks/" + taskIdStr);
                return;
            }

            // Add the comment
            try {
                taskService.addComment(taskId, user, content);
                session.setAttribute("success", "Comment added successfully!");
                response.sendRedirect(request.getContextPath() + "/tasks/" + taskId);
            } catch (Exception e) {
                session.setAttribute("error", "Failed to add comment: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/tasks/" + taskIdStr);
            }
        }
    }
}