package com.crm.controller;

import com.crm.dao.EmployeeDAO;
import com.crm.dao.UserDAO;
import com.crm.dao.ComplaintDAO;
import com.crm.dao.InquiryDAO;
import com.crm.model.Employee;
import com.crm.model.User;
import com.crm.model.Complaint;
import com.crm.model.Inquiry;
import com.crm.util.DBConnection;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;


public class EmployeeServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;
    private UserDAO userDAO;
    private ComplaintDAO complaintDAO;
    private InquiryDAO inquiryDAO;

    @Override
    public void init() throws ServletException {
        System.out.println("🔧 EMPLOYEE SERVLET - Initializing DAOs");
        employeeDAO = new EmployeeDAO();
        userDAO = new UserDAO();
        complaintDAO = new ComplaintDAO();
        inquiryDAO = new InquiryDAO();
        System.out.println("✅ EMPLOYEE SERVLET - DAOs initialized successfully");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "dashboard";
        }

        System.out.println("🔧 EMPLOYEE SERVLET - POST Action: " + action);
        
        try {
            switch (action) {
                case "login":
                    loginEmployee(request, response);
                    break;
                case "updateProfile":
                    updateProfile(request, response);
                    break;
                case "updateComplaintStatus":
                    updateComplaintStatus(request, response);
                    break;
                case "startWorking":
                    startWorkingOnComplaint(request, response);
                    break;
                case "updateInquiry":
                    updateInquiry(request, response);
                    break;
                case "changePassword":
                    changePassword(request, response);
                    break;
                default:
                    response.sendRedirect("employee?action=dashboard");
                    break;
            }
        } catch (Exception e) {
            System.out.println("❌ EMPLOYEE SERVLET POST ERROR: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/employee?action=dashboard&error=Server error");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "dashboard";
        }

        System.out.println("🔧 EMPLOYEE SERVLET - GET Action: " + action);
        
        try {
            switch (action) {
                case "dashboard":
                    showDashboard(request, response);
                    break;
                case "complaints":
                    showComplaints(request, response);
                    break;
                case "complaintDetails":
                    showComplaintDetails(request, response);
                    break;
                case "viewComplaint":
                    showComplaintDetails(request, response);
                    break;
                case "inquiries":
                    showInquiries(request, response);
                    break;
                case "profile":
                    showProfile(request, response);
                    break;
                case "changePassword":
                    showChangePasswordForm(request, response); // FIXED: Use correct method name
                    break;
                case "logout":
                    logout(request, response);
                    break;
                default:
                    showDashboard(request, response);
                    break;
            }
        } catch (Exception e) {
            System.out.println("❌ EMPLOYEE SERVLET GET ERROR: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Server error");
        }
    }

    private void loginEmployee(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("🔧 EMPLOYEE LOGIN - Username: " + username);

        User user = userDAO.authenticate(username, password);
        if (user != null && "employee".equals(user.getRole())) {
            System.out.println("✅ EMPLOYEE AUTH SUCCESS - User ID: " + user.getId());
            
            Employee employee = employeeDAO.getEmployeeByUserId(user.getId());
            
            if (employee != null) {
                HttpSession session = request.getSession();
                
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", "employee");
                session.setAttribute("employee", employee);
                session.setAttribute("user", user);
                
                System.out.println("✅ EMPLOYEE SESSION SET - Employee ID: " + employee.getId());
                
                session.setAttribute("success", "Login successful!");
                response.sendRedirect("employee?action=dashboard");
            } else {
                System.out.println("❌ EMPLOYEE RECORD NOT FOUND");
                request.setAttribute("error", "Employee profile not found");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else {
            System.out.println("❌ EMPLOYEE AUTH FAILED");
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        if ("admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/admin?action=dashboard");
            return;
        }
        
        if (!"employee".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access+denied.+Please+login+as+employee");
            return;
        }
        
        Employee employee = (Employee) session.getAttribute("employee");
        
        if (employee == null) {
            employee = employeeDAO.getEmployeeByUserId(userId);
            if (employee != null) {
                session.setAttribute("employee", employee);
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Employee+profile+not+found");
                return;
            }
        }

        try {
            List<Complaint> assignedComplaints = complaintDAO.getComplaintsByEmployeeId(employee.getId());
            
            int pendingComplaints = complaintDAO.getComplaintCountByEmployeeAndStatus(employee.getId(), "PENDING");
            int inProgressComplaints = complaintDAO.getComplaintCountByEmployeeAndStatus(employee.getId(), "IN_PROGRESS");
            int resolvedComplaints = complaintDAO.getComplaintCountByEmployeeAndStatus(employee.getId(), "RESOLVED");
            int totalComplaints = complaintDAO.getTotalAssignedComplaints(employee.getId());

            request.setAttribute("assignedComplaints", assignedComplaints != null ? assignedComplaints : new java.util.ArrayList<>());
            request.setAttribute("employee", employee);
            request.setAttribute("pendingComplaints", pendingComplaints);
            request.setAttribute("inProgressComplaints", inProgressComplaints);
            request.setAttribute("resolvedComplaints", resolvedComplaints);
            request.setAttribute("totalComplaints", totalComplaints);
            
            request.getRequestDispatcher("/employee/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("❌ EMPLOYEE DASHBOARD ERROR: " + e.getMessage());
            request.setAttribute("assignedComplaints", new java.util.ArrayList<>());
            request.setAttribute("employee", employee);
            request.setAttribute("pendingComplaints", 0);
            request.setAttribute("inProgressComplaints", 0);
            request.setAttribute("resolvedComplaints", 0);
            request.setAttribute("totalComplaints", 0);
            request.getRequestDispatcher("/employee/dashboard.jsp").forward(request, response);
        }
    }

    private void showComplaints(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");
        String role = (String) session.getAttribute("role");
        
        if (employee == null || !"employee".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as employee");
            return;
        }

        try {
            List<Complaint> complaints = complaintDAO.getComplaintsByEmployeeId(employee.getId());
            
            request.setAttribute("complaints", complaints != null ? complaints : new java.util.ArrayList<>());
            request.setAttribute("employee", employee);
            
            request.getRequestDispatcher("/employee/complaints.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("❌ EMPLOYEE COMPLAINTS ERROR: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/employee?action=dashboard&error=Failed to load complaints");
        }
    }

    private void showComplaintDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");
        String role = (String) session.getAttribute("role");
        
        if (employee == null || !"employee".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as employee");
            return;
        }

        String complaintIdStr = request.getParameter("id");
        if (complaintIdStr == null) {
            session.setAttribute("error", "Complaint ID is required");
            response.sendRedirect("employee?action=complaints");
            return;
        }

        try {
            int complaintId = Integer.parseInt(complaintIdStr);
            Complaint complaint = complaintDAO.getComplaintById(complaintId);
            
            if (complaint == null) {
                session.setAttribute("error", "Complaint not found");
                response.sendRedirect("employee?action=complaints");
                return;
            }

            
            if (complaint.getAssignedTo() != employee.getId()) {
                session.setAttribute("error", "This complaint is not assigned to you");
                response.sendRedirect("employee?action=complaints");
                return;
            }

            request.setAttribute("complaint", complaint);
            request.setAttribute("employee", employee);
            
            request.getRequestDispatcher("/employee/complaintDetails.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid complaint ID");
            response.sendRedirect("employee?action=complaints");
        } catch (Exception e) {
            System.out.println("❌ EMPLOYEE COMPLAINT DETAILS ERROR: " + e.getMessage());
            session.setAttribute("error", "Failed to load complaint details");
            response.sendRedirect("employee?action=complaints");
        }
    }

    private void showInquiries(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");
        String role = (String) session.getAttribute("role");
        
        if (employee == null || !"employee".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as employee");
            return;
        }

        try {
            List<Inquiry> inquiries = inquiryDAO.getAllInquiries();
            request.setAttribute("inquiries", inquiries != null ? inquiries : new java.util.ArrayList<>());
            request.setAttribute("employee", employee);
            
            request.getRequestDispatcher("/employee/inquiries.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("❌ EMPLOYEE INQUIRIES ERROR: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/employee?action=dashboard&error=Failed to load inquiries");
        }
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
        
        if (employee == null || user == null || !"employee".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as employee");
            return;
        }

        User refreshedUser = userDAO.getUserById(user.getId());
        if (refreshedUser != null) {
            session.setAttribute("user", refreshedUser);
            user = refreshedUser;
        }

        request.setAttribute("employee", employee);
        request.setAttribute("user", user);
        
        request.getRequestDispatcher("/employee/profile.jsp").forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");
        String role = (String) session.getAttribute("role");
        
        if (employee == null || !"employee".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as employee");
            return;
        }

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String department = request.getParameter("department");

        employee.setFirstName(firstName);
        employee.setLastName(lastName);
        employee.setPhone(phone);
        employee.setDepartment(department);

        boolean success = employeeDAO.updateEmployee(employee);
        
        if (success) {
            session.setAttribute("employee", employee);
            session.setAttribute("success", "Profile updated successfully!");
        } else {
            session.setAttribute("error", "Failed to update profile");
        }
        
        response.sendRedirect("employee?action=profile");
    }

    private void updateComplaintStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");
        String role = (String) session.getAttribute("role");
        
        if (employee == null || !"employee".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as employee");
            return;
        }

        String complaintIdStr = request.getParameter("id");
        String status = request.getParameter("status");
        String source = request.getParameter("source");
        String remarks = request.getParameter("remarks");

        System.out.println("🔧 UPDATE COMPLAINT STATUS - ID: " + complaintIdStr + ", Status: " + status + ", Source: " + source);

        if (complaintIdStr == null || status == null) {
            session.setAttribute("error", "Complaint ID and status are required");
            response.sendRedirect("employee?action=complaints");
            return;
        }

        try {
            int complaintId = Integer.parseInt(complaintIdStr);
            
            Complaint complaint = complaintDAO.getComplaintById(complaintId);
            if (complaint == null) {
                session.setAttribute("error", "Complaint not found");
                response.sendRedirect("employee?action=complaints");
                return;
            }
            
            if (complaint.getAssignedTo() != employee.getId()) {
                session.setAttribute("error", "Complaint not assigned to you");
                response.sendRedirect("employee?action=complaints");
                return;
            }

            boolean success = complaintDAO.updateComplaintStatus(complaintId, status);
            
            if (success) {
                session.setAttribute("success", "Complaint status updated to " + status + " successfully!");
                System.out.println("✅ SUCCESS: Complaint " + complaintId + " status updated to " + status);
            } else {
                session.setAttribute("error", "Failed to update complaint status");
                System.out.println("❌ ERROR: Failed to update complaint status");
            }
            
            
            if ("details".equals(source)) {
                response.sendRedirect("employee?action=viewComplaint&id=" + complaintId);
            } else {
                response.sendRedirect("employee?action=complaints");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid complaint ID");
            response.sendRedirect("employee?action=complaints");
        } catch (Exception e) {
            session.setAttribute("error", "Database error: " + e.getMessage());
            System.out.println("❌ DATABASE ERROR: " + e.getMessage());
            response.sendRedirect("employee?action=complaints");
        }
    }

    private void startWorkingOnComplaint(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");
        String role = (String) session.getAttribute("role");
        
        if (employee == null || !"employee".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as employee");
            return;
        }

        String complaintIdStr = request.getParameter("id");
        String source = request.getParameter("source");

        System.out.println("🔧 START WORKING ON COMPLAINT - ID: " + complaintIdStr + ", Source: " + source);

        if (complaintIdStr == null) {
            session.setAttribute("error", "Complaint ID is required");
            response.sendRedirect("employee?action=complaints");
            return;
        }

        try {
            int complaintId = Integer.parseInt(complaintIdStr);
            
            Complaint complaint = complaintDAO.getComplaintById(complaintId);
            if (complaint == null) {
                session.setAttribute("error", "Complaint not found");
                response.sendRedirect("employee?action=complaints");
                return;
            }
            
            if (complaint.getAssignedTo() != employee.getId()) {
                session.setAttribute("error", "Complaint not assigned to you");
                response.sendRedirect("employee?action=complaints");
                return;
            }

            boolean success = complaintDAO.updateComplaintStatus(complaintId, "IN_PROGRESS");
            
            if (success) {
                session.setAttribute("success", "You have started working on this complaint!");
                System.out.println("✅ SUCCESS: Started working on complaint " + complaintId);
            } else {
                session.setAttribute("error", "Failed to start working on complaint");
                System.out.println("❌ ERROR: Failed to start working on complaint");
            }
            
            if ("details".equals(source)) {
                response.sendRedirect("employee?action=viewComplaint&id=" + complaintId);
            } else {
                response.sendRedirect("employee?action=complaints");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid complaint ID");
            response.sendRedirect("employee?action=complaints");
        } catch (Exception e) {
            session.setAttribute("error", "Database error: " + e.getMessage());
            System.out.println("❌ DATABASE ERROR: " + e.getMessage());
            response.sendRedirect("employee?action=complaints");
        }
    }

    private void updateInquiry(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");
        String role = (String) session.getAttribute("role");
        
        if (employee == null || !"employee".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as employee");
            return;
        }

        String inquiryIdStr = request.getParameter("id");
        String responseText = request.getParameter("response");
        String status = request.getParameter("status");

        if (inquiryIdStr == null || responseText == null || status == null) {
            session.setAttribute("error", "All fields are required");
            response.sendRedirect("employee?action=inquiries");
            return;
        }

        try {
            int inquiryId = Integer.parseInt(inquiryIdStr);
            Inquiry inquiry = inquiryDAO.getInquiryById(inquiryId);
            if (inquiry != null) {
                inquiry.setResponse(responseText);
                inquiry.setStatus(status);
                boolean success = inquiryDAO.updateInquiry(inquiry);
                
                if (success) {
                    session.setAttribute("success", "Inquiry response submitted successfully!");
                } else {
                    session.setAttribute("error", "Failed to submit inquiry response");
                }
            } else {
                session.setAttribute("error", "Inquiry not found");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid inquiry ID");
        } catch (Exception e) {
            session.setAttribute("error", "Database error: " + e.getMessage());
        }
        
        response.sendRedirect("employee?action=inquiries");
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
        
        if (user == null || !"employee".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as employee");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || currentPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            session.setAttribute("error", "All password fields are required");
            response.sendRedirect("employee?action=changePassword");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("error", "New passwords do not match");
            response.sendRedirect("employee?action=changePassword");
            return;
        }

        if (newPassword.length() < 6) {
            session.setAttribute("error", "New password must be at least 6 characters long");
            response.sendRedirect("employee?action=changePassword");
            return;
        }

        boolean currentPasswordValid = userDAO.verifyPassword(user.getId(), currentPassword);
        if (!currentPasswordValid) {
            session.setAttribute("error", "Current password is incorrect");
            response.sendRedirect("employee?action=changePassword");
            return;
        }

        boolean success = userDAO.updatePassword(user.getId(), newPassword);
        
        if (success) {
            session.setAttribute("success", "Password changed successfully!");
            response.sendRedirect("employee?action=profile");
        } else {
            session.setAttribute("error", "Failed to change password");
            response.sendRedirect("employee?action=changePassword");
        }
    }
    
    
    private void showChangePasswordForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
        
        if (employee == null || user == null || !"employee".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as employee");
            return;
        }

        request.setAttribute("employee", employee);
        request.setAttribute("user", user);
        
        
        request.getRequestDispatcher("/employee/changePassword.jsp").forward(request, response);
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/login.jsp?message=Logged out successfully");
    }
}