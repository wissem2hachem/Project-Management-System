package io.conduktor.demos.projectmanagement.service;

import io.conduktor.demos.projectmanagement.entity.Project;
import io.conduktor.demos.projectmanagement.entity.Task;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Transactional
public class DashboardService {

        @PersistenceContext
        private EntityManager entityManager;

        public DashboardService() {
                this.entityManager = io.conduktor.demos.projectmanagement.util.DatabaseUtil.getEntityManager();
        }

        public DashboardService(EntityManager entityManager) {
                this.entityManager = entityManager;
        }

        public Map<String, Object> getDashboardStats(Long userId) {
                Map<String, Object> stats = new HashMap<>();

                // Total projects
                Long totalProjects = entityManager.createQuery(
                                "SELECT COUNT(DISTINCT p) FROM Project p LEFT JOIN p.members m " +
                                                "WHERE p.owner.id = :userId OR m.user.id = :userId",
                                Long.class)
                                .setParameter("userId", userId)
                                .getSingleResult();
                stats.put("totalProjects", totalProjects);

                // Pending tasks
                Long pendingTasks = entityManager.createQuery(
                                "SELECT COUNT(t) FROM Task t WHERE t.assignee.id = :userId " +
                                                "AND t.status != 'DONE'",
                                Long.class)
                                .setParameter("userId", userId)
                                .getSingleResult();
                stats.put("pendingTasks", pendingTasks);

                // Completed tasks
                Long completedTasks = entityManager.createQuery(
                                "SELECT COUNT(t) FROM Task t WHERE t.assignee.id = :userId " +
                                                "AND t.status = 'DONE'",
                                Long.class)
                                .setParameter("userId", userId)
                                .getSingleResult();
                stats.put("completedTasks", completedTasks);

                // Team members count (distinct users across all user's projects)
                Long teamMembers = entityManager.createQuery(
                                "SELECT COUNT(DISTINCT pm.user.id) FROM ProjectMember pm " +
                                                "WHERE pm.project.id IN " +
                                                "(SELECT DISTINCT p.id FROM Project p LEFT JOIN p.members m " +
                                                "WHERE p.owner.id = :userId OR m.user.id = :userId)",
                                Long.class)
                                .setParameter("userId", userId)
                                .getSingleResult();
                stats.put("teamMembers", teamMembers);

                // Recent projects
                List<Project> recentProjects = entityManager.createQuery(
                                "SELECT DISTINCT p FROM Project p LEFT JOIN p.members m " +
                                                "WHERE p.owner.id = :userId OR m.user.id = :userId " +
                                                "ORDER BY p.createdDate DESC",
                                Project.class)
                                .setParameter("userId", userId)
                                .setMaxResults(5)
                                .getResultList();
                stats.put("recentProjects", recentProjects);

                // Recent tasks
                List<Task> recentTasks = entityManager.createQuery(
                                "SELECT t FROM Task t WHERE t.assignee.id = :userId " +
                                                "ORDER BY t.createdDate DESC",
                                Task.class)
                                .setParameter("userId", userId)
                                .setMaxResults(10)
                                .getResultList();
                stats.put("recentTasks", recentTasks);

                return stats;
        }
}