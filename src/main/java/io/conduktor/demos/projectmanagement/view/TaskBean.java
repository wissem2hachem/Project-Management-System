package io.conduktor.demos.projectmanagement.view;

import io.conduktor.demos.projectmanagement.entity.Project;
import io.conduktor.demos.projectmanagement.entity.User;
import io.conduktor.demos.projectmanagement.service.ProjectService;
import io.conduktor.demos.projectmanagement.service.TaskService;
import io.conduktor.demos.projectmanagement.service.UserService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.view.ViewScoped;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

@Named
@ViewScoped
public class TaskBean implements Serializable {

    @Inject
    private TaskService taskService;

    @Inject
    private ProjectService projectService;

    @Inject
    private UserService userService;

    private Long selectedProjectId;
    private String title;
    private String description;
    private String priority; // LOW, MEDIUM, HIGH
    private LocalDateTime dueDate;

    private List<Project> userProjects;
    private User currentUser;

    @PostConstruct
    public void init() {
        FacesContext context = FacesContext.getCurrentInstance();
        HttpServletRequest request = (HttpServletRequest) context.getExternalContext().getRequest();
        HttpSession session = request.getSession(false);

        if (session != null) {
            this.currentUser = (User) session.getAttribute("user");
            if (currentUser != null) {
                this.userProjects = projectService.getUserProjects(currentUser.getId());
            }
        }
    }

    public String createTask() {
        if (currentUser == null) {
            FacesContext.getCurrentInstance().addMessage(null,
                    new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error", "You must be logged in"));
            return null;
        }

        try {
            // Retrieve full project entity to Ensure we have it
            // Project project = projectService.getProjectById(selectedProjectId); // Not
            // strictly needed if we just pass ID to service

            // Use createTaskFromJson to handle ID lookups and additional fields
            taskService.createTaskFromJson(title, description, selectedProjectId, currentUser.getId(), priority, "TODO",
                    dueDate);

            FacesContext.getCurrentInstance().addMessage(null,
                    new FacesMessage(FacesMessage.SEVERITY_INFO, "Success", "Task created successfully"));

            return "/dashboard.xhtml?faces-redirect=true";

        } catch (Exception e) {
            e.printStackTrace();
            FacesContext.getCurrentInstance().addMessage(null,
                    new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error", "Failed to create task: " + e.getMessage()));
            return null;
        }
    }

    // Getters and Setters
    public Long getSelectedProjectId() {
        return selectedProjectId;
    }

    public void setSelectedProjectId(Long selectedProjectId) {
        this.selectedProjectId = selectedProjectId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public LocalDateTime getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDateTime dueDate) {
        this.dueDate = dueDate;
    }

    public List<Project> getUserProjects() {
        return userProjects;
    }
}
