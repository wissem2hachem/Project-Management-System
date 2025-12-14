package io.conduktor.demos.projectmanagement.servlet;

import io.conduktor.demos.projectmanagement.entity.User;
import io.conduktor.demos.projectmanagement.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.userService = new UserService();
        System.out.println("AdminServlet initialized successfully");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== AdminServlet doGet called ===");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Context Path: " + request.getContextPath());
        System.out.println("Path Info: " + request.getPathInfo());

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            System.out.println("No user in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        System.out.println("User in session: " + user.getName() + " (Role: " + user.getRole() + ")");

        // Check if user is admin
        if (!"ADMIN".equals(user.getRole())) {
            System.out.println("User is not ADMIN, access denied");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String path = request.getPathInfo();

        if (path == null || path.equals("/") || path.equals("/users")) {
            try {
                System.out.println("Fetching all users from database...");
                List<User> users = userService.getAllUsers();
                System.out.println("Retrieved " + (users != null ? users.size() : 0) + " users");

                if (users != null) {
                    for (User u : users) {
                        System.out
                                .println("  - User: " + u.getName() + " (" + u.getEmail() + ") - Role: " + u.getRole());
                    }
                }

                request.setAttribute("users", users);
                request.setAttribute("pageTitle", "Users");
                request.setAttribute("pageSubtitle", "View system users and their roles");
                request.setAttribute("contentPage", "/views/admin/users.jsp");

                System.out.println("Forwarding to base.jsp with contentPage: /views/admin/users.jsp");
                request.getRequestDispatcher("/WEB-INF/templates/base.jsp").forward(request, response);
            } catch (Exception e) {
                System.err.println("ERROR in AdminServlet: " + e.getMessage());
                e.printStackTrace();
                throw e;
            }
        } else {
            System.out.println("Path not found: " + path);
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
