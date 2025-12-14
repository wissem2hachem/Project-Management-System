package io.conduktor.demos.projectmanagement.service;

import io.conduktor.demos.projectmanagement.entity.Notification;
import io.conduktor.demos.projectmanagement.entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;

import java.util.List;

@Transactional
public class NotificationService {

    @PersistenceContext
    private EntityManager entityManager;

    public NotificationService() {
    }

    public NotificationService(EntityManager entityManager) {
        this.entityManager = entityManager;
    }

    public void createNotification(User user, String message, String type, Long referenceId) {
        // Don't notify if user is null
        if (user == null)
            return;

        boolean transactionActive = entityManager.getTransaction().isActive();
        if (!transactionActive) {
            entityManager.getTransaction().begin();
        }

        try {
            Notification notification = new Notification(user, message, type, referenceId);
            entityManager.persist(notification);

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

    public List<Notification> getUserNotifications(Long userId) {
        return entityManager.createQuery(
                "SELECT n FROM Notification n WHERE n.user.id = :userId ORDER BY n.createdDate DESC",
                Notification.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    public List<Notification> getUnreadNotifications(Long userId) {
        return entityManager.createQuery(
                "SELECT n FROM Notification n WHERE n.user.id = :userId AND n.isRead = false ORDER BY n.createdDate DESC",
                Notification.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    public long getUnreadCount(Long userId) {
        return entityManager.createQuery(
                "SELECT COUNT(n) FROM Notification n WHERE n.user.id = :userId AND n.isRead = false", Long.class)
                .setParameter("userId", userId)
                .getSingleResult();
    }

    public void markAsRead(Long notificationId) {
        boolean transactionActive = entityManager.getTransaction().isActive();
        if (!transactionActive) {
            entityManager.getTransaction().begin();
        }

        try {
            Notification notification = entityManager.find(Notification.class, notificationId);
            if (notification != null) {
                notification.setRead(true);
                entityManager.merge(notification);
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

    public void markAllAsRead(Long userId) {
        boolean transactionActive = entityManager.getTransaction().isActive();
        if (!transactionActive) {
            entityManager.getTransaction().begin();
        }

        try {
            entityManager.createQuery("UPDATE Notification n SET n.isRead = true WHERE n.user.id = :userId")
                    .setParameter("userId", userId)
                    .executeUpdate();

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
}
