<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.crm.model.User" %>
<%@ page import="com.crm.model.Customer" %>
<%
   
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    Customer customer = (Customer) session.getAttribute("customer");
    User user = (User) session.getAttribute("user");
    
    if (userId == null || !"customer".equals(role) || customer == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
        return;
    }
    
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile - CRM System</title>
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
                        <small>Customer Panel</small>
                    </div>
                    <div class="text-white mb-3 text-center">
                        <i class="fas fa-user"></i> <%= customer.getFullName() %>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/user?action=dashboard">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/user?action=products">
                                <i class="fas fa-box"></i> Products
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/user?action=complaints">
                                <i class="fas fa-exclamation-circle"></i> My Complaints
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/user?action=inquiries">
                                <i class="fas fa-question-circle"></i> Inquiries
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/user?action=faqs">
                                <i class="fas fa-file-alt"></i> FAQs
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="<%= request.getContextPath() %>/user?action=profile">
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
                    <h1 class="h2"><i class="fas fa-user-cog"></i> User Profile</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="<%= request.getContextPath() %>/user?action=changePassword" class="btn btn-outline-primary">
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
                                
                                <form action="<%= request.getContextPath() %>/user" method="post">
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
                                            <input type="email" class="form-control" id="email" name="email" 
                                                   value="<%= user.getEmail() %>" required>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="firstName" class="form-label">First Name</label>
                                            <input type="text" class="form-control" id="firstName" name="firstName" 
                                                   value="<%= customer != null ? customer.getFirstName() : "" %>" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="lastName" class="form-label">Last Name</label>
                                            <input type="text" class="form-control" id="lastName" name="lastName" 
                                                   value="<%= customer != null ? customer.getLastName() : "" %>" required>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="phone" class="form-label">Phone Number</label>
                                            <input type="tel" class="form-control" id="phone" name="phone" 
                                                   value="<%= customer != null && customer.getPhone() != null ? customer.getPhone() : "" %>">
                                        </div>
                                        <div class="col-md-6">
                                            <label for="company" class="form-label">Company</label>
                                            <input type="text" class="form-control" id="company" name="company" 
                                                   value="<%= customer != null && customer.getCompany() != null ? customer.getCompany() : "" %>">
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="address" class="form-label">Address</label>
                                        <textarea class="form-control" id="address" name="address" 
                                                  rows="3" placeholder="Enter your full address"><%= customer != null && customer.getAddress() != null ? customer.getAddress() : "" %></textarea>
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
                                        <i class="fas fa-user-circle fa-4x text-primary"></i>
                                    </div>
                                    <h5><%= customer != null ? customer.getFullName() : user.getUsername() %></h5>
                                    <p class="text-muted">
                                        <span class="badge bg-primary">CUSTOMER</span>
                                    </p>
                                </div>
                                
                                <div class="mb-3">
                                    <strong><i class="fas fa-envelope text-primary"></i> Email:</strong>
                                    <p class="text-muted"><%= user.getEmail() %></p>
                                </div>
                                
                                <div class="mb-3">
                                    <strong><i class="fas fa-calendar text-primary"></i> Member Since:</strong>
                                    <p class="text-muted"><%= user.getCreatedAt() != null ? user.getCreatedAt() : "N/A" %></p>
                                </div>
                                
                                <div class="mb-3">
                                    <strong><i class="fas fa-phone text-primary"></i> Phone:</strong>
                                    <p class="text-muted"><%= customer != null && customer.getPhone() != null ? customer.getPhone() : "Not provided" %></p>
                                </div>
                                
                                <div class="mb-3">
                                    <strong><i class="fas fa-building text-primary"></i> Company:</strong>
                                    <p class="text-muted"><%= customer != null && customer.getCompany() != null ? customer.getCompany() : "Not provided" %></p>
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