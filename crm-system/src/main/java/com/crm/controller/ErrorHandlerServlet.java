package com.crm.controller;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/errorHandler")
public class ErrorHandlerServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
        String errorMessage = (String) request.getAttribute("javax.servlet.error.message");
        
        request.setAttribute("statusCode", statusCode);
        request.setAttribute("errorMessage", errorMessage);
        
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    }
}