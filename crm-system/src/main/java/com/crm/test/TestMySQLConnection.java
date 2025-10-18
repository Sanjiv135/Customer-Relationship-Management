package com.crm.test;

import java.sql.*;

public class TestMySQLConnection {
    public static void main(String[] args) {
        System.out.println("🔍 Testing MySQL Connection...");
        
        try {
            
            Class.forName("com.mysql.jdbc.Driver");
            System.out.println("✅ MySQL Driver loaded successfully!");
            
            
            String url = "jdbc:mysql://localhost:3306/";
            String user = "root";
            String password = "password";
            
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("✅ MySQL Connection SUCCESSFUL!");
            conn.close();
            
        } catch (ClassNotFoundException e) {
            System.out.println("❌ MySQL Driver NOT FOUND in classpath!");
            System.out.println("💡 Make sure mysql-connector-java-5.1.49.jar is in:");
            System.out.println("   - WEB-INF/lib folder");
            System.out.println("   - Tomcat lib folder");
        } catch (SQLException e) {
            System.out.println("❌ MySQL Connection FAILED: " + e.getMessage());
            System.out.println("💡 Check if MySQL server is running on localhost:3306");
        }
    }
}