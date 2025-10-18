<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.crm.model.Employee" %>
<%
    
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    
    if (userId == null || !"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as admin");
        return;
    }

    Employee employee = (Employee) request.getAttribute("employee");
    if (employee == null) {
        response.sendRedirect(request.getContextPath() + "/admin?action=manageEmployees&error=Employee not found");
        return;
    }
    
    
    String fullName = employee.getFullName() != null ? employee.getFullName() : "N/A";
    String firstName = employee.getFirstName() != null ? employee.getFirstName() : "N/A";
    String lastName = employee.getLastName() != null ? employee.getLastName() : "N/A";
    String email = employee.getEmail() != null ? employee.getEmail() : "N/A";
    String department = employee.getDepartment() != null ? employee.getDepartment() : "N/A";
    String position = employee.getPosition() != null ? employee.getPosition() : "Employee";
    String phone = employee.getPhone() != null ? employee.getPhone() : "N/A";
    String status = employee.getStatus() != null ? employee.getStatus() : "ACTIVE";
    String username = employee.getUsername() != null ? employee.getUsername() : "N/A";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Details - CRM System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1><i class="fas fa-user-tie"></i> Employee Details</h1>
                    <a href="${pageContext.request.contextPath}/admin?action=manageEmployees" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Employees
                    </a>
                </div>

                
                <div id="alertContainer"></div>

                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-user-tie"></i> Employee Information - <%= fullName %>
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <strong><i class="fas fa-id-card"></i> Employee ID:</strong> 
                                    <span class="badge bg-dark">#<%= employee.getId() %></span>
                                </div>
                                <div class="mb-3">
                                    <strong><i class="fas fa-user"></i> Username:</strong> 
                                    <code><%= username %></code>
                                </div>
                                <div class="mb-3">
                                    <strong><i class="fas fa-signature"></i> First Name:</strong> 
                                    <%= firstName %>
                                </div>
                                <div class="mb-3">
                                    <strong><i class="fas fa-signature"></i> Last Name:</strong> 
                                    <%= lastName %>
                                </div>
                                <div class="mb-3">
                                    <strong><i class="fas fa-envelope"></i> Email:</strong> 
                                    <a href="mailto:<%= email %>"><%= email %></a>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <strong><i class="fas fa-building"></i> Department:</strong> 
                                    <span class="badge bg-info"><%= department %></span>
                                </div>
                                <div class="mb-3">
                                    <strong><i class="fas fa-briefcase"></i> Position:</strong> 
                                    <%= position %>
                                </div>
                                <div class="mb-3">
                                    <strong><i class="fas fa-phone"></i> Phone:</strong> 
                                    <% if (!"N/A".equals(phone)) { %>
                                        <a href="tel:<%= phone %>"><%= phone %></a>
                                    <% } else { %>
                                        <%= phone %>
                                    <% } %>
                                </div>
                                <div class="mb-3">
                                    <strong><i class="fas fa-circle"></i> Status:</strong> 
                                    <span class="badge <%= "ACTIVE".equals(status) ? "bg-success" : "bg-secondary" %>">
                                        <i class="fas <%= "ACTIVE".equals(status) ? "fa-check-circle" : "fa-times-circle" %>"></i>
                                        <%= status %>
                                    </span>
                                </div>
                                <div class="mb-3">
                                    <strong><i class="fas fa-calendar"></i> Created:</strong> 
                                    <%= employee.getCreatedAt() != null ? employee.getCreatedAt() : "N/A" %>
                                </div>
                            </div>
                        </div>
                        
                        
                        <div class="mt-4 pt-3 border-top">
                            <h5><i class="fas fa-cogs"></i> Actions</h5>
                            <div class="btn-group mt-2" role="group">
                                <a href="${pageContext.request.contextPath}/admin?action=editEmployee&id=<%= employee.getId() %>" 
                                   class="btn btn-warning">
                                    <i class="fas fa-edit"></i> Edit Employee
                                </a>
                                <button class="btn btn-danger delete-employee-btn" 
                                        data-employee-id="<%= employee.getId() %>" 
                                        data-employee-name="<%= fullName %>">
                                    <i class="fas fa-trash"></i> Delete Employee
                                </button>
                                <a href="${pageContext.request.contextPath}/admin?action=manageEmployees" 
                                   class="btn btn-secondary">
                                    <i class="fas fa-list"></i> All Employees
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

   
    <div id="loadingSpinner" class="loading-spinner" style="display: none;">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>

    
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            
            const deleteBtn = document.querySelector('.delete-employee-btn');
            if (deleteBtn) {
                deleteBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const employeeId = this.getAttribute('data-employee-id');
                    const employeeName = this.getAttribute('data-employee-name');
                    
                    if (confirm('Are you sure you want to delete employee "' + employeeName + '"? This action cannot be undone.')) {
                        
                        if (typeof deleteEmployee === 'function') {
                            deleteEmployee(employeeId, employeeName);
                        } else {
                          
                            window.location.href = "${pageContext.request.contextPath}/admin?action=deleteEmployee&id=" + employeeId;
                        }
                    }
                });
            }

            
            setTimeout(() => {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    if (typeof bootstrap !== 'undefined' && bootstrap.Alert) {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    } else {
                        alert.style.display = 'none';
                    }
                });
            }, 5000);
        });
    </script>
</body>
</html>