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
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/admin?action=manageUsers&error=User not found");
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
    <title>User Details - CRM System</title>
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
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2"><i class="fas fa-user"></i> User Details</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin?action=manageUsers" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to List
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
                        <i class="fas fa-exclamation-triangle"></i> <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("error"); %>
                <% } %>

                <div class="card shadow">
                    <div class="card-header bg-white">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-info-circle"></i> 
                            User Information - <%= user.getUsername() %>
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <table class="table table-borderless">
                                    <tr>
                                        <th width="30%">User ID:</th>
                                        <td>#<%= user.getId() %></td>
                                    </tr>
                                    <tr>
                                        <th>Username:</th>
                                        <td><strong><%= user.getUsername() %></strong></td>
                                    </tr>
                                    <tr>
                                        <th>Email:</th>
                                        <td><%= user.getEmail() %></td>
                                    </tr>
                                    <tr>
                                        <th>Role:</th>
                                        <td>
                                            <span class="badge bg-<%= 
                                                "admin".equals(user.getRole()) ? "danger" : 
                                                "employee".equals(user.getRole()) ? "warning" : "info" 
                                            %>">
                                                <%= user.getRole().toUpperCase() %>
                                            </span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <table class="table table-borderless">
                                    <tr>
                                        <th width="40%">Status:</th>
                                        <td>
                                            <span class="badge bg-<%= user.isActive() ? "success" : "danger" %>">
                                                <%= user.isActive() ? "ACTIVE" : "INACTIVE" %>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Temporary Password:</th>
                                        <td>
                                            <span class="badge bg-<%= user.isTempPassword() ? "warning" : "success" %>">
                                                <%= user.isTempPassword() ? "YES" : "NO" %>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Created At:</th>
                                        <td><%= user.getCreatedAtFormatted() %></td>
                                    </tr>
                                </table>
                            </div>
                        </div>

                        
                        <div class="card mt-4">
                            <div class="card-body">
                                <h5 class="card-title">Actions</h5>
                                <div class="btn-group">
                                    <a href="${pageContext.request.contextPath}/admin?action=editUser&id=<%= user.getId() %>" 
                                       class="btn btn-warning" title="Edit User">
                                        <i class="fas fa-edit"></i> Edit User
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin?action=deleteUser&id=<%= user.getId() %>" 
                                       class="btn btn-danger" 
                                       onclick="return confirm('Are you sure you want to delete user <%= user.getUsername() %>? This action cannot be undone.')"
                                       title="Delete User">
                                        <i class="fas fa-trash"></i> Delete User
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin?action=manageUsers" 
                                       class="btn btn-secondary">
                                        <i class="fas fa-arrow-left"></i> Back to Users
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>