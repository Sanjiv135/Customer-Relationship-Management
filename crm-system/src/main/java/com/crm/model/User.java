package com.crm.model;

import java.util.Date;
import java.sql.Timestamp;  // ADD THIS IMPORT
import java.text.SimpleDateFormat;

public class User {
    private int id;
    private String username;
    private String email;
    private String password;
    private String phone;
    private String role;
    private boolean tempPassword;
    private boolean active;
    private Timestamp createdAt;  
    
    
    public User() {}
    
    public User(String username, String email, String password, String role) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.role = role;
        this.tempPassword = false;
        this.active = true;
        this.createdAt = new Timestamp(System.currentTimeMillis());  
    }
    
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public boolean isTempPassword() { return tempPassword; }
    public void setTempPassword(boolean tempPassword) { this.tempPassword = tempPassword; }
    
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }  
    
    
    public String getCreatedAtFormatted() {
        if (createdAt != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            return sdf.format(createdAt);
        }
        return "N/A";
    }
    
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", tempPassword=" + tempPassword +
                ", active=" + active +
                '}';
    }
}