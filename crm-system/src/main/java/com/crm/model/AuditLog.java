package com.crm.model;

import java.time.LocalDateTime;

public class AuditLog {
    private int id;
    private int userId;
    private String action;
    private String description;
    private String ipAddress;
    private LocalDateTime timestamp;
    
    
    public AuditLog() {}

    public AuditLog(int userId, String action, String description, String ipAddress) {
        this.userId = userId;
        this.action = action;
        this.description = description;
        this.ipAddress = ipAddress;
        this.timestamp = LocalDateTime.now();
    }
    
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
}
