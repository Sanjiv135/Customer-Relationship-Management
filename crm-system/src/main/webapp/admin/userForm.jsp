<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.crm.model.User" %>
<%
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    
    if (userId == null || !"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as admin");
        return;
    }
    
    User user = (User) request.getAttribute("user");
    boolean isEdit = user != null;
    
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    
    
    if (success != null) session.removeAttribute("success");
    if (error != null) session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit User" : "Create User" %> - CRM System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .form-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .required-field::after {
            content: " *";
            color: #dc3545;
        }
        .password-strength {
            font-size: 0.875em;
            margin-top: 0.25rem;
        }
        .notification-info {
            background-color: #e7f3ff;
            border-left: 4px solid #007bff;
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
         
            <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar">
                <div class="position-sticky pt-3">
                    <div class="text-center text-white mb-4">
                        <h5>CRM System</h5>
                        <small>Admin Panel</small>
                    </div>
                    <div class="text-white mb-3 text-center">
                        <i class="fas fa-user-shield"></i> Welcome, <%= username %>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=dashboard">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=manageEmployees">
                                <i class="fas fa-users"></i> Manage Employees
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/admin?action=manageUsers">
                                <i class="fas fa-user-friends"></i> Manage Users
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=manageProducts">
                                <i class="fas fa-boxes"></i> Manage Products
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=complaints">
                                <i class="fas fa-exclamation-circle"></i> Complaints
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=manageFAQs">
                                <i class="fas fa-question-circle"></i> Manage FAQs
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=profile">
                                <i class="fas fa-user-cog"></i> Profile
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-danger" href="${pageContext.request.contextPath}/auth?action=logout">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

          
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="fas fa-user-<%= isEdit ? "edit" : "plus" %>"></i> 
                        <%= isEdit ? "Edit User" : "Create New User" %>
                    </h1>
                    <a href="${pageContext.request.contextPath}/admin?action=manageUsers" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Users
                    </a>
                </div>

                
                <% if (success != null) { %>
                    <div class="alert alert-success alert-dismissible fade show">
                        <i class="fas fa-check-circle"></i> <%= success %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <% if (error != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="fas fa-exclamation-circle"></i> <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <div class="card shadow form-container">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-user-circle"></i> 
                            <%= isEdit ? "Edit User Information" : "Create New User" %>
                        </h5>
                    </div>
                    <div class="card-body">
                       
                        <% if (!isEdit) { %>
                        <div class="notification-info">
                            <i class="fas fa-info-circle text-primary"></i>
                            <strong>Notification Information:</strong> 
                            When you create a new user, they will receive their login credentials via email 
                            <% if (!isEdit) { %>and SMS (if phone number is provided)<% } %>.
                            The password will be marked as temporary and they'll be prompted to change it on first login.
                        </div>
                        <% } %>

                        
                        <form action="${pageContext.request.contextPath}/admin" method="post" id="userForm">
                            <input type="hidden" name="action" value="<%= isEdit ? "updateUser" : "createUser" %>">
                            
                            <% if (isEdit) { %>
                                <input type="hidden" name="id" value="<%= user.getId() %>">
                            <% } %>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label required-field">Username</label>
                                    <input type="text" class="form-control" name="username"
                                           value="<%= isEdit ? user.getUsername() : "" %>"
                                           <%= isEdit ? "readonly" : "required" %> 
                                           placeholder="Enter unique username">
                                    <div class="form-text text-muted">
                                        <%= isEdit ? "Username cannot be changed" : "Choose a unique username (3-20 characters)" %>
                                    </div>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label class="form-label required-field">Email</label>
                                    <input type="email" class="form-control" name="email"
                                           value="<%= isEdit ? user.getEmail() : "" %>"
                                           required placeholder="user@example.com">
                                    <div class="form-text text-muted">User's email address for notifications</div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label <%= isEdit ? "" : "required-field" %>">Password</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" name="password" id="password"
                                               <%= isEdit ? "" : "required" %>
                                               placeholder="<%= isEdit ? "Leave blank to keep current" : "Enter password" %>"
                                               minlength="6">
                                        <% if (!isEdit) { %>
                                        <button type="button" class="btn btn-outline-secondary" onclick="generatePassword()" title="Generate Secure Password">
                                            <i class="fas fa-key"></i> Generate
                                        </button>
                                        <% } %>
                                    </div>
                                    <div id="passwordStrength" class="password-strength"></div>
                                    <div class="form-text text-muted">
                                        <%= isEdit ? "Leave blank to keep existing password" : "Minimum 6 characters. For security, use the generate button." %>
                                    </div>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Phone Number</label>
                                    <input type="tel" class="form-control" name="phone"
                                           value="<%= isEdit && user.getPhone() != null ? user.getPhone() : "" %>"
                                           placeholder="+1-555-0123">
                                    <div class="form-text text-muted">Optional phone number for SMS notifications</div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label required-field">Role</label>
                                    <select class="form-select" name="role" required>
                                        <option value="">Select Role</option>
                                        <option value="admin" <%= isEdit && "admin".equals(user.getRole()) ? "selected" : "" %>>Admin</option>
                                        <option value="employee" <%= isEdit && "employee".equals(user.getRole()) ? "selected" : "" %>>Employee</option>
                                        <option value="customer" <%= isEdit && "customer".equals(user.getRole()) ? "selected" : "" %>>Customer</option>
                                    </select>
                                    <div class="form-text text-muted">User's system role</div>
                                </div>
                                
                                <% if (isEdit) { %>
                                <div class="col-md-6 mb-3">
                                    <div class="form-check form-switch mt-4">
                                        <input class="form-check-input" type="checkbox" role="switch" id="active" name="active" 
                                               <%= user.isActive() ? "checked" : "" %>>
                                        <label class="form-check-label" for="active">Active User</label>
                                    </div>
                                    <div class="form-text text-muted">Toggle user activation status</div>
                                </div>
                                <% } %>
                            </div>

                            <div class="text-end mt-4 pt-3 border-top">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-<%= isEdit ? "save" : "user-plus" %>"></i>
                                    <%= isEdit ? "Update User" : "Create User" %>
                                </button>
                                <a href="${pageContext.request.contextPath}/admin?action=manageUsers" class="btn btn-outline-secondary btn-lg">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        
        document.getElementById('userForm').addEventListener('submit', function(e) {
            const requiredFields = this.querySelectorAll('[required]');
            let isValid = true;
            
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    field.classList.add('is-invalid');
                    isValid = false;
                } else {
                    field.classList.remove('is-invalid');
                }
            });

            
            const passwordField = document.getElementById('password');
            if (!<%= isEdit %> && passwordField.value.length < 6) {
                passwordField.classList.add('is-invalid');
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
                showToast('Please fill in all required fields correctly.', 'danger');
            }
        });

        
        document.querySelectorAll('input[required]').forEach(field => {
            field.addEventListener('input', function() {
                if (this.value.trim()) {
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');
                } else {
                    this.classList.remove('is-valid');
                }
            });
        });

        
        function generatePassword() {
            const length = 12;
            const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*";
            let password = "";
            
            
            password += "ABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt(Math.floor(Math.random() * 26)); 
            password += "abcdefghijklmnopqrstuvwxyz".charAt(Math.floor(Math.random() * 26)); 
            password += "0123456789".charAt(Math.floor(Math.random() * 10)); 
            password += "!@#$%^&*".charAt(Math.floor(Math.random() * 8)); 
            
            
            for (let i = 4; i < length; i++) {
                password += charset.charAt(Math.floor(Math.random() * charset.length));
            }
            
            
            password = password.split('').sort(function(){return 0.5-Math.random()}).join('');
            
            
            const passwordField = document.getElementById('password');
            passwordField.type = 'text';
            passwordField.value = password;
            
           
            updatePasswordStrength(password);
            
          
            showToast('Secure password generated! User will receive this via email/SMS.', 'success');
            
           
            setTimeout(() => {
                passwordField.type = 'password';
            }, 5000);
        }

        
        function updatePasswordStrength(password) {
            const strengthIndicator = document.getElementById('passwordStrength');
            const strength = calculatePasswordStrength(password);
            strengthIndicator.innerHTML = `Password strength: <span class="text-${strength.color}">${strength.text}</span>`;
            strengthIndicator.className = `password-strength text-${strength.color}`;
        }

        function calculatePasswordStrength(password) {
            let score = 0;
            
            if (password.length >= 8) score++;
            if (password.match(/[a-z]/)) score++;
            if (password.match(/[A-Z]/)) score++;
            if (password.match(/[0-9]/)) score++;
            if (password.match(/[^a-zA-Z0-9]/)) score++;
            if (password.length >= 12) score++;
            
            const levels = [
                { text: 'Very Weak', color: 'danger' },
                { text: 'Weak', color: 'danger' },
                { text: 'Fair', color: 'warning' },
                { text: 'Good', color: 'info' },
                { text: 'Strong', color: 'success' },
                { text: 'Very Strong', color: 'success' },
                { text: 'Excellent', color: 'success' }
            ];
            
            return levels[Math.min(score, levels.length - 1)];
        }

        
        document.getElementById('password').addEventListener('input', function() {
            updatePasswordStrength(this.value);
        });

       
        function showToast(message, type) {
            const toast = document.createElement('div');
            toast.className = 'alert alert-' + type + ' alert-dismissible fade show';
            toast.style.position = 'fixed';
            toast.style.top = '20px';
            toast.style.right = '20px';
            toast.style.zIndex = '9999';
            toast.style.minWidth = '300px';
            
            
            var iconClass = 'fa-exclamation-circle';
            if (type === 'success') {
                iconClass = 'fa-check-circle';
            }
            
            toast.innerHTML = 
                '<i class="fas ' + iconClass + '"></i> ' + message +
                '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
            
            document.body.appendChild(toast);
            
            setTimeout(() => {
                if (toast.parentNode) {
                    toast.remove();
                }
            }, 5000);
        }

       
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 5000);
            });
        });
    </script>
</body>
</html>