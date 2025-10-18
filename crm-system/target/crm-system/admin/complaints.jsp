<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.crm.model.Complaint" %>
<%@ page import="com.crm.model.Employee" %>
<%
    
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    
    if (userId == null || !"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as admin");
        return;
    }
    
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
    List<Employee> employees = (List<Employee>) request.getAttribute("employees");
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    
    
    String displayName = username != null ? username : "Admin";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Complaints - CRM System</title>
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
                    <h1 class="h2"><i class="fas fa-exclamation-circle"></i> Manage Complaints</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        
                        <a href="<%= request.getContextPath() %>/admin?action=downloadComplaints" 
                           class="btn btn-success me-2">
                            <i class="fas fa-download"></i> Download CSV Report
                        </a>
                    </div>
                </div>

              
                <div id="alertContainer"></div>

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
                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0"><i class="fas fa-list"></i> All Complaints</h5>
                        <span class="badge bg-primary"><%= complaints != null ? complaints.size() : 0 %> complaints</span>
                    </div>
                    <div class="card-body">
                        <% if (complaints != null && !complaints.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table table-striped table-hover" id="complaintsTable">
                                    <thead class="thead-dark">
                                        <tr>
                                            <th>ID</th>
                                            <th>User</th>
                                            <th>Product</th>
                                            <th>Title</th>
                                            <th>Status</th>
                                            <th>Priority</th>
                                            <th>Assigned To</th>
                                            <th>Created At</th>
                                            <th class="table-actions">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Complaint complaint : complaints) { 
                                            
                                            String userName = complaint.getUserName() != null ? complaint.getUserName() : "N/A";
                                            String productName = complaint.getProductName() != null ? complaint.getProductName() : "N/A";
                                            String title = complaint.getTitle() != null ? complaint.getTitle() : "No Title";
                                            String status = complaint.getStatus() != null ? complaint.getStatus() : "UNKNOWN";
                                            String priority = complaint.getPriority() != null ? complaint.getPriority() : "UNKNOWN";
                                            String assignedEmployeeName = complaint.getAssignedEmployeeName() != null ? complaint.getAssignedEmployeeName() : "Not Assigned";
                                            String createdAt = complaint.getCreatedAt() != null ? complaint.getCreatedAt().toString() : "N/A";
                                            
                                            
                                            String statusClass = "";
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
                                            }
                                            
                                            String priorityClass = "";
                                            if (priority != null) {
                                                switch(priority) {
                                                    case "HIGH": priorityClass = "bg-danger"; break;
                                                    case "MEDIUM": priorityClass = "bg-warning"; break;
                                                    case "LOW": priorityClass = "bg-info"; break;
                                                    default: priorityClass = "bg-secondary";
                                                }
                                            } else {
                                                priorityClass = "bg-secondary";
                                            }
                                        %>
                                            <tr data-complaint-id="<%= complaint.getId() %>">
                                                <td>#<%= complaint.getId() %></td>
                                                <td><%= userName %></td>
                                                <td><%= productName %></td>
                                                <td><%= title %></td>
                                                <td>
                                                    <span class="badge <%= statusClass %>">
                                                        <%= status %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge <%= priorityClass %>">
                                                        <%= priority %>
                                                    </span>
                                                </td>
                                                <td><%= assignedEmployeeName %></td>
                                                <td><%= createdAt %></td>
                                                <td class="table-actions">
                                                    <a href="<%= request.getContextPath() %>/admin?action=viewComplaint&id=<%= complaint.getId()  %>" 
                                                        class="btn btn-sm btn-info" title="View Complaint Details">
                                                        <i class="fas fa-eye"></i> View
                                                    </a>
                                                    <a href="<%= request.getContextPath() %>/admin?action=editComplaint&id=<%= complaint.getId() %>" 
                                                       class="btn btn-sm btn-warning" title="Edit Complaint">
                                                        <i class="fas fa-edit"></i> Edit
                                                    </a>
                                                    <a href="<%= request.getContextPath() %>/admin?action=deleteComplaint&id=<%= complaint.getId() %>" 
                                                       class="btn btn-sm btn-danger" 
                                                       onclick="return confirm('Are you sure you want to delete complaint: <%= title %>?')"
                                                       title="Delete Complaint">
                                                        <i class="fas fa-trash"></i> Delete
                                                    </a>
                                                    <button type="button" class="btn btn-sm btn-secondary assign-complaint-btn" 
                                                            data-complaint-id="<%= complaint.getId() %>" 
                                                            title="Assign Complaint">
                                                        <i class="fas fa-user-plus"></i> Assign
                                                    </button>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } else { %>
                            <div class="text-center py-4">
                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                <h5>No Complaints Found</h5>
                                <p class="text-muted">There are no complaints in the system yet.</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </main>
        </div>
    </div>

    
    <div class="modal fade" id="assignModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="<%= request.getContextPath() %>/admin?action=updateComplaint" method="post">
                    <input type="hidden" name="id" id="assignComplaintId">
                    <div class="modal-header">
                        <h5 class="modal-title">Assign Complaint</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="assignStatus" class="form-label">Status</label>
                            <select class="form-select" id="assignStatus" name="status" required>
                                <option value="PENDING">PENDING</option>
                                <option value="IN_PROGRESS">IN_PROGRESS</option>
                                <option value="RESOLVED">RESOLVED</option>
                                <option value="CLOSED">CLOSED</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="assignEmployee" class="form-label">Assign To</label>
                            <select class="form-select" id="assignEmployee" name="assignedTo">
                                <option value="">Not Assigned</option>
                                <% if (employees != null && !employees.isEmpty()) { 
                                    for (Employee emp : employees) { 
                                        String empDisplayName = "Employee";
                                        if (emp != null) {
                                            if (emp.getFirstName() != null && emp.getLastName() != null) {
                                                empDisplayName = emp.getFirstName() + " " + emp.getLastName();
                                            } else if (emp.getFirstName() != null) {
                                                empDisplayName = emp.getFirstName();
                                            } else if (emp.getLastName() != null) {
                                                empDisplayName = emp.getLastName();
                                            }
                                        }
                                        String department = emp != null && emp.getDepartment() != null ? emp.getDepartment() : "N/A";
                                %>
                                        <option value="<%= emp != null ? emp.getId() : "" %>">
                                            <%= empDisplayName %> (<%= department %>)
                                        </option>
                                    <% } 
                                } else { %>
                                    <option value="" disabled>No employees available</option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    
    <div id="loadingSpinner" class="loading-spinner" style="display: none;">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        
        document.addEventListener('DOMContentLoaded', function() {
            
            document.querySelectorAll('.assign-complaint-btn').forEach(function(button) {
                button.addEventListener('click', function() {
                    const complaintId = this.getAttribute('data-complaint-id');
                    document.getElementById('assignComplaintId').value = complaintId;
                    
                    
                    const assignModal = new bootstrap.Modal(document.getElementById('assignModal'));
                    assignModal.show();
                });
            });

            
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function(alert) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 5000);

            
            document.querySelector('.btn-success').addEventListener('click', function(e) {
                
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generating Report...';
                this.disabled = true;
                
                setTimeout(() => {
                    this.innerHTML = originalText;
                    this.disabled = false;
                }, 3000);
            });
        });
    </script>
</body>
</html>