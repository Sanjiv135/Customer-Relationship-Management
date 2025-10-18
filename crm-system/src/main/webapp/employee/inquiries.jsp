<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.crm.model.Inquiry" %>
<%@ page import="com.crm.model.Employee" %>
<%
    
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    Employee employee = (Employee) session.getAttribute("employee");
    
    if (userId == null || !"employee".equals(role) || employee == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as employee");
        return;
    }
    
    List<Inquiry> inquiries = (List<Inquiry>) request.getAttribute("inquiries");
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
    <title>Manage Inquiries - CRM System</title>
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
                            <a class="nav-link active text-white" href="<%= request.getContextPath() %>/employee?action=inquiries">
                                <i class="fas fa-question-circle"></i> Inquiries
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/employee?action=profile">
                                <i class="fas fa-user-cog"></i> Profile
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-danger" href="<%= request.getContextPath() %>/employee?action=logout">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2"><i class="fas fa-question-circle"></i> Manage Inquiries</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <span class="badge bg-primary fs-6">
                            Total: <%= inquiries != null ? inquiries.size() : 0 %>
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
                        <i class="fas fa-exclamation-circle"></i> <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <div class="card shadow">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0"><i class="fas fa-list"></i> Inquiry List</h5>
                        <div class="text-muted">
                            <small>Last updated: <%= new java.util.Date() %></small>
                        </div>
                    </div>
                    <div class="card-body">
                        <% if (inquiries != null && !inquiries.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table table-striped table-hover align-middle">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>ID</th>
                                            <th>User</th>
                                            <th>Subject</th>
                                            <th>Message</th>
                                            <th>Response</th>
                                            <th>Status</th>
                                            <th>Created At</th>
                                            <th class="text-center">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Inquiry inquiry : inquiries) { 
                                            String statusClass = "bg-secondary";
                                            if ("OPEN".equals(inquiry.getStatus())) statusClass = "bg-warning text-dark";
                                            else if ("IN_PROGRESS".equals(inquiry.getStatus())) statusClass = "bg-info";
                                            else if ("CLOSED".equals(inquiry.getStatus())) statusClass = "bg-success";
                                        %>
                                            <tr>
                                                <td class="fw-bold"><%= inquiry.getId() %></td>
                                                <td><%= inquiry.getUserName() %></td>
                                                <td>
                                                    <span class="d-inline-block text-truncate" style="max-width: 150px;" 
                                                          title="<%= inquiry.getSubject() %>">
                                                        <%= inquiry.getSubject() %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="d-inline-block text-truncate" style="max-width: 200px;" 
                                                          title="<%= inquiry.getMessage() %>">
                                                        <%= inquiry.getMessage().length() > 50 ? 
                                                            inquiry.getMessage().substring(0, 50) + "..." : inquiry.getMessage() %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <% if (inquiry.getResponse() != null && !inquiry.getResponse().trim().isEmpty()) { %>
                                                        <span class="d-inline-block text-truncate" style="max-width: 200px;" 
                                                              title="<%= inquiry.getResponse() %>">
                                                            <%= inquiry.getResponse().length() > 50 ? 
                                                                inquiry.getResponse().substring(0, 50) + "..." : inquiry.getResponse() %>
                                                        </span>
                                                    <% } else { %>
                                                        <span class="text-muted fst-italic">No response yet</span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <span class="badge <%= statusClass %>">
                                                        <%= inquiry.getStatus() %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <small class="text-muted">
                                                        <%= inquiry.getCreatedAt() != null ? 
                                                            inquiry.getCreatedAt().toString().substring(0, 10) : "N/A" %>
                                                    </small>
                                                </td>
                                                <td class="text-center">
                                                    <button type="button" class="btn btn-sm btn-primary" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#responseModal<%= inquiry.getId() %>"
                                                            title="Respond to Inquiry">
                                                        <i class="fas fa-reply"></i> Respond
                                                    </button>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } else { %>
                            <div class="text-center py-5">
                                <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                                <h4 class="text-muted">No Inquiries Found</h4>
                                <p class="text-muted">There are no inquiries to display at the moment.</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </main>
        </div>
    </div>


<% if (inquiries != null && !inquiries.isEmpty()) { %>
    <% for (Inquiry inquiry : inquiries) { %>
        <%= inquiry.getId() %> 
        <div class="modal fade" id="responseModal<%= inquiry.getId() %>" tabindex="-1" 
             aria-labelledby="responseModalLabel<%= inquiry.getId() %>" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form action="<%= request.getContextPath() %>/employee" method="post">
                        <input type="hidden" name="action" value="updateInquiry">
                        <input type="hidden" name="id" value="<%= inquiry.getId() %>">
                        
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title" id="responseModalLabel<%= inquiry.getId() %>">
                                <i class="fas fa-reply"></i> Respond to Inquiry #<%= inquiry.getId() %>
                            </h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        
                        <div class="modal-body">
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">User:</label>
                                    <p class="form-control-plaintext"><%= inquiry.getUserName() %></p>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Current Status:</label>
                                    <div>
                                        <span class="badge bg-info"><%= inquiry.getStatus() %></span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold">Subject:</label>
                                <p class="form-control-plaintext border rounded p-2 bg-light">
                                    <%= inquiry.getSubject() %>
                                </p>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold">Original Message:</label>
                                <div class="border rounded p-3 bg-light">
                                    <p class="mb-0"><%= inquiry.getMessage() %></p>
                                </div>
                            </div>
                            
                            <hr>
                            
                           
                            <div class="mb-3">
                                <label for="response<%= inquiry.getId() %>" class="form-label fw-bold">Your Response:</label>
                                <textarea class="form-control" id="response<%= inquiry.getId() %>" 
                                          name="response" rows="5" required 
                                          placeholder="Type your response here..."><%= inquiry.getResponse() != null ? inquiry.getResponse() : "" %></textarea>
                                <div class="form-text">Provide a clear and helpful response to the customer's inquiry.</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="status<%= inquiry.getId() %>" class="form-label fw-bold">Update Status:</label>
                                <select class="form-select" id="status<%= inquiry.getId() %>" name="status" required>
                                    <option value="">Select status...</option>
                                    <option value="OPEN" <%= "OPEN".equals(inquiry.getStatus()) ? "selected" : "" %>>OPEN</option>
                                    <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(inquiry.getStatus()) ? "selected" : "" %>>IN_PROGRESS</option>
                                    <option value="CLOSED" <%= "CLOSED".equals(inquiry.getStatus()) ? "selected" : "" %>>CLOSED</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times"></i> Cancel
                            </button>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-paper-plane"></i> Submit Response
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
    console.log('Inquiries page loaded successfully');
    
   
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