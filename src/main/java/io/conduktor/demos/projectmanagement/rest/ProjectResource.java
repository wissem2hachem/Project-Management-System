package io.conduktor.demos.projectmanagement.rest;

import io.conduktor.demos.projectmanagement.dto.CreateProjectRequest;
import io.conduktor.demos.projectmanagement.entity.Project;
import io.conduktor.demos.projectmanagement.entity.Task;
import io.conduktor.demos.projectmanagement.service.ProjectService;
import io.conduktor.demos.projectmanagement.service.TaskService;
import io.conduktor.demos.projectmanagement.util.DatabaseUtil;
import jakarta.persistence.EntityManager;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Path("/projects")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ProjectResource {

    private ProjectService projectService;
    private TaskService taskService;
    private EntityManager entityManager;

    public ProjectResource() {
        this.entityManager = DatabaseUtil.getEntityManager();
        this.projectService = new ProjectService(entityManager);
        this.taskService = new TaskService(entityManager);
    }

    @GET
    public Response getUserProjects(@QueryParam("userId") Long userId) {
        if (userId == null) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"User ID is required\"}").build();
        }

        try {
            List<Project> projects = projectService.getUserProjects(userId);
            return Response.ok(projects).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}").build();
        }
    }

    @POST
    public Response createProject(CreateProjectRequest request) {
        if (request.getName() == null || request.getName().trim().isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"Project name is required\"}").build();
        }
        if (request.getOwnerId() == null) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"Owner ID is required\"}").build();
        }

        try {
            Project project = projectService.createProjectFromJson(
                    request.getName(),
                    request.getDescription(),
                    request.getOwnerId(),
                    request.getDueDate(),
                    request.getStatus());

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Project created successfully");
            response.put("id", project.getId());
            response.put("project", project);

            return Response.status(Response.Status.CREATED).entity(response).build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}").build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Failed to create project: " + e.getMessage() + "\"}").build();
        }
    }

    @GET
    @Path("/{id}")
    public Response getProject(@PathParam("id") Long id) {
        try {
            Project project = projectService.getProjectById(id);
            if (project == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\": \"Project not found\"}").build();
            }
            return Response.ok(project).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}").build();
        }
    }

    @PUT
    @Path("/{id}")
    public Response updateProject(@PathParam("id") Long id, CreateProjectRequest request) {
        try {
            Project project = projectService.updateProject(
                    id,
                    request.getName(),
                    request.getDescription(),
                    request.getStatus(),
                    request.getDueDate());

            if (project == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\": \"Project not found\"}").build();
            }

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Project updated successfully");
            response.put("project", project);

            return Response.ok(response).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Failed to update project: " + e.getMessage() + "\"}").build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteProject(@PathParam("id") Long id) {
        try {
            projectService.deleteProject(id);
            return Response.ok("{\"message\": \"Project deleted successfully\"}").build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Failed to delete project: " + e.getMessage() + "\"}").build();
        }
    }

    @GET
    @Path("/{id}/tasks")
    public Response getProjectTasks(@PathParam("id") Long projectId) {
        try {
            List<Task> tasks = taskService.getProjectTasks(projectId);
            return Response.ok(tasks).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}").build();
        }
    }
}