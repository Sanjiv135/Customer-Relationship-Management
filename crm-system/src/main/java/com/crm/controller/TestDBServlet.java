package com.crm.controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.crm.util.DBConnection;

@WebServlet("/test-db")
public class TestDBServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Database Test</title></head><body>");
        out.println("<h1>Database Connection Test</h1>");
        
        out.println("<h2>Testing MySQL Driver Loading...</h2>");
        
        
        boolean connected = DBConnection.testConnection();
        
        if (connected) {
            out.println("<p style='color: green; font-weight: bold;'>✅ SUCCESS: Database connected!</p>");
        } else {
            out.println("<p style='color: red; font-weight: bold;'>❌ FAILED: Cannot connect to database</p>");
        }
        
        out.println("</body></html>");
    }
}