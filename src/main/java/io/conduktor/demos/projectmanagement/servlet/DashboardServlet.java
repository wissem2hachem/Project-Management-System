package io.conduktor.demos.projectmanagement.servlet;

import io.conduktor.demos.projectmanagement.entity.User;
import io.conduktor.demos.projectmanagement.service.DashboardService;
import io.conduktor.demos.projectmanagement.service.ProjectService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.UserTransaction;
import javax.naming.InitialContext;
import java.io.IOException;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        try {
            // Get dashboard stats
            // Get dashboard stats
            EntityManager em = io.conduktor.demos.projectmanagement.util.DatabaseUtil.getEntityManager();
            DashboardService dashboardService = new DashboardService(em);

            Map<String, Object> stats = dashboardService.getDashboardStats(user.getId());
            request.setAttribute("dashboardStats", stats);

            // Get projects for progress bars
            ProjectService projectService = new ProjectService(em);
            request.setAttribute("projects", projectService.getUserProjects(user.getId()));

            request.setAttribute("pageTitle", "Dashboard");
            request.setAttribute("contentPage", "/views/dashboard.jsp");
            request.getRequestDispatcher("/WEB-INF/templates/base.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading dashboard");
            request.setAttribute("pageTitle", "Dashboard");
            request.setAttribute("contentPage", "/views/dashboard.jsp");
            request.getRequestDispatcher("/WEB-INF/templates/base.jsp").forward(request, response);
        }
    }
}