<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.crm.model.Employee" %>
<%@ page import="com.crm.model.User" %>
<%
    String role = (String) session.getAttribute("role");
    Employee employee = (Employee) session.getAttribute("employee");
    User user = (User) session.getAttribute("user");
    
    if (employee == null || user == null || !"employee".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as employee");
        return;
    }
    
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password - CRM System</title>
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
                        <small>Employee Panel</small>
                    </div>
                    <div class="text-white mb-3 text-center">
                        <i class="fas fa-user-tie"></i> <%= employee.getFullName() %><br>
                        <small class="text-muted"><%= employee.getDepartment() %></small>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/employee?action=dashboard">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/employee?action=complaints">
                                <i class="fas fa-exclamation-circle"></i> My Complaints
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/employee?action=inquiries">
                                <i class="fas fa-question-circle"></i> Inquiries
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/employee?action=profile">
                                <i class="fas fa-user-cog"></i> Profile
                            </a>
                        </li>
                        <li class="nav-item">
                           
                            <a class="nav-link active text-white" href="<%= request.getContextPath() %>/employee?action=changePassword">
                                <i class="fas fa-key"></i> Change Password
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-danger" href="<%= request.getContextPath() %>/auth?action=logout">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2"><i class="fas fa-key"></i> Change Password</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="<%= request.getContextPath() %>/employee?action=profile" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Profile
                        </a>
                    </div>
                </div>

                <% if (success != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i> <%= success %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("success"); %>
                <% } %>

                <% if (error != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("error"); %>
                <% } %>

                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card shadow">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0"><i class="fas fa-lock"></i> Change Your Password</h5>
                            </div>
                            <div class="card-body">
                               
                                <form action="<%= request.getContextPath() %>/employee" method="post">
                                    <input type="hidden" name="action" value="changePassword">
                                    
                                    <div class="mb-3">
                                        <label for="currentPassword" class="form-label">Current Password</label>
                                        <input type="password" class="form-control" id="currentPassword" 
                                               name="currentPassword" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="newPassword" class="form-label">New Password</label>
                                        <input type="password" class="form-control" id="newPassword" 
                                               name="newPassword" required minlength="6">
                                        <div class="form-text">Password must be at least 6 characters long.</div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                        <input type="password" class="form-control" id="confirmPassword" 
                                               name="confirmPassword" required minlength="6">
                                    </div>
                                    
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Change Password
                                        </button>
                                        <a href="<%= request.getContextPath() %>/employee?action=profile" class="btn btn-secondary">
                                            <i class="fas fa-times"></i> Cancel
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('form');
        const newPassword = document.getElementById('newPassword');
        const confirmPassword = document.getElementById('confirmPassword');
        
        form.addEventListener('submit', function(e) {
            if (newPassword.value !== confirmPassword.value) {
                e.preventDefault();
                alert('New passwords do not match!');
                confirmPassword.focus();
            }
        });
    });
    </script>
</body>
</html>