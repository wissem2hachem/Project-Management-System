package io.conduktor.demos.projectmanagement.rest;

import io.conduktor.demos.projectmanagement.dto.CreateCommentRequest;
import io.conduktor.demos.projectmanagement.dto.CreateTaskRequest;
import io.conduktor.demos.projectmanagement.entity.Task;
import io.conduktor.demos.projectmanagement.entity.TaskComment;
import io.conduktor.demos.projectmanagement.service.TaskService;
import io.conduktor.demos.projectmanagement.util.DatabaseUtil;
import jakarta.persistence.EntityManager;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Path("/tasks")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class TaskResource {

    private TaskService taskService;
    private EntityManager entityManager;

    public TaskResource() {
        this.entityManager = DatabaseUtil.getEntityManager();
        this.taskService = new TaskService(entityManager);
    }

    @POST
    public Response createTask(CreateTaskRequest request) {
        if (request.getTitle() == null || request.getTitle().trim().isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"Task title is required\"}").build();
        }
        if (request.getProjectId() == null) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"Project ID is required\"}").build();
        }

        try {
            Task task = taskService.createTaskFromJson(
                    request.getTitle(),
                    request.getDescription(),
                    request.getProjectId(),
                    request.getAssigneeId(),
                    request.getPriority(),
                    request.getStatus(),
                    request.getDueDate());

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Task created successfully");
            response.put("id", task.getId());
            response.put("task", task);

            return Response.status(Response.Status.CREATED).entity(response).build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}").build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Failed to create task: " + e.getMessage() + "\"}").build();
        }
    }

    @GET
    @Path("/{id}")
    public Response getTask(@PathParam("id") Long id) {
        try {
            Task task = taskService.getTaskById(id);
            if (task == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\": \"Task not found\"}").build();
            }
            return Response.ok(task).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}").build();
        }
    }

    @PUT
    @Path("/{id}")
    public Response updateTask(@PathParam("id") Long id, CreateTaskRequest request) {
        try {
            Task task = taskService.updateTask(
                    id,
                    request.getTitle(),
                    request.getDescription(),
                    request.getStatus(),
                    request.getPriority(),
                    request.getAssigneeId(),
                    request.getDueDate());

            if (task == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\": \"Task not found\"}").build();
            }

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Task updated successfully");
            response.put("task", task);

            return Response.ok(response).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Failed to update task: " + e.getMessage() + "\"}").build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteTask(@PathParam("id") Long id) {
        try {
            taskService.deleteTask(id);
            return Response.ok("{\"message\": \"Task deleted successfully\"}").build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Failed to delete task: " + e.getMessage() + "\"}").build();
        }
    }

    @GET
    @Path("/{id}/comments")
    public Response getTaskComments(@PathParam("id") Long taskId) {
        try {
            List<TaskComment> comments = taskService.getTaskComments(taskId);
            return Response.ok(comments).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}").build();
        }
    }

    @POST
    @Path("/{id}/comments")
    public Response addComment(@PathParam("id") Long taskId, CreateCommentRequest request) {
        if (request.getContent() == null || request.getContent().trim().isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"Comment content is required\"}").build();
        }
        if (request.getAuthorId() == null) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"Author ID is required\"}").build();
        }

        try {
            // Get the author user
            io.conduktor.demos.projectmanagement.entity.User author = entityManager
                    .find(io.conduktor.demos.projectmanagement.entity.User.class, request.getAuthorId());

            if (author == null) {
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity("{\"error\": \"Author not found\"}").build();
            }

            TaskComment comment = taskService.addComment(taskId, author, request.getContent());

            if (comment == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\": \"Task not found\"}").build();
            }

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Comment added successfully");
            response.put("comment", comment);

            return Response.status(Response.Status.CREATED).entity(response).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Failed to add comment: " + e.getMessage() + "\"}").build();
        }
    }
}