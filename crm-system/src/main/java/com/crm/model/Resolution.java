package com.crm.model;

import java.time.LocalDateTime;

public class Resolution {
    private int id;
    private int complaintId;
    private int resolvedBy;
    private String resolutionText;
    private LocalDateTime resolvedAt;
    private String resolvedByName;
    
    
    public Resolution() {}
    
    public Resolution(int id, int complaintId, int resolvedBy, String resolutionText, LocalDateTime resolvedAt) {
        this.id = id;
        this.complaintId = complaintId;
        this.resolvedBy = resolvedBy;
        this.resolutionText = resolutionText;
        this.resolvedAt = resolvedAt;
    }
    
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getComplaintId() { return complaintId; }
    public void setComplaintId(int complaintId) { this.complaintId = complaintId; }
    
    public int getResolvedBy() { return resolvedBy; }
    public void setResolvedBy(int resolvedBy) { this.resolvedBy = resolvedBy; }
    
    public String getResolutionText() { return resolutionText; }
    public void setResolutionText(String resolutionText) { this.resolutionText = resolutionText; }
    
    public LocalDateTime getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(LocalDateTime resolvedAt) { this.resolvedAt = resolvedAt; }
    
    public String getResolvedByName() { return resolvedByName; }
    public void setResolvedByName(String resolvedByName) { this.resolvedByName = resolvedByName; }
}