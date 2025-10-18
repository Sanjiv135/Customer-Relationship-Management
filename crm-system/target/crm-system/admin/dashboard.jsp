<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    
    if (userId == null || !"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as admin");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - CRM System</title>
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
                            <a class="nav-link active text-white" href="<%= request.getContextPath() %>/admin?action=dashboard">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/admin?action=manageEmployees">
                                <i class="fas fa-users"></i> Manage Employees
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/admin?action=manageUsers">
                                <i class="fas fa-user-friends"></i> Manage Users
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/admin?action=manageProducts">
                                <i class="fas fa-boxes"></i> Manage Products
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/admin?action=complaints">
                                <i class="fas fa-exclamation-circle"></i> Complaints
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/admin?action=manageFAQs">
                                <i class="fas fa-question-circle"></i> Manage FAQs
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/admin?action=profile">
                                <i class="fas fa-user-cog"></i> Profile
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
                    <h1 class="h2"><i class="fas fa-tachometer-alt"></i> Admin Dashboard</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <span class="badge bg-primary"><i class="fas fa-user-shield"></i> Administrator</span>
                    </div>
                </div>
                
                
                <div id="alertContainer"></div>
                
                
                <div class="row">
                    <div class="col-md-3 mb-4">
                        <div class="card text-white bg-primary shadow">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">Total Users</h5>
                                        <h2 class="card-text"><%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : 0 %></h2>
                                    </div>
                                    <i class="fas fa-user-friends fa-3x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-4">
                        <div class="card text-white bg-success shadow">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">Total Employees</h5>
                                        <h2 class="card-text"><%= request.getAttribute("totalEmployees") != null ? request.getAttribute("totalEmployees") : 0 %></h2>
                                    </div>
                                    <i class="fas fa-users fa-3x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-4">
                        <div class="card text-white bg-warning shadow">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">Total Complaints</h5>
                                        <h2 class="card-text"><%= request.getAttribute("totalComplaints") != null ? request.getAttribute("totalComplaints") : 0 %></h2>
                                    </div>
                                    <i class="fas fa-exclamation-circle fa-3x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-4">
                        <div class="card text-white bg-info shadow">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">Total Products</h5>
                                        <h2 class="card-text"><%= request.getAttribute("totalProducts") != null ? request.getAttribute("totalProducts") : 0 %></h2>
                                    </div>
                                    <i class="fas fa-boxes fa-3x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card shadow">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0"><i class="fas fa-bolt"></i> Quick Actions</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-3 text-center mb-3">
                                        <a href="<%= request.getContextPath() %>/admin?action=manageEmployees" class="btn btn-outline-primary btn-lg w-100">
                                            <i class="fas fa-user-plus fa-2x mb-2"></i><br>
                                            Add Employee
                                        </a>
                                    </div>
                                    <div class="col-md-3 text-center mb-3">
                                        <a href="<%= request.getContextPath() %>/admin?action=manageProducts" class="btn btn-outline-success btn-lg w-100">
                                            <i class="fas fa-box fa-2x mb-2"></i><br>
                                            Add Product
                                        </a>
                                    </div>
                                    <div class="col-md-3 text-center mb-3">
                                        <a href="<%= request.getContextPath() %>/admin?action=complaints" class="btn btn-outline-warning btn-lg w-100">
                                            <i class="fas fa-exclamation-triangle fa-2x mb-2"></i><br>
                                            View Complaints
                                        </a>
                                    </div>
                                    <div class="col-md-3 text-center mb-3">
                                        <a href="<%= request.getContextPath() %>/admin?action=manageFAQs" class="btn btn-outline-info btn-lg w-100">
                                            <i class="fas fa-question-circle fa-2x mb-2"></i><br>
                                            Manage FAQs
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    
    <div id="loadingSpinner" class="loading-spinner" style="display: none;">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>