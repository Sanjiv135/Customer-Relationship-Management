package com.crm.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.crm.dao.UserDAO;
import com.crm.dao.EmployeeDAO;
import com.crm.dao.CustomerDAO;
import com.crm.model.User;
import com.crm.model.Employee;
import com.crm.model.Customer;
import com.crm.util.DBConnection;
import com.crm.util.PasswordUtil; // ADDED MISSING IMPORT


public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private EmployeeDAO employeeDAO;
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        employeeDAO = new EmployeeDAO();
        customerDAO = new CustomerDAO();
        
        
        System.out.println("🔍 Testing database connection on servlet init...");
        boolean dbConnected = DBConnection.testConnection();
        System.out.println("📊 Database connection test result: " + (dbConnected ? "SUCCESS" : "FAILED"));
        
        if (!dbConnected) {
            System.out.println("🚨 WARNING: Database connection failed on startup");
            System.out.println("💡 The application will try to connect when needed");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            logout(request, response);
        } else {
            
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("signup".equals(action)) {
            signup(request, response);
        } else if ("login".equals(action)) {
            login(request, response);
        } else if ("changePassword".equals(action)) {
            changePassword(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid request");
        }
    }

    private void signup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String company = request.getParameter("company");
        String address = request.getParameter("address");
        String role = "customer";

        
        if (username == null || username.trim().isEmpty() || 
            email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty() ||
            firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty()) {
            
            request.getSession().setAttribute("error", "All required fields must be filled");
            response.sendRedirect(request.getContextPath() + "/signup.jsp");
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);
        user.setPhone(phone);
        user.setRole(role);
        user.setTempPassword(false);
        user.setActive(true);

        if (userDAO.addUser(user)) {
            
            Customer customer = new Customer();
            customer.setUserId(user.getId());
            customer.setFirstName(firstName);
            customer.setLastName(lastName);
            customer.setPhone(phone);
            customer.setEmail(email);
            customer.setCompany(company);
            customer.setAddress(address);
            
            CustomerDAO customerDAO = new CustomerDAO();
            customerDAO.addCustomer(customer);
            
            response.sendRedirect(request.getContextPath() + "/login.jsp?success=Account created successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/signup.jsp?error=Failed to create account");
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        System.out.println("🔐 LOGIN ATTEMPT STARTED");
        System.out.println("   Username: " + username);
        System.out.println("   Role selected: " + role);

        
        boolean dbConnected = DBConnection.testConnection();
        if (!dbConnected) {
            System.out.println("❌ DATABASE CONNECTION FAILED - Cannot proceed with login");
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Database connection failed. Please check if MySQL is running.");
            return;
        }

        
        userDAO.debugUserCheck(username, password);

        User user = userDAO.authenticate(username, password);

        System.out.println("🔐 AUTHENTICATION RESULT:");
        System.out.println("   User object: " + (user != null ? "NOT NULL" : "NULL"));
        if (user != null) {
            System.out.println("   User ID: " + user.getId());
            System.out.println("   User Role: " + user.getRole());
            System.out.println("   Requested Role: " + role);
            System.out.println("   Roles match: " + user.getRole().equals(role));
        }

        if (user != null) {
            
            if (!user.getRole().equals(role)) {
                System.out.println("❌ ROLE MISMATCH - User role: " + user.getRole() + ", Requested role: " + role);
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid role for this user");
                return;
            }

            HttpSession session = request.getSession();
            session.invalidate();
            session = request.getSession(true);
            
            
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("user", user);

            System.out.println("✅ SESSION CREATED:");
            System.out.println("   Session ID: " + session.getId());
            System.out.println("   UserId: " + session.getAttribute("userId"));
            System.out.println("   Username: " + session.getAttribute("username"));
            System.out.println("   Role: " + session.getAttribute("role"));

            
            if ("employee".equals(user.getRole())) {
                System.out.println("🔍 AUTH - Looking up employee details for user_id: " + user.getId());
                Employee employee = employeeDAO.getEmployeeByUserId(user.getId());
                if (employee != null) {
                    session.setAttribute("employee", employee);
                    System.out.println("✅ AUTH - Employee object set in session: " + employee.getFirstName() + " " + employee.getLastName());
                }
            } else if ("customer".equals(user.getRole())) {
                System.out.println("🔍 AUTH - Looking up customer details for user_id: " + user.getId());
                Customer customer = customerDAO.getCustomerByUserId(user.getId());
                if (customer != null) {
                    session.setAttribute("customer", customer);
                    System.out.println("✅ AUTH - Customer object set in session: " + customer.getFirstName() + " " + customer.getLastName());
                }
            }

           
            if (user.isTempPassword()) {
                System.out.println("📝 User has temp password, redirecting to change password");
                session.setAttribute("hasTempPassword", true); 
                response.sendRedirect(request.getContextPath() + "/change-password.jsp");
                return;
            }

           
            String redirectUrl;
            String contextPath = request.getContextPath();
            
            switch (user.getRole()) {
                case "admin":
                    redirectUrl = contextPath + "/admin?action=dashboard";
                    break;
                case "employee":
                    redirectUrl = contextPath + "/employee?action=dashboard";
                    break;
                case "customer":
                    redirectUrl = contextPath + "/user?action=dashboard";
                    break;
                default:
                    redirectUrl = contextPath + "/login.jsp?error=Invalid role";
                    break;
            }

            System.out.println("🔄 FINAL REDIRECT: " + redirectUrl);
            response.sendRedirect(redirectUrl);

        } else {
            System.out.println("❌ AUTHENTICATION FAILED - User not found or password incorrect");
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid credentials");
        }

        System.out.println("🔐 LOGIN PROCESS COMPLETED\n");
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp?success=Logged out successfully");
    }
    
    protected void changePassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        
        Boolean hasTempPassword = (Boolean) session.getAttribute("hasTempPassword");
        boolean isTempPasswordFlow = hasTempPassword != null && hasTempPassword;
        
        try {
            
            if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("error", "New passwords do not match");
                response.sendRedirect("change-password.jsp");
                return;
            }
            
            
            if (newPassword.length() < 6) {
                session.setAttribute("error", "Password must be at least 6 characters long");
                response.sendRedirect("change-password.jsp");
                return;
            }
            
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserById(userId);
            
            if (user == null) {
                session.setAttribute("error", "User not found");
                response.sendRedirect("change-password.jsp");
                return;
            }
            
            
            if (!isTempPasswordFlow) {
                
                if (!userDAO.verifyPassword(userId, currentPassword)) {
                    session.setAttribute("error", "Current password is incorrect");
                    response.sendRedirect("change-password.jsp");
                    return;
                }
            }
            
            
            boolean success = userDAO.updatePassword(userId, newPassword);
            
            if (success) {
                
                if (isTempPasswordFlow) {
                    userDAO.clearTempPassword(userId);
                    session.removeAttribute("hasTempPassword");
                }
                
                session.setAttribute("success", "Password changed successfully");
                
                
                if (isTempPasswordFlow) {
                    
                    String redirectUrl = role + "?action=dashboard";
                    response.sendRedirect(redirectUrl);
                } else {
                   
                    response.sendRedirect("change-password.jsp");
                }
            } else {
                session.setAttribute("error", "Failed to change password");
                response.sendRedirect("change-password.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error changing password: " + e.getMessage());
            response.sendRedirect("change-password.jsp");
        }
    }
}