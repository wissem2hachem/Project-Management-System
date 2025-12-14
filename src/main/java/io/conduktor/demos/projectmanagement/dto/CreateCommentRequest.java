package io.conduktor.demos.projectmanagement.dto;

public class CreateCommentRequest {
    private String content;
    private Long authorId;

    public CreateCommentRequest() {
    }

    // Getters and Setters
    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Long getAuthorId() {
        return authorId;
    }

    public void setAuthorId(Long authorId) {
        this.authorId = authorId;
    }
}
