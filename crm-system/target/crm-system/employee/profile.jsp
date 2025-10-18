<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.crm.model.Employee" %>
<%@ page import="com.crm.model.User" %>
<%
    
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    Employee employee = (Employee) session.getAttribute("employee");
    User user = (User) session.getAttribute("user");
    
    if (userId == null || !"employee".equals(role) || employee == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as employee");
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
    <title>Employee Profile - CRM System</title>
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
                            <a class="nav-link active text-white" href="<%= request.getContextPath() %>/employee?action=profile">
                                <i class="fas fa-user-cog"></i> Profile
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-danger" href="<%= request.getContextPath() %>/employee?action=logout">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2"><i class="fas fa-user-cog"></i> Employee Profile</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                       
                        <a href="<%= request.getContextPath() %>/employee?action=changePassword" class="btn btn-outline-primary">
                            <i class="fas fa-key"></i> Change Password
                        </a>
                    </div>
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

                <div class="row">
                    <div class="col-md-8">
                        <div class="card shadow">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0"><i class="fas fa-user-edit"></i> Profile Information</h5>
                            </div>
                            <div class="card-body">
                                <form action="<%= request.getContextPath() %>/employee" method="post">
                                    <input type="hidden" name="action" value="updateProfile">
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="username" class="form-label">Username</label>
                                            <input type="text" class="form-control" id="username" 
                                                   value="<%= user.getUsername() %>" readonly>
                                            <div class="form-text">Username cannot be changed</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="email" class="form-label">Email Address</label>
                                            <input type="email" class="form-control" id="email" 
                                                   value="<%= user.getEmail() %>" readonly>
                                            <div class="form-text">Email cannot be changed</div>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="firstName" class="form-label">First Name</label>
                                            <input type="text" class="form-control" id="firstName" name="firstName" 
                                                   value="<%= employee.getFirstName() %>" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="lastName" class="form-label">Last Name</label>
                                            <input type="text" class="form-control" id="lastName" name="lastName" 
                                                   value="<%= employee.getLastName() %>" required>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="phone" class="form-label">Phone Number</label>
                                            <input type="tel" class="form-control" id="phone" name="phone" 
                                                   value="<%= employee.getPhone() != null ? employee.getPhone() : "" %>"
                                                   placeholder="Enter phone number">
                                        </div>
                                        <div class="col-md-6">
                                            <label for="department" class="form-label">Department</label>
                                            <input type="text" class="form-control" id="department" name="department" 
                                                   value="<%= employee.getDepartment() != null ? employee.getDepartment() : "" %>"
                                                   placeholder="Enter department">
                                        </div>
                                    </div>
                                    
                                    <div class="text-end">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Update Profile
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card shadow">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0"><i class="fas fa-info-circle"></i> Account Information</h5>
                            </div>
                            <div class="card-body">
                                <div class="text-center mb-4">
                                    <div class="mb-3">
                                        <i class="fas fa-user-tie fa-4x text-primary"></i>
                                    </div>
                                    <h5><%= employee.getFullName() %></h5>
                                    <p class="text-muted">
                                        <span class="badge bg-success">EMPLOYEE</span>
                                    </p>
                                </div>
                                
                                <div class="mb-3">
                                    <strong><i class="fas fa-envelope text-primary"></i> Email:</strong>
                                    <p class="text-muted"><%= user.getEmail() %></p>
                                </div>
                                
                                <div class="mb-3">
                                    <strong><i class="fas fa-building text-primary"></i> Department:</strong>
                                    <p class="text-muted"><%= employee.getDepartment() != null ? employee.getDepartment() : "Not assigned" %></p>
                                </div>
                                
                                <div class="mb-3">
                                    <strong><i class="fas fa-phone text-primary"></i> Phone:</strong>
                                    <p class="text-muted"><%= employee.getPhone() != null ? employee.getPhone() : "Not provided" %></p>
                                </div>
                                
                                <div class="mb-3">
                                    <strong><i class="fas fa-calendar text-primary"></i> Member Since:</strong>
                                    <p class="text-muted"><%= user.getCreatedAt() != null ? user.getCreatedAt() : "N/A" %></p>
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