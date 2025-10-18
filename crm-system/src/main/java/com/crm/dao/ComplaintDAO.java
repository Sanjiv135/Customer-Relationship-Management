package com.crm.dao;

import com.crm.model.Complaint;
import com.crm.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    
    public int getComplaintCountByEmployeeAndStatus(int employeeId, String status) {
        String sql = "SELECT COUNT(*) FROM complaints WHERE assigned_to = ? AND status = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, employeeId);
            stmt.setString(2, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            System.out.println("❌ Error getting complaint count by employee and status: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    
    public int getTotalAssignedComplaints(int employeeId) {
        String sql = "SELECT COUNT(*) FROM complaints WHERE assigned_to = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, employeeId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            System.out.println("❌ Error getting total assigned complaints: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    

    public boolean assignComplaint(int complaintId, int employeeId) {
        String sql = "UPDATE complaints SET assigned_to = ?, status = 'IN_PROGRESS', updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, employeeId);
            stmt.setInt(2, complaintId);
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("✅ ASSIGN COMPLAINT - Rows affected: " + rowsAffected + " for ID: " + complaintId + " to employee: " + employeeId);
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error assigning complaint: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    
    public boolean deleteComplaint(int complaintId) {
        String sql = "DELETE FROM complaints WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, complaintId);
            int rowsAffected = stmt.executeUpdate();
            System.out.println("✅ DELETE COMPLAINT - Rows affected: " + rowsAffected + " for ID: " + complaintId);
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error deleting complaint: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    
    public boolean updateComplaint(Complaint complaint) {
        String sql = "UPDATE complaints SET status = ?, assigned_to = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, complaint.getStatus());
            if (complaint.getAssignedTo() > 0) {
                stmt.setInt(2, complaint.getAssignedTo());
            } else {
                stmt.setNull(2, Types.INTEGER);
            }
            stmt.setInt(3, complaint.getId());
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("✅ UPDATE COMPLAINT - Rows affected: " + rowsAffected + " for ID: " + complaint.getId());
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error updating complaint: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    
    public boolean updateComplaintStatus(int complaintId, String status) {
        String sql = "UPDATE complaints SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, complaintId);

            int rowsAffected = stmt.executeUpdate();
            System.out.println("✅ UPDATE COMPLAINT STATUS - Rows affected: " + rowsAffected + " for ID: " + complaintId + ", Status: " + status);
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("❌ Error updating complaint status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    
    public boolean unassignComplaint(int complaintId) {
        String sql = "UPDATE complaints SET assigned_to = NULL, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, complaintId);
            int rowsAffected = stmt.executeUpdate();
            System.out.println("✅ UNASSIGN COMPLAINT - Rows affected: " + rowsAffected + " for ID: " + complaintId);
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error unassigning complaint: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    
    public List<Complaint> getComplaintsByStatus(String status) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT c.*, u.username AS customer_username, " +
                     "p.name AS product_name, " +
                     "CONCAT(e.first_name, ' ', e.last_name) AS assigned_employee_name " +
                     "FROM complaints c " +
                     "LEFT JOIN users u ON c.user_id = u.id " +
                     "LEFT JOIN products p ON c.product_id = p.id " +
                     "LEFT JOIN employees e ON c.assigned_to = e.id " +
                     "WHERE c.status = ? " +
                     "ORDER BY c.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapResultSetToComplaint(rs));
                }
            }

        } catch (SQLException e) {
            System.out.println("❌ Error getting complaints by status: " + e.getMessage());
            e.printStackTrace();
        }

        return complaints;
    }

    
    public List<Complaint> getComplaintsByPriority(String priority) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT c.*, u.username AS customer_username, " +
                     "p.name AS product_name, " +
                     "CONCAT(e.first_name, ' ', e.last_name) AS assigned_employee_name " +
                     "FROM complaints c " +
                     "LEFT JOIN users u ON c.user_id = u.id " +
                     "LEFT JOIN products p ON c.product_id = p.id " +
                     "LEFT JOIN employees e ON c.assigned_to = e.id " +
                     "WHERE c.priority = ? " +
                     "ORDER BY c.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, priority);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapResultSetToComplaint(rs));
                }
            }

        } catch (SQLException e) {
            System.out.println("❌ Error getting complaints by priority: " + e.getMessage());
            e.printStackTrace();
        }

        return complaints;
    }

    
    public java.util.Map<String, Integer> getComplaintStatistics() {
        java.util.Map<String, Integer> stats = new java.util.HashMap<>();
        String sql = "SELECT status, COUNT(*) as count FROM complaints GROUP BY status";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                stats.put(rs.getString("status"), rs.getInt("count"));
            }

        } catch (SQLException e) {
            System.out.println("❌ Error getting complaint statistics: " + e.getMessage());
            e.printStackTrace();
        }

        return stats;
    }

    
    public List<Complaint> getAllComplaints() {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT c.*, u.username AS customer_username, " +
                     "p.name AS product_name, " +
                     "CONCAT(e.first_name, ' ', e.last_name) AS assigned_employee_name " +
                     "FROM complaints c " +
                     "LEFT JOIN users u ON c.user_id = u.id " +
                     "LEFT JOIN products p ON c.product_id = p.id " +
                     "LEFT JOIN employees e ON c.assigned_to = e.id " +
                     "ORDER BY c.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                complaints.add(mapResultSetToComplaint(rs));
            }
            
            System.out.println("✅ GET ALL COMPLAINTS - Found " + complaints.size() + " complaints");

        } catch (SQLException e) {
            System.out.println("❌ Error getting all complaints: " + e.getMessage());
            e.printStackTrace();
        }

        return complaints;
    }

    
    public List<Complaint> getComplaintsByUserId(int userId) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT c.*, u.username AS customer_username, " +
                     "p.name AS product_name, " +
                     "CONCAT(e.first_name, ' ', e.last_name) AS assigned_employee_name " +
                     "FROM complaints c " +
                     "LEFT JOIN users u ON c.user_id = u.id " +
                     "LEFT JOIN products p ON c.product_id = p.id " +
                     "LEFT JOIN employees e ON c.assigned_to = e.id " +
                     "WHERE c.user_id = ? " +
                     "ORDER BY c.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapResultSetToComplaint(rs));
                }
            }
            
            System.out.println("✅ GET COMPLAINTS BY USER ID - Found " + complaints.size() + " complaints for user: " + userId);

        } catch (SQLException e) {
            System.out.println("❌ Error getting complaints by user ID: " + e.getMessage());
            e.printStackTrace();
        }

        return complaints;
    }

    
    public List<Complaint> getComplaintsByEmployeeId(int employeeId) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT c.*, u.username AS customer_username, " +
                     "p.name AS product_name, " +
                     "CONCAT(e.first_name, ' ', e.last_name) AS assigned_employee_name " +
                     "FROM complaints c " +
                     "LEFT JOIN users u ON c.user_id = u.id " +
                     "LEFT JOIN products p ON c.product_id = p.id " +
                     "LEFT JOIN employees e ON c.assigned_to = e.id " +
                     "WHERE c.assigned_to = ? " +
                     "ORDER BY c.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, employeeId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapResultSetToComplaint(rs));
                }
            }
            
            System.out.println("✅ GET COMPLAINTS BY EMPLOYEE ID - Found " + complaints.size() + " complaints for employee: " + employeeId);

        } catch (SQLException e) {
            System.out.println("❌ Error getting complaints by employee ID: " + e.getMessage());
            e.printStackTrace();
        }

        return complaints;
    }

    
    public boolean addComplaint(Complaint complaint) {
        String sql = "INSERT INTO complaints (user_id, product_id, title, description, status, priority, attachment_path, original_file_name) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, complaint.getUserId());
            if (complaint.getProductId() > 0) {
                stmt.setInt(2, complaint.getProductId());
            } else {
                stmt.setNull(2, Types.INTEGER);
            }
            stmt.setString(3, complaint.getTitle());
            stmt.setString(4, complaint.getDescription());
            stmt.setString(5, complaint.getStatus());
            stmt.setString(6, complaint.getPriority());
            stmt.setString(7, complaint.getAttachmentPath());
            stmt.setString(8, complaint.getOriginalFileName());

            boolean success = stmt.executeUpdate() > 0;
            System.out.println("✅ ADD COMPLAINT - Success: " + success + " for title: " + complaint.getTitle());
            return success;

        } catch (SQLException e) {
            System.out.println("❌ Error adding complaint: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    
    public Complaint getComplaintById(int id) {
        Complaint complaint = null;
        String sql = "SELECT c.*, u.username AS customer_username, " +
                     "p.name AS product_name, " +
                     "CONCAT(e.first_name, ' ', e.last_name) AS assigned_employee_name " +
                     "FROM complaints c " +
                     "LEFT JOIN users u ON c.user_id = u.id " +
                     "LEFT JOIN products p ON c.product_id = p.id " +
                     "LEFT JOIN employees e ON c.assigned_to = e.id " +
                     "WHERE c.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    complaint = mapResultSetToComplaint(rs);
                    System.out.println("✅ GET COMPLAINT BY ID - Found complaint: " + complaint.getTitle() + " for ID: " + id);
                } else {
                    System.out.println("❌ GET COMPLAINT BY ID - No complaint found for ID: " + id);
                }
            }

        } catch (SQLException e) {
            System.out.println("❌ Error getting complaint by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return complaint;
    }

    
    public boolean updateComplaintDetails(Complaint complaint) {
        String sql = "UPDATE complaints SET title = ?, description = ?, status = ?, priority = ?, " +
                     "assigned_to = ?, product_id = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, complaint.getTitle());
            stmt.setString(2, complaint.getDescription());
            stmt.setString(3, complaint.getStatus());
            stmt.setString(4, complaint.getPriority());
            if (complaint.getAssignedTo() > 0) {
                stmt.setInt(5, complaint.getAssignedTo());
            } else {
                stmt.setNull(5, Types.INTEGER);
            }
            if (complaint.getProductId() > 0) {
                stmt.setInt(6, complaint.getProductId());
            } else {
                stmt.setNull(6, Types.INTEGER);
            }
            stmt.setInt(7, complaint.getId());
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("✅ UPDATE COMPLAINT DETAILS - Rows affected: " + rowsAffected + " for ID: " + complaint.getId());
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error updating complaint details: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    
    public List<Complaint> searchComplaints(String keyword) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT c.*, u.username AS customer_username, " +
                     "p.name AS product_name, " +
                     "CONCAT(e.first_name, ' ', e.last_name) AS assigned_employee_name " +
                     "FROM complaints c " +
                     "LEFT JOIN users u ON c.user_id = u.id " +
                     "LEFT JOIN products p ON c.product_id = p.id " +
                     "LEFT JOIN employees e ON c.assigned_to = e.id " +
                     "WHERE c.title LIKE ? OR c.description LIKE ? " +
                     "ORDER BY c.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchTerm = "%" + keyword + "%";
            stmt.setString(1, searchTerm);
            stmt.setString(2, searchTerm);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapResultSetToComplaint(rs));
                }
            }
            
            System.out.println("✅ SEARCH COMPLAINTS - Found " + complaints.size() + " complaints for keyword: " + keyword);

        } catch (SQLException e) {
            System.out.println("❌ Error searching complaints: " + e.getMessage());
            e.printStackTrace();
        }

        return complaints;
    }

    
    private Complaint mapResultSetToComplaint(ResultSet rs) throws SQLException {
        Complaint complaint = new Complaint();
        complaint.setId(rs.getInt("id"));
        complaint.setUserId(rs.getInt("user_id"));
        complaint.setProductId(rs.getInt("product_id"));
        complaint.setTitle(rs.getString("title"));
        complaint.setDescription(rs.getString("description"));
        complaint.setStatus(rs.getString("status"));
        complaint.setPriority(rs.getString("priority"));
        complaint.setAssignedTo(rs.getInt("assigned_to"));
        complaint.setCreatedAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        complaint.setUpdatedAt(rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null);
        
        complaint.setUserName(rs.getString("customer_username"));
        complaint.setProductName(rs.getString("product_name"));
        complaint.setAssignedEmployeeName(rs.getString("assigned_employee_name"));
        complaint.setAttachmentPath(rs.getString("attachment_path"));
        complaint.setOriginalFileName(rs.getString("original_file_name"));
        
        return complaint;
    }

    
    public List<Complaint> getRecentComplaints(int limit) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT c.*, u.username AS customer_username, " +
                     "p.name AS product_name, " +
                     "CONCAT(e.first_name, ' ', e.last_name) AS assigned_employee_name " +
                     "FROM complaints c " +
                     "LEFT JOIN users u ON c.user_id = u.id " +
                     "LEFT JOIN products p ON c.product_id = p.id " +
                     "LEFT JOIN employees e ON c.assigned_to = e.id " +
                     "ORDER BY c.created_at DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapResultSetToComplaint(rs));
                }
            }
            
            System.out.println("✅ GET RECENT COMPLAINTS - Found " + complaints.size() + " complaints");

        } catch (SQLException e) {
            System.out.println("❌ Error getting recent complaints: " + e.getMessage());
            e.printStackTrace();
        }

        return complaints;
    }

   
    public boolean isComplaintAssignedToEmployee(int complaintId, int employeeId) {
        String sql = "SELECT COUNT(*) FROM complaints WHERE id = ? AND assigned_to = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, complaintId);
            stmt.setInt(2, employeeId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            System.out.println("❌ Error checking complaint assignment: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }
}