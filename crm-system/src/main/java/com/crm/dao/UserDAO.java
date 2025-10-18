package com.crm.dao;

import com.crm.model.User;
import com.crm.util.DBConnection;
import com.crm.util.PasswordUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    public boolean addUser(User user) {
        String sql = "INSERT INTO users (username, email, password, phone, role, temp_password, is_active, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, PasswordUtil.hashPassword(user.getPassword()));
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getRole());
            stmt.setBoolean(6, user.isTempPassword());
            stmt.setBoolean(7, user.isActive());
            stmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("❌ Error adding user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET email = ?, phone = ?, role = ?, is_active = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getPhone());
            stmt.setString(3, user.getRole());
            stmt.setBoolean(4, user.isActive());
            stmt.setInt(5, user.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ Error updating user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("❌ Error getting user by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhone(rs.getString("phone"));
        user.setRole(rs.getString("role"));
        user.setTempPassword(rs.getBoolean("temp_password"));
        user.setActive(rs.getBoolean("is_active"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
    
 
    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("❌ Error getting user by username: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("❌ Error getting user by email: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("❌ Error getting all users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }
    
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ Error deleting user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ?, temp_password = false WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, PasswordUtil.hashPassword(newPassword));
            stmt.setInt(2, userId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ Error updating password: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean verifyPassword(int userId, String password) {
        String sql = "SELECT password FROM users WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                return PasswordUtil.checkPassword(password, hashedPassword);
            }
        } catch (SQLException e) {
            System.err.println("❌ Error verifying password: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
 

    
    public void debugUserCheck(String username, String password) {
        System.out.println("=== DEBUG USER CHECK ===");
        System.out.println("Username: " + username);
        System.out.println("Password provided: " + password);
        
        String sql = "SELECT * FROM users WHERE username = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in debugUserCheck");
                return;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            
            rs = stmt.executeQuery();
            if (rs.next()) {
                System.out.println("✅ User found in DB:");
                System.out.println("   ID: " + rs.getInt("id"));
                System.out.println("   Username: " + rs.getString("username"));
                System.out.println("   Email: " + rs.getString("email"));
                System.out.println("   Role: " + rs.getString("role"));
                System.out.println("   Password hash: " + rs.getString("password"));
                System.out.println("   Is Active: " + rs.getBoolean("is_active"));
                System.out.println("   Temp Password: " + rs.getBoolean("temp_password"));
                System.out.println("   Created At: " + rs.getTimestamp("created_at"));
                
                String storedHash = rs.getString("password");
                boolean passwordMatch = false;
                if (storedHash != null) {
                    passwordMatch = PasswordUtil.checkPassword(password, storedHash);
                }
                System.out.println("   Password matches: " + passwordMatch);
                
            } else {
                System.out.println("❌ User NOT found in database!");
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Database error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        System.out.println("=== END DEBUG ===");
    }

    
    public User authenticate(String username, String password) {
        System.out.println("🔐 AUTHENTICATE METHOD - Starting authentication for: " + username);
        
        String sql = "SELECT id, username, email, password, role, temp_password, is_active, created_at FROM users WHERE username = ? AND is_active = TRUE";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in authenticate method");
                return null;
            }
            
            System.out.println("✅ Database connection obtained successfully");
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                String storedHashedPassword = rs.getString("password");
                System.out.println("🔑 Password check - Stored hash: " + (storedHashedPassword != null ? "**[HASH]**" : "NULL"));
                
                if (storedHashedPassword == null) {
                    System.out.println("❌ Stored password hash is NULL for user: " + username);
                    return null;
                }
                
                boolean passwordValid = PasswordUtil.checkPassword(password, storedHashedPassword);
                System.out.println("🔑 Password valid: " + passwordValid);
                
                if (passwordValid) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(storedHashedPassword);
                    user.setRole(rs.getString("role"));
                    user.setTempPassword(rs.getBoolean("temp_password"));
                    user.setActive(rs.getBoolean("is_active"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    System.out.println("✅ AUTHENTICATION SUCCESS - User: " + user.getUsername() + ", Role: " + user.getRole());
                    return user;
                } else {
                    System.out.println("❌ AUTHENTICATION FAILED - Password mismatch for user: " + username);
                }
            } else {
                System.out.println("❌ AUTHENTICATION FAILED - User not found or inactive: " + username);
            }
            return null;

        } catch (SQLException e) {
            System.out.println("❌ Authentication SQL error: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    
    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            System.out.println("❌ Error closing ResultSet: " + e.getMessage());
        }
        try {
            if (stmt != null) stmt.close();
        } catch (SQLException e) {
            System.out.println("❌ Error closing Statement: " + e.getMessage());
        }
        try {
            if (conn != null) DBConnection.closeConnection(conn);
        } catch (Exception e) {
            System.out.println("❌ Error closing Connection: " + e.getMessage());
        }
    }


    
    public User getUserByPhone(String phone) {
       
        String cleanPhone = cleanPhoneNumber(phone);
        
        
        String sql = "SELECT u.* FROM users u WHERE REPLACE(REPLACE(REPLACE(REPLACE(u.phone, ' ', ''), '-', ''), '(', ''), ')', '') = ? " +
                     "UNION " +
                     "SELECT u.* FROM users u JOIN customers c ON u.id = c.user_id WHERE REPLACE(REPLACE(REPLACE(REPLACE(c.phone, ' ', ''), '-', ''), '(', ''), ')', '') = ? " +
                     "UNION " +
                     "SELECT u.* FROM users u JOIN employees e ON u.id = e.user_id WHERE REPLACE(REPLACE(REPLACE(REPLACE(e.phone, ' ', ''), '-', ''), '(', ''), ')', '') = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in getUserByPhone");
                return null;
            }
            
            System.out.println("🔍 Executing phone lookup SQL for: " + cleanPhone);
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, cleanPhone);
            stmt.setString(2, cleanPhone);
            stmt.setString(3, cleanPhone);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setTempPassword(rs.getBoolean("temp_password"));
                user.setActive(rs.getBoolean("is_active"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                
                System.out.println("✅ User found by phone: " + phone + " - " + user.getUsername() + " - " + user.getEmail());
                return user;
            }
            
            System.out.println("❌ No user found for phone: " + phone);
            return null;

        } catch (SQLException e) {
            System.out.println("❌ SQL Error getting user by phone: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }    
    
    private String cleanPhoneNumber(String phone) {
        if (phone == null) return "";
        
        if (phone.startsWith("+")) {
            return "+" + phone.substring(1).replaceAll("[^0-9]", "");
        } else {
            return phone.replaceAll("[^0-9]", "");
        }
    }


    
    public User getUserByIdentifier(String identifier, String identifierType) {
        String sql = "SELECT u.*, " +
                     "CASE WHEN u.role = 'customer' THEN c.phone " +
                     "     WHEN u.role = 'employee' THEN e.phone " +
                     "     ELSE NULL END as phone " +
                     "FROM users u " +
                     "LEFT JOIN customers c ON u.id = c.user_id " +
                     "LEFT JOIN employees e ON u.id = e.user_id " +
                     "WHERE ";
        
        if ("email".equals(identifierType)) {
            sql += "u.email = ?";
        } else if ("username".equals(identifierType)) {
            sql += "u.username = ?";
        } else if ("phone".equals(identifierType)) {
            sql += "(c.phone = ? OR e.phone = ?)";
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in getUserByIdentifier");
                return null;
            }
            
            stmt = conn.prepareStatement(sql);
            
            if ("phone".equals(identifierType)) {
                stmt.setString(1, identifier);
                stmt.setString(2, identifier);
            } else {
                stmt.setString(1, identifier);
            }
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone")); // Set phone number
                user.setTempPassword(rs.getBoolean("temp_password"));
                user.setActive(rs.getBoolean("is_active"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                
                System.out.println("✅ User found: " + user.getUsername() + ", Phone: " + user.getPhone());
                return user;
            }
            
            System.out.println("❌ No user found for " + identifierType + ": " + identifier);
            return null;

        } catch (SQLException e) {
            System.out.println("❌ Error getting user by identifier: " + e.getMessage());
            return null;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }


    public List<User> getUsersByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT id, username, email, password, role, temp_password, is_active, created_at FROM users WHERE role = ? ORDER BY created_at DESC";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in getUsersByRole");
                return users;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, role);
            
            rs = stmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setTempPassword(rs.getBoolean("temp_password"));
                user.setActive(rs.getBoolean("is_active"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                users.add(user);
            }
            return users;

        } catch (SQLException e) {
            System.out.println("❌ Error getting users by role: " + e.getMessage());
            return users;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }


    
    public void storeOTP(String identifier, String otp, String identifierType) {
        String sql = "UPDATE users SET reset_token = ?, reset_token_expiry = DATE_ADD(NOW(), INTERVAL 10 MINUTE) WHERE ";
        
        if ("email".equals(identifierType)) {
            sql += "email = ?";
        } else if ("username".equals(identifierType)) {
            sql += "username = ?";
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in storeOTP");
                return;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, otp);
            stmt.setString(2, identifier);
            int rowsAffected = stmt.executeUpdate();
            
            System.out.println("✅ OTP stored for " + identifierType + ": " + identifier + " - Rows affected: " + rowsAffected);

        } catch (SQLException e) {
            System.out.println("❌ Error storing OTP: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public boolean verifyOTP(String identifier, String otp, String identifierType) {
        String sql = "SELECT id FROM users WHERE reset_token = ? AND reset_token_expiry > NOW() AND ";
        
        if ("email".equals(identifierType)) {
            sql += "email = ?";
        } else if ("username".equals(identifierType)) {
            sql += "username = ?";
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in verifyOTP");
                return false;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, otp);
            stmt.setString(2, identifier);
            
            rs = stmt.executeQuery();
            boolean isValid = rs.next();
            
            System.out.println("✅ OTP verification for " + identifierType + ": " + identifier + " - " + (isValid ? "VALID" : "INVALID"));
            return isValid;

        } catch (SQLException e) {
            System.out.println("❌ Error verifying OTP: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public void clearOTP(String identifier, String identifierType) {
        String sql = "UPDATE users SET reset_token = NULL, reset_token_expiry = NULL WHERE ";
        
        if ("email".equals(identifierType)) {
            sql += "email = ?";
        } else if ("username".equals(identifierType)) {
            sql += "username = ?";
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in clearOTP");
                return;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, identifier);
            int rowsAffected = stmt.executeUpdate();
            
            System.out.println("✅ OTP cleared for " + identifierType + ": " + identifier + " - Rows affected: " + rowsAffected);

        } catch (SQLException e) {
            System.out.println("❌ Error clearing OTP: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    
    public void storeResetToken(String email, String token) {
        String sql = "UPDATE users SET reset_token = ?, reset_token_expiry = DATE_ADD(NOW(), INTERVAL 1 HOUR) WHERE email = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in storeResetToken");
                return;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, token);
            stmt.setString(2, email);
            stmt.executeUpdate();

        } catch (SQLException e) {
            System.out.println("❌ Error storing reset token: " + e.getMessage());
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public boolean isValidResetToken(String token) {
        String sql = "SELECT id FROM users WHERE reset_token = ? AND reset_token_expiry > NOW()";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in isValidResetToken");
                return false;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, token);
            
            rs = stmt.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            System.out.println("❌ Error validating reset token: " + e.getMessage());
            return false;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public boolean updatePasswordWithToken(String token, String newPassword) {
        String sql = "UPDATE users SET password = ?, reset_token = NULL, reset_token_expiry = NULL WHERE reset_token = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in updatePasswordWithToken");
                return false;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, PasswordUtil.hashPassword(newPassword));
            stmt.setString(2, token);
            
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("❌ Error updating password with token: " + e.getMessage());
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    
    public boolean usernameExists(String username) {
        String sql = "SELECT id FROM users WHERE username = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in usernameExists");
                return false;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            
            rs = stmt.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            System.out.println("❌ Error checking username existence: " + e.getMessage());
            return false;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public boolean emailExists(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in emailExists");
                return false;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            
            rs = stmt.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            System.out.println("❌ Error checking email existence: " + e.getMessage());
            return false;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public boolean adminExists() {
        String sql = "SELECT COUNT(*) as count FROM users WHERE role = 'admin'";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in adminExists");
                return false;
            }
            
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            return false;
            
        } catch (SQLException e) {
            System.out.println("❌ Error checking admin existence: " + e.getMessage());
            return false;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public boolean updateUserStatus(int userId, boolean isActive) {
        String sql = "UPDATE users SET is_active = ? WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in updateUserStatus");
                return false;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setBoolean(1, isActive);
            stmt.setInt(2, userId);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error updating user status: " + e.getMessage());
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public boolean resetUserPassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ?, temp_password = TRUE WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in resetUserPassword");
                return false;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, PasswordUtil.hashPassword(newPassword));
            stmt.setInt(2, userId);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error resetting user password: " + e.getMessage());
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    
    public boolean clearTempPassword(int userId) {
        String sql = "UPDATE users SET temp_password = false WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in clearTempPassword");
                return false;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("🔄 CLEAR TEMP PASSWORD - User ID: " + userId + ", Rows affected: " + rowsAffected);
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error clearing temp password: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    public void debugUserPhone(String phone) {
        System.out.println("=== DEBUG USER PHONE ===");
        System.out.println("Phone to search: " + phone);
        
        String sql = "SELECT id, username, email, phone FROM users WHERE phone IS NOT NULL";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            System.out.println("Users with phone numbers:");
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("id") + 
                                 ", Username: " + rs.getString("username") + 
                                 ", Email: " + rs.getString("email") + 
                                 ", Phone: " + rs.getString("phone"));
            }
        } catch (SQLException e) {
            System.out.println("Error debugging user phones: " + e.getMessage());
        }
    }
}