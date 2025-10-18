<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - CRM System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-success text-white text-center">
                        <h4>Create Your Account</h4>
                    </div>
                    <div class="card-body">
                        <% 
                            String error = (String) request.getAttribute("error"); 
                            if (error == null) {
                                error = (String) session.getAttribute("error");
                            }
                            if (error != null) { 
                        %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle"></i> <%= error %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% 
                            session.removeAttribute("error"); 
                            } 
                        %>
                        
                        <% 
                            String success = (String) request.getAttribute("success"); 
                            if (success == null) {
                                success = (String) session.getAttribute("success");
                            }
                            if (success != null) { 
                        %>
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle"></i> <%= success %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% 
                            session.removeAttribute("success"); 
                            } 
                        %>

                        <form action="${pageContext.request.contextPath}/auth" method="post">
                            <input type="hidden" name="action" value="signup">

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="username" class="form-label">Username *</label>
                                    <input type="text" class="form-control" id="username" name="username" required 
                                           pattern="[a-zA-Z0-9]{3,20}" 
                                           title="Username must be 3-20 characters (letters and numbers only)"
                                           value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
                                    <div class="form-text">3-20 characters, letters and numbers only</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">Email *</label>
                                    <input type="email" class="form-control" id="email" name="email" required
                                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="password" class="form-label">Password *</label>
                                    <input type="password" class="form-control" id="password" name="password" required 
                                           pattern=".{6,}" 
                                           title="Password must be at least 6 characters">
                                    <div class="form-text">Minimum 6 characters</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="confirmPassword" class="form-label">Confirm Password *</label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="firstName" class="form-label">First Name *</label>
                                    <input type="text" class="form-control" id="firstName" name="firstName" required
                                           value="<%= request.getParameter("firstName") != null ? request.getParameter("firstName") : "" %>">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="lastName" class="form-label">Last Name *</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName" required
                                           value="<%= request.getParameter("lastName") != null ? request.getParameter("lastName") : "" %>">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Phone Number *</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" required
                                           pattern="^[+]?[0-9\s\-\(\)]{10,15}$"
                                           title="Please enter a valid phone number (10-15 digits)"
                                           value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>">
                                    <div class="form-text">Format: +1-555-0123 or 5550123456</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="company" class="form-label">Company</label>
                                    <input type="text" class="form-control" id="company" name="company"
                                           value="<%= request.getParameter("company") != null ? request.getParameter("company") : "" %>">
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="3"
                                          placeholder="Enter your full address"><%= request.getParameter("address") != null ? request.getParameter("address") : "" %></textarea>
                            </div>
                            
                            <div class="mb-3 form-check">
                                <input type="checkbox" class="form-check-input" id="agreeTerms" name="agreeTerms" required>
                                <label class="form-check-label" for="agreeTerms">
                                    I agree to the <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">Terms and Conditions</a> *
                                </label>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-success btn-lg">
                                    <i class="fas fa-user-plus"></i> Create Account
                                </button>
                            </div>
                        </form>

                        <div class="text-center mt-3">
                            <a href="${pageContext.request.contextPath}/login.jsp" class="text-decoration-none">
                                <i class="fas fa-sign-in-alt"></i> Already have an account? Login here
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

   
    <div class="modal fade" id="termsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Terms and Conditions</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <h6>1. Account Registration</h6>
                    <p>You must provide accurate and complete information when creating your account.</p>
                    
                    <h6>2. User Responsibilities</h6>
                    <p>You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.</p>
                    
                    <h6>3. Acceptable Use</h6>
                    <p>You agree to use the CRM system in compliance with all applicable laws and regulations. You shall not use the service for any illegal or unauthorized purpose.</p>
                    
                    <h6>4. Privacy</h6>
                    <p>Your personal information will be handled in accordance with our privacy policy. We collect necessary information to provide and improve our services.</p>
                    
                    <h6>5. Data Ownership</h6>
                    <p>You retain ownership of your data. We only process your data to provide the CRM services.</p>
                    
                    <h6>6. Account Termination</h6>
                    <p>Accounts violating these terms may be suspended or terminated at our discretion. You may also terminate your account at any time.</p>
                    
                    <h6>7. Service Availability</h6>
                    <p>We strive to maintain service availability but do not guarantee uninterrupted access. We may perform maintenance that could temporarily affect availability.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');
            const phone = document.getElementById('phone');
            
           
            form.addEventListener('submit', function(e) {
                let isValid = true;
                
                
                if (password.value !== confirmPassword.value) {
                    e.preventDefault();
                    alert('Passwords do not match!');
                    confirmPassword.focus();
                    isValid = false;
                }
                
                
                const phoneRegex = /^[+]?[0-9\s\-\(\)]{10,15}$/;
                if (phone.value && !phoneRegex.test(phone.value.replace(/\s/g, ''))) {
                    e.preventDefault();
                    alert('Please enter a valid phone number (10-15 digits)');
                    phone.focus();
                    isValid = false;
                }
                
                if (!isValid) {
                    return false;
                }
            });
            
           
            confirmPassword.addEventListener('input', function() {
                if (password.value !== confirmPassword.value) {
                    confirmPassword.classList.add('is-invalid');
                    confirmPassword.classList.remove('is-valid');
                } else {
                    confirmPassword.classList.remove('is-invalid');
                    confirmPassword.classList.add('is-valid');
                }
            });
            
           
            phone.addEventListener('input', function() {
                const phoneRegex = /^[+]?[0-9\s\-\(\)]{10,15}$/;
                if (phone.value && !phoneRegex.test(phone.value.replace(/\s/g, ''))) {
                    phone.classList.add('is-invalid');
                    phone.classList.remove('is-valid');
                } else if (phone.value) {
                    phone.classList.remove('is-invalid');
                    phone.classList.add('is-valid');
                } else {
                    phone.classList.remove('is-invalid', 'is-valid');
                }
            });
            
           
            phone.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value.length > 0) {
                    if (value.length <= 3) {
                        value = value;
                    } else if (value.length <= 6) {
                        value = value.slice(0, 3) + '-' + value.slice(3);
                    } else if (value.length <= 10) {
                        value = value.slice(0, 3) + '-' + value.slice(3, 6) + '-' + value.slice(6);
                    } else {
                        value = '+' + value.slice(0, 1) + '-' + value.slice(1, 4) + '-' + value.slice(4, 7) + '-' + value.slice(7, 11);
                    }
                }
                e.target.value = value;
            });
        });
    </script>
    
    <style>
        .is-valid {
            border-color: #198754;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 8 8'%3e%3cpath fill='%23198754' d='M2.3 6.73L.6 4.53c-.4-1.04.46-1.4 1.1-.8l1.1 1.4 3.4-3.8c.6-.63 1.6-.27 1.2.7l-4 4.6c-.43.5-.8.4-1.1.1z'/%3e%3c/svg%3e");
        }
        
        .is-invalid {
            border-color: #dc3545;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 12' width='12' height='12' fill='none' stroke='%23dc3545'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath d='M5.8 3.6h.4L6 6.5z'/%3e%3ccircle cx='6' cy='8.2' r='.6' fill='%23dc3545' stroke='none'/%3e%3c/svg%3e");
        }
        
        .form-text {
            font-size: 0.875em;
            color: #6c757d;
        }
        
        .card {
            border: none;
            border-radius: 15px;
        }
        
        .card-header {
            border-radius: 15px 15px 0 0 !important;
            padding: 1.5rem;
        }
        
        .btn-success {
            background: linear-gradient(135deg, #198754 0%, #157347 100%);
            border: none;
            border-radius: 8px;
            padding: 12px;
            font-weight: 600;
        }
        
        .btn-success:hover {
            background: linear-gradient(135deg, #157347 0%, #0f5132 100%);
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(25, 135, 84, 0.3);
        }
    </style>
</body>
</html>