<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.crm.model.FAQ" %>
<%@ page import="com.crm.model.User" %>
<%@ page import="com.crm.model.Customer" %>
<%
    
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    Customer customer = (Customer) session.getAttribute("customer");
    
    if (userId == null || !"customer".equals(role) || customer == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login as customer");
        return;
    }
    
    List<FAQ> faqs = (List<FAQ>) request.getAttribute("faqs");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FAQs - CRM System</title>
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
                        <small>Customer Panel</small>
                    </div>
                    <div class="text-white mb-3 text-center">
                        <i class="fas fa-user"></i> <%= customer.getFullName() %>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/user?action=dashboard">Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/user?action=products">Products</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/user?action=complaints">My Complaints</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/user?action=inquiries">Inquiries</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="<%= request.getContextPath() %>/user?action=faqs">FAQs</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/user?action=profile">Profile</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-danger" href="<%= request.getContextPath() %>/auth?action=logout">Logout</a>
                        </li>
                    </ul>
                </div>
            </nav>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Frequently Asked Questions</h1>
                </div>

                <div class="row">
                    <div class="col-12">
                        <% if (faqs != null && !faqs.isEmpty()) { %>
                            <div class="accordion" id="faqAccordion">
                                <% for (int i = 0; i < faqs.size(); i++) { 
                                    FAQ faq = faqs.get(i);
                                %>
                                    <div class="accordion-item">
                                        <h2 class="accordion-header" id="heading<%= i %>">
                                            <button class="accordion-button <%= i != 0 ? "collapsed" : "" %>" 
                                                    type="button" data-bs-toggle="collapse" 
                                                    data-bs-target="#collapse<%= i %>" 
                                                    aria-expanded="<%= i == 0 ? "true" : "false" %>" 
                                                    aria-controls="collapse<%= i %>">
                                                <%= faq.getQuestion() %>
                                            </button>
                                        </h2>
                                        <div id="collapse<%= i %>" 
                                             class="accordion-collapse collapse <%= i == 0 ? "show" : "" %>" 
                                             aria-labelledby="heading<%= i %>" 
                                             data-bs-parent="#faqAccordion">
                                            <div class="accordion-body">
                                                <%= faq.getAnswer() %>
                                                <% if (faq.getCategory() != null) { %>
                                                    <div class="mt-2">
                                                        <small class="text-muted">
                                                            Category: <%= faq.getCategory() %>
                                                        </small>
                                                    </div>
                                                <% } %>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        <% } else { %>
                            <div class="text-center py-4">
                                <i class="fas fa-question-circle fa-3x text-muted mb-3"></i>
                                <h4>No FAQs Available</h4>
                                <p class="text-muted">Check back later for frequently asked questions.</p>
                            </div>
                        <% } %>
                    </div>
                </div>

                
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title">Need More Help?</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6>Submit a Complaint</h6>
                                        <p>If you're experiencing issues with our products or services, submit a detailed complaint and our support team will assist you.</p>
                                        
                                        <a href="<%= request.getContextPath() %>/user?action=new-complaint" class="btn btn-primary">Submit Complaint</a>
                                    </div>
                                    <div class="col-md-6">
                                        <h6>Contact Support</h6>
                                        <p>For immediate assistance, you can contact our support team directly.</p>
                                        <ul class="list-unstyled">
                                            <li><i class="fas fa-phone"></i> Support: 1-800-HELP-NOW</li>
                                            <li><i class="fas fa-envelope"></i> Email: support@crm.com</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>