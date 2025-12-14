package io.conduktor.demos.projectmanagement.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "notifications")
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private String message;

    @Column(nullable = false)
    private String type; // INFO, ASSIGNMENT, COMMENT, SYSTEM

    @Column(name = "is_read", nullable = false)
    private boolean isRead = false;

    @Column(name = "created_date", nullable = false)
    private LocalDateTime createdDate;

    // Link to related entity (optional, e.g., task ID)
    @Column(name = "reference_id")
    private Long referenceId;

    public Notification() {
        this.createdDate = LocalDateTime.now();
    }

    public Notification(User user, String message, String type, Long referenceId) {
        this();
        this.user = user;
        this.message = message;
        this.type = type;
        this.referenceId = referenceId;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public Long getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(Long referenceId) {
        this.referenceId = referenceId;
    }
}
