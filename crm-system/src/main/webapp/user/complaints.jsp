<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.crm.model.Complaint" %>
<%@ page import="com.crm.model.Customer" %>
<%
    
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    Customer customer = (Customer) session.getAttribute("customer");
    
    if (userId == null || !"customer".equals(role) || customer == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
        return;
    }

    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");

    
    if (success != null) session.removeAttribute("success");
    if (error != null) session.removeAttribute("error");

    String displayName = customer.getFirstName() != null ? 
                         (customer.getLastName() != null ? customer.getFirstName() + " " + customer.getLastName() : customer.getFirstName()) :
                         (customer.getLastName() != null ? customer.getLastName() : customer.getEmail());
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
    <style>
        .table-actions {
            white-space: nowrap;
            width: 200px;
        }
        .action-btn {
            margin: 2px;
        }
    </style>
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
                    <i class="fas fa-user"></i> <%= displayName %>
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
                        <a class="nav-link active text-white" href="${pageContext.request.contextPath}/user?action=complaints">
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
                <h1 class="h2"><i class="fas fa-exclamation-circle"></i> My Complaints</h1>
                <a href="${pageContext.request.contextPath}/user?action=new-complaint" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Submit New Complaint
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

            <div class="card shadow">
                <div class="card-header bg-white">
                    <h5 class="card-title mb-0"><i class="fas fa-list"></i> Complaint History</h5>
                </div>
                <div class="card-body">
                    <% if (complaints != null && !complaints.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover align-middle" id="complaintsTable">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Product</th>
                                        <th>Title</th>
                                        <th>Description</th>
                                        <th>Status</th>
                                        <th>Priority</th>
                                        <th>Assigned To</th>
                                        <th>Created At</th>
                                        <th class="table-actions">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Complaint complaint : complaints) { 
                                        String statusClass = "bg-secondary";
                                        String priorityClass = "bg-secondary";
                                        if ("PENDING".equals(complaint.getStatus())) statusClass = "bg-warning";
                                        else if ("IN_PROGRESS".equals(complaint.getStatus())) statusClass = "bg-info";
                                        else if ("RESOLVED".equals(complaint.getStatus())) statusClass = "bg-success";
                                        else if ("CLOSED".equals(complaint.getStatus())) statusClass = "bg-dark";

                                        if ("HIGH".equals(complaint.getPriority())) priorityClass = "bg-danger";
                                        else if ("MEDIUM".equals(complaint.getPriority())) priorityClass = "bg-warning";
                                        else if ("LOW".equals(complaint.getPriority())) priorityClass = "bg-info";

                                        String shortDescription = complaint.getDescription() != null && complaint.getDescription().length() > 50 ? 
                                                                  complaint.getDescription().substring(0, 50) + "..." : 
                                                                  complaint.getDescription() != null ? complaint.getDescription() : "";
                                    %>
                                        <tr data-complaint-id="<%= complaint.getId() %>">
                                            <td>#<%= complaint.getId() %></td>
                                            <td><%= complaint.getProductName() != null ? complaint.getProductName() : "N/A" %></td>
                                            <td><%= complaint.getTitle() != null ? complaint.getTitle() : "No Title" %></td>
                                            <td><%= shortDescription %></td>
                                            <td>
                                                <span class="badge <%= statusClass %>">
                                                    <%= complaint.getStatus() != null ? complaint.getStatus() : "UNKNOWN" %>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge <%= priorityClass %>">
                                                    <%= complaint.getPriority() != null ? complaint.getPriority() : "UNKNOWN" %>
                                                </span>
                                            </td>
                                            <td><%= complaint.getAssignedEmployeeName() != null ? complaint.getAssignedEmployeeName() : "Not Assigned" %></td>
                                            <td><%= complaint.getCreatedAt() != null ? complaint.getCreatedAt() : "N/A" %></td>
                                            <td class="table-actions">
                                                
                                                <a href="${pageContext.request.contextPath}/user?action=viewComplaint&id=<%= complaint.getId() %>" 
                                                    class="btn btn-sm btn-primary action-btn" title="View Details">
                                                    <i class="fas fa-eye"></i> View
                                                </a>
                                                
                                            
                                                <% if ("PENDING".equals(complaint.getStatus())) { %>
                                                    <button class="btn btn-sm btn-warning action-btn edit-complaint-btn" 
                                                            data-complaint-id="<%= complaint.getId() %>"
                                                            data-complaint-title="<%= complaint.getTitle() != null ? complaint.getTitle() : "" %>"
                                                            data-complaint-description="<%= complaint.getDescription() != null ? complaint.getDescription() : "" %>"
                                                            data-complaint-priority="<%= complaint.getPriority() != null ? complaint.getPriority() : "MEDIUM" %>"
                                                            title="Edit Complaint">
                                                        <i class="fas fa-edit"></i> Edit
                                                    </button>
                                                <% } %>
                                                
                                                
                                                <% if ("PENDING".equals(complaint.getStatus())) { %>
                                                    <button class="btn btn-sm btn-danger action-btn delete-complaint-btn" 
                                                            data-complaint-id="<%= complaint.getId() %>" 
                                                            data-complaint-title="<%= complaint.getTitle() != null ? complaint.getTitle() : "No Title" %>"
                                                            title="Delete Complaint">
                                                        <i class="fas fa-trash"></i> Delete
                                                    </button>
                                                <% } %>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } else { %>
                        <div class="text-center py-4">
                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                            <h4>No Complaints Found</h4>
                            <p class="text-muted">You haven't submitted any complaints yet.</p>
                            <a href="${pageContext.request.contextPath}/user?action=new-complaint" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Submit Your First Complaint
                            </a>
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</div>


<div class="modal fade" id="editComplaintModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/user" method="post">
                <input type="hidden" name="action" value="updateComplaint">
                <input type="hidden" name="id" id="editComplaintId">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Complaint</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="editTitle" class="form-label">Complaint Title</label>
                        <input type="text" class="form-control" id="editTitle" name="title" required>
                    </div>
                    <div class="mb-3">
                        <label for="editDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="editDescription" name="description" rows="5" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="editPriority" class="form-label">Priority</label>
                        <select class="form-select" id="editPriority" name="priority" required>
                            <option value="LOW">Low</option>
                            <option value="MEDIUM">Medium</option>
                            <option value="HIGH">High</option>
                            <option value="URGENT">Urgent</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Complaint</button>
                </div>
            </form>
        </div>
    </div>
</div>


<div class="modal fade" id="deleteComplaintModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Confirm Delete</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete the complaint: <strong id="deleteComplaintTitle"></strong>?</p>
                <p class="text-danger">This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form action="${pageContext.request.contextPath}/user" method="post" style="display: inline;">
                    <input type="hidden" name="action" value="deleteComplaint">
                    <input type="hidden" name="id" id="deleteComplaintId">
                    <button type="submit" class="btn btn-danger">Delete Complaint</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
 
    document.addEventListener('DOMContentLoaded', function() {
        const editButtons = document.querySelectorAll('.edit-complaint-btn');
        const deleteButtons = document.querySelectorAll('.delete-complaint-btn');
        
       
        editButtons.forEach(button => {
            button.addEventListener('click', function() {
                const complaintId = this.getAttribute('data-complaint-id');
                const complaintTitle = this.getAttribute('data-complaint-title');
                const complaintDescription = this.getAttribute('data-complaint-description');
                const complaintPriority = this.getAttribute('data-complaint-priority');
                
                document.getElementById('editComplaintId').value = complaintId;
                document.getElementById('editTitle').value = complaintTitle;
                document.getElementById('editDescription').value = complaintDescription;
                document.getElementById('editPriority').value = complaintPriority;
                
                const editModal = new bootstrap.Modal(document.getElementById('editComplaintModal'));
                editModal.show();
            });
        });
        
     
        deleteButtons.forEach(button => {
            button.addEventListener('click', function() {
                const complaintId = this.getAttribute('data-complaint-id');
                const complaintTitle = this.getAttribute('data-complaint-title');
                
                document.getElementById('deleteComplaintId').value = complaintId;
                document.getElementById('deleteComplaintTitle').textContent = complaintTitle;
                
                const deleteModal = new bootstrap.Modal(document.getElementById('deleteComplaintModal'));
                deleteModal.show();
            });
        });
    });
</script>
</body>
</html>