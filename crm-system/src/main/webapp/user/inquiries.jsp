<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.crm.model.Inquiry" %>
<%@ page import="com.crm.model.Customer" %>
<%
   
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    Customer customer = (Customer) session.getAttribute("customer");
    
    if (userId == null || !"customer".equals(role) || customer == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
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
    <title>My Inquiries - CRM System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .badge-open { background-color: #28a745; }
        .badge-in-progress { background-color: #ffc107; color: #000; }
        .badge-resolved { background-color: #17a2b8; }
        .badge-closed { background-color: #6c757d; }
    </style>
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
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/user?action=dashboard">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/user?action=products">
                                <i class="fas fa-box"></i> Products
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/user?action=complaints">
                                <i class="fas fa-exclamation-circle"></i> My Complaints
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="<%= request.getContextPath() %>/user?action=inquiries">
                                <i class="fas fa-question-circle"></i> Inquiries
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/user?action=faqs">
                                <i class="fas fa-file-alt"></i> FAQs
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%= request.getContextPath() %>/user?action=profile">
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
                    <h1 class="h2"><i class="fas fa-question-circle"></i> My Inquiries</h1>
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newInquiryModal">
                        <i class="fas fa-plus"></i> New Inquiry
                    </button>
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
                    <div class="card-header bg-white">
                        <h5 class="card-title mb-0"><i class="fas fa-list"></i> Inquiry History</h5>
                    </div>
                    <div class="card-body">
                        <% if (inquiries != null && !inquiries.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>ID</th>
                                            <th>Subject</th>
                                            <th>Message</th>
                                            <th>Response</th>
                                            <th>Status</th>
                                            <th>Created At</th>
                                            <th>Updated At</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Inquiry inquiry : inquiries) { 
                                            String statusClass = "";
                                            switch(inquiry.getStatus().toLowerCase()) {
                                                case "open": statusClass = "badge-open"; break;
                                                case "in_progress": statusClass = "badge-in-progress"; break;
                                                case "resolved": statusClass = "badge-resolved"; break;
                                                case "closed": statusClass = "badge-closed"; break;
                                                default: statusClass = "bg-secondary";
                                            }
                                        %>
                                            <tr>
                                                <td>#<%= inquiry.getId() %></td>
                                                <td><strong><%= inquiry.getSubject() %></strong></td>
                                                <td>
                                                    <%= inquiry.getMessage().length() > 50 ? 
                                                        inquiry.getMessage().substring(0, 50) + "..." : inquiry.getMessage() %>
                                                </td>
                                                <td>
                                                    <% if (inquiry.getResponse() != null && !inquiry.getResponse().trim().isEmpty()) { %>
                                                        <%= inquiry.getResponse().length() > 50 ? 
                                                            inquiry.getResponse().substring(0, 50) + "..." : inquiry.getResponse() %>
                                                    <% } else { %>
                                                        <span class="text-muted">Awaiting response</span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <span class="badge <%= statusClass %>">
                                                        <%= inquiry.getStatus() %>
                                                    </span>
                                                </td>
                                                <td><%= inquiry.getCreatedAt() != null ? inquiry.getCreatedAt().toString() : "N/A" %></td>
                                                <td><%= inquiry.getUpdatedAt() != null ? inquiry.getUpdatedAt().toString() : "N/A" %></td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } else { %>
                            <div class="text-center py-4">
                                <i class="fas fa-question-circle fa-3x text-muted mb-3"></i>
                                <h4>No Inquiries Submitted</h4>
                                <p class="text-muted">You haven't submitted any inquiries yet.</p>
                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newInquiryModal">
                                    <i class="fas fa-plus"></i> Submit Your First Inquiry
                                </button>
                            </div>
                        <% } %>
                    </div>
                </div>
            </main>
        </div>
    </div>

    
    <div class="modal fade" id="newInquiryModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form action="<%= request.getContextPath() %>/user?action=addInquiry" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-question-circle"></i> Submit New Inquiry</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="subject" class="form-label">Subject</label>
                            <input type="text" class="form-control" id="subject" name="subject" 
                                   placeholder="Brief subject of your inquiry" required
                                   maxlength="255">
                            <div class="form-text">Maximum 255 characters</div>
                        </div>
                        <div class="mb-3">
                            <label for="message" class="form-label">Message</label>
                            <textarea class="form-control" id="message" name="message" 
                                      rows="6" placeholder="Please provide detailed information about your inquiry..." 
                                      required maxlength="2000"></textarea>
                            <div class="form-text">Maximum 2000 characters</div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane"></i> Submit Inquiry
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            
            const subjectInput = document.getElementById('subject');
            const messageTextarea = document.getElementById('message');
            
            if (subjectInput) {
                const subjectCounter = document.createElement('div');
                subjectCounter.className = 'form-text text-end';
                subjectCounter.textContent = '0/255 characters';
                subjectInput.parentNode.appendChild(subjectCounter);
                
                subjectInput.addEventListener('input', function() {
                    const length = this.value.length;
                    subjectCounter.textContent = length + '/255 characters';
                    if (length > 255) {
                        subjectCounter.classList.add('text-danger');
                    } else {
                        subjectCounter.classList.remove('text-danger');
                    }
                });
            }
            
            if (messageTextarea) {
                const messageCounter = document.createElement('div');
                messageCounter.className = 'form-text text-end';
                messageCounter.textContent = '0/2000 characters';
                messageTextarea.parentNode.appendChild(messageCounter);
                
                messageTextarea.addEventListener('input', function() {
                    const length = this.value.length;
                    messageCounter.textContent = length + '/2000 characters';
                    if (length > 2000) {
                        messageCounter.classList.add('text-danger');
                    } else {
                        messageCounter.classList.remove('text-danger');
                    }
                });
            }
            
            
            <% if (error != null && error.contains("inquiry")) { %>
                const modal = new bootstrap.Modal(document.getElementById('newInquiryModal'));
                modal.show();
            <% } %>
        });
    </script>
</body>
</html>