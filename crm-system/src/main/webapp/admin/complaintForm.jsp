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
    List<Employee> employees = (List<Employee>) request.getAttribute("employees");
    
    boolean isEdit = complaint != null && complaint.getId() > 0;
    String pageTitle = isEdit ? "Edit Complaint" : "Create Complaint";
    
    
    String displayName = username != null ? username : "Admin";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> - CRM System</title>
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
                    <h1 class="h2">
                        <i class="fas fa-<%= isEdit ? "edit" : "plus" %>"></i> <%= pageTitle %>
                    </h1>
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

                <div class="card shadow">
                    <div class="card-header bg-white">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-<%= isEdit ? "edit" : "plus-circle" %>"></i> 
                            <%= isEdit ? "Edit Complaint Details" : "Create New Complaint" %>
                        </h5>
                    </div>
                    <div class="card-body">
                        <form action="<%= request.getContextPath() %>/admin?action=updateComplaintDetails" method="post">
                            <% if (isEdit) { %>
                                <input type="hidden" name="id" value="<%= complaint.getId() %>">
                            <% } %>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="title" class="form-label">Title <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="title" name="title" 
                                               value="<%= complaint != null && complaint.getTitle() != null ? complaint.getTitle() : "" %>" 
                                               required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="priority" class="form-label">Priority <span class="text-danger">*</span></label>
                                        <select class="form-select" id="priority" name="priority" required>
                                            <option value="LOW" <%= complaint != null && "LOW".equals(complaint.getPriority()) ? "selected" : "" %>>LOW</option>
                                            <option value="MEDIUM" <%= complaint != null && "MEDIUM".equals(complaint.getPriority()) ? "selected" : "" %>>MEDIUM</option>
                                            <option value="HIGH" <%= complaint != null && "HIGH".equals(complaint.getPriority()) ? "selected" : "" %>>HIGH</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label">Description <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="description" name="description" rows="5" 
                                          required><%= complaint != null && complaint.getDescription() != null ? complaint.getDescription() : "" %></textarea>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="status" class="form-label">Status <span class="text-danger">*</span></label>
                                        <select class="form-select" id="status" name="status" required>
                                            <option value="PENDING" <%= complaint != null && "PENDING".equals(complaint.getStatus()) ? "selected" : "" %>>PENDING</option>
                                            <option value="IN_PROGRESS" <%= complaint != null && "IN_PROGRESS".equals(complaint.getStatus()) ? "selected" : "" %>>IN_PROGRESS</option>
                                            <option value="RESOLVED" <%= complaint != null && "RESOLVED".equals(complaint.getStatus()) ? "selected" : "" %>>RESOLVED</option>
                                            <option value="CLOSED" <%= complaint != null && "CLOSED".equals(complaint.getStatus()) ? "selected" : "" %>>CLOSED</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="assignedTo" class="form-label">Assign To</label>
                                        <select class="form-select" id="assignedTo" name="assignedTo">
                                            <option value="">Not Assigned</option>
                                            <% if (employees != null && !employees.isEmpty()) { 
                                                for (Employee emp : employees) { 
                                                    boolean isSelected = complaint != null && complaint.getAssignedTo() == emp.getId();
                                                    String empDisplayName = emp.getFirstName() + " " + emp.getLastName();
                                                    if (emp.getDepartment() != null) {
                                                        empDisplayName += " (" + emp.getDepartment() + ")";
                                                    }
                                            %>
                                                <option value="<%= emp.getId() %>" <%= isSelected ? "selected" : "" %>>
                                                    <%= empDisplayName %>
                                                </option>
                                            <%   } 
                                            } else { %>
                                                <option value="" disabled>No employees available</option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="row mt-4">
                                <div class="col-12">
                                    <div class="d-flex justify-content-between">
                                        <a href="<%= request.getContextPath() %>/admin?action=complaints" class="btn btn-secondary">
                                            <i class="fas fa-times"></i> Cancel
                                        </a>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> <%= isEdit ? "Update Complaint" : "Create Complaint" %>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <% if (isEdit && complaint != null) { %>
                <div class="card shadow mt-4">
                    <div class="card-header bg-white">
                        <h5 class="card-title mb-0 text-danger">
                            <i class="fas fa-exclamation-triangle"></i> Danger Zone
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-1">Delete Complaint</h6>
                                <p class="mb-0 text-muted">Once deleted, this complaint cannot be recovered.</p>
                            </div>
                            <a href="<%= request.getContextPath() %>/admin?action=deleteComplaint&id=<%= complaint.getId() %>" 
                               class="btn btn-danger"
                               onclick="return confirm('Are you sure you want to delete this complaint? This action cannot be undone.')">
                                <i class="fas fa-trash"></i> Delete Complaint
                            </a>
                        </div>
                    </div>
                </div>
                <% } %>
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

        
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            form.addEventListener('submit', function(e) {
                const title = document.getElementById('title').value.trim();
                const description = document.getElementById('description').value.trim();
                
                if (!title || !description) {
                    e.preventDefault();
                    alert('Please fill in all required fields.');
                    return false;
                }
            });
        });
    </script>
</body>
</html>