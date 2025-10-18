package com.crm.util;

import java.sql.*;

public class DBConnection {
    
    private static boolean driverLoaded = false;
    
    static {
        loadMySQLDriver();
    }
    
    private static void loadMySQLDriver() {
        if (driverLoaded) return;
        
        System.out.println("🚀 LOADING MYSQL 8.x DRIVER...");
        
        
        String[] drivers = {
            "com.mysql.cj.jdbc.Driver",  
            "com.mysql.jdbc.Driver"      
        };
        
        for (String driverClass : drivers) {
            try {
                System.out.println("🔄 Trying driver: " + driverClass);
                Class.forName(driverClass);
                System.out.println("✅ SUCCESS: Driver loaded - " + driverClass);
                driverLoaded = true;
                return;
            } catch (ClassNotFoundException e) {
                System.out.println("❌ FAILED: " + driverClass + " - " + e.getMessage());
            }
        }
        
        if (!driverLoaded) {
            System.err.println("🚨 CRITICAL: No MySQL drivers found!");
            System.err.println("💡 Solution: Copy mysql-connector-java-8.0.33.jar to WEB-INF/lib folder");
        }
    }
    
    public static Connection getConnection() {
        if (!driverLoaded) {
            System.out.println("⚠️ Driver not loaded, attempting to load again...");
            loadMySQLDriver();
        }
        
        try {
            System.out.println("🔄 ATTEMPTING DATABASE CONNECTION...");
            
            
            checkAvailableDrivers();
            
            
            String[] urls = {
                "jdbc:mysql://localhost:3306/crmdb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                "jdbc:mysql://localhost:3306/crm_system?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                "jdbc:mysql://localhost:3306/mysql?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
            };
            
            String user = "root";
            String password = "Password";
            
            for (String url : urls) {
                try {
                    System.out.println("🔄 Trying URL: " + url);
                    Connection conn = DriverManager.getConnection(url, user, password);
                    System.out.println("✅ SUCCESS! Connected to: " + url);
                    
                    
                    if (testDatabaseConnection(conn)) {
                        return conn;
                    } else {
                        conn.close();
                    }
                    
                } catch (SQLException e) {
                    System.out.println("❌ Failed for URL " + url + ": " + e.getMessage());
                    if (e.getMessage().contains("Unknown database")) {
                        System.out.println("💡 Database doesn't exist, but MySQL server is running");
                       
                        if (url.contains("crmdb")) {
                            createDatabase();
                        }
                    }
                }
            }
            
            
            String fallbackUrl = "jdbc:mysql://localhost:3306/?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            try {
                System.out.println("🔄 Trying fallback URL: " + fallbackUrl);
                Connection conn = DriverManager.getConnection(fallbackUrl, user, password);
                System.out.println("✅ Connected to MySQL server (no specific database)");
                return conn;
            } catch (SQLException e) {
                System.out.println("❌ Final fallback failed: " + e.getMessage());
            }
            
            return null;
            
        } catch (Exception e) {
            System.err.println("❌ DATABASE CONNECTION FAILED: " + e.getMessage());
            return null;
        }
    }
    
    private static void checkAvailableDrivers() {
        System.out.println("🔍 CHECKING AVAILABLE JDBC DRIVERS...");
        try {
            java.util.Enumeration<Driver> drivers = DriverManager.getDrivers();
            boolean foundMySQL = false;
            
            while (drivers.hasMoreElements()) {
                Driver driver = drivers.nextElement();
                String driverName = driver.getClass().getName();
                System.out.println("   📍 Driver: " + driverName);
                if (driverName.contains("mysql")) {
                    foundMySQL = true;
                    System.out.println("   ✅ MySQL Driver Found: " + driverName);
                }
            }
            
            if (!foundMySQL) {
                System.out.println("   ❌ No MySQL drivers found in DriverManager");
            }
            
        } catch (Exception e) {
            System.out.println("❌ Error checking drivers: " + e.getMessage());
        }
    }
    
    private static boolean testDatabaseConnection(Connection conn) {
        try {
            String testQuery = "SELECT 1 as test_result";
            try (Statement stmt = conn.createStatement(); 
                 ResultSet rs = stmt.executeQuery(testQuery)) {
                if (rs.next()) {
                    System.out.println("✅ Database test query successful");
                    return true;
                }
            }
            return false;
        } catch (SQLException e) {
            System.out.println("❌ Database test failed: " + e.getMessage());
            return false;
        }
    }
    
    private static void createDatabase() {
        System.out.println("🔄 ATTEMPTING TO CREATE DATABASE...");
        
        String url = "jdbc:mysql://localhost:3306/?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        String user = "root";
        String password = "Kasthu@123";
        
        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement()) {
            
            
            stmt.executeUpdate("CREATE DATABASE IF NOT EXISTS crmdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            System.out.println("✅ Created database: crmdb");
            
            
            stmt.executeUpdate("USE crmdb");
            System.out.println("✅ Using database: crmdb");
            
            
            createTables();
            
        } catch (SQLException e) {
            System.out.println("❌ Error creating database: " + e.getMessage());
        }
    }
    
    private static void createTables() {
        System.out.println("🔄 CREATING DATABASE TABLES...");
        
        String url = "jdbc:mysql://localhost:3306/crmdb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        String user = "root";
        String password = "Kasthu@123";
        
        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement()) {
            
           
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS users (" +
                "id INT PRIMARY KEY AUTO_INCREMENT, " +
                "username VARCHAR(50) UNIQUE NOT NULL, " +
                "password VARCHAR(255) NOT NULL, " +
                "email VARCHAR(100) UNIQUE NOT NULL, " +
                "role ENUM('admin', 'employee', 'customer') NOT NULL, " +
                "temp_password BOOLEAN DEFAULT FALSE, " +
                "is_active BOOLEAN DEFAULT TRUE, " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "reset_token VARCHAR(100), " +
                "reset_token_expiry DATETIME" +
            ")");
            System.out.println("✅ Created users table");
            
            
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS employees (" +
                "id INT PRIMARY KEY AUTO_INCREMENT, " +
                "user_id INT NOT NULL, " +
                "first_name VARCHAR(50) NOT NULL, " +
                "last_name VARCHAR(50) NOT NULL, " +
                "phone VARCHAR(20), " +
                "department VARCHAR(50), " +
                "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
            ")");
            System.out.println("✅ Created employees table");
            
            
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS customers (" +
                "id INT PRIMARY KEY AUTO_INCREMENT, " +
                "user_id INT NOT NULL, " +
                "first_name VARCHAR(50) NOT NULL, " +
                "last_name VARCHAR(50) NOT NULL, " +
                "phone VARCHAR(20), " +
                "address TEXT, " +
                "company VARCHAR(100), " +
                "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
            ")");
            System.out.println("✅ Created customers table");
            
          
            insertSampleData(stmt);
            
            System.out.println("🎉 DATABASE SETUP COMPLETED SUCCESSFULLY!");
            
        } catch (SQLException e) {
            System.out.println("❌ Error creating tables: " + e.getMessage());
        }
    }
    
    private static void insertSampleData(Statement stmt) throws SQLException {
        System.out.println("🔄 INSERTING SAMPLE DATA...");
        
        
        stmt.executeUpdate("DELETE FROM customers");
        stmt.executeUpdate("DELETE FROM employees");
        stmt.executeUpdate("DELETE FROM users");
        
        
        String[] userInserts = {
            "INSERT INTO users (username, password, email, role) VALUES " +
            "('admin_john', '$2a$10$8pMHf4UezaGaXcUfwAwzyO/CiEVwJw7fbdxuCR2V5KFJeUtRwk7De', 'admin.john@crm.com', 'admin')",
            "INSERT INTO users (username, password, email, role) VALUES " +
            "('admin_sarah', '$2a$10$8pMHf4UezaGaXcUfwAwzyO/CiEVwJw7fbdxuCR2V5KFJeUtRwk7De', 'admin.sarah@crm.com', 'admin')",
            "INSERT INTO users (username, password, email, role) VALUES " +
            "('tech_mike', '$2a$10$8pMHf4UezaGaXcUfwAwzyO/CiEVwJw7fbdxuCR2V5KFJeUtRwk7De', 'mike.tech@crm.com', 'employee')",
            "INSERT INTO users (username, password, email, role) VALUES " +
            "('support_lisa', '$2a$10$8pMHf4UezaGaXcUfwAwzyO/CiEVwJw7fbdxuCR2V5KFJeUtRwk7De', 'lisa.support@crm.com', 'employee')",
            "INSERT INTO users (username, password, email, role) VALUES " +
            "('cust_john', '$2a$10$8pMHf4UezaGaXcUfwAwzyO/CiEVwJw7fbdxuCR2V5KFJeUtRwk7De', 'john.doe@customer.com', 'customer')",
            "INSERT INTO users (username, password, email, role) VALUES " +
            "('cust_jane', '$2a$10$8pMHf4UezaGaXcUfwAwzyO/CiEVwJw7fbdxuCR2V5KFJeUtRwk7De', 'jane.smith@customer.com', 'customer')"
        };
        
        for (String insert : userInserts) {
            stmt.executeUpdate(insert);
        }
        System.out.println("✅ Inserted sample users");
        
       
        String[] employeeInserts = {
            "INSERT INTO employees (user_id, first_name, last_name, phone, department) VALUES " +
            "(3, 'Mike', 'Wilson', '+1-555-0101', 'Technical Support')",
            "INSERT INTO employees (user_id, first_name, last_name, phone, department) VALUES " +
            "(4, 'Lisa', 'Johnson', '+1-555-0102', 'Customer Support')"
        };
        
        for (String insert : employeeInserts) {
            stmt.executeUpdate(insert);
        }
        System.out.println("✅ Inserted sample employees");
        
       
        String[] customerInserts = {
            "INSERT INTO customers (user_id, first_name, last_name, phone, address, company) VALUES " +
            "(5, 'John', 'Doe', '+1-555-0201', '123 Main St, New York, NY 10001', 'Tech Solutions Inc.')",
            "INSERT INTO customers (user_id, first_name, last_name, phone, address, company) VALUES " +
            "(6, 'Jane', 'Smith', '+1-555-0202', '456 Oak Ave, Los Angeles, CA 90210', 'Marketing Pro LLC')"
        };
        
        for (String insert : customerInserts) {
            stmt.executeUpdate(insert);
        }
        System.out.println("✅ Inserted sample customers");
        
        System.out.println("📋 TEST USERS CREATED:");
        System.out.println("   👨‍💼 admin_john / password123 (Admin)");
        System.out.println("   👨‍💼 admin_sarah / password123 (Admin)");
        System.out.println("   👨‍💻 tech_mike / password123 (Employee)");
        System.out.println("   👩‍💻 support_lisa / password123 (Employee)");
        System.out.println("   👤 cust_john / password123 (Customer)");
        System.out.println("   👤 cust_jane / password123 (Customer)");
    }
    
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    conn.close();
                    System.out.println("✅ Connection closed");
                }
            } catch (SQLException e) {
                System.err.println("❌ Error closing connection: " + e.getMessage());
            }
        }
    }
    
    public static boolean testConnection() {
        System.out.println("🔍 TESTING DATABASE CONNECTION...");
        try (Connection conn = getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ DATABASE CONNECTION TEST: SUCCESS");
                return true;
            } else {
                System.out.println("❌ DATABASE CONNECTION TEST: FAILED");
                return false;
            }
        } catch (SQLException e) {
            System.out.println("❌ DATABASE CONNECTION TEST: EXCEPTION - " + e.getMessage());
            return false;
        }
    }
    
    public static void returnConnection(Connection conn) {
        closeConnection(conn);
    }
}