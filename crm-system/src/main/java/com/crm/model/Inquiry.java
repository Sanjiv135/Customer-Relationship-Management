package com.crm.model;

import java.time.LocalDateTime;

public class Inquiry {
    private int id;
    private int userId;
    private String subject;
    private String message;
    private String response;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String userName;
    
    
    public Inquiry() {}
    
    public Inquiry(int id, int userId, String subject, String message, String response, 
                   String status, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.userId = userId;
        this.subject = subject;
        this.message = message;
        this.response = response;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
   
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public String getResponse() { return response; }
    public void setResponse(String response) { this.response = response; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
}