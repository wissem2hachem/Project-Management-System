package io.conduktor.demos.projectmanagement.view;

import io.conduktor.demos.projectmanagement.entity.Project;
import io.conduktor.demos.projectmanagement.entity.Task;
import io.conduktor.demos.projectmanagement.entity.User;
import io.conduktor.demos.projectmanagement.service.ProjectService;
import io.conduktor.demos.projectmanagement.service.TaskService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.faces.context.FacesContext;
import java.io.Serializable;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Named
@ViewScoped
public class DashboardBean implements Serializable {

    @Inject
    private ProjectService projectService;

    @Inject
    private TaskService taskService;

    private List<Project> projects;
    private List<Task> recentTasks;
    private Map<String, Long> dashboardStats;
    private User currentUser;

    @PostConstruct
    public void init() {
        // Retrieve current user from Session (set by Servlet/JSP login)
        FacesContext context = FacesContext.getCurrentInstance();
        HttpServletRequest request = (HttpServletRequest) context.getExternalContext().getRequest();
        HttpSession session = request.getSession(false);

        if (session != null) {
            this.currentUser = (User) session.getAttribute("user");
        }

        loadDashboardData();
    }

    private void loadDashboardData() {
        if (currentUser == null) {
            projects = Collections.emptyList();
            recentTasks = Collections.emptyList();
            dashboardStats = new HashMap<>();
            dashboardStats.put("totalProjects", 0L);
            dashboardStats.put("pendingTasks", 0L);
            dashboardStats.put("completedTasks", 0L);
            dashboardStats.put("teamMembers", 0L);
            return;
        }

        // Fetch projects
        projects = projectService.getUserProjects(currentUser.getId());

        // Populate stats (mocking some logic or calculating from projects)
        long totalProjects = projects.size();
        long pendingTasks = 0;
        long completedTasks = 0;

        // This is a simplification. Ideally, we would have a service method for recent
        // tasks across all projects
        // For now, let's just grab tasks from the first few projects or assume a method
        // exists.
        // Since we don't have a "getUserTasks" in ProjectService/TaskService easily
        // accessible without iterating,
        // we might stick to project-based fetching or iterate.
        // Let's iterate for now as a naive implementation.

        for (Project p : projects) {
            List<Task> pTasks = taskService.getProjectTasks(p.getId());
            for (Task t : pTasks) {
                if ("DONE".equals(t.getStatus())) {
                    completedTasks++;
                } else {
                    pendingTasks++;
                }
            }
        }

        dashboardStats = new HashMap<>();
        dashboardStats.put("totalProjects", totalProjects);
        dashboardStats.put("pendingTasks", pendingTasks);
        dashboardStats.put("completedTasks", completedTasks);
        dashboardStats.put("teamMembers", 1L); // Just the user for now
    }

    public List<Project> getProjects() {
        return projects;
    }

    public Map<String, Long> getDashboardStats() {
        return dashboardStats;
    }

    public User getCurrentUser() {
        return currentUser;
    }
}
