package io.conduktor.demos.projectmanagement.service;

import io.conduktor.demos.projectmanagement.entity.User;
import io.conduktor.demos.projectmanagement.util.DatabaseUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

public class UserService {

    private EntityManager entityManager;

    public UserService() {
        this.entityManager = DatabaseUtil.getEntityManager();
    }

    public User registerUser(String name, String email, String password) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();

            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPassword(password); // In real app, hash this password
            user.setRole("MEMBER");

            entityManager.persist(user);
            transaction.commit();
            return user;
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        }
    }

    public User login(String email, String password) {
        try {
            User user = entityManager.createQuery(
                    "SELECT u FROM User u WHERE u.email = :email", User.class)
                    .setParameter("email", email)
                    .getSingleResult();

            // In real app, use password hashing
            if (password.equals(user.getPassword())) {
                return user;
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    public User getUserById(Long id) {
        return entityManager.find(User.class, id);
    }

    public User getUserByEmail(String email) {
        try {
            return entityManager.createQuery(
                    "SELECT u FROM User u WHERE u.email = :email", User.class)
                    .setParameter("email", email)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    public void updateUser(User user) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            entityManager.merge(user);
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        }
    }

    public java.util.List<User> getAllUsers() {
        try {
            System.out.println("UserService.getAllUsers() called");
            java.util.List<User> users = entityManager.createQuery("SELECT u FROM User u", User.class).getResultList();
            System.out.println("Query executed successfully, found " + users.size() + " users");
            return users;
        } catch (Exception e) {
            System.err.println("ERROR in getAllUsers(): " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public void deleteUser(Long id) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            User user = entityManager.find(User.class, id);
            if (user != null) {
                entityManager.remove(user);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        }
    }

    public void resetPassword(Long userId, String newPassword) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            User user = entityManager.find(User.class, userId);
            if (user != null) {
                user.setPassword(newPassword); // In real app, hash this
                entityManager.merge(user);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        }
    }
}