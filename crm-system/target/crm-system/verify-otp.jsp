<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify OTP - CRM System</title>
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
        .otp-input {
            text-align: center;
            font-size: 1.5rem;
            font-weight: bold;
            letter-spacing: 8px;
            height: 60px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #2575fc 0%, #6a11cb 100%);
            border: none;
        }
        .countdown {
            font-size: 0.9rem;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-primary text-white text-center">
                        <h4><i class="fas fa-shield-alt"></i> Verify OTP</h4>
                    </div>
                    <div class="card-body p-4">

                        <% 
                            String error = request.getParameter("error");
                            String success = request.getParameter("success");
                            String identifier = request.getParameter("identifier");
                            String method = request.getParameter("method");
                            
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

                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i> 
                            <%
                                if ("email".equals(method)) {
                                    out.print("We've sent a 6-digit OTP to your email: <strong>" + (identifier != null ? identifier : "") + "</strong>");
                                } else {
                                    out.print("We've sent a 6-digit OTP via SMS to your phone: <strong>" + (identifier != null ? identifier : "") + "</strong>");
                                }
                            %>
                            <br>The OTP is valid for <span id="countdown">10:00</span> minutes.
                        </div>

                        <form action="${pageContext.request.contextPath}/password-reset" method="post" id="verifyOtpForm">
                            <input type="hidden" name="action" value="verify-otp">
                            <input type="hidden" name="identifier" value="<%= identifier != null ? identifier : "" %>">
                            <input type="hidden" name="method" value="<%= method != null ? method : "email" %>">
                            
                            <div class="form-group mb-4">
                                <label for="otp" class="form-label">Enter 6-digit OTP:</label>
                                <input type="text" id="otp" name="otp" class="form-control otp-input" 
                                       maxlength="6" pattern="[0-9]{6}" 
                                       placeholder="000000" required
                                       oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                                <div class="form-text text-center">Enter the 6-digit code sent to your <%= "email".equals(method) ? "email" : "phone" %></div>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-check-circle"></i> Verify OTP
                                </button>
                                <a href="${pageContext.request.contextPath}/password-reset" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left"></i> Back
                                </a>
                            </div>
                        </form>

                        <div class="text-center mt-3">
                            <form action="${pageContext.request.contextPath}/password-reset" method="post" class="d-inline">
                                <input type="hidden" name="action" value="resend-otp">
                                <input type="hidden" name="identifier" value="<%= identifier != null ? identifier : "" %>">
                                <input type="hidden" name="method" value="<%= method != null ? method : "email" %>">
                                <button type="submit" class="btn btn-link p-0" id="resendBtn">
                                    <i class="fas fa-redo"></i> Resend OTP
                                </button>
                            </form>
                            <span class="countdown text-muted ms-2" id="resendCountdown"></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        
        let timeLeft = 600; 
        const countdownElement = document.getElementById('countdown');
        const resendCountdownElement = document.getElementById('resendCountdown');
        const resendBtn = document.getElementById('resendBtn');
        
        function updateCountdown() {
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            countdownElement.textContent = `${minutes}:${seconds.toString().padStart(2, '0')}`;
            
            if (timeLeft <= 0) {
                countdownElement.textContent = "Expired!";
                countdownElement.className = "text-danger";
            } else {
                timeLeft--;
                setTimeout(updateCountdown, 1000);
            }
        }
        
        
        let resendTimeLeft = 30;
        function updateResendCountdown() {
            if (resendTimeLeft > 0) {
                resendCountdownElement.textContent = `(${resendTimeLeft}s)`;
                resendBtn.parentElement.style.pointerEvents = 'none';
                resendBtn.style.opacity = '0.5';
                resendTimeLeft--;
                setTimeout(updateResendCountdown, 1000);
            } else {
                resendCountdownElement.textContent = '';
                resendBtn.parentElement.style.pointerEvents = 'auto';
                resendBtn.style.opacity = '1';
            }
        }
        
        
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('otp').focus();
            updateCountdown();
            updateResendCountdown();
        });
    </script>
</body>
</html>