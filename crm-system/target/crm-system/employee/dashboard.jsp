<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.crm.model.Employee" %>
<%@ page import="com.crm.model.Complaint" %>
<%
    
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    Employee employee = (Employee) session.getAttribute("employee");
    
    if (userId == null || !"employee".equals(role) || employee == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as employee");
        return;
    }
    
    List<Complaint> assignedComplaints = (List<Complaint>) request.getAttribute("assignedComplaints");
    
    
    int totalComplaints = 0;
    int pendingCount = 0;
    int inProgressCount = 0;
    int resolvedCount = 0;
    
    if (assignedComplaints != null) {
        totalComplaints = assignedComplaints.size();
        for (Complaint c : assignedComplaints) {
            if ("PENDING".equals(c.getStatus())) {
                pendingCount++;
            } else if ("IN_PROGRESS".equals(c.getStatus())) {
                inProgressCount++;
            } else if ("RESOLVED".equals(c.getStatus())) {
                resolvedCount++;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Dashboard - CRM System</title>
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
                            <a class="nav-link active text-white" href="<%= request.getContextPath() %>/employee">
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
                                <i class="fas fa-user"></i> Profile
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
                    <h1 class="h2"><i class="fas fa-tachometer-alt"></i> Employee Dashboard</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <span class="badge bg-success"><i class="fas fa-user-tie"></i> <%= employee.getDepartment() %></span>
                    </div>
                </div>

               
                <div class="row mb-4">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-primary shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                            Assigned Complaints</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800"><%= totalComplaints %></div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-exclamation-circle fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-warning shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                            Pending Complaints</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800"><%= pendingCount %></div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-clock fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-info shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                            In Progress</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800"><%= inProgressCount %></div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-spinner fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-success shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                            Resolved</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800"><%= resolvedCount %></div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-check-circle fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                
                <div class="card shadow">
                    <div class="card-header bg-white">
                        <h5 class="card-title mb-0"><i class="fas fa-list"></i> Recent Assigned Complaints</h5>
                    </div>
                    <div class="card-body">
                        <% if (assignedComplaints != null && !assignedComplaints.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead class="thead-dark">
                                        <tr>
                                            <th>ID</th>
                                            <th>User</th>
                                            <th>Title</th>
                                            <th>Status</th>
                                            <th>Priority</th>
                                            <th>Created At</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Complaint c : assignedComplaints) { 
                                            String statusClass = "";
                                            switch(c.getStatus()) {
                                                case "PENDING": statusClass = "bg-warning"; break;
                                                case "IN_PROGRESS": statusClass = "bg-info"; break;
                                                case "RESOLVED": statusClass = "bg-success"; break;
                                                default: statusClass = "bg-secondary";
                                            }
                                            
                                            String priorityClass = "";
                                            switch(c.getPriority()) {
                                                case "HIGH": priorityClass = "bg-danger"; break;
                                                case "MEDIUM": priorityClass = "bg-warning"; break;
                                                case "LOW": priorityClass = "bg-info"; break;
                                                default: priorityClass = "bg-secondary";
                                            }
                                        %>
                                        <tr>
                                            <td>#<%= c.getId() %></td>
                                            <td><%= c.getUserName() != null ? c.getUserName() : "N/A" %></td>
                                            <td><%= c.getTitle() %></td>
                                            <td><span class="badge <%= statusClass %>"><%= c.getStatus() %></span></td>
                                            <td><span class="badge <%= priorityClass %>"><%= c.getPriority() %></span></td>
                                            <td><%= c.getCreatedAt() %></td>
                                            <td>
                                                <a href="<%= request.getContextPath() %>/employee?action=viewComplaint&id=<%= c.getId() %>" 
                                                   class="btn btn-sm btn-primary" title="View Details">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } else { %>
                            <div class="text-center py-4">
                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                <p class="text-muted">No complaints assigned to you yet.</p>
                                <p class="text-muted small">Complaints will appear here when assigned by administrators.</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>