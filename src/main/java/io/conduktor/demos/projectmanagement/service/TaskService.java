package io.conduktor.demos.projectmanagement.service;

import io.conduktor.demos.projectmanagement.entity.Project;
import io.conduktor.demos.projectmanagement.entity.Task;
import io.conduktor.demos.projectmanagement.entity.TaskComment;
import io.conduktor.demos.projectmanagement.entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Transactional
public class TaskService {

    @PersistenceContext
    private EntityManager entityManager;

    public TaskService() {
    }

    public TaskService(EntityManager entityManager) {
        this.entityManager = entityManager;
    }

    public Task createTaskFromJson(String title, String description, Long projectId, Long assigneeId, String priority,
            String status, LocalDateTime dueDate) {
        Project project = entityManager.find(Project.class, projectId);
        if (project == null) {
            throw new IllegalArgumentException("Project not found with id: " + projectId);
        }

        Task task = new Task();
        task.setTitle(title);
        task.setDescription(description);
        task.setProject(project);

        if (assigneeId != null) {
            User assignee = entityManager.find(User.class, assigneeId);
            if (assignee != null) {
                task.setAssignee(assignee);
            }
        }

        if (priority != null) {
            task.setPriority(priority);
        }

        if (status != null) {
            task.setStatus(status);
        }

        if (dueDate != null) {
            task.setDueDate(dueDate);
        }

        entityManager.getTransaction().begin();
        try {
            entityManager.persist(task);
            entityManager.getTransaction().commit();
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            throw e;
        }

        return task;
    }

    // New method for TaskServlet
    public Task createTask(String title, String description, Project project, User assignee) {
        Task task = new Task();
        task.setTitle(title);
        task.setDescription(description);
        task.setProject(project);
        task.setAssignee(assignee);
        task.setStatus("TODO");
        task.setPriority("MEDIUM");

        entityManager.getTransaction().begin();
        try {
            entityManager.persist(task);
            entityManager.getTransaction().commit();
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            throw e;
        }
        return task;
    }

    public Task getTaskById(Long id) {
        return entityManager.find(Task.class, id);
    }

    public Task updateTask(Long id, String title, String description, String status, String priority, Long assigneeId,
            LocalDateTime dueDate) {
        entityManager.getTransaction().begin();
        try {
            Task task = entityManager.find(Task.class, id);
            if (task != null) {
                if (title != null)
                    task.setTitle(title);
                if (description != null)
                    task.setDescription(description);
                if (status != null)
                    task.setStatus(status);
                if (priority != null)
                    task.setPriority(priority);
                if (dueDate != null)
                    task.setDueDate(dueDate);

                if (assigneeId != null) {
                    User assignee = entityManager.find(User.class, assigneeId);
                    if (assignee != null) {
                        task.setAssignee(assignee);
                    }
                }

                entityManager.merge(task);
            }
            entityManager.getTransaction().commit();
            return task;
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            throw e;
        }
    }

    // New method for TaskServlet
    public Task updateTaskStatus(Long id, String status) {
        entityManager.getTransaction().begin();
        try {
            Task task = entityManager.find(Task.class, id);
            if (task != null) {
                task.setStatus(status);
                entityManager.merge(task);
            }
            entityManager.getTransaction().commit();
            return task;
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            throw e;
        }
    }

    public void deleteTask(Long id) {
        entityManager.getTransaction().begin();
        try {
            Task task = entityManager.find(Task.class, id);
            if (task != null) {
                entityManager.remove(task);
            }
            entityManager.getTransaction().commit();
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            throw e;
        }
    }

    public List<Task> getUserTasks(Long userId) {
        return entityManager.createQuery(
                "SELECT t FROM Task t WHERE t.assignee.id = :userId", Task.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    // New method for ProjectServlet/ProjectResource
    public List<Task> getProjectTasks(Long projectId) {
        return entityManager.createQuery(
                "SELECT t FROM Task t WHERE t.project.id = :projectId", Task.class)
                .setParameter("projectId", projectId)
                .getResultList();
    }

    public List<Task> getTasksByStatus(Long userId, String status) {
        return entityManager.createQuery(
                "SELECT t FROM Task t WHERE t.assignee.id = :userId AND t.status = :status", Task.class)
                .setParameter("userId", userId)
                .setParameter("status", status)
                .getResultList();
    }

    public List<TaskComment> getTaskComments(Long taskId) {
        return entityManager.createQuery(
                "SELECT c FROM TaskComment c WHERE c.task.id = :taskId ORDER BY c.createdDate DESC", TaskComment.class)
                .setParameter("taskId", taskId)
                .getResultList();
    }

    public TaskComment addComment(Long taskId, User author, String content) {
        entityManager.getTransaction().begin();
        try {
            Task task = entityManager.find(Task.class, taskId);
            if (task == null) {
                entityManager.getTransaction().rollback();
                return null;
            }

            TaskComment comment = new TaskComment(task, author, content);
            entityManager.persist(comment);
            entityManager.getTransaction().commit();
            return comment;
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            throw e;
        }
    }
}
