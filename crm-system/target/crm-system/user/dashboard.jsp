<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.crm.model.User, com.crm.model.Customer, java.util.List, com.crm.model.Complaint" %>
<%
    
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    Customer customer = (Customer) session.getAttribute("customer");
    
    if (userId == null || !"customer".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard - CRM System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sidebar {
            background: #000000;
            min-height: 100vh;
        }
        .stats-card {
            transition: transform 0.3s;
        }
        .stats-card:hover {
            transform: translateY(-5px);
        }
        .quick-action-btn {
            transition: all 0.3s;
        }
        .quick-action-btn:hover {
            transform: scale(1.05);
        }
        .nav-link {
            color: #ffffff !important;
            padding: 12px 15px;
            margin: 2px 0;
            border-radius: 5px;
        }
        .nav-link:hover, .nav-link.active {
            background: #333333 !important;
            color: #ffffff !important;
        }
        .nav-link.text-warning:hover {
            background: #333333 !important;
            color: #ffc107 !important;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
           
            <nav class="col-md-3 col-lg-2 d-md-block sidebar">
                <div class="position-sticky pt-3">
                    <div class="text-center text-white mb-4">
                        <h5>CRM System</h5>
                        <small>Customer Panel</small>
                    </div>
                    <div class="text-white mb-3 text-center">
                        <i class="fas fa-user"></i> Welcome, <%= customer != null ? customer.getFirstName() + " " + customer.getLastName() : username %>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="<%= request.getContextPath() %>/user?action=dashboard">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/user?action=products">
                                <i class="fas fa-boxes"></i> Products
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/user?action=complaints">
                                <i class="fas fa-list-alt"></i> My Complaints
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/user?action=inquiries">
                                <i class="fas fa-question-circle"></i> Inquiries
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/user?action=faqs">
                                <i class="fas fa-life-ring"></i> FAQs
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/user?action=profile">
                                <i class="fas fa-user-cog"></i> Profile
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-warning" href="<%= request.getContextPath() %>/auth?action=logout">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2"><i class="fas fa-tachometer-alt"></i> Customer Dashboard</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <span class="badge bg-success"><i class="fas fa-user"></i> Customer</span>
                    </div>
                </div>
                
               
                <div id="alertContainer"></div>
                
               
                <div class="row">
                    <div class="col-md-3 mb-4">
                        <div class="card text-white bg-primary shadow stats-card">
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
                        <div class="card text-white bg-success shadow stats-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">Resolved</h5>
                                        <h2 class="card-text"><%= request.getAttribute("resolvedComplaints") != null ? request.getAttribute("resolvedComplaints") : 0 %></h2>
                                    </div>
                                    <i class="fas fa-check-circle fa-3x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-4">
                        <div class="card text-white bg-warning shadow stats-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">Pending</h5>
                                        <h2 class="card-text"><%= request.getAttribute("pendingComplaints") != null ? request.getAttribute("pendingComplaints") : 0 %></h2>
                                    </div>
                                    <i class="fas fa-clock fa-3x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-4">
                        <div class="card text-white bg-info shadow stats-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">In Progress</h5>
                                        <h2 class="card-text"><%= request.getAttribute("inProgressComplaints") != null ? request.getAttribute("inProgressComplaints") : 0 %></h2>
                                    </div>
                                    <i class="fas fa-sync-alt fa-3x opacity-50"></i>
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
                                    <div class="col-md-4 text-center mb-3">
                                        <a href="<%= request.getContextPath() %>/user?action=new-complaint" class="btn btn-outline-primary btn-lg w-100 quick-action-btn">
                                            <i class="fas fa-plus-circle fa-2x mb-2"></i><br>
                                            Submit Complaint
                                        </a>
                                    </div>
                                    <div class="col-md-4 text-center mb-3">
                                        <a href="<%= request.getContextPath() %>/user?action=complaints" class="btn btn-outline-success btn-lg w-100 quick-action-btn">
                                            <i class="fas fa-list fa-2x mb-2"></i><br>
                                            View Complaints
                                        </a>
                                    </div>
                                    <div class="col-md-4 text-center mb-3">
                                        <a href="<%= request.getContextPath() %>/user?action=faqs" class="btn btn-outline-info btn-lg w-100 quick-action-btn">
                                            <i class="fas fa-question-circle fa-2x mb-2"></i><br>
                                            View FAQs
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

               
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card shadow">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0"><i class="fas fa-history"></i> Recent Complaints</h5>
                            </div>
                            <div class="card-body">
                                <%
                                    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
                                    if (complaints != null && !complaints.isEmpty()) {
                                %>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Product</th>
                                                    <th>Title</th>
                                                    <th>Status</th>
                                                    <th>Priority</th>
                                                    <th>Created At</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% for (Complaint complaint : complaints) { %>
                                                    <tr>
                                                        <td>#<%= complaint.getId() %></td>
                                                        <td><%= complaint.getProductName() != null ? complaint.getProductName() : "N/A" %></td>
                                                        <td><%= complaint.getTitle() %></td>
                                                        <td>
                                                            <span class="badge 
                                                                <% if ("RESOLVED".equals(complaint.getStatus())) { %>bg-success
                                                                <% } else if ("IN_PROGRESS".equals(complaint.getStatus())) { %>bg-warning
                                                                <% } else { %>bg-secondary<% } %>">
                                                                <%= complaint.getStatus() != null ? complaint.getStatus() : "PENDING" %>
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <span class="badge 
                                                                <% if ("HIGH".equals(complaint.getPriority())) { %>bg-danger
                                                                <% } else if ("MEDIUM".equals(complaint.getPriority())) { %>bg-warning
                                                                <% } else { %>bg-info<% } %>">
                                                                <%= complaint.getPriority() != null ? complaint.getPriority() : "LOW" %>
                                                            </span>
                                                        </td>
                                                        <td><%= complaint.getCreatedAt() != null ? complaint.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
                                                        <td>
                                                            <a href="<%= request.getContextPath() %>/user?action=view-complaint&id=<%= complaint.getId() %>" 
                                                               class="btn btn-sm btn-outline-primary">
                                                                <i class="fas fa-eye"></i> View
                                                            </a>
                                                        </td>
                                                    </tr>
                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                <% } else { %>
                                    <div class="text-center py-4">
                                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">No Complaints Yet</h5>
                                        <p class="text-muted">You haven't submitted any complaints yet.</p>
                                        <a href="<%= request.getContextPath() %>/user?action=new-complaint" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Submit Your First Complaint
                                        </a>
                                    </div>
                                <% } %>
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