<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - CRM System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .form-control:focus {
            border-color: #2575fc;
            box-shadow: 0 0 0 0.2rem rgba(37, 117, 252, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #2575fc 0%, #6a11cb 100%);
            border: none;
        }
        .method-card {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .method-card:hover, .method-card.selected {
            border-color: #2575fc;
            background-color: #f8f9ff;
        }
        .method-icon {
            font-size: 2rem;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-primary text-white text-center">
                        <h4><i class="fas fa-key"></i> Forgot Password</h4>
                    </div>
                    <div class="card-body p-4">

                        <% 
                            String error = request.getParameter("error");
                            String success = request.getParameter("success");
                            if (error != null) { 
                        %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle"></i> <%= error %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>
                        
                        <% if (success != null) { %>
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle"></i> <%= success %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>

                        <p class="text-muted mb-4">Select how you want to receive your OTP code:</p>

                        <form action="${pageContext.request.contextPath}/password-reset" method="post" id="forgotPasswordForm">
                            <input type="hidden" name="action" value="request-otp">
                            
                            <div class="mb-4">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="method-card" id="emailMethod" onclick="selectMethod('email')">
                                            <div class="text-center">
                                                <div class="method-icon text-primary">
                                                    <i class="fas fa-envelope"></i>
                                                </div>
                                                <h6>Email</h6>
                                                <small class="text-muted">Get OTP via Email</small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="method-card" id="phoneMethod" onclick="selectMethod('phone')">
                                            <div class="text-center">
                                                <div class="method-icon text-success">
                                                    <i class="fas fa-mobile-alt"></i>
                                                </div>
                                                <h6>SMS</h6>
                                                <small class="text-muted">Get OTP via SMS</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" name="method" id="selectedMethod" value="email" required>
                            </div>

                            <div class="form-group mb-3" id="emailGroup">
                                <label for="email" class="form-label">Email Address:</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                    <input type="email" id="email" name="email" class="form-control" 
                                           placeholder="Enter your registered email address" required>
                                </div>
                            </div>

                            <div class="form-group mb-3" id="phoneGroup" style="display: none;">
                                <label for="phone" class="form-label">Phone Number:</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                    <input type="tel" id="phone" name="phone" class="form-control" 
                                           placeholder="Enter your registered phone number">
                                </div>
                                <small class="form-text text-muted">Format: +1-555-123-4567 or 5551234567</small>
                            </div>

                            <div class="d-grid gap-2 mt-4">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-paper-plane"></i> Send OTP
                                </button>
                                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left"></i> Back to Login
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        function selectMethod(method) {
            
            document.getElementById('emailMethod').classList.remove('selected');
            document.getElementById('phoneMethod').classList.remove('selected');
            document.getElementById(method + 'Method').classList.add('selected');
            
            
            document.getElementById('selectedMethod').value = method;
            
            
            if (method === 'email') {
                document.getElementById('emailGroup').style.display = 'block';
                document.getElementById('phoneGroup').style.display = 'none';
                document.getElementById('email').required = true;
                document.getElementById('phone').required = false;
                document.getElementById('phone').value = '';
            } else {
                document.getElementById('emailGroup').style.display = 'none';
                document.getElementById('phoneGroup').style.display = 'block';
                document.getElementById('email').required = false;
                document.getElementById('phone').required = true;
                document.getElementById('email').value = '';
            }
        }

        
        document.addEventListener('DOMContentLoaded', function() {
            selectMethod('email');
           
            document.getElementById('emailMethod').classList.add('selected');
        });

        
        document.getElementById('forgotPasswordForm').addEventListener('submit', function(e) {
            const method = document.getElementById('selectedMethod').value;
            const email = document.getElementById('email').value;
            const phone = document.getElementById('phone').value;
            
            if (method === 'email' && !email) {
                e.preventDefault();
                alert('Please enter your email address');
                return;
            }
            
            if (method === 'phone' && !phone) {
                e.preventDefault();
                alert('Please enter your phone number');
                return;
            }
        });
    </script>
</body>
</html>