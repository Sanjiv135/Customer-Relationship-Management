package com.crm.controller;

import com.crm.dao.UserDAO;
import com.crm.dao.CustomerDAO;
import com.crm.dao.ProductDAO;
import com.crm.dao.ComplaintDAO;
import com.crm.dao.InquiryDAO;
import com.crm.dao.FAQDAO;
import com.crm.model.User;
import com.crm.model.Customer;
import com.crm.model.Product;
import com.crm.model.Complaint;
import com.crm.model.Inquiry;
import com.crm.model.FAQ;
import com.crm.util.DBConnection;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;


public class UserServlet extends HttpServlet {
    private UserDAO userDAO;
    private CustomerDAO customerDAO;
    private ProductDAO productDAO;
    private ComplaintDAO complaintDAO;
    private InquiryDAO inquiryDAO;
    private FAQDAO faqDAO;

    @Override
    public void init() throws ServletException {
        System.out.println("🔧 USER SERVLET - Initializing DAOs");
        userDAO = new UserDAO();
        customerDAO = new CustomerDAO();
        productDAO = new ProductDAO();
        complaintDAO = new ComplaintDAO();
        inquiryDAO = new InquiryDAO();
        faqDAO = new FAQDAO();
        System.out.println("✅ USER SERVLET - DAOs initialized successfully");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            System.out.println("🔧 USER SERVLET POST - No action, redirecting to dashboard");
            response.sendRedirect(request.getContextPath() + "/user?action=dashboard");
            return;
        }

        System.out.println("🔧 USER SERVLET POST - Action: " + action);

        try {
            switch (action) {
                case "updateProfile":
                    updateProfile(request, response);
                    break;
                case "addComplaint":
                    addComplaint(request, response);
                    break;
                case "addInquiry":
                    addInquiry(request, response);
                    break;
                case "deleteComplaint":
                    deleteComplaint(request, response);
                    break;
                case "updateComplaint":
                    updateComplaint(request, response);
                    break;
                case "changePassword":
                    changePassword(request, response);
                    break;
                default:
                    System.out.println("🔧 USER SERVLET POST - Unknown action, redirecting to dashboard");
                    response.sendRedirect(request.getContextPath() + "/user?action=dashboard");
                    break;
            }
        } catch (Exception e) {
            System.out.println("❌ USER SERVLET POST ERROR: " + e.getMessage());
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Operation failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/user?action=dashboard");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("🎯 DEBUG - UserServlet doGet() STARTED");
        System.out.println("🔍 DEBUG - Request URL: " + request.getRequestURL());
        System.out.println("🔍 DEBUG - Query String: " + request.getQueryString());
        
        String action = request.getParameter("action");
        System.out.println("🔍 DEBUG - Action parameter: " + action);
        
       
        HttpSession session = request.getSession(false);
        System.out.println("🔍 DEBUG - Session exists: " + (session != null));
        
        if (session != null) {
            Integer userId = (Integer) session.getAttribute("userId");
            String role = (String) session.getAttribute("role");
            Customer customer = (Customer) session.getAttribute("customer");
            
            System.out.println("🔍 DEBUG - Session Data:");
            System.out.println("   User ID: " + userId);
            System.out.println("   Role: " + role);
            System.out.println("   Customer: " + (customer != null ? customer.getFullName() : "NULL"));
        }

        if (action == null) {
            System.out.println("🔧 USER SERVLET - No action, loading dashboard data");
            loadDashboardData(request, response);
            return;
        }

        System.out.println("🔧 USER SERVLET - Action: " + action);
        
        if (session == null) {
            System.out.println("❌ USER SERVLET - No session found");
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login first");
            return;
        }
        
        try {
            switch (action) {
                case "dashboard":
                    loadDashboardData(request, response);
                    break;
                case "products":
                    loadProductsData(request, response);
                    break;
                case "complaints":
                    loadComplaintsData(request, response);
                    break;
                case "inquiries":
                    loadInquiriesData(request, response);
                    break;
                case "faqs":
                    loadFAQsData(request, response);
                    break;
                case "profile":
                    loadProfileData(request, response);
                    break;
                case "viewComplaint":
                    viewComplaint(request, response);
                    break;
                case "new-complaint":  // ✅ FIXED: This matches the JSP links
                    loadNewComplaintPage(request, response);
                    break;
                case "changePassword": 
                    showChangePasswordPage(request, response); 
                    break;
                case "logout":
                    logout(request, response);
                    break;
                default:
                    System.out.println("🔧 USER SERVLET - Unknown action, loading dashboard");
                    loadDashboardData(request, response);
                    break;
            }
        } catch (Exception e) {
            System.out.println("❌ USER SERVLET ERROR: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Server error");
        }
        
        System.out.println("🎯 DEBUG - UserServlet doGet() COMPLETED");
    }

    private void loadDashboardData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("🎯 DEBUG - Entering loadDashboardData method");
        
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            System.out.println("❌ DEBUG - No session found");
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login first");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        Customer customer = (Customer) session.getAttribute("customer");
        
        System.out.println("🔍 DEBUG - Session Data in loadDashboardData:");
        System.out.println("   User ID: " + userId);
        System.out.println("   Role: " + role);
        System.out.println("   Customer: " + (customer != null ? customer.getFullName() : "NULL"));
        
        if (userId == null || !"customer".equals(role) || customer == null) {
            System.out.println("❌ DEBUG - Invalid session data");
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
            return;
        }

        try {
            
            System.out.println("🔍 DEBUG - Fetching complaints for user: " + userId);
            List<Complaint> userComplaints = complaintDAO.getComplaintsByUserId(userId);
            System.out.println("✅ DEBUG - Found " + (userComplaints != null ? userComplaints.size() : 0) + " complaints");
            
            
            List<Complaint> recentComplaints = userComplaints != null && userComplaints.size() > 5 
                ? userComplaints.subList(0, 5) 
                : userComplaints;

           
            int totalComplaints = userComplaints != null ? userComplaints.size() : 0;
            int pendingComplaints = 0;
            int resolvedComplaints = 0;
            
            if (userComplaints != null) {
                for (Complaint complaint : userComplaints) {
                    if (complaint.getStatus() != null) {
                        if ("RESOLVED".equals(complaint.getStatus())) {
                            resolvedComplaints++;
                        } else if ("PENDING".equals(complaint.getStatus()) || "IN_PROGRESS".equals(complaint.getStatus())) {
                            pendingComplaints++;
                        }
                    }
                }
            }

            System.out.println("🔍 DEBUG - Complaint Statistics:");
            System.out.println("   Total: " + totalComplaints);
            System.out.println("   Pending: " + pendingComplaints);
            System.out.println("   Resolved: " + resolvedComplaints);

          
            request.setAttribute("userComplaints", recentComplaints != null ? recentComplaints : new ArrayList<>());
            request.setAttribute("customer", customer);
            request.setAttribute("user", session.getAttribute("user"));
            request.setAttribute("totalComplaints", totalComplaints);
            request.setAttribute("pendingComplaints", pendingComplaints);
            request.setAttribute("resolvedComplaints", resolvedComplaints);
            
            System.out.println("✅ DEBUG - All attributes set successfully");
            System.out.println("🔄 DEBUG - Forwarding to dashboard.jsp");
            
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/dashboard.jsp");
            dispatcher.forward(request, response);
            
            System.out.println("✅ DEBUG - Forward completed successfully");
            
        } catch (Exception e) {
            System.out.println("❌ DASHBOARD DATA LOADING ERROR: " + e.getMessage());
            e.printStackTrace();
            
            
            request.setAttribute("userComplaints", new ArrayList<>());
            request.setAttribute("customer", customer);
            request.setAttribute("user", session.getAttribute("user"));
            request.setAttribute("totalComplaints", 0);
            request.setAttribute("pendingComplaints", 0);
            request.setAttribute("resolvedComplaints", 0);
            
            System.out.println("🔄 DEBUG - Forwarding to dashboard.jsp with error defaults");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/dashboard.jsp");
            dispatcher.forward(request, response);
        }
        
        System.out.println("🎯 DEBUG - loadDashboardData method COMPLETED");
    }

    private void loadProductsData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("🎯 DEBUG - Entering loadProductsData method");
        
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        String role = (String) session.getAttribute("role");
        
        if (customer == null || !"customer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
            return;
        }

        try {
            List<Product> products = productDAO.getAllProducts();
            request.setAttribute("products", products);
            request.setAttribute("customer", customer);
            
            System.out.println("🔄 SERVLET - Forwarding to products.jsp");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/products.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.out.println("❌ PRODUCTS DATA LOADING ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to load products");
            request.setAttribute("products", new ArrayList<>());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/products.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void loadComplaintsData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("🎯 DEBUG - Entering loadComplaintsData method");
        
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        String role = (String) session.getAttribute("role");
        
        if (customer == null || !"customer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
            return;
        }

        try {
            List<Complaint> complaints = complaintDAO.getComplaintsByUserId(customer.getUserId());
            request.setAttribute("complaints", complaints);
            request.setAttribute("customer", customer);
            
            System.out.println("🔄 SERVLET - Forwarding to complaints.jsp");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/complaints.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.out.println("❌ COMPLAINTS DATA LOADING ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to load complaints");
            request.setAttribute("complaints", new ArrayList<>());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/complaints.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void loadInquiriesData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("🎯 DEBUG - Entering loadInquiriesData method");
        
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        String role = (String) session.getAttribute("role");
        
        if (customer == null || !"customer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
            return;
        }

        try {
            List<Inquiry> inquiries = inquiryDAO.getInquiriesByUserId(customer.getUserId());
            request.setAttribute("inquiries", inquiries);
            request.setAttribute("customer", customer);
            
            System.out.println("🔄 SERVLET - Forwarding to inquiries.jsp");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/inquiries.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.out.println("❌ INQUIRIES DATA LOADING ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to load inquiries");
            request.setAttribute("inquiries", new ArrayList<>());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/inquiries.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void loadFAQsData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("🎯 DEBUG - Entering loadFAQsData method");
        
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        String role = (String) session.getAttribute("role");
        
        if (customer == null || !"customer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
            return;
        }

        try {
            List<FAQ> faqs = faqDAO.getAllFAQs();
            request.setAttribute("faqs", faqs);
            request.setAttribute("customer", customer);
            
            System.out.println("🔄 SERVLET - Forwarding to faqs.jsp");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/faqs.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.out.println("❌ FAQS DATA LOADING ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to load FAQs");
            request.setAttribute("faqs", new ArrayList<>());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/faqs.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void loadProfileData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("🎯 DEBUG - Entering loadProfileData method");
        
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
        
        if (customer == null || user == null || !"customer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
            return;
        }

        try {
            
            User refreshedUser = userDAO.getUserById(user.getId());
            if (refreshedUser != null) {
                session.setAttribute("user", refreshedUser);
                user = refreshedUser;
            }

            request.setAttribute("customer", customer);
            request.setAttribute("user", user);
            
            System.out.println("🔄 SERVLET - Forwarding to profile.jsp");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/profile.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.out.println("❌ PROFILE DATA LOADING ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to load profile data");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/profile.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void loadNewComplaintPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("🎯 DEBUG - Entering loadNewComplaintPage method");
        
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        String role = (String) session.getAttribute("role");
        
        if (customer == null || !"customer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
            return;
        }

        try {
            List<Product> products = productDAO.getAllProducts();
            request.setAttribute("products", products);
            request.setAttribute("customer", customer);
            
            System.out.println("🔄 SERVLET - Forwarding to complaintForm.jsp");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/complaintForm.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.out.println("❌ NEW COMPLAINT PAGE LOADING ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to load products");
            request.setAttribute("products", new ArrayList<>());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/complaintForm.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
        
        if (customer == null || user == null || !"customer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
            return;
        }

        try {
            String email = request.getParameter("email");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String company = request.getParameter("company");
            String address = request.getParameter("address");

            
            user.setEmail(email);
            boolean userUpdated = userDAO.updateUser(user);

            
            customer.setFirstName(firstName);
            customer.setLastName(lastName);
            customer.setPhone(phone);
            customer.setCompany(company);
            customer.setAddress(address);

            boolean customerUpdated = customerDAO.updateCustomer(customer);
            
            if (userUpdated && customerUpdated) {
                session.setAttribute("user", user);
                session.setAttribute("customer", customer);
                session.setAttribute("success", "Profile updated successfully!");
            } else {
                session.setAttribute("error", "Failed to update profile");
            }
        } catch (Exception e) {
            System.out.println("❌ UPDATE PROFILE ERROR: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Failed to update profile: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/user?action=profile");
    }
    
    private void viewComplaint(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("🎯 DEBUG - Entering viewComplaint method");
        
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (customer == null || !"customer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
            return;
        }

        String complaintIdStr = request.getParameter("id");
        if (complaintIdStr == null) {
            session.setAttribute("error", "Complaint ID is required");
            response.sendRedirect("user?action=complaints");
            return;
        }

        try {
            int complaintId = Integer.parseInt(complaintIdStr);
            Complaint complaint = complaintDAO.getComplaintById(complaintId);
            
            if (complaint == null) {
                session.setAttribute("error", "Complaint not found");
                response.sendRedirect("user?action=complaints");
                return;
            }

            
            if (complaint.getUserId() != userId) {
                session.setAttribute("error", "You don't have permission to view this complaint");
                response.sendRedirect("user?action=complaints");
                return;
            }

            request.setAttribute("complaint", complaint);
            request.setAttribute("customer", customer);
            
            System.out.println("🔄 SERVLET - Forwarding to complaintDetails.jsp");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/complaintDetails.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid complaint ID");
            response.sendRedirect("user?action=complaints");
        } catch (Exception e) {
            System.out.println("❌ VIEW COMPLAINT ERROR: " + e.getMessage());
            session.setAttribute("error", "Failed to load complaint details");
            response.sendRedirect("user?action=complaints");
        }
    }

    private void addComplaint(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
        
        if (user == null || !"customer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
            return;
        }

        try {
            String productId = request.getParameter("productId");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String priority = request.getParameter("priority");

            
            if (title == null || title.trim().isEmpty() || description == null || description.trim().isEmpty()) {
                session.setAttribute("error", "Title and description are required");
                response.sendRedirect(request.getContextPath() + "/user?action=newComplaint");
                return;
            }

            Complaint complaint = new Complaint();
            complaint.setUserId(user.getId());
            if (productId != null && !productId.isEmpty() && !"0".equals(productId)) {
                complaint.setProductId(Integer.parseInt(productId));
            } else {
                complaint.setProductId(0); 
            }
            complaint.setTitle(title);
            complaint.setDescription(description);
            complaint.setPriority(priority != null ? priority : "MEDIUM");
            complaint.setStatus("PENDING");

            boolean success = complaintDAO.addComplaint(complaint);
            
            if (success) {
                session.setAttribute("success", "Complaint submitted successfully!");
            } else {
                session.setAttribute("error", "Failed to submit complaint");
            }
        } catch (Exception e) {
            System.out.println("❌ ADD COMPLAINT ERROR: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Failed to submit complaint: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/user?action=complaints");
    }

    private void addInquiry(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
        
        if (user == null || !"customer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
            return;
        }

        try {
            String subject = request.getParameter("subject");
            String message = request.getParameter("message");

            
            if (subject == null || subject.trim().isEmpty() || message == null || message.trim().isEmpty()) {
                session.setAttribute("error", "Subject and message are required");
                response.sendRedirect(request.getContextPath() + "/user?action=inquiries");
                return;
            }

            Inquiry inquiry = new Inquiry();
            inquiry.setUserId(user.getId());
            inquiry.setSubject(subject);
            inquiry.setMessage(message);
            inquiry.setStatus("OPEN");

            boolean success = inquiryDAO.addInquiry(inquiry);
            
            if (success) {
                session.setAttribute("success", "Inquiry submitted successfully!");
            } else {
                session.setAttribute("error", "Failed to submit inquiry");
            }
        } catch (Exception e) {
            System.out.println("❌ ADD INQUIRY ERROR: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Failed to submit inquiry: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/user?action=inquiries");
    }

    private void deleteComplaint(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
        
        if (user == null || !"customer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
            return;
        }

        try {
            String complaintIdStr = request.getParameter("id");
            if (complaintIdStr == null || complaintIdStr.isEmpty()) {
                session.setAttribute("error", "Complaint ID is required");
                response.sendRedirect(request.getContextPath() + "/user?action=complaints");
                return;
            }

            int complaintId = Integer.parseInt(complaintIdStr);
            
            
            Complaint complaint = complaintDAO.getComplaintById(complaintId);
            if (complaint == null || complaint.getUserId() != user.getId()) {
                session.setAttribute("error", "Complaint not found or access denied");
                response.sendRedirect(request.getContextPath() + "/user?action=complaints");
                return;
            }

            boolean success = complaintDAO.deleteComplaint(complaintId);
            
            if (success) {
                session.setAttribute("success", "Complaint deleted successfully!");
            } else {
                session.setAttribute("error", "Failed to delete complaint");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid complaint ID");
        } catch (Exception e) {
            System.out.println("❌ DELETE COMPLAINT ERROR: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Failed to delete complaint: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/user?action=complaints");
    }

    private void updateComplaint(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
        
        if (user == null || !"customer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
            return;
        }

        try {
            String complaintIdStr = request.getParameter("id");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String priority = request.getParameter("priority");

            if (complaintIdStr == null || complaintIdStr.isEmpty()) {
                session.setAttribute("error", "Complaint ID is required");
                response.sendRedirect(request.getContextPath() + "/user?action=complaints");
                return;
            }

            int complaintId = Integer.parseInt(complaintIdStr);
            
            
            Complaint existingComplaint = complaintDAO.getComplaintById(complaintId);
            if (existingComplaint == null || existingComplaint.getUserId() != user.getId()) {
                session.setAttribute("error", "Complaint not found or access denied");
                response.sendRedirect(request.getContextPath() + "/user?action=complaints");
                return;
            }

            
            existingComplaint.setTitle(title);
            existingComplaint.setDescription(description);
            existingComplaint.setPriority(priority);

            boolean success = complaintDAO.updateComplaintDetails(existingComplaint);
            
            if (success) {
                session.setAttribute("success", "Complaint updated successfully!");
            } else {
                session.setAttribute("error", "Failed to update complaint");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid complaint ID");
        } catch (Exception e) {
            System.out.println("❌ UPDATE COMPLAINT ERROR: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Failed to update complaint: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/user?action=complaints");
    }
    
    private void showChangePasswordPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("🎯 DEBUG - Entering showChangePasswordPage method");
        
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        String role = (String) session.getAttribute("role");
        
        if (customer == null || !"customer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
            return;
        }

        try {
            request.setAttribute("customer", customer);
            
            System.out.println("🔄 SERVLET - Forwarding to changePassword.jsp");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/changePassword.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.out.println("❌ CHANGE PASSWORD PAGE LOADING ERROR: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user?action=profile");
        }
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
        
        if (user == null || !"customer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
            return;
        }

        try {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            
            if (currentPassword == null || currentPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {
                session.setAttribute("error", "All password fields are required");
                response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp");
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("error", "New passwords do not match");
                response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp");
                return;
            }

            if (newPassword.length() < 6) {
                session.setAttribute("error", "New password must be at least 6 characters long");
                response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp");
                return;
            }

            
            boolean currentPasswordValid = userDAO.verifyPassword(user.getId(), currentPassword);
            if (!currentPasswordValid) {
                session.setAttribute("error", "Current password is incorrect");
                response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp");
                return;
            }

            
            boolean success = userDAO.updatePassword(user.getId(), newPassword);
            
            if (success) {
                session.setAttribute("success", "Password changed successfully!");
                response.sendRedirect(request.getContextPath() + "/user?action=profile");
            } else {
                session.setAttribute("error", "Failed to change password");
                response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp");
            }
        } catch (Exception e) {
            System.out.println("❌ CHANGE PASSWORD ERROR: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Failed to change password: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp");
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/login.jsp?message=Logged out successfully");
    }
}