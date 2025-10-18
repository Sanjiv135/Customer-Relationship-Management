<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.crm.model.Product" %>
<%
    
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    
    if (userId == null || !"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as admin");
        return;
    }
    
    List<Product> products = (List<Product>) request.getAttribute("products");
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    String displayName = username != null ? username : "Admin";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products - CRM System</title>
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
                    <li class="nav-item"><a class="nav-link text-white" href="<%= request.getContextPath() %>/admin?action=dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="<%= request.getContextPath() %>/admin?action=manageEmployees"><i class="fas fa-users"></i> Manage Employees</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="<%= request.getContextPath() %>/admin?action=manageUsers"><i class="fas fa-user-friends"></i> Manage Users</a></li>
                    <li class="nav-item"><a class="nav-link active text-white" href="<%= request.getContextPath() %>/admin?action=manageProducts"><i class="fas fa-box"></i> Manage Products</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="<%= request.getContextPath() %>/admin?action=complaints"><i class="fas fa-exclamation-circle"></i> Complaints</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="<%= request.getContextPath() %>/admin?action=manageFAQs"><i class="fas fa-file-alt"></i> Manage FAQs</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="<%= request.getContextPath() %>/admin?action=profile"><i class="fas fa-user-cog"></i> Profile</a></li>
                    <li class="nav-item"><a class="nav-link text-danger" href="<%= request.getContextPath() %>/auth?action=logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </div>
        </nav>

        
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2"><i class="fas fa-box"></i> Manage Products</h1>
               
                <a href="${pageContext.request.contextPath}/admin?action=addProduct" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add New Product
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
                <div class="card-header bg-white">
                    <h5 class="card-title mb-0"><i class="fas fa-list"></i> Product List</h5>
                </div>
                <div class="card-body">
                    <% if (products != null && !products.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="thead-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Description</th>
                                    <th>Price</th>
                                    <th>Category</th>
                                    <th>Stock</th>
                                    <th>Created At</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>
                                <tbody>
                                <% for (Product product : products) { 
                                    String desc = product.getDescription() != null 
                                        ? (product.getDescription().length() > 50 
                                            ? product.getDescription().substring(0, 50) + "..." 
                                            : product.getDescription()) 
                                        : "N/A";
                                %>
                                    <tr>
                                        <td>#<%= product.getId() %></td>
                                        <td><%= product.getName() != null ? product.getName() : "N/A" %></td>
                                        <td><%= desc %></td>
                                        <td>$<%= String.format("%.2f", product.getPrice()) %></td>
                                        <td><%= product.getCategory() != null ? product.getCategory() : "N/A" %></td>
                                        <td><%= product.getStockQuantity() %></td>
                                        <td><%= product.getCreatedAt() %></td>
                                        <td>
                                            
                                            <a href="${pageContext.request.contextPath}/admin?action=editProduct&id=<%= product.getId() %>" 
                                               class="btn btn-sm btn-warning">
                                               <i class="fas fa-edit"></i> Edit
                                            </a>
                                            <a href="<%= request.getContextPath() %>/admin?action=deleteProduct&id=<%= product.getId() %>"
                                               class="btn btn-sm btn-danger"
                                               onclick="return confirm('Are you sure you want to delete this product?')">
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
                            <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                            <h5>No Products Found</h5>
                            <p class="text-muted">There are currently no products in the system.</p>
                            <a href="${pageContext.request.contextPath}/admin?action=addProduct" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Add New Product
                            </a>
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
