<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.crm.model.Complaint" %>
<%@ page import="com.crm.model.Employee" %>
<%
    Complaint complaint = (Complaint) request.getAttribute("complaint");
    Employee employee = (Employee) session.getAttribute("employee");
    String role = (String) session.getAttribute("role");
    
    if (employee == null || !"employee".equals(role) || complaint == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access denied");
        return;
    }

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
    <title>Complaint Details - CRM System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .status-badge {
            font-size: 0.9em;
            padding: 0.5em 0.8em;
        }
        .priority-badge {
            font-size: 0.9em;
            padding: 0.5em 0.8em;
        }
        .complaint-card {
            border-left: 4px solid #007bff;
        }
        .info-card {
            border-left: 4px solid #28a745;
        }
        .update-card {
            border-left: 4px solid #ffc107;
        }
        .action-btn {
            min-width: 120px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar">
                <div class="position-sticky pt-3">
                    <div class="text-center text-white mb-4">
                        <h5>CRM System</h5>
                        <small>Employee Panel</small>
                    </div>
                    <div class="text-white mb-3 text-center">
                        <i class="fas fa-user-tie"></i> <%= employee.getFullName() %><br>
                        <small class="text-muted"><%= employee.getDepartment() %></small>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/employee?action=dashboard">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/employee?action=complaints">
                                <i class="fas fa-exclamation-circle"></i> My Complaints
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/employee?action=inquiries">
                                <i class="fas fa-question-circle"></i> Inquiries
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/employee?action=profile">
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
                    <h1 class="h2"><i class="fas fa-eye"></i> Complaint Details - #<%= complaint.getId() %></h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="<%= request.getContextPath() %>/employee?action=complaints" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Complaints
                        </a>
                    </div>
                </div>

                
                <% if (success != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i> <strong>Success!</strong> <%= success %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <% if (error != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> <strong>Error!</strong> <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <div class="row">
                   
                    <div class="col-md-8">
                        <div class="card shadow mb-4 complaint-card">
                            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-ticket-alt"></i> Complaint Details
                                </h5>
                                <span class="badge bg-light text-dark">
                                    <i class="fas fa-hashtag"></i> #<%= complaint.getId() %>
                                </span>
                            </div>
                            <div class="card-body">
                                <h4 class="text-primary mb-3"><%= complaint.getTitle() %></h4>
                                
                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <strong><i class="fas fa-user text-muted"></i> Submitted by:</strong>
                                        <span class="text-muted"><%= complaint.getUserName() != null ? complaint.getUserName() : "N/A" %></span>
                                    </div>
                                    <div class="col-md-6">
                                        <% if (complaint.getProductName() != null && !complaint.getProductName().equals("N/A")) { %>
                                        <strong><i class="fas fa-cube text-muted"></i> Product:</strong>
                                        <span class="text-muted"><%= complaint.getProductName() %></span>
                                        <% } %>
                                    </div>
                                </div>
                                
                                <div class="mb-4">
                                    <h6 class="border-bottom pb-2">
                                        <i class="fas fa-align-left text-muted"></i> 
                                        <strong>Description</strong>
                                    </h6>
                                    <div class="bg-light p-3 rounded">
                                        <p class="mb-0"><%= complaint.getDescription() %></p>
                                    </div>
                                </div>

                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <strong>Created Date:</strong>
                                        <p class="text-muted"><%= complaint.getCreatedAt() %></p>
                                    </div>
                                    <% if (complaint.getUpdatedAt() != null) { %>
                                    <div class="col-md-6">
                                        <strong>Last Updated:</strong>
                                        <p class="text-muted"><%= complaint.getUpdatedAt() %></p>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>

                   
                    <div class="col-md-4">
                       
                        <div class="card shadow mb-4 info-card">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-info-circle"></i> Complaint Information
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <strong>Status:</strong>
                                        <%
                                            String statusClass = "";
                                            String statusIcon = "";
                                            switch(complaint.getStatus()) {
                                                case "PENDING": 
                                                    statusClass = "bg-warning text-dark";
                                                    statusIcon = "fas fa-clock";
                                                    break;
                                                case "IN_PROGRESS": 
                                                    statusClass = "bg-info text-white";
                                                    statusIcon = "fas fa-spinner";
                                                    break;
                                                case "RESOLVED": 
                                                    statusClass = "bg-success text-white";
                                                    statusIcon = "fas fa-check-circle";
                                                    break;
                                                case "CLOSED": 
                                                    statusClass = "bg-dark text-white";
                                                    statusIcon = "fas fa-lock";
                                                    break;
                                                default: 
                                                    statusClass = "bg-secondary text-white";
                                                    statusIcon = "fas fa-question-circle";
                                            }
                                        %>
                                        <span class="badge status-badge <%= statusClass %>">
                                            <i class="<%= statusIcon %>"></i> <%= complaint.getStatus() %>
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <strong>Priority:</strong>
                                        <%
                                            String priorityClass = "";
                                            String priorityIcon = "";
                                            switch(complaint.getPriority()) {
                                                case "HIGH": 
                                                    priorityClass = "bg-danger text-white";
                                                    priorityIcon = "fas fa-exclamation-triangle";
                                                    break;
                                                case "MEDIUM": 
                                                    priorityClass = "bg-warning text-dark";
                                                    priorityIcon = "fas fa-exclamation-circle";
                                                    break;
                                                case "LOW": 
                                                    priorityClass = "bg-info text-white";
                                                    priorityIcon = "fas fa-info-circle";
                                                    break;
                                                default: 
                                                    priorityClass = "bg-secondary text-white";
                                                    priorityIcon = "fas fa-question-circle";
                                            }
                                        %>
                                        <span class="badge priority-badge <%= priorityClass %>">
                                            <i class="<%= priorityIcon %>"></i> <%= complaint.getPriority() %>
                                        </span>
                                    </div>
                                </div>
                                
                                <% if (complaint.getAssignedEmployeeName() != null) { %>
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <strong>Assigned To:</strong>
                                        <span class="text-muted">
                                            <i class="fas fa-user-tie"></i> <%= complaint.getAssignedEmployeeName() %>
                                        </span>
                                    </div>
                                </div>
                                <% } %>
                            </div>
                        </div>

                       
                        <div class="card shadow update-card">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-edit"></i> Update Status
                                </h5>
                            </div>
                            <div class="card-body">
                                <form id="updateStatusForm" action="<%= request.getContextPath() %>/employee" method="POST">
                                    <input type="hidden" name="action" value="updateComplaintStatus">
                                    <input type="hidden" name="id" value="<%= complaint.getId() %>">
                                    <input type="hidden" name="source" value="details">
                                    
                                    <div class="mb-3">
                                        <label for="statusSelect" class="form-label">
                                            <strong>Select New Status:</strong>
                                        </label>
                                        <select class="form-select" id="statusSelect" name="status" required>
                                            <option value="">Choose status...</option>
                                            <option value="PENDING" <%= "PENDING".equals(complaint.getStatus()) ? "selected" : "" %>>PENDING</option>
                                            <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(complaint.getStatus()) ? "selected" : "" %>>IN PROGRESS</option>
                                            <option value="RESOLVED" <%= "RESOLVED".equals(complaint.getStatus()) ? "selected" : "" %>>RESOLVED</option>
                                            <option value="CLOSED" <%= "CLOSED".equals(complaint.getStatus()) ? "selected" : "" %>>CLOSED</option>
                                        </select>
                                        <div class="form-text">
                                            Current status: <span class="fw-bold"><%= complaint.getStatus() %></span>
                                        </div>
                                    </div>

                                    
                                    <div class="mb-3">
                                        <label for="remarks" class="form-label fw-bold">Remarks (Optional):</label>
                                        <textarea class="form-control" id="remarks" name="remarks" 
                                                 rows="3" placeholder="Add any remarks about this status update..."></textarea>
                                    </div>
                                    
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-success btn-lg">
                                            <i class="fas fa-save"></i> Update Status
                                        </button>
                                        <div class="text-center">
                                            <small class="text-muted">
                                                This will update the complaint status immediately
                                            </small>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>

                        
                        <div class="card shadow mt-4">
                            <div class="card-header bg-white">
                                <h6 class="card-title mb-0">
                                    <i class="fas fa-bolt"></i> Quick Actions
                                </h6>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    
                                    <% if ("PENDING".equals(complaint.getStatus())) { %>
                                    <form action="<%= request.getContextPath() %>/employee" method="POST" style="margin: 0;">
                                        <input type="hidden" name="action" value="updateComplaintStatus">
                                        <input type="hidden" name="id" value="<%= complaint.getId() %>">
                                        <input type="hidden" name="status" value="IN_PROGRESS">
                                        <input type="hidden" name="source" value="details">
                                        <input type="hidden" name="remarks" value="Started working on the complaint">
                                        <button type="submit" class="btn btn-primary btn-sm action-btn">
                                            <i class="fas fa-play"></i> Start Working
                                        </button>
                                    </form>
                                    <% } %>
                                    
                                    
                                    <% if ("IN_PROGRESS".equals(complaint.getStatus())) { %>
                                    <button type="button" class="btn btn-success btn-sm action-btn" onclick="setQuickStatus('RESOLVED')">
                                        <i class="fas fa-check"></i> Mark Resolved
                                    </button>
                                    <% } %>
                                    
                                    
                                    <% if ("RESOLVED".equals(complaint.getStatus())) { %>
                                    <button type="button" class="btn btn-dark btn-sm action-btn" onclick="setQuickStatus('CLOSED')">
                                        <i class="fas fa-lock"></i> Mark Closed
                                    </button>
                                    <% } %>
                                    
                                    <a href="<%= request.getContextPath() %>/employee?action=complaints" class="btn btn-outline-secondary btn-sm">
                                        <i class="fas fa-list"></i> View All Complaints
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
        function setQuickStatus(status) {
            if (confirm('Are you sure you want to change status to ' + status + '?')) {
                document.getElementById('statusSelect').value = status;
                document.getElementById('updateStatusForm').submit();
            }
        }

        function validateStatusForm() {
            const statusSelect = document.getElementById('statusSelect');
            if (!statusSelect.value) {
                alert('Please select a status');
                statusSelect.focus();
                return false;
            }
            
            const currentStatus = '<%= complaint.getStatus() %>';
            const newStatus = statusSelect.value;
            
            if (currentStatus === newStatus) {
                if (!confirm('The selected status is the same as current status. Continue anyway?')) {
                    return false;
                }
            }
            
            const submitBtn = document.querySelector('#updateStatusForm button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
            submitBtn.disabled = true;
            
            
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            }, 5000);
            
            return true;
        }

        document.addEventListener('DOMContentLoaded', function() {
            console.log('Complaint details page loaded successfully');
            
            const updateStatusForm = document.getElementById('updateStatusForm');
            if (updateStatusForm) {
                updateStatusForm.addEventListener('submit', function(e) {
                    if (!validateStatusForm()) {
                        e.preventDefault();
                    }
                });
            }

            
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function(alert) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 5000);
        });
    </script>
</body>
</html>