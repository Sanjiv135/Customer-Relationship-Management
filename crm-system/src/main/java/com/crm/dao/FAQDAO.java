package com.crm.dao;

import com.crm.model.FAQ;
import com.crm.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FAQDAO {

    
    public List<FAQ> getAllFAQs() {
        List<FAQ> faqs = new ArrayList<>();
        String sql = "SELECT f.*, u.username as created_by_name " +
                     "FROM faq f " +
                     "LEFT JOIN users u ON f.created_by = u.id " +
                     "ORDER BY f.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                FAQ faq = mapResultSetToFAQ(rs);
                faqs.add(faq);
            }

        } catch (SQLException e) {
            System.out.println("Error getting all FAQs: " + e.getMessage());
        }

        return faqs;
    }

    
    public boolean addFAQ(FAQ faq) {
        String sql = "INSERT INTO faq (question, answer, category, created_by) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, faq.getQuestion());
            stmt.setString(2, faq.getAnswer());
            stmt.setString(3, faq.getCategory());
            stmt.setInt(4, faq.getCreatedBy());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error adding FAQ: " + e.getMessage());
            return false;
        }
    }

   
    public boolean updateFAQ(FAQ faq) {
        String sql = "UPDATE faq SET question = ?, answer = ?, category = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, faq.getQuestion());
            stmt.setString(2, faq.getAnswer());
            stmt.setString(3, faq.getCategory());
            stmt.setInt(4, faq.getId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error updating FAQ: " + e.getMessage());
            return false;
        }
    }

   
    public boolean deleteFAQ(int id) {
        String sql = "DELETE FROM faq WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error deleting FAQ: " + e.getMessage());
            return false;
        }
    }

   
    public FAQ getFAQById(int id) {
        FAQ faq = null;
        String sql = "SELECT f.*, u.username as created_by_name " +
                     "FROM faq f " +
                     "LEFT JOIN users u ON f.created_by = u.id " +
                     "WHERE f.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                faq = mapResultSetToFAQ(rs);
            }

        } catch (SQLException e) {
            System.out.println("Error getting FAQ by id: " + e.getMessage());
        }

        return faq;
    }

    
    private FAQ mapResultSetToFAQ(ResultSet rs) throws SQLException {
        FAQ faq = new FAQ();
        faq.setId(rs.getInt("id"));
        faq.setQuestion(rs.getString("question"));
        faq.setAnswer(rs.getString("answer"));
        faq.setCategory(rs.getString("category"));
        faq.setCreatedBy(rs.getInt("created_by"));
        faq.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        faq.setCreatedByName(rs.getString("created_by_name"));
        return faq;
    }
}
