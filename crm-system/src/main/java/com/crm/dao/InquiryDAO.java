package com.crm.dao;

import com.crm.model.Inquiry;
import com.crm.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InquiryDAO {

    
    public List<Inquiry> getAllInquiries() {
        List<Inquiry> inquiries = new ArrayList<>();
        String sql = "SELECT i.*, u.username as user_name FROM inquiries i " +
                     "LEFT JOIN users u ON i.user_id = u.id " +
                     "ORDER BY i.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Inquiry inquiry = mapResultSetToInquiry(rs);
                inquiries.add(inquiry);
            }

        } catch (SQLException e) {
            System.out.println("Error getting all inquiries: " + e.getMessage());
        }

        return inquiries;
    }

    
    public List<Inquiry> getInquiriesByUserId(int userId) {
        List<Inquiry> inquiries = new ArrayList<>();
        String sql = "SELECT i.*, u.username as user_name FROM inquiries i " +
                     "LEFT JOIN users u ON i.user_id = u.id " +
                     "WHERE i.user_id = ? ORDER BY i.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Inquiry inquiry = mapResultSetToInquiry(rs);
                inquiries.add(inquiry);
            }

        } catch (SQLException e) {
            System.out.println("Error getting inquiries by user id: " + e.getMessage());
        }

        return inquiries;
    }

   
    public boolean addInquiry(Inquiry inquiry) {
        String sql = "INSERT INTO inquiries (user_id, subject, message, status) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, inquiry.getUserId());
            stmt.setString(2, inquiry.getSubject());
            stmt.setString(3, inquiry.getMessage());
            stmt.setString(4, inquiry.getStatus());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error adding inquiry: " + e.getMessage());
            return false;
        }
    }

    
    public boolean updateInquiry(Inquiry inquiry) {
        String sql = "UPDATE inquiries SET response = ?, status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, inquiry.getResponse());
            stmt.setString(2, inquiry.getStatus());
            stmt.setInt(3, inquiry.getId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error updating inquiry: " + e.getMessage());
            return false;
        }
    }

   
    public boolean deleteInquiry(int id) {
        String sql = "DELETE FROM inquiries WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error deleting inquiry: " + e.getMessage());
            return false;
        }
    }

    
    public Inquiry getInquiryById(int id) {
        Inquiry inquiry = null;
        String sql = "SELECT i.*, u.username as user_name FROM inquiries i " +
                     "LEFT JOIN users u ON i.user_id = u.id " +
                     "WHERE i.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                inquiry = mapResultSetToInquiry(rs);
            }

        } catch (SQLException e) {
            System.out.println("Error getting inquiry by id: " + e.getMessage());
        }

        return inquiry;
    }

    
    private Inquiry mapResultSetToInquiry(ResultSet rs) throws SQLException {
        Inquiry inquiry = new Inquiry();
        inquiry.setId(rs.getInt("id"));
        inquiry.setUserId(rs.getInt("user_id"));
        inquiry.setSubject(rs.getString("subject"));
        inquiry.setMessage(rs.getString("message"));
        inquiry.setResponse(rs.getString("response"));
        inquiry.setStatus(rs.getString("status"));
        inquiry.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        inquiry.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        inquiry.setUserName(rs.getString("user_name"));
        return inquiry;
    }
}