package com.crm.controller;

import com.crm.dao.*;
import com.crm.model.*;
import com.crm.util.EmailUtil;
import com.crm.util.PasswordUtil;
import com.crm.util.TwilioUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    private AdminDAO adminDAO;
    private UserDAO userDAO;
    private EmployeeDAO employeeDAO;
    private CustomerDAO customerDAO;
    private ComplaintDAO complaintDAO;
    private ProductDAO productDAO;
    private FAQDAO faqDAO;
    private EmailUtil emailUtil;

    @Override
    public void init() throws ServletException {
        System.out.println("🔧 ADMIN SERVLET - Initializing DAOs");
        adminDAO = new AdminDAO();
        userDAO = new UserDAO();
        employeeDAO = new EmployeeDAO();
        customerDAO = new CustomerDAO();
        complaintDAO = new ComplaintDAO();
        productDAO = new ProductDAO();
        faqDAO = new FAQDAO();
        emailUtil = new EmailUtil();
        System.out.println("✅ ADMIN SERVLET - DAOs initialized successfully");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        System.out.println("🎯 ADMIN SERVLET GET - Action: " + action);

        if (action == null) action = "dashboard";

        try {
            switch (action) {
                case "dashboard": showDashboard(request, response); break;
                case "manageUsers": showManageUsers(request, response); break;
                case "manageEmployees": showManageEmployees(request, response); break;
                case "manageProducts": showManageProducts(request, response); break;
                case "manageFAQs": showManageFAQs(request, response); break;
                case "complaints": showComplaints(request, response); break;
                case "profile": showProfile(request, response); break;
                case "downloadComplaints": downloadComplaints(request, response); break;

               
                case "viewEmployee": viewEmployee(request, response); break;
                case "addEmployee": showAddEmployeeForm(request, response); break;
                case "editEmployee": showEditEmployeeForm(request, response); break;
                case "deleteEmployee": deleteEmployee(request, response); break;
                
               
                case "viewUser": viewUser(request, response); break;
                case "createUser": showCreateUserForm(request, response); break;
                case "editUser": showEditUserForm(request, response); break;
                case "deleteUser": deleteUser(request, response); break;
                
               
                case "addProduct": showAddProductForm(request, response); break;
                case "editProduct": showEditProductForm(request, response); break;
                case "deleteProduct": deleteProduct(request, response); break;
                case "viewProduct": viewProduct(request, response); break;
                
               
                case "addFAQ": showAddFAQForm(request, response); break;
                case "editFAQ": showEditFAQForm(request, response); break;
                case "deleteFAQ": deleteFAQ(request, response); break;
                
               
                case "viewComplaint": viewComplaint(request, response); break;
                case "editComplaint": showEditComplaintForm(request, response); break;
                case "deleteComplaint": deleteComplaint(request, response); break;
                
                default: showDashboard(request, response); break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Server error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        System.out.println("📨 ADMIN SERVLET POST - Action: " + action);

        try {
            switch (action) {
                case "addEmployee": addEmployee(request, response); break;
                case "updateEmployee": updateEmployee(request, response); break;
                case "addProduct": addProduct(request, response); break;
                case "updateProduct": updateProduct(request, response); break;
                case "addFAQ": addFAQ(request, response); break;
                case "updateFAQ": updateFAQ(request, response); break;
                case "createUser": createUser(request, response); break;
                case "updateUser": updateUser(request, response); break;
                case "updateComplaint": updateComplaintPost(request, response); break;
                case "updateComplaintDetails": updateComplaintDetails(request, response); break;
                default: response.sendRedirect("admin?action=dashboard"); break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Operation failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin?action=dashboard");
        }
    }

   
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (!"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as admin");
            return;
        }

        int totalUsers = userDAO.getAllUsers().size();
        int totalEmployees = employeeDAO.getAllEmployees().size();
        int totalCustomers = customerDAO.getAllCustomers().size();
        int totalComplaints = complaintDAO.getAllComplaints().size();
        int totalProducts = productDAO.getAllProducts().size();

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalEmployees", totalEmployees);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalComplaints", totalComplaints);
        request.setAttribute("totalProducts", totalProducts);
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int userId = (int) request.getSession().getAttribute("userId");
        User user = userDAO.getUserById(userId);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/admin/profile.jsp").forward(request, response);
    }

    
    private void showManageUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            System.out.println("🎯 ADMIN SERVLET - showManageUsers method called");
            
            List<User> users = userDAO.getAllUsers();
            System.out.println("✅ ADMIN SERVLET - Loaded " + (users != null ? users.size() : 0) + " users");
            
            request.setAttribute("users", users);
            
            
            String jspPath = "/admin/manageUsers.jsp";
            System.out.println("🔄 ADMIN SERVLET - Forwarding to: " + jspPath);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
            dispatcher.forward(request, response);
            
            System.out.println("✅ ADMIN SERVLET - Forward completed successfully");
            
        } catch (Exception e) {
            System.out.println("❌ ADMIN SERVLET - Error in showManageUsers: " + e.getMessage());
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Failed to load users: " + e.getMessage());
            response.sendRedirect("admin?action=dashboard");
        }
    }
    private void showCreateUserForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/userForm.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditUserForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                response.sendRedirect("admin?action=manageUsers&error=User ID required");
                return;
            }
            
            int id = Integer.parseInt(idStr);
            User user = userDAO.getUserById(id);
            
            if (user == null) {
                response.sendRedirect("admin?action=manageUsers&error=User not found");
                return;
            }
            
            request.setAttribute("user", user);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/userForm.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("admin?action=manageUsers&error=Invalid user ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin?action=manageUsers&error=Failed to load user");
        }
    }

    private void viewUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String id = request.getParameter("id");
        System.out.println("🎯 VIEW USER - ID: " + id);
        
        if (id != null) {
            User user = userDAO.getUserById(Integer.parseInt(id));
            if (user != null) {
                System.out.println("✅ VIEW USER - Found: " + user.getUsername());
                request.setAttribute("user", user);
                request.getRequestDispatcher("/admin/userDetails.jsp").forward(request, response);
            } else {
                System.out.println("❌ VIEW USER - User not found");
                HttpSession session = request.getSession();
                session.setAttribute("error", "User not found");
                response.sendRedirect("admin?action=manageUsers");
            }
        } else {
            System.out.println("❌ VIEW USER - No ID provided");
            HttpSession session = request.getSession();
            session.setAttribute("error", "User ID required");
            response.sendRedirect("admin?action=manageUsers");
        }
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        try {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");

            System.out.println("🔧 ADMIN SERVLET - Creating user: " + username + ", email: " + email + ", role: " + role);

            
            if (username == null || username.trim().isEmpty() || 
                email == null || email.trim().isEmpty() || 
                password == null || password.trim().isEmpty() || 
                role == null || role.trim().isEmpty()) {
                
                session.setAttribute("error", "All required fields must be filled");
                response.sendRedirect("admin?action=createUser");
                return;
            }

           
            if (userDAO.usernameExists(username)) {
                session.setAttribute("error", "Username '" + username + "' already exists");
                response.sendRedirect("admin?action=createUser");
                return;
            }

            
            if (userDAO.emailExists(email)) {
                session.setAttribute("error", "Email '" + email + "' already exists");
                response.sendRedirect("admin?action=createUser");
                return;
            }

            User user = new User();
            user.setUsername(username.trim());
            user.setEmail(email.trim());
            user.setPassword(password);
            user.setPhone(phone != null ? phone.trim() : null);
            user.setRole(role);
            user.setTempPassword(true); 
            user.setActive(true);

            boolean success = userDAO.addUser(user);
            
            if (success) {
                System.out.println("✅ ADMIN SERVLET - User created successfully: " + username);
                
                
                boolean emailSent = sendUserCreationNotification(user, password);
                boolean smsSent = false;
                
                if (user.getPhone() != null && !user.getPhone().trim().isEmpty()) {
                    smsSent = sendWelcomeSMS(user, password); 
                }
                
                String successMessage = "User '" + username + "' created successfully!";
                if (emailSent) {
                    successMessage += " Email notification sent.";
                }
                if (smsSent) {
                    successMessage += " SMS notification sent.";
                }
                
                session.setAttribute("success", successMessage);
                
                
                if ("customer".equals(role)) {
                    try {
                        Customer customer = new Customer();
                        customer.setUserId(user.getId());
                        customer.setFirstName("New");
                        customer.setLastName("Customer");
                        customer.setEmail(user.getEmail());
                        customer.setPhone(user.getPhone());
                        customer.setCompany("Not specified");
                        customerDAO.addCustomer(customer);
                        System.out.println("✅ ADMIN SERVLET - Customer profile created for: " + username);
                    } catch (Exception e) {
                        System.out.println("⚠️ ADMIN SERVLET - Customer profile creation failed: " + e.getMessage());
                    }
                }
            } else {
                System.out.println("❌ ADMIN SERVLET - Failed to create user: " + username);
                session.setAttribute("error", "Failed to create user '" + username + "'");
            }
        } catch (Exception e) {
            System.out.println("❌ CREATE USER ERROR: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Failed to create user: " + e.getMessage());
        }
        
        response.sendRedirect("admin?action=manageUsers");
    }
    
    private boolean sendUserCreationNotification(User user, String plainTextPassword) {
        try {
            String message = "Your account has been created by the CRM Administrator. Please use the assigned password to log in and make sure to update your password upon first login.\n\n" +
                            "=== YOUR LOGIN CREDENTIALS ===\n" +
                            "Username: " + user.getUsername() + "\n" +
                            "Password: " + plainTextPassword + "\n" +
                            "Role: " + user.getRole() + "\n" +
                            "Email: " + user.getEmail() + "\n" +
                            (user.getPhone() != null ? "Phone: " + user.getPhone() + "\n" : "") +
                            "\n" +
                            "🔗 Login URL: http://localhost:8080/crm-system/login.jsp\n\n" +
                            "⚠️ This is a temporary password. Please change it immediately after your first login.\n\n" +
                            "Best regards,\nCRM System Administration Team";

            emailUtil.sendUserCredentials(user.getEmail(), user.getUsername(), plainTextPassword, 
                                        user.getRole(), user.getPhone(), true);
            
            System.out.println("✅ User creation email sent to: " + user.getEmail());
            return true;
            
        } catch (Exception e) {
            System.out.println("❌ Failed to send user creation email: " + e.getMessage());
            return false;
        }
    }
   
    private void sendUserCreationEmail(User user, String plainTextPassword, String message) {
        try {
            String subject = "Your CRM System Account Has Been Created";
            
            
            String htmlMessage = createEmailTemplate(user, plainTextPassword);
            
            emailUtil.sendEmail(user.getEmail(), subject, htmlMessage);
            System.out.println("✅ User creation email sent to: " + user.getEmail());
            
        } catch (Exception e) {
            System.out.println("❌ Failed to send user creation email: " + e.getMessage());
            
        }
    }

   
    private boolean sendUserCreationSMS(User user, String plainTextPassword) {
        try {
            String smsMessage = "Your CRM account has been created by Administrator.\n\n" +
                               "Username: " + user.getUsername() + "\n" +
                               "Password: " + plainTextPassword + "\n" +
                               "Role: " + user.getRole() + "\n\n" +
                               "Please login and change your password.\n" +
                               "Login: http://localhost:8080/crm-system/login.jsp\n\n" +
                               "This is a temporary password. Change it after first login.";

            
            boolean smsSent = sendWelcomeSMS(user, plainTextPassword);
            
            if (smsSent) {
                System.out.println("✅ User creation SMS sent to: " + user.getPhone());
                return true;
            } else {
                System.out.println("❌ Failed to send user creation SMS to: " + user.getPhone());
                return false;
            }
            
        } catch (Exception e) {
            System.out.println("❌ Error sending user creation SMS: " + e.getMessage());
            return false;
        }
    }
    
    private String createEmailTemplate(User user, String plainTextPassword) {
        return "<!DOCTYPE html>" +
               "<html lang=\"en\">" +
               "<head>" +
               "    <meta charset=\"UTF-8\">" +
               "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">" +
               "    <title>CRM Account Created</title>" +
               "    <style>" +
               "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
               "        .container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
               "        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0; }" +
               "        .content { background: #f9f9f9; padding: 20px; border-radius: 0 0 5px 5px; }" +
               "        .credentials { background: #fff; border: 2px solid #e0e0e0; border-radius: 5px; padding: 15px; margin: 15px 0; }" +
               "        .warning { background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 5px; padding: 15px; margin: 15px 0; color: #856404; }" +
               "        .footer { text-align: center; margin-top: 20px; padding: 20px; background: #f8f9fa; border-radius: 5px; }" +
               "        .button { display: inline-block; padding: 12px 24px; background: #007bff; color: white; text-decoration: none; border-radius: 5px; margin: 10px 0; }" +
               "    </style>" +
               "</head>" +
               "<body>" +
               "    <div class=\"container\">" +
               "        <div class=\"header\">" +
               "            <h1>Welcome to CRM System</h1>" +
               "            <p>Your account has been created successfully</p>" +
               "        </div>" +
               "        <div class=\"content\">" +
               "            <p>Dear " + user.getUsername() + ",</p>" +
               "            <p>Your account has been created by the CRM Administrator. Please use the credentials below to log in to the system.</p>" +
               "            " +
               "            <div class=\"credentials\">" +
               "                <h3>🔐 Your Login Credentials</h3>" +
               "                <p><strong>Username:</strong> " + user.getUsername() + "</p>" +
               "                <p><strong>Password:</strong> " + plainTextPassword + "</p>" +
               "                <p><strong>Role:</strong> " + user.getRole() + "</p>" +
               "                <p><strong>Email:</strong> " + user.getEmail() + "</p>" +
               "            </div>" +
               "            " +
               "            <div class=\"warning\">" +
               "                <h3>⚠️ Important Security Notice</h3>" +
               "                <p>This is a temporary password. For security reasons, please change your password immediately after your first login.</p>" +
               "            </div>" +
               "            " +
               "            <div style=\"text-align: center; margin: 20px 0;\">" +
               "                <a href=\"http://localhost:8080/crm-system/login.jsp\" class=\"button\">" +
               "                    🚀 Login to CRM System" +
               "                </a>" +
               "            </div>" +
               "            " +
               "            <p>If you have any questions or need assistance, please contact the system administrator.</p>" +
               "        </div>" +
               "        <div class=\"footer\">" +
               "            <p><strong>Best regards,</strong><br>CRM System Administration Team</p>" +
               "            <p><small>This is an automated message. Please do not reply to this email.</small></p>" +
               "        </div>" +
               "    </div>" +
               "</body>" +
               "</html>";
    }
    
    private void updateUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        try {
            String idStr = request.getParameter("id");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");
            String activeStr = request.getParameter("active");

            System.out.println("🔧 ADMIN SERVLET - Updating user ID: " + idStr);

            if (idStr == null || idStr.trim().isEmpty()) {
                session.setAttribute("error", "User ID is required");
                response.sendRedirect("admin?action=manageUsers");
                return;
            }

            int id = Integer.parseInt(idStr);
            User user = userDAO.getUserById(id);
            
            if (user == null) {
                session.setAttribute("error", "User not found with ID: " + id);
                response.sendRedirect("admin?action=manageUsers");
                return;
            }

            
            user.setEmail(email.trim());
            user.setPhone(phone != null ? phone.trim() : null);
            user.setRole(role);
            user.setActive("on".equals(activeStr));

            boolean success = userDAO.updateUser(user);
            
            if (success) {
                System.out.println("✅ ADMIN SERVLET - User updated successfully: " + user.getUsername());
                session.setAttribute("success", "User '" + user.getUsername() + "' updated successfully!");
            } else {
                System.out.println("❌ ADMIN SERVLET - Failed to update user: " + user.getUsername());
                session.setAttribute("error", "Failed to update user '" + user.getUsername() + "'");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid user ID format");
        } catch (Exception e) {
            System.out.println("❌ UPDATE USER ERROR: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Failed to update user: " + e.getMessage());
        }
        
        response.sendRedirect("admin?action=manageUsers");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        try {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                session.setAttribute("error", "User ID is required");
                response.sendRedirect("admin?action=manageUsers");
                return;
            }

            int id = Integer.parseInt(idStr);
            
           
            Integer currentUserId = (Integer) session.getAttribute("userId");
            if (currentUserId != null && id == currentUserId) {
                session.setAttribute("error", "You cannot delete your own account");
                response.sendRedirect("admin?action=manageUsers");
                return;
            }

            User user = userDAO.getUserById(id);
            if (user == null) {
                session.setAttribute("error", "User not found");
                response.sendRedirect("admin?action=manageUsers");
                return;
            }

            boolean success = userDAO.deleteUser(id);
            
            if (success) {
                session.setAttribute("success", "User '" + user.getUsername() + "' deleted successfully!");
            } else {
                session.setAttribute("error", "Failed to delete user '" + user.getUsername() + "'");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid user ID");
        } catch (Exception e) {
            System.out.println("❌ DELETE USER ERROR: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Failed to delete user: " + e.getMessage());
        }
        
        response.sendRedirect("admin?action=manageUsers");
    }

    
    private void showManageEmployees(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        
        
        String success = (String) session.getAttribute("success");
        String error = (String) session.getAttribute("error");
        
        if (success != null) {
            request.setAttribute("success", success);
            session.removeAttribute("success");
        }
        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("error");
        }
        
        List<Employee> employees = employeeDAO.getAllEmployees();
        request.setAttribute("employees", employees);
        request.getRequestDispatcher("/admin/manageEmployees.jsp").forward(request, response);
    }

    private void showAddEmployeeForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("🎯 SHOW ADD EMPLOYEE FORM");
        request.removeAttribute("employee");
        request.getRequestDispatcher("/admin/employeeForm.jsp").forward(request, response);
    }

    private void showEditEmployeeForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String id = request.getParameter("id");
        System.out.println("🎯 SHOW EDIT EMPLOYEE FORM - ID: " + id);
        
        if (id != null) {
            Employee emp = employeeDAO.getEmployeeById(Integer.parseInt(id));
            if (emp != null) {
                System.out.println("✅ SHOW EDIT EMPLOYEE FORM - Found: " + emp.getFirstName() + " " + emp.getLastName());
                
                User user = userDAO.getUserById(emp.getUserId());
                if (user != null) {
                    emp.setEmail(user.getEmail());
                    emp.setUsername(user.getUsername());
                }
                
                request.setAttribute("employee", emp);
                request.getRequestDispatcher("/admin/employeeForm.jsp").forward(request, response);
            } else {
                System.out.println("❌ SHOW EDIT EMPLOYEE FORM - Employee not found");
                HttpSession session = request.getSession();
                session.setAttribute("error", "Employee not found");
                response.sendRedirect("admin?action=manageEmployees");
            }
        } else {
            System.out.println("❌ SHOW EDIT EMPLOYEE FORM - No ID provided");
            HttpSession session = request.getSession();
            session.setAttribute("error", "Employee ID required");
            response.sendRedirect("admin?action=manageEmployees");
        }
    }

    private void viewEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String id = request.getParameter("id");
        System.out.println("🎯 VIEW EMPLOYEE - ID: " + id);
        
        if (id != null) {
            Employee employee = employeeDAO.getEmployeeById(Integer.parseInt(id));
            if (employee != null) {
                System.out.println("✅ VIEW EMPLOYEE - Found: " + employee.getFirstName() + " " + employee.getLastName());
                
                User user = userDAO.getUserById(employee.getUserId());
                if (user != null) {
                    employee.setEmail(user.getEmail());
                    employee.setUsername(user.getUsername());
                }
                
                request.setAttribute("employee", employee);
                request.getRequestDispatcher("/admin/employeeDetails.jsp").forward(request, response);
            } else {
                System.out.println("❌ VIEW EMPLOYEE - Employee not found");
                HttpSession session = request.getSession();
                session.setAttribute("error", "Employee not found");
                response.sendRedirect("admin?action=manageEmployees");
            }
        } else {
            System.out.println("❌ VIEW EMPLOYEE - No ID provided");
            HttpSession session = request.getSession();
            session.setAttribute("error", "Employee ID required");
            response.sendRedirect("admin?action=manageEmployees");
        }
    }

    private void addEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String department = request.getParameter("department");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("🎯 ADD EMPLOYEE - Creating employee: " + firstName + " " + lastName);
        
        
        if (username == null || username.trim().isEmpty()) {
            username = (firstName.charAt(0) + lastName).toLowerCase().replaceAll("\\s+", "");
        }
        
        
        if (password == null || password.trim().isEmpty()) {
            password = "Temp123!";
        }

       
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setRole("employee");
        user.setTempPassword(true);
        user.setActive(true);

        if (userDAO.addUser(user)) {
            User createdUser = userDAO.getUserByUsername(username);
            if (createdUser != null) {
                System.out.println("✅ ADD EMPLOYEE - User created, ID: " + createdUser.getId());
                
                
                Employee emp = new Employee();
                emp.setUserId(createdUser.getId());
                emp.setFirstName(firstName);
                emp.setLastName(lastName);
                emp.setDepartment(department);
                emp.setPhone(phone);
                
                if (employeeDAO.addEmployee(emp)) {
                    System.out.println("✅ ADD EMPLOYEE - Employee record created successfully");
                    session.setAttribute("success", "Employee '" + firstName + " " + lastName + "' added successfully!");
                } else {
                    System.out.println("❌ ADD EMPLOYEE - Failed to create employee record");
                    userDAO.deleteUser(createdUser.getId());
                    session.setAttribute("error", "Failed to create employee record");
                }
            } else {
                System.out.println("❌ ADD EMPLOYEE - Could not retrieve created user");
                session.setAttribute("error", "Failed to create employee user account");
            }
        } else {
            System.out.println("❌ ADD EMPLOYEE - Failed to create user account");
            session.setAttribute("error", "Failed to create employee - username/email may already exist");
        }
        
        response.sendRedirect("admin?action=manageEmployees");
    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        
        String id = request.getParameter("id");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String department = request.getParameter("department");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        System.out.println("🎯 UPDATE EMPLOYEE - ID: " + id);
        
        if (id != null) {
            Employee emp = employeeDAO.getEmployeeById(Integer.parseInt(id));
            if (emp != null) {
                System.out.println("✅ UPDATE EMPLOYEE - Found employee: " + emp.getFirstName());
                
                emp.setFirstName(firstName);
                emp.setLastName(lastName);
                emp.setDepartment(department);
                emp.setPhone(phone);
                
                User user = userDAO.getUserById(emp.getUserId());
                if (user != null) {
                    if (!user.getEmail().equals(email)) {
                        user.setEmail(email);
                        userDAO.updateUser(user);
                    }
                    
                    if (password != null && !password.trim().isEmpty()) {
                        user.setPassword(password);
                        user.setTempPassword(false);
                        userDAO.updateUser(user);
                        System.out.println("✅ UPDATE EMPLOYEE - Password updated");
                    }
                }
                
                if (employeeDAO.updateEmployee(emp)) {
                    System.out.println("✅ UPDATE EMPLOYEE - Employee updated successfully");
                    session.setAttribute("success", "Employee '" + firstName + " " + lastName + "' updated successfully!");
                } else {
                    System.out.println("❌ UPDATE EMPLOYEE - Failed to update employee");
                    session.setAttribute("error", "Failed to update employee");
                }
            } else {
                System.out.println("❌ UPDATE EMPLOYEE - Employee not found with ID: " + id);
                session.setAttribute("error", "Employee not found");
            }
        } else {
            System.out.println("❌ UPDATE EMPLOYEE - No ID provided");
            session.setAttribute("error", "Employee ID required");
        }
        
        response.sendRedirect("admin?action=manageEmployees");
    }

    private void deleteEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        String id = request.getParameter("id");
        
        System.out.println("🎯 DELETE EMPLOYEE - ID: " + id);
        
        if (id != null) {
            Employee emp = employeeDAO.getEmployeeById(Integer.parseInt(id));
            if (emp != null) {
                System.out.println("✅ DELETE EMPLOYEE - Found employee, user ID: " + emp.getUserId());
                String employeeName = emp.getFirstName() + " " + emp.getLastName();
                
                if (employeeDAO.deleteEmployee(emp.getId())) {
                    if (userDAO.deleteUser(emp.getUserId())) {
                        System.out.println("✅ DELETE EMPLOYEE - Successfully deleted");
                        session.setAttribute("success", "Employee '" + employeeName + "' deleted successfully!");
                    } else {
                        System.out.println("❌ DELETE EMPLOYEE - Failed to delete user account");
                        session.setAttribute("error", "Failed to delete user account");
                    }
                } else {
                    System.out.println("❌ DELETE EMPLOYEE - Failed to delete employee record");
                    session.setAttribute("error", "Failed to delete employee record");
                }
            } else {
                System.out.println("❌ DELETE EMPLOYEE - Employee not found");
                session.setAttribute("error", "Employee not found");
            }
        } else {
            System.out.println("❌ DELETE EMPLOYEE - No ID provided");
            session.setAttribute("error", "Employee ID required");
        }
        
        response.sendRedirect("admin?action=manageEmployees");
    }

    
    private void showManageProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        
        
        String success = (String) session.getAttribute("success");
        String error = (String) session.getAttribute("error");
        
        if (success != null) {
            request.setAttribute("success", success);
            session.removeAttribute("success");
        }
        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("error");
        }
        
        List<Product> products = productDAO.getAllProducts();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/admin/manageProducts.jsp").forward(request, response);
    }

    private void showAddProductForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/productForm.jsp").forward(request, response);
    }

    private void showEditProductForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String id = request.getParameter("id");
        if (id != null) {
            Product p = productDAO.getProductById(Integer.parseInt(id));
            if (p != null) {
                request.setAttribute("product", p);
                request.getRequestDispatcher("/admin/productForm.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Product not found");
                response.sendRedirect("admin?action=manageProducts");
            }
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Product ID required");
            response.sendRedirect("admin?action=manageProducts");
        }
    }

    private void viewProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String id = request.getParameter("id");
        if (id != null) {
            Product product = productDAO.getProductById(Integer.parseInt(id));
            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("/admin/productDetails.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Product not found");
                response.sendRedirect("admin?action=manageProducts");
            }
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Product ID required");
            response.sendRedirect("admin?action=manageProducts");
        }
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        
        Product p = new Product();
        p.setName(request.getParameter("name"));
        p.setDescription(request.getParameter("description"));
        p.setPrice(Double.parseDouble(request.getParameter("price")));
        p.setCategory(request.getParameter("category"));
        p.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));

        if (productDAO.addProduct(p)) {
            session.setAttribute("success", "Product '" + p.getName() + "' added successfully!");
        } else {
            session.setAttribute("error", "Failed to add product");
        }
        
        response.sendRedirect("admin?action=manageProducts");
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        
        Product p = new Product();
        p.setId(Integer.parseInt(request.getParameter("id")));
        p.setName(request.getParameter("name"));
        p.setDescription(request.getParameter("description"));
        p.setPrice(Double.parseDouble(request.getParameter("price")));
        p.setCategory(request.getParameter("category"));
        p.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));

        if (productDAO.updateProduct(p)) {
            session.setAttribute("success", "Product '" + p.getName() + "' updated successfully!");
        } else {
            session.setAttribute("error", "Failed to update product");
        }
        
        response.sendRedirect("admin?action=manageProducts");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        String id = request.getParameter("id");
        
        if (id != null) {
            Product product = productDAO.getProductById(Integer.parseInt(id));
            if (product != null) {
                if (productDAO.deleteProduct(Integer.parseInt(id))) {
                    session.setAttribute("success", "Product '" + product.getName() + "' deleted successfully!");
                } else {
                    session.setAttribute("error", "Failed to delete product");
                }
            } else {
                session.setAttribute("error", "Product not found");
            }
        } else {
            session.setAttribute("error", "Product ID required");
        }
        
        response.sendRedirect("admin?action=manageProducts");
    }

   
    private void showManageFAQs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        
        
        String success = (String) session.getAttribute("success");
        String error = (String) session.getAttribute("error");
        
        if (success != null) {
            request.setAttribute("success", success);
            session.removeAttribute("success");
        }
        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("error");
        }
        
        List<FAQ> faqs = faqDAO.getAllFAQs();
        request.setAttribute("faqs", faqs);
        request.getRequestDispatcher("/admin/manageFAQs.jsp").forward(request, response);
    }

    private void showAddFAQForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/faqForm.jsp").forward(request, response);
    }

    private void showEditFAQForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "FAQ ID required");
                response.sendRedirect("admin?action=manageFAQs");
                return;
            }
            
            int id = Integer.parseInt(idParam);
            FAQ faq = faqDAO.getFAQById(id);
            
            if (faq != null) {
                request.setAttribute("faq", faq);
                request.getRequestDispatcher("/admin/faqForm.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("error", "FAQ not found");
                response.sendRedirect("admin?action=manageFAQs");
            }
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Invalid FAQ ID");
            response.sendRedirect("admin?action=manageFAQs");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error loading FAQ");
            response.sendRedirect("admin?action=manageFAQs");
        }
    }

    private void addFAQ(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        
        FAQ faq = new FAQ();
        faq.setQuestion(request.getParameter("question"));
        faq.setAnswer(request.getParameter("answer"));
        faq.setCategory(request.getParameter("category"));
        faq.setCreatedBy((Integer) session.getAttribute("userId"));

        if (faqDAO.addFAQ(faq)) {
            session.setAttribute("success", "FAQ added successfully!");
        } else {
            session.setAttribute("error", "Failed to add FAQ");
        }
        
        response.sendRedirect("admin?action=manageFAQs");
    }

    private void updateFAQ(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        
        FAQ faq = new FAQ();
        faq.setId(Integer.parseInt(request.getParameter("id")));
        faq.setQuestion(request.getParameter("question"));
        faq.setAnswer(request.getParameter("answer"));
        faq.setCategory(request.getParameter("category"));

        if (faqDAO.updateFAQ(faq)) {
            session.setAttribute("success", "FAQ updated successfully!");
        } else {
            session.setAttribute("error", "Failed to update FAQ");
        }
        
        response.sendRedirect("admin?action=manageFAQs");
    }

    private void deleteFAQ(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                session.setAttribute("error", "FAQ ID required");
                response.sendRedirect("admin?action=manageFAQs");
                return;
            }
            
            int id = Integer.parseInt(idParam);
            boolean success = faqDAO.deleteFAQ(id);
            
            if (success) {
                session.setAttribute("success", "FAQ deleted successfully!");
            } else {
                session.setAttribute("error", "Failed to delete FAQ");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid FAQ ID");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error deleting FAQ");
        }
        
        response.sendRedirect("admin?action=manageFAQs");
    }

    
    private void showComplaints(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        
        
        String success = (String) session.getAttribute("success");
        String error = (String) session.getAttribute("error");
        
        if (success != null) {
            request.setAttribute("success", success);
            session.removeAttribute("success");
        }
        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("error");
        }
        
        List<Complaint> complaints = complaintDAO.getAllComplaints();
        List<Employee> employees = employeeDAO.getAllEmployees();
        request.setAttribute("complaints", complaints);
        request.setAttribute("employees", employees);
        request.getRequestDispatcher("/admin/complaints.jsp").forward(request, response);
    }

    private void showEditComplaintForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String id = request.getParameter("id");
        System.out.println("🎯 SHOW EDIT COMPLAINT FORM - ID: " + id);
        
        if (id != null) {
            Complaint complaint = complaintDAO.getComplaintById(Integer.parseInt(id));
            if (complaint != null) {
                System.out.println("✅ SHOW EDIT COMPLAINT FORM - Found: " + complaint.getTitle());
                List<Employee> employees = employeeDAO.getAllEmployees();
                request.setAttribute("complaint", complaint);
                request.setAttribute("employees", employees);
                request.getRequestDispatcher("/admin/complaintForm.jsp").forward(request, response);
            } else {
                System.out.println("❌ SHOW EDIT COMPLAINT FORM - Complaint not found");
                HttpSession session = request.getSession();
                session.setAttribute("error", "Complaint not found");
                response.sendRedirect("admin?action=complaints");
            }
        } else {
            System.out.println("❌ SHOW EDIT COMPLAINT FORM - No ID provided");
            HttpSession session = request.getSession();
            session.setAttribute("error", "Complaint ID required");
            response.sendRedirect("admin?action=complaints");
        }
    }

    private void viewComplaint(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String id = request.getParameter("id");
        System.out.println("🎯 VIEW COMPLAINT - ID: " + id);
        
        if (id != null) {
            Complaint complaint = complaintDAO.getComplaintById(Integer.parseInt(id));
            if (complaint != null) {
                System.out.println("✅ VIEW COMPLAINT - Found: " + complaint.getTitle());
                List<Employee> employees = employeeDAO.getAllEmployees();
                request.setAttribute("complaint", complaint);
                request.setAttribute("employees", employees);
                request.getRequestDispatcher("/admin/complaintDetails.jsp").forward(request, response);
            } else {
                System.out.println("❌ VIEW COMPLAINT - Complaint not found");
                HttpSession session = request.getSession();
                session.setAttribute("error", "Complaint not found");
                response.sendRedirect("admin?action=complaints");
            }
        } else {
            System.out.println("❌ VIEW COMPLAINT - No ID provided");
            HttpSession session = request.getSession();
            session.setAttribute("error", "Complaint ID required");
            response.sendRedirect("admin?action=complaints");
        }
    }

    private void deleteComplaint(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        String id = request.getParameter("id");
        
        System.out.println("🎯 DELETE COMPLAINT - ID: " + id);
        
        if (id != null) {
            Complaint complaint = complaintDAO.getComplaintById(Integer.parseInt(id));
            if (complaint != null) {
                String complaintTitle = complaint.getTitle();
                if (complaintDAO.deleteComplaint(Integer.parseInt(id))) {
                    System.out.println("✅ DELETE COMPLAINT - Successfully deleted: " + complaintTitle);
                    session.setAttribute("success", "Complaint '" + complaintTitle + "' deleted successfully!");
                } else {
                    System.out.println("❌ DELETE COMPLAINT - Failed to delete complaint");
                    session.setAttribute("error", "Failed to delete complaint");
                }
            } else {
                System.out.println("❌ DELETE COMPLAINT - Complaint not found");
                session.setAttribute("error", "Complaint not found");
            }
        } else {
            System.out.println("❌ DELETE COMPLAINT - No ID provided");
            session.setAttribute("error", "Complaint ID required");
        }
        
        response.sendRedirect("admin?action=complaints");
    }

    private void updateComplaintPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        
        String id = request.getParameter("id");
        String status = request.getParameter("status");
        String assignedTo = request.getParameter("assignedTo");
        
        System.out.println("🎯 UPDATE COMPLAINT POST - ID: " + id + ", Status: " + status + ", AssignedTo: " + assignedTo);
        
        if (id != null) {
            Complaint complaint = complaintDAO.getComplaintById(Integer.parseInt(id));
            if (complaint != null) {
                boolean success = true;
                
                
                if (status != null && !status.trim().isEmpty()) {
                    success = success && complaintDAO.updateComplaintStatus(Integer.parseInt(id), status);
                    System.out.println("✅ UPDATE COMPLAINT - Status updated to: " + status);
                }
                
                
                if (assignedTo != null && !assignedTo.trim().isEmpty()) {
                    success = success && complaintDAO.assignComplaint(Integer.parseInt(id), Integer.parseInt(assignedTo));
                    System.out.println("✅ UPDATE COMPLAINT - Assigned to: " + assignedTo);
                } else if (assignedTo != null && assignedTo.trim().isEmpty()) {
                    
                    success = success && complaintDAO.unassignComplaint(Integer.parseInt(id));
                    System.out.println("✅ UPDATE COMPLAINT - Unassigned complaint");
                }
                
                if (success) {
                    session.setAttribute("success", "Complaint updated successfully!");
                } else {
                    session.setAttribute("error", "Failed to update complaint");
                }
            } else {
                session.setAttribute("error", "Complaint not found");
            }
        } else {
            session.setAttribute("error", "Complaint ID required");
        }
        
        response.sendRedirect("admin?action=complaints");
    }

    private void updateComplaintDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        
        String id = request.getParameter("id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");
        String assignedTo = request.getParameter("assignedTo");
        
        System.out.println("🎯 UPDATE COMPLAINT DETAILS - ID: " + id);
        
        if (id != null) {
            Complaint complaint = complaintDAO.getComplaintById(Integer.parseInt(id));
            if (complaint != null) {
                complaint.setTitle(title);
                complaint.setDescription(description);
                complaint.setStatus(status);
                complaint.setPriority(priority);
                
                if (assignedTo != null && !assignedTo.trim().isEmpty()) {
                    complaint.setAssignedTo(Integer.parseInt(assignedTo));
                } else {
                    complaint.setAssignedTo(0); 
                }
                
                if (complaintDAO.updateComplaintDetails(complaint)) {
                    session.setAttribute("success", "Complaint updated successfully!");
                } else {
                    session.setAttribute("error", "Failed to update complaint");
                }
            } else {
                session.setAttribute("error", "Complaint not found");
            }
        } else {
            session.setAttribute("error", "Complaint ID required");
        }
        
        response.sendRedirect("admin?action=complaints");
    }

    
    private void downloadComplaints(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (!"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as admin");
            return;
        }

        try {
            List<Complaint> complaints = complaintDAO.getAllComplaints();
            
            
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=complaints_report.csv");
            response.setCharacterEncoding("UTF-8");
            
            
            PrintWriter writer = response.getWriter();
            
            
            writer.println("Complaint ID,User,Product,Title,Status,Priority,Assigned To,Created At,Description");
            
            
            for (Complaint complaint : complaints) {
                String userName = complaint.getUserName() != null ? complaint.getUserName() : "N/A";
                String productName = complaint.getProductName() != null ? complaint.getProductName() : "N/A";
                String assignedEmployeeName = complaint.getAssignedEmployeeName() != null ? complaint.getAssignedEmployeeName() : "Not Assigned";
                String createdAt = complaint.getCreatedAt() != null ? complaint.getCreatedAt().toString() : "N/A";
                String description = complaint.getDescription() != null ? 
                    complaint.getDescription().replace("\"", "\"\"").replace(",", ";") : "No Description";
                
                
                String title = complaint.getTitle() != null ? 
                    "\"" + complaint.getTitle().replace("\"", "\"\"") + "\"" : "\"No Title\"";
                description = "\"" + description + "\"";
                
                writer.println(complaint.getId() + "," +
                             userName + "," +
                             productName + "," +
                             title + "," +
                             complaint.getStatus() + "," +
                             complaint.getPriority() + "," +
                             assignedEmployeeName + "," +
                             createdAt + "," +
                             description);
            }
            
            writer.flush();
            writer.close();
            System.out.println("✅ Complaint report downloaded successfully");
            
        } catch (Exception e) {
            System.out.println("❌ Error downloading complaints: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Failed to download complaints report");
            response.sendRedirect("admin?action=complaints");
        }
    }

   
    private void sendWelcomeEmail(User user, String plainTextPassword, boolean isTempPassword) {
        try {
            String subject = "Welcome to CRM System - Your Account Credentials";
            
            StringBuilder body = new StringBuilder();
            body.append("Dear ").append(user.getUsername()).append(",\n\n")
                .append("Your account has been successfully created in the CRM System.\n\n")
                .append("=== YOUR LOGIN CREDENTIALS ===\n")
                .append("Username: ").append(user.getUsername()).append("\n")
                .append("Password: ").append(plainTextPassword).append("\n")
                .append("Role: ").append(user.getRole()).append("\n")
                .append("Email: ").append(user.getEmail()).append("\n");
            
            if (user.getPhone() != null && !user.getPhone().trim().isEmpty()) {
                body.append("Phone: ").append(user.getPhone()).append("\n");
            }
            
            body.append("\n");
            
            if (isTempPassword) {
                body.append("⚠️  This is a temporary password. Please change it immediately after your first login.\n\n");
            }
            
            body.append("🔗 Login URL: http://localhost:8080/crm-system/login.jsp\n\n")
                .append("Best regards,\n")
                .append("CRM System Administration Team");

            emailUtil.sendEmail(user.getEmail(), subject, body.toString());
            System.out.println("✅ Welcome email with credentials sent to: " + user.getEmail());
            
        } catch (Exception e) {
            System.out.println("❌ Failed to send welcome email: " + e.getMessage());
            throw new RuntimeException("Email sending failed", e);
        }
    }


    
 
    private boolean sendWelcomeSMS(User user, String plainTextPassword) {
        try {
            if (user.getPhone() == null || user.getPhone().trim().isEmpty()) {
                System.out.println("❌ No phone number available for SMS");
                return false;
            }
            
            System.out.println("📱 Attempting to send SMS to: " + user.getPhone());
            
            
            try {
                
                try {
                    Class.forName("com.twilio.Twilio");
                    Class.forName("org.apache.commons.logging.LogFactory");
                    System.out.println("✅ Twilio dependencies found");
                } catch (ClassNotFoundException e) {
                    System.out.println("⚠️ Twilio dependencies not available, SMS disabled");
                    return false;
                }
                
                
                boolean smsSent = TwilioUtil.sendWelcomeSMS(user.getPhone(), user.getUsername(), plainTextPassword, user.getRole());
                
                if (smsSent) {
                    System.out.println("✅ Welcome SMS with credentials sent to: " + user.getPhone());
                } else {
                    System.out.println("❌ Failed to send welcome SMS to: " + user.getPhone());
                }
                
                return smsSent;
                
            } catch (NoClassDefFoundError e) {
                System.out.println("⚠️ Twilio dependencies not available (NoClassDefFoundError), SMS disabled: " + e.getMessage());
                return false;
            } catch (Exception e) {
                System.out.println("⚠️ Twilio SMS failed, but continuing: " + e.getMessage());
                e.printStackTrace();
                return false;
            }
            
        } catch (Exception e) {
            System.out.println("❌ Error in SMS sending process: " + e.getMessage());
            return false;
        }
    }
}