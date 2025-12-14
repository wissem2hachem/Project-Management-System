package io.conduktor.demos.projectmanagement.servlet;

import io.conduktor.demos.projectmanagement.entity.User;
import io.conduktor.demos.projectmanagement.service.UserService;
import io.conduktor.demos.projectmanagement.util.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.persistence.EntityManager;
import java.io.IOException;

@WebServlet(name = "UserServlet", urlPatterns = { "/user/*" })
public class UserServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        // Initialize services
        EntityManager em = DatabaseUtil.getEntityManager();
        userService = new UserService();
        // In a real app, you'd inject EntityManager properly
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getPathInfo();

        if (path == null || path.equals("/") || path.equals("/profile")) {
            // User profile
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user != null) {
                // Refresh user data from database
                User updatedUser = userService.getUserById(user.getId());
                if (updatedUser != null) {
                    session.setAttribute("user", updatedUser);
                    request.setAttribute("user", updatedUser);
                }
                request.getRequestDispatcher("/auth/profile.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("register".equals(action)) {
            handleRegistration(request, response);
        } else if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("logout".equals(action)) {
            handleLogout(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        }
    }

    private void handleRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("Processing registration for email: " + email);

        try {
            // Check if user already exists
            User existingUser = userService.getUserByEmail(email);
            if (existingUser != null) {
                System.out.println("Registration failed: Email already exists - " + email);
                request.setAttribute("error", "Email already registered");
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }

            // Create new user
            User user = userService.registerUser(name, email, password);

            if (user != null) {
                System.out.println("Registration successful for user: " + user.getId());
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                System.out.println("Registration failed: userService returned null");
                request.setAttribute("error", "Registration failed");
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.err.println("Registration Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Server error: " + e.getMessage());
            request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = userService.login(email, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                request.setAttribute("error", "Invalid email or password");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error: " + e.getMessage());
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
    }
}