package com.crm.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.crm.util.DBConnection;
import com.crm.model.Admin;
import com.crm.model.User;

public class AdminDAO {

    public Admin getAdminByUsername(String username) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT id, username, email, password, created_at FROM users WHERE username = ? AND role = 'admin'";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();

            if (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setUsername(rs.getString("username"));
                admin.setEmail(rs.getString("email"));
                admin.setPassword(rs.getString("password"));
                
                
                Timestamp timestamp = rs.getTimestamp("created_at");
                if (timestamp != null) {
                    admin.setCreatedAt(new Date(timestamp.getTime()));
                }
                
                return admin;
            }
            return null;

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            closeResources(stmt, rs);
            closeConnection(conn);
        }
    }

    public Admin getAdminById(int adminId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT id, username, email, password, created_at FROM users WHERE id = ? AND role = 'admin'";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, adminId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setUsername(rs.getString("username"));
                admin.setEmail(rs.getString("email"));
                admin.setPassword(rs.getString("password"));
                
                
                Timestamp timestamp = rs.getTimestamp("created_at");
                if (timestamp != null) {
                    admin.setCreatedAt(new Date(timestamp.getTime()));
                }
                
                return admin;
            }
            return null;

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            closeResources(stmt, rs);
            closeConnection(conn);
        }
    }

    public List<Admin> getAllAdmins() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Admin> admins = new ArrayList<>();

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT id, username, email, password, created_at FROM users WHERE role = 'admin' ORDER BY created_at DESC";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setUsername(rs.getString("username"));
                admin.setEmail(rs.getString("email"));
                admin.setPassword(rs.getString("password"));
                
                
                Timestamp timestamp = rs.getTimestamp("created_at");
                if (timestamp != null) {
                    admin.setCreatedAt(new Date(timestamp.getTime()));
                }
                
                admins.add(admin);
            }
            return admins;

        } catch (SQLException e) {
            e.printStackTrace();
            return admins;
        } finally {
            closeResources(stmt, rs);
            closeConnection(conn);
        }
    }

    public boolean createAdmin(Admin admin) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, 'admin')";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, admin.getUsername());
            stmt.setString(2, admin.getEmail());
            stmt.setString(3, admin.getPassword());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(stmt, null);
            closeConnection(conn);
        }
    }

    public boolean updateAdmin(Admin admin) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE users SET username = ?, email = ? WHERE id = ? AND role = 'admin'";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, admin.getUsername());
            stmt.setString(2, admin.getEmail());
            stmt.setInt(3, admin.getId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(stmt, null);
            closeConnection(conn);
        }
    }

    public boolean deleteAdmin(int adminId) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM users WHERE id = ? AND role = 'admin'";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, adminId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(stmt, null);
            closeConnection(conn);
        }
    }

    public boolean updateAdminPassword(int adminId, String newPassword) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE users SET password = ? WHERE id = ? AND role = 'admin'";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newPassword);
            stmt.setInt(2, adminId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(stmt, null);
            closeConnection(conn);
        }
    }

    public boolean adminExists(String username) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT id FROM users WHERE username = ? AND role = 'admin'";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(stmt, rs);
            closeConnection(conn);
        }
    }

    public boolean emailExists(String email) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT id FROM users WHERE email = ? AND role = 'admin'";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(stmt, rs);
            closeConnection(conn);
        }
    }

   
    private void closeResources(PreparedStatement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}