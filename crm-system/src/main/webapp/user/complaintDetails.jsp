<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.crm.model.Complaint" %>
<%@ page import="com.crm.model.Customer" %>
<%
    Complaint complaint = (Complaint) request.getAttribute("complaint");
    Customer customer = (Customer) session.getAttribute("customer");
    String role = (String) session.getAttribute("role");
    
    if (customer == null || !"customer".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
        return;
    }
    
    if (complaint == null) {
        response.sendRedirect(request.getContextPath() + "/user?action=complaints&error=Complaint not found");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaint Details - CRM System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar">
                <div class="position-sticky pt-3 text-white">
                    <div class="text-center mb-4">
                        <h5>CRM System</h5>
                        <small>Customer Panel</small>
                    </div>
                    <div class="text-center mb-3">
                        <i class="fas fa-user"></i> <%= customer.getFullName() %>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/user?action=dashboard">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/user?action=products">
                                <i class="fas fa-box"></i> Products
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/user?action=complaints">
                                <i class="fas fa-exclamation-circle"></i> My Complaints
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/user?action=inquiries">
                                <i class="fas fa-question-circle"></i> Inquiries
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/user?action=faqs">
                                <i class="fas fa-file-alt"></i> FAQs
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/user?action=profile">
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
                    <h1 class="h2"><i class="fas fa-exclamation-circle"></i> Complaint Details</h1>
                    <a href="${pageContext.request.contextPath}/user?action=complaints" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Complaints
                    </a>
                </div>

                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">Complaint #<%= complaint.getId() %></h5>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <strong>Title:</strong> <%= complaint.getTitle() %>
                            </div>
                            <div class="col-md-6">
                                <strong>Product:</strong> <%= complaint.getProductName() != null ? complaint.getProductName() : "N/A" %>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <strong>Status:</strong>
                                <span class="badge bg-<%= 
                                    "PENDING".equals(complaint.getStatus()) ? "warning" :
                                    "IN_PROGRESS".equals(complaint.getStatus()) ? "info" :
                                    "RESOLVED".equals(complaint.getStatus()) ? "success" : "secondary"
                                %>">
                                    <%= complaint.getStatus() %>
                                </span>
                            </div>
                            <div class="col-md-6">
                                <strong>Priority:</strong>
                                <span class="badge bg-<%= 
                                    "HIGH".equals(complaint.getPriority()) ? "danger" :
                                    "MEDIUM".equals(complaint.getPriority()) ? "warning" :
                                    "LOW".equals(complaint.getPriority()) ? "info" : "secondary"
                                %>">
                                    <%= complaint.getPriority() %>
                                </span>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <strong>Assigned To:</strong> <%= complaint.getAssignedEmployeeName() != null ? complaint.getAssignedEmployeeName() : "Not Assigned" %>
                            </div>
                            <div class="col-md-6">
                                <strong>Created:</strong> <%= complaint.getCreatedAt() %>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <strong>Description:</strong>
                            <div class="border p-3 bg-light rounded">
                                <%= complaint.getDescription() %>
                            </div>
                        </div>
                        
                        <% if (complaint.getUpdatedAt() != null && !complaint.getUpdatedAt().equals(complaint.getCreatedAt())) { %>
                        <div class="row">
                            <div class="col-12">
                                <strong>Last Updated:</strong> <%= complaint.getUpdatedAt() %>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>