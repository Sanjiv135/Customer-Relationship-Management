package com.crm.dao;

import com.crm.model.AuditLog;
import com.crm.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuditLogDAO {
    
    public void logAction(AuditLog auditLog) {
        String sql = "INSERT INTO audit_logs (user_id, action, description, ip_address, timestamp) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, auditLog.getUserId());
            stmt.setString(2, auditLog.getAction());
            stmt.setString(3, auditLog.getDescription());
            stmt.setString(4, auditLog.getIpAddress());
            stmt.setTimestamp(5, Timestamp.valueOf(auditLog.getTimestamp()));
            
            stmt.executeUpdate();
            
        } catch (SQLException e) {
            System.err.println("Failed to log audit action: " + e.getMessage());
        }
    }
    
    public List<AuditLog> getLogsByUserId(int userId) {
        List<AuditLog> logs = new ArrayList<>();
        String sql = "SELECT al.*, u.username FROM audit_logs al JOIN users u ON al.user_id = u.id WHERE al.user_id = ? ORDER BY al.timestamp DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                AuditLog log = new AuditLog();
                log.setId(rs.getInt("id"));
                log.setUserId(rs.getInt("user_id"));
                log.setAction(rs.getString("action"));
                log.setDescription(rs.getString("description"));
                log.setIpAddress(rs.getString("ip_address"));
                log.setTimestamp(rs.getTimestamp("timestamp").toLocalDateTime());
                logs.add(log);
            }
            
        } catch (SQLException e) {
            System.err.println("Failed to get audit logs: " + e.getMessage());
        }
        
        return logs;
    }
}