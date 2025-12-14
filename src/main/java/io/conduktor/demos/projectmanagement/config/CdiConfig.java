package io.conduktor.demos.projectmanagement.config;

import io.conduktor.demos.projectmanagement.service.ProjectService;
import io.conduktor.demos.projectmanagement.service.TaskService;
import io.conduktor.demos.projectmanagement.service.UserService;
import io.conduktor.demos.projectmanagement.util.DatabaseUtil;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.context.RequestScoped;
import jakarta.enterprise.inject.Produces;
import jakarta.persistence.EntityManager;

@ApplicationScoped
public class CdiConfig {

    @Produces
    @RequestScoped
    public EntityManager createEntityManager() {
        return DatabaseUtil.getEntityManager();
    }

    public void closeEntityManager(@jakarta.enterprise.inject.Disposes EntityManager em) {
        if (em.isOpen()) {
            em.close();
        }
    }

    @Produces
    @RequestScoped
    public ProjectService createProjectService(EntityManager em) {
        return new ProjectService(em);
    }

    @Produces
    @RequestScoped
    public TaskService createTaskService(EntityManager em) {
        return new TaskService(em);
    }

    @Produces
    @RequestScoped
    public UserService createUserService() {
        return new UserService();
    }
}
