package com.crm.dao;

import com.crm.model.Customer;
import com.crm.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    
    public boolean addCustomer(Customer customer) {
        String sql = "INSERT INTO customers (user_id, first_name, last_name, email, phone, address, company) VALUES (?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in addCustomer");
                return false;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, customer.getUserId());
            stmt.setString(2, customer.getFirstName());
            stmt.setString(3, customer.getLastName());
            stmt.setString(4, customer.getEmail());
            stmt.setString(5, customer.getPhone());
            stmt.setString(6, customer.getAddress());
            stmt.setString(7, customer.getCompany());

            boolean success = stmt.executeUpdate() > 0;
            System.out.println("✅ ADD CUSTOMER - Success: " + success + " for user ID: " + customer.getUserId());
            return success;

        } catch (SQLException e) {
            System.out.println("❌ Error adding customer: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    
    public Customer getCustomerByUserId(int userId) {
        String sql = "SELECT c.*, u.username FROM customers c LEFT JOIN users u ON c.user_id = u.id WHERE c.user_id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in getCustomerByUserId");
                return null;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            rs = stmt.executeQuery();
            if (rs.next()) {
                Customer customer = new Customer();
                customer.setId(rs.getInt("id"));
                customer.setUserId(rs.getInt("user_id"));
                customer.setFirstName(rs.getString("first_name"));
                customer.setLastName(rs.getString("last_name"));
                customer.setEmail(rs.getString("email"));
                customer.setPhone(rs.getString("phone"));
                customer.setAddress(rs.getString("address"));
                customer.setCompany(rs.getString("company"));
                customer.setUsername(rs.getString("username"));
                
                
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    customer.setCreatedAt(createdAt.toLocalDateTime());
                }
                
                System.out.println("✅ CUSTOMER DAO - Found customer for user_id: " + userId);
                return customer;
            }
            
            System.out.println("❌ CUSTOMER DAO - No customer found for user_id: " + userId);
            return null;

        } catch (SQLException e) {
            System.out.println("❌ Error getting customer by user ID: " + e.getMessage());
            return null;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT c.*, u.username FROM customers c LEFT JOIN users u ON c.user_id = u.id ORDER BY c.created_at DESC";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in getAllCustomers");
                return customers;
            }
            
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Customer customer = new Customer();
                customer.setId(rs.getInt("id"));
                customer.setUserId(rs.getInt("user_id"));
                customer.setFirstName(rs.getString("first_name"));
                customer.setLastName(rs.getString("last_name"));
                customer.setEmail(rs.getString("email"));
                customer.setPhone(rs.getString("phone"));
                customer.setAddress(rs.getString("address"));
                customer.setCompany(rs.getString("company"));
                customer.setUsername(rs.getString("username"));
                
                
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    customer.setCreatedAt(createdAt.toLocalDateTime());
                }
                
                customers.add(customer);
            }
            
            System.out.println("✅ GET ALL CUSTOMERS - Found " + customers.size() + " customers");
            return customers;

        } catch (SQLException e) {
            System.out.println("❌ Error getting all customers: " + e.getMessage());
            return customers;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public boolean updateCustomer(Customer customer) {
        String sql = "UPDATE customers SET first_name = ?, last_name = ?, email = ?, phone = ?, address = ?, company = ? WHERE user_id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in updateCustomer");
                return false;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, customer.getFirstName());
            stmt.setString(2, customer.getLastName());
            stmt.setString(3, customer.getEmail());
            stmt.setString(4, customer.getPhone());
            stmt.setString(5, customer.getAddress());
            stmt.setString(6, customer.getCompany());
            stmt.setInt(7, customer.getUserId());
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("✅ UPDATE CUSTOMER - Rows affected: " + rowsAffected + " for user ID: " + customer.getUserId());
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error updating customer: " + e.getMessage());
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public boolean deleteCustomer(int userId) {
        String sql = "DELETE FROM customers WHERE user_id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.out.println("❌ CRITICAL: Database connection is null in deleteCustomer");
                return false;
            }
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("✅ DELETE CUSTOMER - Rows affected: " + rowsAffected + " for user ID: " + userId);
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error deleting customer: " + e.getMessage());
            return false;
        } finally {
            closeResources(null, stmt, conn);
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
}