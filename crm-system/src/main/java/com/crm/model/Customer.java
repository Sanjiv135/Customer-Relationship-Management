package com.crm.model;

import java.time.LocalDateTime;

public class Customer {
    private int id;
    private int userId;
    private String firstName;
    private String lastName;
    private String phone;
    private String address;
    private String company;
    private String username;
    private String email;
    private LocalDateTime createdAt; 
    
    
    public Customer() {}
    
    public Customer(int userId, String firstName, String lastName, String phone, String address, String company) {
        this.userId = userId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.phone = phone;
        this.address = address;
        this.company = company;
    }
    
    
    public int getId() { 
        return id; 
    }
    
    public void setId(int id) { 
        this.id = id; 
    }
    
    public int getUserId() { 
        return userId; 
    }
    
    public void setUserId(int userId) { 
        this.userId = userId; 
    }
    
    public String getFirstName() { 
        return firstName; 
    }
    
    public void setFirstName(String firstName) { 
        this.firstName = firstName; 
    }
    
    public String getLastName() { 
        return lastName; 
    }
    
    public void setLastName(String lastName) { 
        this.lastName = lastName; 
    }
    
    public String getPhone() { 
        return phone; 
    }
    
    public void setPhone(String phone) { 
        this.phone = phone; 
    }
    
    public String getAddress() { 
        return address; 
    }
    
    public void setAddress(String address) { 
        this.address = address; 
    }
    
    public String getCompany() { 
        return company; 
    }
    
    public void setCompany(String company) { 
        this.company = company; 
    }
    
    public String getUsername() { 
        return username; 
    }
    
    public void setUsername(String username) { 
        this.username = username; 
    }
    
    public String getEmail() { 
        return email; 
    }
    
    public void setEmail(String email) { 
        this.email = email; 
    }
    
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    
    public String getFullName() {
        return firstName + " " + lastName;
    }
}