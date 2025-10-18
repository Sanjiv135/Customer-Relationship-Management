<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.crm.model.Employee" %>
<%
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");

    if (userId == null || !"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as admin");
        return;
    }

    List<Employee> employees = (List<Employee>) request.getAttribute("employees");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Employees - CRM System</title>
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
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2"><i class="fas fa-users"></i> Manage Employees</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin?action=addEmployee" class="btn btn-primary">
                            <i class="fas fa-user-plus"></i> Add New Employee
                        </a>
                    </div>
                </div>

                
                <div id="alertContainer"></div>

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
                        <h5 class="card-title mb-0"><i class="fas fa-list"></i> Employee List</h5>
                    </div>
                    <div class="card-body">
                        <% if (employees != null && !employees.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table table-striped table-hover" id="employeesTable">
                                    <thead class="thead-dark">
                                        <tr>
                                            <th>ID</th>
                                            <th>Username</th>
                                            <th>Full Name</th>
                                            <th>Email</th>
                                            <th>Department</th>
                                            <th>Phone</th>
                                            <th class="table-actions">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Employee emp : employees) { 
                                            String fullName = emp.getFullName() != null ? emp.getFullName() : "N/A";
                                            String email = emp.getEmail() != null ? emp.getEmail() : "N/A";
                                            String department = emp.getDepartment() != null ? emp.getDepartment() : "N/A";
                                            String phone = emp.getPhone() != null ? emp.getPhone() : "N/A";
                                            String usernameValue = emp.getUsername() != null ? emp.getUsername() : "N/A";
                                        %>
                                            <tr data-employee-id="<%= emp.getId() %>">
                                                <td>#<%= emp.getId() %></td>
                                                <td><strong><%= usernameValue %></strong></td>
                                                <td><%= fullName %></td>
                                                <td><%= email %></td>
                                                <td>
                                                    <span class="badge bg-info">
                                                        <%= department %>
                                                    </span>
                                                </td>
                                                <td><%= phone %></td>
                                                <td class="table-actions">
                                                    
                                                    <a href="${pageContext.request.contextPath}/admin?action=viewEmployee&id=<%= emp.getId() %>" 
                                                       class="btn btn-sm btn-info" title="View Employee Details">
                                                        <i class="fas fa-eye"></i> View
                                                    </a>
                                                    
                                                    <a href="${pageContext.request.contextPath}/admin?action=editEmployee&id=<%= emp.getId() %>" 
                                                       class="btn btn-sm btn-warning" title="Edit Employee">
                                                        <i class="fas fa-edit"></i> Edit
                                                    </a>
                                                   
                                                    <a href="${pageContext.request.contextPath}/admin?action=deleteEmployee&id=<%= emp.getId() %>" 
                                                       class="btn btn-sm btn-danger" 
                                                       onclick="return confirm('Are you sure you want to delete <%= fullName %>? This action cannot be undone.')"
                                                       title="Delete Employee">
                                                        <i class="fas fa-trash"></i> Delete
                                                    </a>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } else { %>
                            <div class="text-center py-4">
                                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                <p class="text-muted">No employees found in the system.</p>
                                <a href="${pageContext.request.contextPath}/admin?action=addEmployee" class="btn btn-primary">
                                    <i class="fas fa-user-plus"></i> Create First Employee
                                </a>
                            </div>
                        <% } %>
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
    
    <script>
        
        setTimeout(() => {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>