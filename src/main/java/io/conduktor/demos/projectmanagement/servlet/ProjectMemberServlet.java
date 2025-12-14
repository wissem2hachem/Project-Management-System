package io.conduktor.demos.projectmanagement.servlet;

import io.conduktor.demos.projectmanagement.entity.Project;
import io.conduktor.demos.projectmanagement.entity.ProjectMember;
import io.conduktor.demos.projectmanagement.entity.User;
import io.conduktor.demos.projectmanagement.service.ProjectService;
import io.conduktor.demos.projectmanagement.util.DatabaseUtil;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/projects/members")
public class ProjectMemberServlet extends HttpServlet {

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
        String projectIdStr = request.getParameter("projectId");

        if (projectIdStr == null || projectIdStr.trim().isEmpty()) {
            session.setAttribute("error", "Project ID is required");
            response.sendRedirect(request.getContextPath() + "/projects/");
            return;
        }

        Long projectId;
        try {
            projectId = Long.parseLong(projectIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid project ID");
            response.sendRedirect(request.getContextPath() + "/projects/");
            return;
        }

        EntityManager em = DatabaseUtil.getEntityManager();
        ProjectService projectService = new ProjectService(em);

        if ("add".equals(action)) {
            // Add member to project
            String userEmail = request.getParameter("userEmail");
            String role = request.getParameter("role");

            StringBuilder errors = new StringBuilder();

            // Validate input
            if (userEmail == null || userEmail.trim().isEmpty()) {
                errors.append("User email is required. ");
            }

            if (role == null || role.trim().isEmpty()) {
                errors.append("Role is required. ");
            } else if (!role.equals("MANAGER") && !role.equals("DEVELOPER") && !role.equals("TESTER")) {
                errors.append("Invalid role. Must be MANAGER, DEVELOPER, or TESTER. ");
            }

            if (errors.length() > 0) {
                session.setAttribute("error", errors.toString());
                response.sendRedirect(request.getContextPath() + "/projects/view/" + projectId);
                return;
            }

            try {
                // Find user by email
                List<User> users = em.createQuery(
                        "SELECT u FROM User u WHERE u.email = :email", User.class)
                        .setParameter("email", userEmail.trim())
                        .getResultList();

                if (users.isEmpty()) {
                    session.setAttribute("error", "User with email '" + userEmail + "' not found");
                    response.sendRedirect(request.getContextPath() + "/projects/view/" + projectId);
                    return;
                }

                User memberUser = users.get(0);
                Project project = projectService.getProjectById(projectId);

                if (project == null) {
                    session.setAttribute("error", "Project not found");
                    response.sendRedirect(request.getContextPath() + "/projects/");
                    return;
                }

                // Check if user is already a member
                List<ProjectMember> existingMembers = em.createQuery(
                        "SELECT pm FROM ProjectMember pm WHERE pm.project.id = :projectId AND pm.user.id = :userId",
                        ProjectMember.class)
                        .setParameter("projectId", projectId)
                        .setParameter("userId", memberUser.getId())
                        .getResultList();

                if (!existingMembers.isEmpty()) {
                    session.setAttribute("error", "User is already a member of this project");
                    response.sendRedirect(request.getContextPath() + "/projects/view/" + projectId);
                    return;
                }

                // Add member
                projectService.addMember(project, memberUser, role);
                session.setAttribute("success", "Team member added successfully!");
                response.sendRedirect(request.getContextPath() + "/projects/view/" + projectId);

            } catch (Exception e) {
                session.setAttribute("error", "Failed to add member: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/projects/view/" + projectId);
            }

        } else if ("remove".equals(action)) {
            // Remove member from project
            String memberIdStr = request.getParameter("memberId");

            if (memberIdStr == null || memberIdStr.trim().isEmpty()) {
                session.setAttribute("error", "Member ID is required");
                response.sendRedirect(request.getContextPath() + "/projects/view/" + projectId);
                return;
            }

            try {
                Long memberId = Long.parseLong(memberIdStr);

                em.getTransaction().begin();
                ProjectMember member = em.find(ProjectMember.class, memberId);

                if (member != null) {
                    // Verify the member belongs to the project
                    if (!member.getProject().getId().equals(projectId)) {
                        session.setAttribute("error", "Invalid member for this project");
                        em.getTransaction().rollback();
                        response.sendRedirect(request.getContextPath() + "/projects/view/" + projectId);
                        return;
                    }

                    em.remove(member);
                    em.getTransaction().commit();
                    session.setAttribute("success", "Team member removed successfully");
                } else {
                    session.setAttribute("error", "Member not found");
                    em.getTransaction().rollback();
                }

                response.sendRedirect(request.getContextPath() + "/projects/view/" + projectId);

            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid member ID");
                response.sendRedirect(request.getContextPath() + "/projects/view/" + projectId);
            } catch (Exception e) {
                if (em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                session.setAttribute("error", "Failed to remove member: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/projects/view/" + projectId);
            }
        }
    }
}
