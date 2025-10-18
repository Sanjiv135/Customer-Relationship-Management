<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.crm.model.Complaint" %>
<%@ page import="com.crm.model.Employee" %>
<%@ page import="java.util.List" %>
<%
    
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    
    if (userId == null || !"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as admin");
        return;
    }
    
    Complaint complaint = (Complaint) request.getAttribute("complaint");
    if (complaint == null) {
        response.sendRedirect(request.getContextPath() + "/admin?action=complaints");
        return;
    }
    
   
    String displayName = username != null ? username : "Admin";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaint Details - CRM System</title>
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
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/admin?action=dashboard">
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
                                <i class="fas fa-box"></i> Manage Products
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="<%= request.getContextPath() %>/admin?action=complaints">
                                <i class="fas fa-exclamation-circle"></i> Complaints
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/admin?action=manageFAQs">
                                <i class="fas fa-file-alt"></i> Manage FAQs
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
                    <h1 class="h2"><i class="fas fa-exclamation-circle"></i> Complaint Details</h1>
                    <a href="<%= request.getContextPath() %>/admin?action=complaints" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Complaints
                    </a>
                </div>

                
                <%
                    String success = (String) session.getAttribute("success");
                    String error = (String) session.getAttribute("error");
                    
                    if (success != null) {
                %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i> <%= success %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <%
                        session.removeAttribute("success");
                    }
                    
                    if (error != null) {
                %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle"></i> <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <%
                        session.removeAttribute("error");
                    }
                %>

                <div class="row">
                    <div class="col-md-8">
                        <div class="card shadow">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0"><i class="fas fa-info-circle"></i> Complaint Information</h5>
                            </div>
                            <div class="card-body">
                                <div class="row mb-3">
                                    <div class="col-sm-3"><strong>Complaint ID:</strong></div>
                                    <div class="col-sm-9">#<%= complaint.getId() %></div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-sm-3"><strong>Title:</strong></div>
                                    <div class="col-sm-9"><%= complaint.getTitle() != null ? complaint.getTitle() : "N/A" %></div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-sm-3"><strong>Description:</strong></div>
                                    <div class="col-sm-9"><%= complaint.getDescription() != null ? complaint.getDescription() : "N/A" %></div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-sm-3"><strong>Status:</strong></div>
                                    <div class="col-sm-9">
                                        <%
                                            String statusClass = "";
                                            String status = complaint.getStatus();
                                            if (status != null) {
                                                switch(status) {
                                                    case "PENDING": statusClass = "bg-warning"; break;
                                                    case "IN_PROGRESS": statusClass = "bg-info"; break;
                                                    case "RESOLVED": statusClass = "bg-success"; break;
                                                    case "CLOSED": statusClass = "bg-secondary"; break;
                                                    default: statusClass = "bg-secondary";
                                                }
                                            } else {
                                                statusClass = "bg-secondary";
                                                status = "UNKNOWN";
                                            }
                                        %>
                                        <span class="badge <%= statusClass %>">
                                            <%= status %>
                                        </span>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-sm-3"><strong>Priority:</strong></div>
                                    <div class="col-sm-9">
                                        <%
                                            String priorityClass = "";
                                            String priority = complaint.getPriority();
                                            if (priority != null) {
                                                switch(priority) {
                                                    case "HIGH": priorityClass = "bg-danger"; break;
                                                    case "MEDIUM": priorityClass = "bg-warning"; break;
                                                    case "LOW": priorityClass = "bg-info"; break;
                                                    default: priorityClass = "bg-secondary";
                                                }
                                            } else {
                                                priorityClass = "bg-secondary";
                                                priority = "UNKNOWN";
                                            }
                                        %>
                                        <span class="badge <%= priorityClass %>">
                                            <%= priority %>
                                        </span>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-sm-3"><strong>Created At:</strong></div>
                                    <div class="col-sm-9"><%= complaint.getCreatedAt() != null ? complaint.getCreatedAt() : "N/A" %></div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-sm-3"><strong>Last Updated:</strong></div>
                                    <div class="col-sm-9"><%= complaint.getUpdatedAt() != null ? complaint.getUpdatedAt() : "N/A" %></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card shadow">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0"><i class="fas fa-user"></i> User Information</h5>
                            </div>
                            <div class="card-body">
                                <div class="row mb-3">
                                    <div class="col-sm-4"><strong>User:</strong></div>
                                    <div class="col-sm-8"><%= complaint.getUserName() != null ? complaint.getUserName() : "N/A" %></div>
                                </div>
                                <% if (complaint.getProductName() != null) { %>
                                <div class="row mb-3">
                                    <div class="col-sm-4"><strong>Product:</strong></div>
                                    <div class="col-sm-8"><%= complaint.getProductName() %></div>
                                </div>
                                <% } %>
                                <% if (complaint.getAssignedEmployeeName() != null) { %>
                                <div class="row mb-3">
                                    <div class="col-sm-4"><strong>Assigned To:</strong></div>
                                    <div class="col-sm-8"><%= complaint.getAssignedEmployeeName() %></div>
                                </div>
                                <% } %>
                            </div>
                        </div>
                        
                        <div class="card shadow mt-4">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0"><i class="fas fa-bolt"></i> Quick Actions</h5>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <a href="<%= request.getContextPath() %>/admin?action=complaints" class="btn btn-primary">
                                        <i class="fas fa-list"></i> Back to List
                                    </a>
                                    <a href="<%= request.getContextPath() %>/admin?action=editComplaint&id=<%= complaint.getId() %>" class="btn btn-warning">
                                        <i class="fas fa-edit"></i> Edit Complaint
                                    </a>
                                    <a href="<%= request.getContextPath() %>/admin?action=deleteComplaint&id=<%= complaint.getId() %>" 
                                       class="btn btn-danger"
                                       onclick="return confirm('Are you sure you want to delete this complaint?')">
                                        <i class="fas fa-trash"></i> Delete Complaint
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
    <script>
        
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>