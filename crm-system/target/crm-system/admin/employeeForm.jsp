<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.crm.model.Employee" %>
<%
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    
    if (userId == null || !"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as admin");
        return;
    }
    
    Employee employee = (Employee) request.getAttribute("employee");
    boolean isEdit = employee != null;
    
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Employee" : "Add Employee" %> - CRM System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
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
                        <i class="fas fa-user-shield"></i> Welcome, <%= session.getAttribute("username") %>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=dashboard">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/admin?action=manageEmployees">
                                <i class="fas fa-users"></i> Manage Employees
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=manageUsers">
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
                        <%= isEdit ? "Edit Employee" : "Add New Employee" %>
                    </h1>
                    <a href="${pageContext.request.contextPath}/admin?action=manageEmployees" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to List
                    </a>
                </div>

                <% if (success != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i> <%= success %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                <% if (error != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <div class="card shadow">
                    <div class="card-header bg-white">
                        <h5 class="card-title mb-0"><i class="fas fa-user"></i> Employee Information</h5>
                    </div>
                    <div class="card-body">
                        <form id="employeeForm" method="post"
                              action="${pageContext.request.contextPath}/admin?action=<%= isEdit ? "updateEmployee" : "addEmployee" %>">
                              
                            <% if (isEdit) { %>
                                <input type="hidden" name="id" value="<%= employee.getId() %>">
                            <% } %>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="firstName" class="form-label">First Name *</label>
                                    <input type="text" class="form-control" id="firstName" name="firstName"
                                           value="<%= isEdit && employee.getFirstName() != null ? employee.getFirstName() : "" %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="lastName" class="form-label">Last Name *</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName"
                                           value="<%= isEdit && employee.getLastName() != null ? employee.getLastName() : "" %>" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">Email *</label>
                                    <input type="email" class="form-control" id="email" name="email"
                                           value="<%= isEdit && employee.getEmail() != null ? employee.getEmail() : "" %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Phone</label>
                                    <input type="tel" class="form-control" id="phone" name="phone"
                                           value="<%= isEdit && employee.getPhone() != null ? employee.getPhone() : "" %>"
                                           placeholder="+91-99999-99999">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="department" class="form-label">Department</label>
                                <input type="text" class="form-control" id="department" name="department"
                                       value="<%= isEdit && employee.getDepartment() != null ? employee.getDepartment() : "" %>"
                                       placeholder="e.g., Sales, Support, HR">
                            </div>

                            <% if (!isEdit) { %>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="username" class="form-label">Username</label>
                                    <input type="text" class="form-control" id="username" name="username"
                                           placeholder="Leave blank to auto-generate">
                                    <div class="form-text">If left blank, username will be auto-generated</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="password" name="password"
                                           placeholder="Leave blank for default password">
                                    <div class="form-text">If left blank, default password will be set</div>
                                </div>
                            </div>
                            <% } else { %>
                                <div class="mb-3">
                                    <label for="password" class="form-label">New Password</label>
                                    <input type="password" class="form-control" id="password" name="password"
                                           placeholder="Leave blank to keep current password">
                                    <div class="form-text">Only enter if you want to change the password</div>
                                </div>
                            <% } %>

                            <div class="d-flex justify-content-between mt-4">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-<%= isEdit ? "save" : "user-plus" %>"></i>
                                    <%= isEdit ? "Update Employee" : "Create Employee" %>
                                </button>
                                <a href="${pageContext.request.contextPath}/admin?action=manageEmployees" class="btn btn-secondary btn-lg">
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
        
        document.getElementById('firstName')?.addEventListener('blur', generateUsername);
        document.getElementById('lastName')?.addEventListener('blur', generateUsername);
        
        function generateUsername() {
            if (!<%= isEdit %>) {
                const firstName = document.getElementById('firstName').value.trim();
                const lastName = document.getElementById('lastName').value.trim();
                const usernameField = document.getElementById('username');
                
                if (firstName && lastName && (!usernameField.value || usernameField.value.startsWith(firstName.charAt(0).toLowerCase()))) {
                    const username = (firstName.charAt(0) + lastName).toLowerCase().replaceAll('\\s+', '');
                    usernameField.value = username;
                }
            }
        }
        
        
        document.getElementById('employeeForm').addEventListener('submit', function(e) {
            const requiredFields = this.querySelectorAll('[required]');
            let valid = true;
            
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    field.classList.add('is-invalid');
                    valid = false;
                } else {
                    field.classList.remove('is-invalid');
                }
            });
            
            if (!valid) {
                e.preventDefault();
                alert('Please fill in all required fields.');
            }
        });
    </script>
</body>
</html>