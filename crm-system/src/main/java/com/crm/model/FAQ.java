package com.crm.model;

import java.time.LocalDateTime;

public class FAQ {
    private int id;
    private String question;
    private String answer;
    private String category;
    private int createdBy;
    private LocalDateTime createdAt;
    private String createdByName;
    
    
    public FAQ() {}
    
    public FAQ(int id, String question, String answer, String category, int createdBy, LocalDateTime createdAt) {
        this.id = id;
        this.question = question;
        this.answer = answer;
        this.category = category;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
    }
    
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getQuestion() { return question; }
    public void setQuestion(String question) { this.question = question; }
    
    public String getAnswer() { return answer; }
    public void setAnswer(String answer) { this.answer = answer; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }
}