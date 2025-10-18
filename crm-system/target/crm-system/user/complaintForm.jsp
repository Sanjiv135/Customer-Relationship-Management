<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.crm.model.Product" %>
<%@ page import="com.crm.model.Customer" %>
<%
    Customer customer = (Customer) session.getAttribute("customer");
    String role = (String) session.getAttribute("role");
    
    if (customer == null || !"customer".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
        return;
    }

    List<Product> products = (List<Product>) request.getAttribute("products");
    String productIdParam = request.getParameter("productId");
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
    <title>Submit Complaint - CRM System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
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
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/user?action=complaints">
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
                <h1 class="h2">Submit New Complaint</h1>
                <a href="${pageContext.request.contextPath}/user?action=complaints" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Complaints
                </a>
            </div>

           
            <% if (success != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle"></i> <%= success %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <% if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle"></i> <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <div class="card">
                <div class="card-body">
                   
                    <form action="${pageContext.request.contextPath}/user" method="post">
                        <input type="hidden" name="action" value="addComplaint">
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="productId" class="form-label">Related Product (Optional)</label>
                                <select class="form-select" id="productId" name="productId">
                                    <option value="">Select a product (optional)</option>
                                    <% if (products != null && !products.isEmpty()) { %>
                                        <% for (Product product : products) { %>
                                            <option value="<%= product.getId() %>" 
                                                    <%= productIdParam != null && productIdParam.equals(String.valueOf(product.getId())) ? "selected" : "" %>>
                                                <%= product.getName() %> - $<%= String.format("%.2f", product.getPrice()) %>
                                            </option>
                                        <% } %>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="priority" class="form-label">Priority</label>
                                <select class="form-select" id="priority" name="priority" required>
                                    <option value="LOW">Low</option>
                                    <option value="MEDIUM" selected>Medium</option>
                                    <option value="HIGH">High</option>
                                    <option value="URGENT">Urgent</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="title" class="form-label">Complaint Title</label>
                            <input type="text" class="form-control" id="title" name="title" 
                                   placeholder="Brief description of the issue" required
                                   maxlength="255">
                            <div class="form-text">Maximum 255 characters</div>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label">Detailed Description</label>
                            <textarea class="form-control" id="description" name="description" 
                                      rows="6" placeholder="Please provide detailed information about the issue..." 
                                      required maxlength="2000"></textarea>
                            <div class="form-text">Maximum 2000 characters</div>
                        </div>

                        <div class="text-end">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-paper-plane"></i> Submit Complaint
                            </button>
                            <a href="${pageContext.request.contextPath}/user?action=complaints" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card mt-4">
                <div class="card-header">
                    <h5 class="card-title"><i class="fas fa-info-circle"></i> Complaint Guidelines</h5>
                </div>
                <div class="card-body">
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">
                            <i class="fas fa-check text-success"></i> Provide clear and detailed description of the issue
                        </li>
                        <li class="list-group-item">
                            <i class="fas fa-check text-success"></i> Include relevant product information if applicable
                        </li>
                        <li class="list-group-item">
                            <i class="fas fa-check text-success"></i> Select appropriate priority level based on urgency
                        </li>
                        <li class="list-group-item">
                            <i class="fas fa-check text-success"></i> Our support team will review your complaint within 24 hours
                        </li>
                        <li class="list-group-item">
                            <i class="fas fa-check text-success"></i> You can track the status of your complaint in "My Complaints" section
                        </li>
                    </ul>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    
    document.addEventListener('DOMContentLoaded', function() {
        const descriptionTextarea = document.getElementById('description');
        const descriptionCounter = document.createElement('div');
        descriptionCounter.className = 'form-text text-end';
        descriptionCounter.textContent = '0/2000 characters';
        descriptionTextarea.parentNode.appendChild(descriptionCounter);

        descriptionTextarea.addEventListener('input', function() {
            const length = this.value.length;
            descriptionCounter.textContent = length + '/2000 characters';
            if (length > 2000) {
                descriptionCounter.classList.add('text-danger');
            } else {
                descriptionCounter.classList.remove('text-danger');
            }
        });

        
        const urlParams = new URLSearchParams(window.location.search);
        const productId = urlParams.get('productId');
        if (productId) {
            document.getElementById('productId').value = productId;
        }
    });
</script>
</body>
</html>