package com.crm.controller;

import com.crm.dao.ComplaintDAO;
import com.crm.model.Complaint;
import com.crm.model.Employee;
import com.crm.model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/complaint")
public class ComplaintServlet extends HttpServlet {
    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String id = request.getParameter("id");

        System.out.println("🔧 COMPLAINT SERVLET - Action: " + action + ", ID: " + id);

        if ("details".equals(action) && id != null) {
            try {
                int complaintId = Integer.parseInt(id);
                Complaint complaint = complaintDAO.getComplaintById(complaintId);
                
                if (complaint != null) {
                    System.out.println("✅ COMPLAINT DETAILS - Found complaint: " + complaint.getTitle());
                    
                   
                    HttpSession session = request.getSession();
                    String role = (String) session.getAttribute("role");
                    Integer userId = (Integer) session.getAttribute("userId");
                    
                    boolean hasPermission = false;
                    
                    if ("customer".equals(role)) {
                        
                        if (complaint.getUserId() == userId) {
                            hasPermission = true;
                        }
                    } else if ("employee".equals(role)) {
                        
                        Employee employee = (Employee) session.getAttribute("employee");
                        if (employee != null && complaint.getAssignedTo() == employee.getId()) {
                            hasPermission = true;
                        }
                       
                        hasPermission = true; 
                    } else if ("admin".equals(role)) {
                        
                        hasPermission = true;
                    }
                    
                    if (hasPermission) {
                        request.setAttribute("complaint", complaint);
                        
                        
                        String jspPage;
                        if ("admin".equals(role)) {
                            jspPage = "/admin/complaintDetails.jsp";
                        } else if ("employee".equals(role)) {
                            jspPage = "/employee/complaintDetails.jsp";
                        } else if ("customer".equals(role)) {
                            jspPage = "/user/complaintDetails.jsp";
                        } else {
                            
                            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login first");
                            return;
                        }
                        
                        System.out.println("✅ COMPLAINT DETAILS - Forwarding to: " + jspPage);
                        request.getRequestDispatcher(jspPage).forward(request, response);
                        return;
                    } else {
                        System.out.println("❌ COMPLAINT DETAILS - Access denied for user: " + userId);
                        session.setAttribute("error", "You don't have permission to view this complaint");
                    }
                } else {
                    System.out.println("❌ COMPLAINT DETAILS - Not found: " + complaintId);
                    HttpSession session = request.getSession();
                    session.setAttribute("error", "Complaint not found");
                }
            } catch (NumberFormatException e) {
                System.out.println("❌ COMPLAINT DETAILS ERROR - Invalid complaint ID format: " + id);
                HttpSession session = request.getSession();
                session.setAttribute("error", "Invalid complaint ID");
            } catch (Exception e) {
                System.out.println("❌ COMPLAINT DETAILS ERROR: " + e.getMessage());
                e.printStackTrace();
                HttpSession session = request.getSession();
                session.setAttribute("error", "Error loading complaint details");
            }
        } else {
            System.out.println("❌ COMPLAINT SERVLET - Invalid request: action=" + action + ", id=" + id);
            HttpSession session = request.getSession();
            session.setAttribute("error", "Invalid request");
        }
        
        
        response.sendRedirect(getRedirectURL(request));
    }
    
    
    
   
    private String getRedirectURL(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        String contextPath = request.getContextPath();
        
        if ("admin".equals(role)) {
            return contextPath + "/admin?action=complaints";
        } else if ("employee".equals(role)) {
            return contextPath + "/employee?action=complaints";
        } else if ("customer".equals(role)) {
            return contextPath + "/user?action=complaints";
        } else {
            return contextPath + "/login.jsp";
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            
            createComplaint(request, response);
        } else {
            
            response.sendRedirect(getRedirectURL(request));
        }
    }
    
    
     
     
    private void createComplaint(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
        
        
        if (!"customer".equals(role) || userId == null) {
            session.setAttribute("error", "Access denied");
            response.sendRedirect(getRedirectURL(request));
            return;
        }
        
        try {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String priority = request.getParameter("priority");
            String productIdStr = request.getParameter("productId");
            
            
            if (title == null || title.trim().isEmpty() || 
                description == null || description.trim().isEmpty()) {
                session.setAttribute("error", "Title and description are required");
                response.sendRedirect(request.getContextPath() + "/user?action=complaintForm");
                return;
            }
            
            Complaint complaint = new Complaint();
            complaint.setUserId(userId);
            complaint.setTitle(title);
            complaint.setDescription(description);
            complaint.setPriority(priority != null ? priority : "MEDIUM");
            complaint.setStatus("PENDING");
            
            if (productIdStr != null && !productIdStr.trim().isEmpty()) {
                try {
                    complaint.setProductId(Integer.parseInt(productIdStr));
                } catch (NumberFormatException e) {
                    
                    complaint.setProductId(0);
                }
            }
            
            if (complaintDAO.addComplaint(complaint)) {
                session.setAttribute("success", "Complaint submitted successfully!");
                response.sendRedirect(request.getContextPath() + "/user?action=complaints");
            } else {
                session.setAttribute("error", "Failed to submit complaint");
                response.sendRedirect(request.getContextPath() + "/user?action=complaintForm");
            }
            
        } catch (Exception e) {
            System.out.println("❌ CREATE COMPLAINT ERROR: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Error submitting complaint");
            response.sendRedirect(request.getContextPath() + "/user?action=complaintForm");
        }
    }
}