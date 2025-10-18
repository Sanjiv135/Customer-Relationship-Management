<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
   
    String selectedRole = request.getParameter("role");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRM System - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-6">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white text-center">
                        <h4>CRM System Login</h4>
                    </div>
                    <div class="card-body">

                        <% 
                            String error = (String) session.getAttribute("error"); 
                            if (error != null) { 
                        %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <%= error %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% 
                                session.removeAttribute("error"); 
                            } 
                        %>

                        
                        <form action="${pageContext.request.contextPath}/auth" method="post">
                            <input type="hidden" name="action" value="login">

                            <div class="form-group mb-3">
                                <label for="username" class="form-label">Username:</label>
                                <input type="text" id="username" name="username" class="form-control" required>
                            </div>

                            <div class="form-group mb-3">
                                <label for="password" class="form-label">Password:</label>
                                <input type="password" id="password" name="password" class="form-control" required>
                            </div>

                            <div class="form-group mb-3">
                                <label for="role" class="form-label">Login As:</label>
                                <select id="role" name="role" class="form-select" required>
                                    <option value="">Select Role</option>
                                    <option value="customer" <%= "customer".equals(selectedRole) ? "selected" : "" %>>Customer</option>
                                    <option value="employee" <%= "employee".equals(selectedRole) ? "selected" : "" %>>Employee</option>
                                    <option value="admin" <%= "admin".equals(selectedRole) ? "selected" : "" %>>Admin</option>
                                </select>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary">Login</button>
                            </div>
                        </form>

                       
                        <div class="text-center mt-3">
                            <a href="index.jsp" class="text-decoration-none">Back to Home</a> | 
                            <a href="signup.jsp" class="text-decoration-none">Create New Account</a>
                        </div>

                       
                        <div class="mt-4">
                            <h6>Demo Credentials:</h6>
                            <small class="text-muted">
                                <strong>Admin:</strong> admin / password123<br>
                                <strong>Employee:</strong> emp1 / password123<br>
                                <strong>Customer:</strong> user1 / password123
                            </small>
                        </div>

                        
                        <div class="text-center mt-3">
                            <a href="${pageContext.request.contextPath}/forgot-password.jsp" class="text-decoration-none">
                                <i class="fas fa-key"></i> Forgot Password?
                            </a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
