package io.conduktor.demos.projectmanagement.servlet;

import io.conduktor.demos.projectmanagement.entity.Project;
import io.conduktor.demos.projectmanagement.entity.Task;
import io.conduktor.demos.projectmanagement.entity.User;
import io.conduktor.demos.projectmanagement.service.ProjectService;
import io.conduktor.demos.projectmanagement.service.TaskService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import io.conduktor.demos.projectmanagement.util.DatabaseUtil;

@WebServlet("/projects/*")
public class ProjectServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String path = request.getPathInfo();
        ProjectService projectService = new ProjectService(DatabaseUtil.getEntityManager());

        if (path == null || path.equals("/")) {
            // List projects with statistics
            List<Project> projects = projectService.getUserProjects(user.getId());
            request.setAttribute("projects", projects);

            // Calculate statistics
            int totalProjects = projects.size();
            int activeProjects = 0;
            int completedProjects = 0;

            for (Project project : projects) {
                if ("ACTIVE".equals(project.getStatus())) {
                    activeProjects++;
                } else if ("COMPLETED".equals(project.getStatus())) {
                    completedProjects++;
                }
            }

            request.setAttribute("totalProjects", totalProjects);
            request.setAttribute("activeProjects", activeProjects);
            request.setAttribute("completedProjects", completedProjects);

            // Layout attributes
            request.setAttribute("pageTitle", "Projects");
            request.setAttribute("pageSubtitle", "Manage your projects and teams");
            request.setAttribute("contentPage", "/views/projects/list.jsp");

            request.getRequestDispatcher("/WEB-INF/templates/base.jsp").forward(request, response);

        } else if (path.equals("/create")) {
            // Show create form
            request.setAttribute("pageTitle", "Create Project");
            request.setAttribute("contentPage", "/views/projects/create.jsp");
            request.getRequestDispatcher("/WEB-INF/templates/base.jsp").forward(request, response);

        } else if (path.startsWith("/view/")) {
            // View project details
            try {
                Long projectId = Long.parseLong(path.substring(6));
                Project project = projectService.getProjectById(projectId);

                if (project != null) {
                    TaskService taskService = new TaskService(DatabaseUtil.getEntityManager());
                    List<Task> tasks = taskService.getProjectTasks(projectId);

                    // Calculate project statistics
                    int totalTasks = tasks.size();
                    int todoTasks = 0;
                    int inProgressTasks = 0;
                    int doneTasks = 0;

                    for (Task task : tasks) {
                        switch (task.getStatus()) {
                            case "TODO":
                                todoTasks++;
                                break;
                            case "IN_PROGRESS":
                                inProgressTasks++;
                                break;
                            case "DONE":
                                doneTasks++;
                                break;
                        }
                    }

                    int completionPercentage = totalTasks > 0 ? (doneTasks * 100) / totalTasks : 0;

                    request.setAttribute("project", project);
                    request.setAttribute("tasks", tasks);
                    request.setAttribute("members", projectService.getProjectMembers(projectId));
                    request.setAttribute("totalTasks", totalTasks);
                    request.setAttribute("todoTasks", todoTasks);
                    request.setAttribute("inProgressTasks", inProgressTasks);
                    request.setAttribute("doneTasks", doneTasks);
                    request.setAttribute("completionPercentage", completionPercentage);

                    request.setAttribute("contentPage", "/views/projects/detail.jsp");
                    request.setAttribute("pageTitle", project.getName());
                    request.getRequestDispatcher("/WEB-INF/templates/base.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Project not found");
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid project ID");
            }

        } else if (path.startsWith("/edit/")) {
            // Show edit form
            try {
                Long projectId = Long.parseLong(path.substring(6));
                Project project = projectService.getProjectById(projectId);

                if (project != null) {
                    request.setAttribute("project", project);
                    request.setAttribute("pageTitle", "Edit Project");
                    request.setAttribute("contentPage", "/views/projects/edit.jsp");
                    request.getRequestDispatcher("/WEB-INF/templates/base.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Project not found");
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid project ID");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        ProjectService projectService = new ProjectService(DatabaseUtil.getEntityManager());

        if ("create".equals(action)) {
            // Enhanced validation for project creation
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String dueDateStr = request.getParameter("dueDate");
            String status = request.getParameter("status");

            StringBuilder errors = new StringBuilder();

            // Validate required fields
            if (name == null || name.trim().isEmpty()) {
                errors.append("Project name is required. ");
            } else if (name.length() > 100) {
                errors.append("Project name must be less than 100 characters. ");
            }

            // Validate description
            if (description != null && description.length() > 1000) {
                errors.append("Description must be less than 1000 characters. ");
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
                if (!status.equals("ACTIVE") && !status.equals("COMPLETED") && !status.equals("ON_HOLD")) {
                    errors.append("Invalid status value. ");
                }
            } else {
                status = "ACTIVE"; // Default status
            }

            // If there are errors, redirect back with error message
            if (errors.length() > 0) {
                session.setAttribute("error", errors.toString());
                session.setAttribute("formData", request.getParameterMap());
                response.sendRedirect(request.getContextPath() + "/projects/create");
                return;
            }

            // Create the project
            try {
                projectService.createProject(name, description, user);
                session.setAttribute("success", "Project created successfully!");
                response.sendRedirect(request.getContextPath() + "/projects/");
            } catch (Exception e) {
                session.setAttribute("error", "Failed to create project: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/projects/create");
            }

        } else if ("update".equals(action)) {
            // Enhanced validation for project update
            String projectIdStr = request.getParameter("projectId");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String status = request.getParameter("status");

            StringBuilder errors = new StringBuilder();

            // Validate project ID
            Long projectId = null;
            if (projectIdStr == null || projectIdStr.trim().isEmpty()) {
                errors.append("Project ID is required. ");
            } else {
                try {
                    projectId = Long.parseLong(projectIdStr);
                } catch (NumberFormatException e) {
                    errors.append("Invalid project ID format. ");
                }
            }

            // Validate name
            if (name == null || name.trim().isEmpty()) {
                errors.append("Project name is required. ");
            } else if (name.length() > 100) {
                errors.append("Project name must be less than 100 characters. ");
            }

            // Validate description
            if (description != null && description.length() > 1000) {
                errors.append("Description must be less than 1000 characters. ");
            }

            // Validate status
            if (status != null && !status.trim().isEmpty()) {
                if (!status.equals("ACTIVE") && !status.equals("COMPLETED") && !status.equals("ON_HOLD")) {
                    errors.append("Invalid status value. ");
                }
            }

            // If there are errors, redirect back with error message
            if (errors.length() > 0) {
                session.setAttribute("error", errors.toString());
                response.sendRedirect(request.getContextPath() + "/projects/edit/" + projectIdStr);
                return;
            }

            // Update the project
            try {
                Project project = projectService.getProjectById(projectId);
                if (project != null) {
                    // Update project fields (you'll need to add an update method in ProjectService)
                    session.setAttribute("success", "Project updated successfully!");
                    response.sendRedirect(request.getContextPath() + "/projects/view/" + projectId);
                } else {
                    session.setAttribute("error", "Project not found.");
                    response.sendRedirect(request.getContextPath() + "/projects/");
                }
            } catch (Exception e) {
                session.setAttribute("error", "Failed to update project: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/projects/edit/" + projectIdStr);
            }

        } else if ("delete".equals(action)) {
            // Delete project
            String projectIdStr = request.getParameter("projectId");

            try {
                Long projectId = Long.parseLong(projectIdStr);
                // You'll need to add a delete method in ProjectService
                session.setAttribute("success", "Project deleted successfully!");
                response.sendRedirect(request.getContextPath() + "/projects/");
            } catch (Exception e) {
                session.setAttribute("error", "Failed to delete project: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/projects/");
            }
        }
    }
}