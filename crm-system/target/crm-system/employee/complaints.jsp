<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.crm.model.Complaint" %>
<%@ page import="com.crm.model.Employee" %>
<%
   
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    Employee employee = (Employee) session.getAttribute("employee");

    if (userId == null || !"employee".equals(role) || employee == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as employee");
        return;
    }

    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
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
    <title>My Complaints - CRM System</title>
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
                    <small>Employee Panel</small>
                </div>
                <div class="text-white mb-3 text-center">
                    <i class="fas fa-user-tie"></i> <%= employee.getFullName() %><br>
                    <small class="text-muted"><%= employee.getDepartment() %></small>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/employee?action=dashboard">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active text-white" href="${pageContext.request.contextPath}/employee?action=complaints">
                            <i class="fas fa-exclamation-circle"></i> My Complaints
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/employee?action=inquiries">
                            <i class="fas fa-question-circle"></i> Inquiries
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/employee?action=profile">
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
                <h1 class="h2"><i class="fas fa-exclamation-circle"></i> My Assigned Complaints</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <span class="badge bg-primary fs-6">
                        Total: <%= complaints != null ? complaints.size() : 0 %>
                    </span>
                </div>
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

            <div class="card shadow">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0"><i class="fas fa-list"></i> Complaint List</h5>
                    <div class="text-muted">
                        <small>Last updated: <%= new java.util.Date() %></small>
                    </div>
                </div>
                <div class="card-body">
                    <% if (complaints != null && !complaints.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover align-middle" id="complaintsTable">
                                <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>User</th>
                                    <th>Product</th>
                                    <th>Title</th>
                                    <th>Status</th>
                                    <th>Priority</th>
                                    <th>Created At</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                                </thead>
                                <tbody>
                                <% for (Complaint complaint : complaints) { 
                                    String statusClass = "bg-secondary";
                                    String priorityClass = "bg-secondary";
                                    
                                    if ("PENDING".equals(complaint.getStatus())) statusClass = "bg-warning text-dark";
                                    else if ("IN_PROGRESS".equals(complaint.getStatus())) statusClass = "bg-info";
                                    else if ("RESOLVED".equals(complaint.getStatus())) statusClass = "bg-success";
                                    else if ("CLOSED".equals(complaint.getStatus())) statusClass = "bg-dark";

                                    if ("HIGH".equals(complaint.getPriority())) priorityClass = "bg-danger";
                                    else if ("MEDIUM".equals(complaint.getPriority())) priorityClass = "bg-warning text-dark";
                                    else if ("LOW".equals(complaint.getPriority())) priorityClass = "bg-info";
                                %>
                                    <tr>
                                        <td class="fw-bold">#<%= complaint.getId() %></td>
                                        <td><%= complaint.getUserName() %></td>
                                        <td><%= complaint.getProductName() != null ? complaint.getProductName() : "N/A" %></td>
                                        <td>
                                            <span class="d-inline-block text-truncate" style="max-width: 200px;" 
                                                  title="<%= complaint.getTitle() %>">
                                                <%= complaint.getTitle() %>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge <%= statusClass %>">
                                                <%= complaint.getStatus() %>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge <%= priorityClass %>">
                                                <%= complaint.getPriority() %>
                                            </span>
                                        </td>
                                        <td>
                                            <small class="text-muted">
                                                <%= complaint.getCreatedAt() != null ? 
                                                    complaint.getCreatedAt().toString().substring(0, 10) : "N/A" %>
                                            </small>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group btn-group-sm" role="group">
                                                
                                                <a href="${pageContext.request.contextPath}/employee?action=viewComplaint&id=<%= complaint.getId() %>" 
                                                   class="btn btn-primary" title="View Complaint Details">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                              
                                                <button type="button"
                                                        class="btn btn-warning"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#updateModal<%= complaint.getId() %>"
                                                        title="Update Status">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } else { %>
                        <div class="text-center py-5">
                            <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                            <h4 class="text-muted">No Complaints Assigned</h4>
                            <p class="text-muted">There are no complaints assigned to you at the moment.</p>
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</div>


<% if (complaints != null && !complaints.isEmpty()) { %>
    <% for (Complaint complaint : complaints) { %>
        <%= complaint.getId() %> 
        <div class="modal fade" id="updateModal<%= complaint.getId() %>" tabindex="-1" 
             aria-labelledby="updateModalLabel<%= complaint.getId() %>" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    
                    <form action="${pageContext.request.contextPath}/employee" method="post">
                        <input type="hidden" name="action" value="updateComplaintStatus">
                        <input type="hidden" name="id" value="<%= complaint.getId() %>">
                        <input type="hidden" name="source" value="list">
                        
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title" id="updateModalLabel<%= complaint.getId() %>">
                                <i class="fas fa-edit"></i> Update Complaint #<%= complaint.getId() %>
                            </h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Complaint Title:</label>
                                <p class="form-control-plaintext"><%= complaint.getTitle() %></p>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold">Current Status:</label>
                                <div>
                                    <span class="badge bg-info fs-6"><%= complaint.getStatus() %></span>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="status<%= complaint.getId() %>" class="form-label fw-bold">Update Status:</label>
                                <select class="form-select" id="status<%= complaint.getId() %>" name="status" required>
                                    <option value="">Select new status...</option>
                                    <option value="PENDING" <%= "PENDING".equals(complaint.getStatus()) ? "selected" : "" %>>PENDING</option>
                                    <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(complaint.getStatus()) ? "selected" : "" %>>IN PROGRESS</option>
                                    <option value="RESOLVED" <%= "RESOLVED".equals(complaint.getStatus()) ? "selected" : "" %>>RESOLVED</option>
                                    <option value="CLOSED" <%= "CLOSED".equals(complaint.getStatus()) ? "selected" : "" %>>CLOSED</option>
                                </select>
                            </div>

                            
                            <div class="mb-3">
                                <label for="remarks<%= complaint.getId() %>" class="form-label fw-bold">Remarks (Optional):</label>
                                <textarea class="form-control" id="remarks<%= complaint.getId() %>" name="remarks" 
                                         rows="3" placeholder="Add any remarks about this status update..."></textarea>
                            </div>
                        </div>
                        
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times"></i> Cancel
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Update Status
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    <% } %>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>

document.addEventListener('DOMContentLoaded', function() {
    console.log('Complaints page loaded successfully');
    
    
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        });
    }, 5000);

   
    const updateForms = document.querySelectorAll('form[action*="employee"]');
    updateForms.forEach(function(form) {
        form.addEventListener('submit', function(e) {
            const statusSelect = form.querySelector('select[name="status"]');
            if (!statusSelect.value) {
                e.preventDefault();
                alert('Please select a status');
                statusSelect.focus();
                return false;
            }
            
            
            const submitBtn = form.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
            submitBtn.disabled = true;
            
            
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            }, 5000);
        });
    });
});
</script>
</body>
</html>