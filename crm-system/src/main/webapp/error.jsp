<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - CRM System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .error-container {
            margin-top: 100px;
        }
        .error-icon {
            font-size: 4rem;
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow error-container">
                    <div class="card-header bg-danger text-white">
                        <h4 class="card-title mb-0">
                            <i class="fas fa-exclamation-triangle"></i> Error Occurred
                        </h4>
                    </div>
                    <div class="card-body text-center">
                        <div class="mb-4">
                            <i class="fas fa-bug error-icon"></i>
                        </div>
                        
                        <%
                            
                            Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
                            String errorMessage = (String) request.getAttribute("javax.servlet.error.message");
                            String requestUri = (String) request.getAttribute("javax.servlet.error.request_uri");
                            Throwable ex = (Throwable) request.getAttribute("javax.servlet.error.exception");
                            
                            
                            if (statusCode == null) statusCode = 500;
                            if (errorMessage == null || errorMessage.trim().isEmpty()) {
                                errorMessage = "An unexpected error occurred while processing your request.";
                            }
                            if (requestUri == null) requestUri = "Unknown";
                        %>
                        
                        <h3 class="text-danger mb-3">Error <%= statusCode %></h3>
                        <div class="alert alert-danger">
                            <strong>Message:</strong> <%= errorMessage %>
                        </div>
                        
                        <div class="mb-3">
                            <strong>Request URI:</strong> <code><%= requestUri %></code>
                        </div>
                        
                        <% if (ex != null) { %>
                            <div class="alert alert-warning text-start">
                                <strong>Exception Details:</strong>
                                <div class="mt-2">
                                    <strong>Type:</strong> <%= ex.getClass().getName() %><br>
                                    <strong>Message:</strong> <%= ex.getMessage() %>
                                </div>
                                <% if (ex.getCause() != null) { %>
                                    <div class="mt-2">
                                        <strong>Root Cause:</strong> <%= ex.getCause().getMessage() %>
                                    </div>
                                <% } %>
                            </div>
                            
                            
                            <% if (false) { // Set to true for debugging %>
                                <div class="alert alert-info text-start small">
                                    <strong>Stack Trace:</strong>
                                    <pre class="mt-2" style="font-size: 0.8rem;"><%
                                        java.io.StringWriter sw = new java.io.StringWriter();
                                        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
                                        ex.printStackTrace(pw);
                                        out.print(sw.toString());
                                    %></pre>
                                </div>
                            <% } %>
                        <% } %>
                        
                        <div class="mt-4">
                            <a href="<%= request.getContextPath() %>/" class="btn btn-primary me-2">
                                <i class="fas fa-home"></i> Go Home
                            </a>
                            <a href="javascript:history.back()" class="btn btn-secondary me-2">
                                <i class="fas fa-arrow-left"></i> Go Back
                            </a>
                            <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-outline-primary">
                                <i class="fas fa-sign-in-alt"></i> Login Again
                            </a>
                        </div>
                        
                        
                        <% if (statusCode == 404) { %>
                            <div class="mt-4 alert alert-info">
                                <i class="fas fa-info-circle"></i> 
                                <strong>Tip:</strong> The page you're looking for might have been moved or deleted.
                            </div>
                        <% } else if (statusCode == 500) { %>
                            <div class="mt-4 alert alert-info">
                                <i class="fas fa-info-circle"></i> 
                                <strong>Tip:</strong> This is a server error. Please try again later or contact support.
                            </div>
                        <% } else if (statusCode == 403) { %>
                            <div class="mt-4 alert alert-info">
                                <i class="fas fa-info-circle"></i> 
                                <strong>Tip:</strong> You don't have permission to access this resource.
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>