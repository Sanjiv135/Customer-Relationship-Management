package com.crm.dao;

import com.crm.model.Employee;
import com.crm.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {
    
    
    public Employee getEmployeeByUserId(int userId) {
        String sql = "SELECT e.*, u.email, u.username, u.is_active " +
                     "FROM employees e " +
                     "LEFT JOIN users u ON e.user_id = u.id " +
                     "WHERE e.user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Employee employee = extractEmployeeFromResultSet(rs);
                System.out.println("✅ Employee found for user_id: " + userId);
                return employee;
            } else {
                System.out.println("❌ No employee found for user_id: " + userId);
            }

        } catch (SQLException e) {
            System.out.println("❌ ERROR fetching employee by user_id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    
    public Employee getEmployeeById(int id) {
        String sql = "SELECT e.*, u.email, u.username, u.is_active " +
                     "FROM employees e " +
                     "LEFT JOIN users u ON e.user_id = u.id " +
                     "WHERE e.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                System.out.println("✅ Employee found (ID: " + id + ")");
                return extractEmployeeFromResultSet(rs);
            } else {
                System.out.println("❌ No employee found with ID: " + id);
            }

        } catch (SQLException e) {
            System.out.println("❌ ERROR fetching employee by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    
    public List<Employee> getAllEmployees() {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT e.*, u.email, u.username, u.is_active " +
                     "FROM employees e " +
                     "LEFT JOIN users u ON e.user_id = u.id " +
                     "ORDER BY e.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                employees.add(extractEmployeeFromResultSet(rs));
            }

            System.out.println("✅ Total employees fetched: " + employees.size());

        } catch (SQLException e) {
            System.out.println("❌ ERROR fetching all employees: " + e.getMessage());
            e.printStackTrace();
        }
        return employees;
    }

    
    public boolean addEmployee(Employee employee) {
        String sql = "INSERT INTO employees (user_id, first_name, last_name, department, phone, position) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, employee.getUserId());
            stmt.setString(2, employee.getFirstName());
            stmt.setString(3, employee.getLastName());
            stmt.setString(4, employee.getDepartment());
            stmt.setString(5, employee.getPhone());
            stmt.setString(6, employee.getPosition() != null ? employee.getPosition() : "Employee");

            boolean success = stmt.executeUpdate() > 0;
            if (success) {
                System.out.println("✅ Employee added: " + employee.getFullName());
            } else {
                System.out.println("❌ Failed to add employee: " + employee.getFullName());
            }
            return success;

        } catch (SQLException e) {
            System.out.println("❌ ERROR adding employee: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    
    public boolean updateEmployee(Employee employee) {
        String sql = "UPDATE employees SET first_name = ?, last_name = ?, department = ?, phone = ?, " +
                     "position = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, employee.getFirstName());
            stmt.setString(2, employee.getLastName());
            stmt.setString(3, employee.getDepartment());
            stmt.setString(4, employee.getPhone());
            stmt.setString(5, employee.getPosition() != null ? employee.getPosition() : "Employee");
            stmt.setInt(6, employee.getId());

            boolean success = stmt.executeUpdate() > 0;
            if (success) {
                System.out.println("✅ Employee updated: " + employee.getFullName());
            } else {
                System.out.println("❌ Failed to update employee: " + employee.getFullName());
            }
            return success;

        } catch (SQLException e) {
            System.out.println("❌ ERROR updating employee: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

   
    public boolean deleteEmployee(int id) {
        String sql = "DELETE FROM employees WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            boolean success = stmt.executeUpdate() > 0;
            if (success) {
                System.out.println("🗑️ Employee deleted (ID: " + id + ")");
            } else {
                System.out.println("❌ Failed to delete employee (ID: " + id + ")");
            }
            return success;

        } catch (SQLException e) {
            System.out.println("❌ ERROR deleting employee: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    
    public int getEmployeeCount() {
        String sql = "SELECT COUNT(*) AS count FROM employees";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                int count = rs.getInt("count");
                System.out.println("✅ Employee count: " + count);
                return count;
            }

        } catch (SQLException e) {
            System.out.println("❌ ERROR counting employees: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    
    private Employee extractEmployeeFromResultSet(ResultSet rs) throws SQLException {
        Employee employee = new Employee();
        
        
        employee.setId(rs.getInt("id"));
        employee.setUserId(rs.getInt("user_id"));
        employee.setFirstName(rs.getString("first_name"));
        employee.setLastName(rs.getString("last_name"));
        employee.setDepartment(rs.getString("department"));
        employee.setPhone(rs.getString("phone"));

        
        try {
            employee.setPosition(rs.getString("position"));
        } catch (SQLException e) {
            employee.setPosition("Employee"); 
        }

        
        try {
            boolean isActive = rs.getBoolean("is_active");
            employee.setStatus(isActive ? "ACTIVE" : "INACTIVE");
        } catch (SQLException e) {
            employee.setStatus("ACTIVE"); 
        }

        
        try {
            employee.setEmail(rs.getString("email"));
        } catch (SQLException e) {
            
        }

        try {
            employee.setUsername(rs.getString("username"));
        } catch (SQLException e) {
            
        }

        
        try {
            employee.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (SQLException e) {
            
        }

        try {
            employee.setUpdatedAt(rs.getTimestamp("updated_at"));
        } catch (SQLException e) {
            
        }

        return employee;
    }
}