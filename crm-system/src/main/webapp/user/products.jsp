<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.crm.model.Product" %>
<%@ page import="com.crm.model.User" %>
<%@ page import="com.crm.model.Customer" %>
<%
   
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    Customer customer = (Customer) session.getAttribute("customer");
    
    if (userId == null || !"customer".equals(role) || customer == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
        return;
    }
    
    List<Product> products = (List<Product>) request.getAttribute("products");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - CRM System</title>
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
                            <a class="nav-link" href="<%= request.getContextPath() %>/user?action=dashboard">Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="<%= request.getContextPath() %>/user?action=products">Products</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/user?action=complaints">My Complaints</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/user?action=inquiries">Inquiries</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/user?action=faqs">FAQs</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/user?action=profile">Profile</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-danger" href="<%= request.getContextPath() %>/auth?action=logout">Logout</a>
                        </li>
                    </ul>
                </div>
            </nav>

            
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Products</h1>
                </div>

                <div class="row">
                    <% if (products != null && !products.isEmpty()) { %>
                        <% for (Product product : products) { %>
                            <div class="col-md-4 mb-4">
                                <div class="card h-100 shadow-sm">
                                    <div class="card-body">
                                        <h5 class="card-title"><%= product.getName() %></h5>
                                        <h6 class="card-subtitle mb-2 text-muted">
                                            <%= product.getCategory() != null ? product.getCategory() : "General" %>
                                        </h6>
                                        <p class="card-text">
                                            <%= product.getDescription() != null ? 
                                                (product.getDescription().length() > 100 ? 
                                                product.getDescription().substring(0, 100) + "..." : product.getDescription()) 
                                                : "No description available." %>
                                        </p>
                                        <div class="mb-2">
                                            <strong class="text-primary">$<%= String.format("%.2f", product.getPrice()) %></strong>
                                        </div>
                                        <div class="mb-3">
                                            <small class="text-muted">
                                                Stock: <%= product.getStockQuantity() %> units
                                            </small>
                                        </div>

                                        
                                        <a href="${pageContext.request.contextPath}/user?action=new-complaint&productId=<%= product.getId() %>" 
                                           class="btn btn-warning btn-sm">
                                            <i class="fas fa-exclamation-triangle"></i> Report Issue
                                        </a>
                                    </div>
                                    <div class="card-footer">
                                        <small class="text-muted">Added on: <%= product.getCreatedAt() %></small>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    <% } else { %>
                        <div class="col-12">
                            <div class="text-center">
                                <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                                <h4>No Products Available</h4>
                                <p class="text-muted">Check back later for new products.</p>
                            </div>
                        </div>
                    <% } %>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>