<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - CRM System</title>
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
        .password-strength {
            height: 5px;
            margin-top: 5px;
            border-radius: 5px;
        }
        .strength-weak { background-color: #dc3545; width: 25%; }
        .strength-fair { background-color: #fd7e14; width: 50%; }
        .strength-good { background-color: #ffc107; width: 75%; }
        .strength-strong { background-color: #198754; width: 100%; }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-success text-white text-center">
                        <h4><i class="fas fa-lock"></i> Reset Your Password</h4>
                    </div>
                    <div class="card-body p-4">

                        <% 
                            String error = request.getParameter("error");
                            String identifier = request.getParameter("identifier");
                            String method = request.getParameter("method");
                            
                            if (error != null) { 
                        %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle"></i> <%= error %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>

                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i> 
                            OTP verified successfully! Please set your new password.
                        </div>

                        <form action="${pageContext.request.contextPath}/password-reset" method="post" id="resetPasswordForm">
                            <input type="hidden" name="action" value="reset-password">
                            <input type="hidden" name="identifier" value="<%= identifier != null ? identifier : "" %>">
                            <input type="hidden" name="method" value="<%= method != null ? method : "email" %>">
                            
                            <div class="form-group mb-3">
                                <label for="newPassword" class="form-label">New Password:</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" 
                                           required minlength="6" onkeyup="checkPasswordStrength()">
                                    <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('newPassword')">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div class="password-strength" id="passwordStrength"></div>
                                <small class="form-text text-muted">Password must be at least 6 characters long</small>
                            </div>
                            
                            <div class="form-group mb-4">
                                <label for="confirmPassword" class="form-label">Confirm New Password:</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                    <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('confirmPassword')">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <small id="passwordMatch" class="form-text"></small>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-success btn-lg">
                                    <i class="fas fa-save"></i> Reset Password
                                </button>
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
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const icon = field.nextElementSibling.querySelector('i');
            
            if (field.type === 'password') {
                field.type = 'text';
                icon.className = 'fas fa-eye-slash';
            } else {
                field.type = 'password';
                icon.className = 'fas fa-eye';
            }
        }
        
        function checkPasswordStrength() {
            const password = document.getElementById('newPassword').value;
            const strengthBar = document.getElementById('passwordStrength');
            const confirmField = document.getElementById('confirmPassword');
            const matchText = document.getElementById('passwordMatch');
            
           
            strengthBar.className = 'password-strength';
            matchText.className = 'form-text';
            matchText.textContent = '';
            
            if (password.length === 0) {
                return;
            }
            
            
            let strength = 0;
            if (password.length >= 6) strength++;
            if (password.length >= 8) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;
            
          
            if (strength <= 1) {
                strengthBar.className = 'password-strength strength-weak';
            } else if (strength <= 2) {
                strengthBar.className = 'password-strength strength-fair';
            } else if (strength <= 3) {
                strengthBar.className = 'password-strength strength-good';
            } else {
                strengthBar.className = 'password-strength strength-strong';
            }
            
           
            if (confirmField.value) {
                if (password === confirmField.value) {
                    matchText.className = 'form-text text-success';
                    matchText.innerHTML = '<i class="fas fa-check-circle"></i> Passwords match';
                } else {
                    matchText.className = 'form-text text-danger';
                    matchText.innerHTML = '<i class="fas fa-times-circle"></i> Passwords do not match';
                }
            }
        }
        
        
        document.getElementById('newPassword').addEventListener('input', checkPasswordStrength);
        document.getElementById('confirmPassword').addEventListener('input', checkPasswordStrength);
        
        
        document.getElementById('resetPasswordForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long');
                return;
            }
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match');
                return;
            }
        });
    </script>
</body>
</html>