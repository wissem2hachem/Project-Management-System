package io.conduktor.demos.projectmanagement.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.conduktor.demos.projectmanagement.entity.User;
import io.conduktor.demos.projectmanagement.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Map;

@WebServlet("/api/users/*")
public class UserApiServlet extends HttpServlet {

    private UserService userService;
    private ObjectMapper objectMapper;

    @Override
    public void init() throws ServletException {
        this.userService = new UserService();
        this.objectMapper = new ObjectMapper();
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null)
            return false;
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // Create User
            try {
                StringBuilder buffer = new StringBuilder();
                BufferedReader reader = request.getReader();
                String line;
                while ((line = reader.readLine()) != null) {
                    buffer.append(line);
                }
                String json = buffer.toString();

                // Simple parsing or use Jackson if dependency available
                // Assuming Jackson is available as per pom.xml check earlier
                Map<String, String> userData = objectMapper.readValue(json, Map.class);

                String name = userData.get("name");
                String email = userData.get("email");
                String password = userData.get("password");
                String role = userData.get("role");

                User newUser = userService.registerUser(name, email, password);
                if (newUser != null) {
                    newUser.setRole(role);
                    userService.updateUser(newUser); // Explicitly update role as register defaults to MEMBER
                    response.setStatus(HttpServletResponse.SC_CREATED);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User creation failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating user");
            }
        } else if (pathInfo.matches("/\\d+/reset-password")) {
            // Reset Password
            try {
                String[] parts = pathInfo.split("/");
                Long userId = Long.parseLong(parts[1]);
                // For demo, resetting to default password "password123"
                userService.resetPassword(userId, "password123");
                response.setStatus(HttpServletResponse.SC_OK);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo != null && pathInfo.matches("/\\d+")) {
            try {
                Long userId = Long.parseLong(pathInfo.substring(1));
                userService.deleteUser(userId);
                response.setStatus(HttpServletResponse.SC_NO_CONTENT); // 204 No Content
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            StringBuilder buffer = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                buffer.append(line);
            }
            String json = buffer.toString();

            Map<String, String> userData = objectMapper.readValue(json, Map.class);
            Long userId = Long.parseLong(userData.get("id"));
            String name = userData.get("name");
            String email = userData.get("email");
            String role = userData.get("role");

            User user = userService.getUserById(userId);
            if (user != null) {
                user.setName(name);
                user.setEmail(email);
                user.setRole(role);
                userService.updateUser(user);
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
