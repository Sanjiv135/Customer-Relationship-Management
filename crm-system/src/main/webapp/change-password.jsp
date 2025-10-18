<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");

    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login first");
        return;
    }

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
    <title>Change Password - CRM System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .password-container {
            max-width: 500px;
            margin: 0 auto;
            padding: 2rem;
        }
        .card {
            border: none;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row min-vh-100">
       
        <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar">
            <div class="position-sticky pt-3">
                <div class="text-center text-white mb-4">
                    <h5>CRM System</h5>
                    <small><%= role != null ? role.substring(0, 1).toUpperCase() + role.substring(1) : "User" %> Panel</small>
                </div>
                <div class="text-white mb-3 text-center">
                    <i class="fas fa-user"></i> Welcome, <%= username != null ? username : "User" %>
                </div>
                <ul class="nav flex-column">
                    <% if ("admin".equals(role)) { %>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=dashboard">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=manageUsers">
                                <i class="fas fa-user-friends"></i> Manage Users
                            </a>
                        </li>
                    <% } else if ("employee".equals(role)) { %>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/employee?action=dashboard">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/employee?action=complaints">
                                <i class="fas fa-exclamation-circle"></i> Complaints
                            </a>
                        </li>
                    <% } else if ("customer".equals(role)) { %>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/user?action=dashboard">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/user?action=complaints">
                                <i class="fas fa-exclamation-circle"></i> My Complaints
                            </a>
                        </li>
                    <% } %>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/<%= role != null ? role : "user" %>?action=profile">
                            <i class="fas fa-user-cog"></i> Profile
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active text-white" href="${pageContext.request.contextPath}/change-password.jsp">
                            <i class="fas fa-key"></i> Change Password
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

        
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 d-flex align-items-center justify-content-center">
            <div class="password-container">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h4 class="card-title mb-0">
                            <i class="fas fa-key"></i> Change Password
                        </h4>
                    </div>
                    <div class="card-body">
                        <% if (success != null) { %>
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle"></i> <%= success %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>

                        <% if (error != null) { %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle"></i> <%= error %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>

                        <form action="${pageContext.request.contextPath}/auth" method="post" id="changePasswordForm">
                            <input type="hidden" name="action" value="changePassword">
                            
                            <div class="mb-3">
                                <label for="currentPassword" class="form-label">Current Password</label>
                                <div class="input-group">
                                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                    <button type="button" class="btn btn-outline-secondary toggle-password" data-target="currentPassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="newPassword" class="form-label">New Password</label>
                                <div class="input-group">
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="6">
                                    <button type="button" class="btn btn-outline-secondary toggle-password" data-target="newPassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div class="form-text">
                                    Password must be at least 6 characters long.
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                <div class="input-group">
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required minlength="6">
                                    <button type="button" class="btn btn-outline-secondary toggle-password" data-target="confirmPassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div id="passwordMatch" class="form-text"></div>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Change Password
                                </button>
                                <a href="${pageContext.request.contextPath}/<%= role != null ? role : "user" %>?action=dashboard" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
   
    document.querySelectorAll('.toggle-password').forEach(function(button) {
        button.addEventListener('click', function() {
            const targetId = this.getAttribute('data-target');
            const passwordInput = document.getElementById(targetId);
            const icon = this.querySelector('i');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.className = 'fas fa-eye-slash';
            } else {
                passwordInput.type = 'password';
                icon.className = 'fas fa-eye';
            }
        });
    });

    
    const newPassword = document.getElementById('newPassword');
    const confirmPassword = document.getElementById('confirmPassword');
    const passwordMatch = document.getElementById('passwordMatch');

    function validatePasswordMatch() {
        if (newPassword.value && confirmPassword.value) {
            if (newPassword.value === confirmPassword.value) {
                passwordMatch.innerHTML = '<i class="fas fa-check text-success"></i> Passwords match';
                passwordMatch.className = 'form-text text-success';
            } else {
                passwordMatch.innerHTML = '<i class="fas fa-times text-danger"></i> Passwords do not match';
                passwordMatch.className = 'form-text text-danger';
            }
        } else {
            passwordMatch.innerHTML = '';
            passwordMatch.className = 'form-text';
        }
    }

    newPassword.addEventListener('input', validatePasswordMatch);
    confirmPassword.addEventListener('input', validatePasswordMatch);

    
    document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
        const newPasswordValue = newPassword.value;
        const confirmPasswordValue = confirmPassword.value;

        if (newPasswordValue.length < 6) {
            e.preventDefault();
            alert('Password must be at least 6 characters long.');
            newPassword.focus();
            return;
        }

        if (newPasswordValue !== confirmPasswordValue) {
            e.preventDefault();
            alert('Passwords do not match. Please confirm your new password.');
            confirmPassword.focus();
            return;
        }
    });

   
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
});
</script>
</body>
</html>