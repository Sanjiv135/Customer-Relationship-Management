package com.crm.util;

import java.io.File;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;

public class ForceDriverLoad {
    
    public static void loadMySQLDriver() {
        System.out.println("🚀 FORCE LOADING MYSQL DRIVER FROM JAR...");
        
        try {
            
            String webInfPath = ForceDriverLoad.class.getClassLoader().getResource("").toString();
            System.out.println("📁 Classpath base: " + webInfPath);
            
            
            File mysqlJar = new File("C:/Users/kasth/eclipse-workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/crm-system/WEB-INF/lib/mysql-connector-java-5.1.49.jar");
            
            if (mysqlJar.exists()) {
                System.out.println("✅ MySQL JAR found: " + mysqlJar.getAbsolutePath());
                
               
                URL jarUrl = mysqlJar.toURI().toURL();
                URLClassLoader child = new URLClassLoader(new URL[]{jarUrl}, ForceDriverLoad.class.getClassLoader());
                
              
                Class<?> driverClass = child.loadClass("com.mysql.jdbc.Driver");
                System.out.println("✅ MySQL Driver class loaded: " + driverClass.getName());
                
                
                java.sql.Driver driver = (java.sql.Driver) driverClass.newInstance();
                java.sql.DriverManager.registerDriver(driver);
                System.out.println("✅ MySQL Driver registered with DriverManager");
                
            } else {
                System.out.println("❌ MySQL JAR not found at: " + mysqlJar.getAbsolutePath());
                
                
                File libDir = new File("C:/Users/kasth/eclipse-workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/crm-system/WEB-INF/lib");
                if (libDir.exists()) {
                    System.out.println("📦 JARs in lib folder:");
                    for (File jar : libDir.listFiles((dir, name) -> name.endsWith(".jar"))) {
                        System.out.println("   - " + jar.getName());
                    }
                }
            }
            
        } catch (Exception e) {
            System.out.println("❌ Error force loading MySQL driver: " + e.getMessage());
            e.printStackTrace();
        }
    }
}