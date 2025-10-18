<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.crm.model.Product" %>
<%
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    
    if (userId == null || !"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as admin");
        return;
    }
    
    Product product = (Product) request.getAttribute("product");
    boolean isEdit = product != null;
    
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Product" : "Add Product" %> - CRM System</title>
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
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=dashboard">Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=manageEmployees">Manage Employees</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin?action=manageUsers">Manage Users</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/admin?action=manageProducts">Manage Products</a>
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
                    <h1 class="h2"><%= isEdit ? "Edit Product" : "Add New Product" %></h1>
                    <a href="${pageContext.request.contextPath}/admin?action=manageProducts" class="btn btn-secondary">Back to List</a>
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

                <div class="card">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin?action=<%= isEdit ? "updateProduct" : "addProduct" %>" method="post">
                            <% if (isEdit) { %>
                                <input type="hidden" name="id" value="<%= product.getId() %>">
                            <% } %>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="name" class="form-label">Product Name *</label>
                                    <input type="text" class="form-control" id="name" name="name" 
                                           value="<%= isEdit && product.getName() != null ? product.getName() : "" %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="category" class="form-label">Category *</label>
                                    <input type="text" class="form-control" id="category" name="category" 
                                           value="<%= isEdit && product.getCategory() != null ? product.getCategory() : "" %>" required
                                           placeholder="Software, Mobile, Analytics, etc.">
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" id="description" name="description" rows="3"><%= isEdit && product.getDescription() != null ? product.getDescription() : "" %></textarea>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="price" class="form-label">Price *</label>
                                    <input type="number" step="0.01" min="0" class="form-control" id="price" name="price" 
                                           value="<%= isEdit ? product.getPrice() : "" %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="stockQuantity" class="form-label">Stock Quantity *</label>
                                    <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" 
                                           value="<%= isEdit ? product.getStockQuantity() : "0" %>" required min="0">
                                </div>
                            </div>
                            
                            <div class="text-end">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-<%= isEdit ? "save" : "plus" %>"></i>
                                    <%= isEdit ? "Update Product" : "Add Product" %>
                                </button>
                                <a href="${pageContext.request.contextPath}/admin?action=manageProducts" class="btn btn-secondary">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>