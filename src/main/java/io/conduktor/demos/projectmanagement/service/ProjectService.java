package io.conduktor.demos.projectmanagement.service;

import io.conduktor.demos.projectmanagement.entity.Project;
import io.conduktor.demos.projectmanagement.entity.ProjectMember;
import io.conduktor.demos.projectmanagement.entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.List;

@Transactional
public class ProjectService {

    @PersistenceContext
    private EntityManager entityManager;

    public ProjectService() {
    }

    public ProjectService(EntityManager entityManager) {
        this.entityManager = entityManager;
    }

    public Project createProject(String name, String description, User owner) {
        try {
            entityManager.getTransaction().begin();
            Project project = new Project();
            project.setName(name);
            project.setDescription(description);
            project.setOwner(owner);
            project.setStatus("PLANNING");
            entityManager.persist(project);

            // Add owner as manager
            addMember(project, owner, "MANAGER");

            entityManager.getTransaction().commit();
            return project;
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            throw e;
        }
    }

    public void addMember(Project project, User user, String role) {
        boolean transactionActive = entityManager.getTransaction().isActive();
        if (!transactionActive) {
            entityManager.getTransaction().begin();
        }
        try {
            ProjectMember member = new ProjectMember(project, user, role);
            entityManager.persist(member);
            if (!transactionActive) {
                entityManager.getTransaction().commit();
            }
        } catch (Exception e) {
            if (!transactionActive && entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            throw e;
        }
    }

    public List<Project> getUserProjects(Long userId) {
        return entityManager.createQuery(
                "SELECT DISTINCT p FROM Project p LEFT JOIN p.members m " +
                        "WHERE p.owner.id = :userId OR m.user.id = :userId",
                Project.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    public Project getProjectById(Long id) {
        return entityManager.find(Project.class, id);
    }

    public List<ProjectMember> getProjectMembers(Long projectId) {
        return entityManager.createQuery(
                "SELECT pm FROM ProjectMember pm WHERE pm.project.id = :projectId", ProjectMember.class)
                .setParameter("projectId", projectId)
                .getResultList();
    }

    public Project updateProject(Long id, String name, String description, String status, LocalDateTime dueDate) {
        boolean transactionActive = entityManager.getTransaction().isActive();
        if (!transactionActive) {
            entityManager.getTransaction().begin();
        }
        try {
            Project project = entityManager.find(Project.class, id);
            if (project != null) {
                if (name != null)
                    project.setName(name);
                if (description != null)
                    project.setDescription(description);
                if (status != null)
                    project.setStatus(status);
                if (dueDate != null)
                    project.setDueDate(dueDate);
                entityManager.merge(project);
            }
            if (!transactionActive) {
                entityManager.getTransaction().commit();
            }
            return project;
        } catch (Exception e) {
            if (!transactionActive && entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            throw e;
        }
    }

    public void deleteProject(Long id) {
        boolean transactionActive = entityManager.getTransaction().isActive();
        if (!transactionActive) {
            entityManager.getTransaction().begin();
        }
        try {
            Project project = entityManager.find(Project.class, id);
            if (project != null) {
                entityManager.remove(project);
            }
            if (!transactionActive) {
                entityManager.getTransaction().commit();
            }
        } catch (Exception e) {
            if (!transactionActive && entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            throw e;
        }
    }

    public Project createProjectFromJson(String name, String description, Long ownerId, LocalDateTime dueDate,
            String status) {
        User owner = entityManager.find(User.class, ownerId);
        if (owner == null) {
            throw new IllegalArgumentException("Owner not found with id: " + ownerId);
        }

        Project project = createProject(name, description, owner);
        if (dueDate != null) {
            project.setDueDate(dueDate);
        }
        if (status != null) {
            project.setStatus(status);
        }
        return project;
    }
}