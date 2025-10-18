<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.crm.model.User" %>
<%
   
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");

    if (userId == null || !"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as admin");
        return;
    }

    List<User> users = (List<User>) request.getAttribute("users");
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");

    String displayName = username != null ? username : "Admin";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - CRM System</title>
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
                        <i class="fas fa-user-shield"></i> Welcome, <%= displayName %>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=dashboard">Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=manageEmployees">Manage Employees</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/admin?action=manageUsers">Manage Users</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=manageProducts">Manage Products</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=complaints">Complaints</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=manageFAQs">Manage FAQs</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=profile">Profile</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-danger" href="${pageContext.request.contextPath}/auth?action=logout">Logout</a>
                        </li>
                    </ul>
                </div>
            </nav>

            
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2"><i class="fas fa-user-friends"></i> Manage Users</h1>
                    
                    <a href="${pageContext.request.contextPath}/admin?action=createUser" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add New User
                    </a>
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
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Username</th>
                                        <th>Email</th>
                                        <th>Phone</th>
                                        <th>Role</th>
                                        <th>Status</th>
                                        <th>Created At</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (users != null && !users.isEmpty()) { %>
                                        <% for (User user : users) { 
                                            String usernameValue = user.getUsername() != null ? user.getUsername() : "";
                                            String email = user.getEmail() != null ? user.getEmail() : "";
                                            String phone = user.getPhone() != null ? user.getPhone() : "N/A";
                                            String roleValue = user.getRole() != null ? user.getRole() : "";
                                            String status = user.isActive() ? "Active" : "Inactive";
                                            String statusClass = user.isActive() ? "badge bg-success" : "badge bg-danger";
                                            String createdAt = user.getCreatedAt() != null ? user.getCreatedAt().toString() : "";
                                        %>
                                            <tr data-user-id="<%= user.getId() %>">
                                                <td><%= user.getId() %></td>
                                                <td><%= usernameValue %></td>
                                                <td><%= email %></td>
                                                <td><%= phone %></td>
                                                <td><span class="badge bg-primary"><%= roleValue %></span></td>
                                                <td><span class="<%= statusClass %>"><%= status %></span></td>
                                                <td><%= createdAt %></td>
                                                <td>
                                                    <div class="btn-group">
                                                       
                                                        <a href="${pageContext.request.contextPath}/admin?action=viewUser&id=<%= user.getId() %>" 
                                                           class="btn btn-sm btn-info">
                                                            <i class="fas fa-eye"></i> View
                                                        </a>
                                                      
                                                        <a href="${pageContext.request.contextPath}/admin?action=editUser&id=<%= user.getId() %>" 
                                                           class="btn btn-sm btn-warning">
                                                            <i class="fas fa-edit"></i> Edit
                                                        </a>
                                                       
                                                        <a href="${pageContext.request.contextPath}/admin?action=deleteUser&id=<%= user.getId() %>" 
                                                           class="btn btn-sm btn-danger"
                                                           onclick="return confirm('Are you sure you want to delete user: <%= usernameValue.replace("\"", "&quot;") %>?')">
                                                            <i class="fas fa-trash"></i> Delete
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    <% } else { %>
                                        <tr>
                                            <td colspan="8" class="text-center text-muted py-4">
                                                <i class="fas fa-inbox fa-2x mb-2"></i><br>
                                                No users found. <a href="${pageContext.request.contextPath}/admin?action=createUser">Create the first user</a>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <style>
    .sidebar {
        min-height: 100vh;
        box-shadow: 2px 0 5px rgba(0,0,0,0.1);
    }
    
    .nav-link {
        color: #fff;
        padding: 10px 15px;
        border-radius: 5px;
        margin: 2px 0;
    }
    
    .nav-link:hover, .nav-link.active {
        background-color: #495057;
        color: #fff;
    }
    
    .table th {
        border-top: none;
        font-weight: 600;
    }
    </style>
</body>
</html>