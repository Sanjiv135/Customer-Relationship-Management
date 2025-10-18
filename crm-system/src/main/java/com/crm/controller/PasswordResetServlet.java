package com.crm.controller;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;

import com.crm.dao.UserDAO;
import com.crm.util.PasswordUtil;
import com.crm.util.EmailUtil;
import com.crm.util.TwilioUtil;
import com.crm.model.User;

import java.io.IOException;

@WebServlet("/password-reset")
public class PasswordResetServlet extends HttpServlet {
    private UserDAO userDAO;
    private EmailUtil emailUtil;
    private boolean emailEnabled = true;
    private boolean smsEnabled = true;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        emailUtil = new EmailUtil();
        
        
        smsEnabled = TwilioUtil.testConnection();
        
        System.out.println("🔧 PasswordResetServlet - Initializing");
        System.out.println("📧 Email features: " + (emailEnabled ? "ENABLED" : "DISABLED"));
        System.out.println("📱 SMS features: " + (smsEnabled ? "ENABLED" : "DISABLED"));
        System.out.println("✅ PasswordResetServlet - Ready");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        System.out.println("🔧 PasswordResetServlet GET - Action: " + action);
        
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password.jsp");
        } else {
            switch (action) {
                case "verify-otp":
                    request.getRequestDispatcher("/verify-otp.jsp").forward(request, response);
                    break;
                case "reset-password":
                    request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        System.out.println("🔧 PasswordResetServlet - Action: " + action);
        
        switch (action) {
            case "request-otp":
                requestOTP(request, response);
                break;
            case "verify-otp":
                verifyOTP(request, response);
                break;
            case "reset-password":
                resetPassword(request, response);
                break;
            case "resend-otp":
                resendOTP(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/forgot-password.jsp?error=Invalid action");
        }
    }

    private void requestOTP(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String method = request.getParameter("method");
        String identifier = null;
        
        System.out.println("=== DEBUG: requestOTP STARTED ===");
        System.out.println("🔧 Method: " + method);
        
        try {
            
            if ("email".equals(method)) {
                identifier = request.getParameter("email");
                System.out.println("📧 Email provided: " + identifier);
            } else if ("phone".equals(method)) {
                identifier = request.getParameter("phone");
                System.out.println("📱 Phone provided: " + identifier);
            } else {
                System.out.println("❌ Invalid method: " + method);
                response.sendRedirect(request.getContextPath() + "/forgot-password.jsp?error=Invalid method selected");
                return;
            }
            
            
            if (identifier == null || identifier.trim().isEmpty()) {
                System.out.println("❌ Identifier is null or empty");
                response.sendRedirect(request.getContextPath() + "/forgot-password.jsp?error=Please enter your " + method);
                return;
            }
            
            System.out.println("🔍 Looking up user by " + method + ": " + identifier);
            
            
            User user = null;
            if ("email".equals(method)) {
                user = userDAO.getUserByEmail(identifier);
            } else if ("phone".equals(method)) {
                user = userDAO.getUserByPhone(identifier);
            }
            
            System.out.println("👤 User lookup result: " + (user != null ? "FOUND" : "NOT FOUND"));
            
            if (user == null) {
                
                System.out.println("❌ User not found for " + method + ": " + identifier);
                response.sendRedirect(request.getContextPath() + "/forgot-password.jsp?success=If your " + method + " is registered, you will receive an OTP shortly");
                return;
            }
            
            System.out.println("✅ User found: " + user.getUsername() + ", Email: " + user.getEmail() + ", Phone: " + user.getPhone());
            
            
            String otp = PasswordUtil.generateOTP();
            System.out.println("🔑 Generated OTP: " + otp);
            
           
            System.out.println("💾 Storing OTP in database...");
            userDAO.storeOTP(user.getEmail(), otp, "email");
            System.out.println("✅ OTP stored successfully");
            
            
            boolean otpSent = false;
            String sendMethod = "";
            
            if ("email".equals(method) && emailEnabled) {
                System.out.println("📧 Attempting to send OTP via email to: " + user.getEmail());
                emailUtil.sendOTPEmail(user.getEmail(), otp);
                otpSent = true;
                sendMethod = "email";
            } else if ("phone".equals(method) && smsEnabled) {
                System.out.println("📱 Attempting to send OTP via SMS to: " + user.getPhone());
                otpSent = TwilioUtil.sendOTPSMS(user.getPhone(), otp);
                sendMethod = "SMS";
            } else {
                
                System.out.println("⚠️  " + method.toUpperCase() + " service disabled, OTP displayed in console: " + otp);
                otpSent = true;
                sendMethod = "console";
            }
            
            if (otpSent) {
                
                HttpSession session = request.getSession();
                session.setAttribute("resetIdentifier", user.getEmail());
                session.setAttribute("resetMethod", method);
                session.setAttribute("resetAttempts", 0);
                session.setAttribute("userPhone", user.getPhone()); 
                session.setMaxInactiveInterval(600); 
                
                System.out.println("✅ OTP sent via " + sendMethod + " - Session created for OTP verification");
                
                
                String redirectUrl = request.getContextPath() + "/password-reset?action=verify-otp&method=" + method + 
                                   "&identifier=" + java.net.URLEncoder.encode(user.getEmail(), "UTF-8");
                System.out.println("🔄 Redirecting to: " + redirectUrl);
                response.sendRedirect(redirectUrl);
            } else {
                System.out.println("❌ OTP sending failed for method: " + method);
                response.sendRedirect(request.getContextPath() + "/forgot-password.jsp?error=Failed to send OTP. Please try again.");
            }
            
        } catch (Exception e) {
            System.err.println("❌ CRITICAL ERROR in requestOTP: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/forgot-password.jsp?error=System error. Please try again.");
        }
        
        System.out.println("=== DEBUG: requestOTP COMPLETED ===\n");
    }

    private void verifyOTP(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String identifier = request.getParameter("identifier");
        String method = request.getParameter("method");
        String otp = request.getParameter("otp");
        
        System.out.println("🔧 Verify OTP - Identifier: " + identifier + ", OTP: " + otp);
        
        if (otp == null || otp.length() != 6 || !otp.matches("\\d{6}")) {
            response.sendRedirect(request.getContextPath() + "/password-reset?action=verify-otp&method=" + method + 
                                "&identifier=" + java.net.URLEncoder.encode(identifier, "UTF-8") + 
                                "&error=Invalid OTP format");
            return;
        }
        
        HttpSession session = request.getSession();
        Integer attempts = (Integer) session.getAttribute("resetAttempts");
        
        
        if (attempts != null && attempts >= 3) {
            response.sendRedirect(request.getContextPath() + "/forgot-password.jsp?error=Too many failed attempts. Please request a new OTP.");
            return;
        }
        
        
        boolean isValid = userDAO.verifyOTP(identifier, otp, "email");
        
        if (isValid) {
            
            session.removeAttribute("resetAttempts");
            
            
            String redirectUrl = request.getContextPath() + "/password-reset?action=reset-password&method=" + method + 
                               "&identifier=" + java.net.URLEncoder.encode(identifier, "UTF-8");
            response.sendRedirect(redirectUrl);
        } else {
            
            if (attempts == null) {
                attempts = 1;
            } else {
                attempts++;
            }
            session.setAttribute("resetAttempts", attempts);
            
            String errorMsg = "Invalid OTP. Attempts remaining: " + (3 - attempts);
            response.sendRedirect(request.getContextPath() + "/password-reset?action=verify-otp&method=" + method + 
                                "&identifier=" + java.net.URLEncoder.encode(identifier, "UTF-8") + 
                                "&error=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
        }
    }

    private void resetPassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String identifier = request.getParameter("identifier");
        String method = request.getParameter("method");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        System.out.println("🔧 Reset Password - Identifier: " + identifier);
        
       
        if (newPassword == null || newPassword.length() < 6) {
            response.sendRedirect(request.getContextPath() + "/password-reset?action=reset-password&method=" + method + 
                                "&identifier=" + java.net.URLEncoder.encode(identifier, "UTF-8") + 
                                "&error=Password must be at least 6 characters long");
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/password-reset?action=reset-password&method=" + method + 
                                "&identifier=" + java.net.URLEncoder.encode(identifier, "UTF-8") + 
                                "&error=Passwords do not match");
            return;
        }
        
        try {
            
            User user = userDAO.getUserByEmail(identifier);
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/forgot-password.jsp?error=User not found");
                return;
            }
            
            
            boolean success = userDAO.updatePassword(user.getId(), newPassword);
            
            if (success) {
                
                userDAO.clearOTP(identifier, "email");
                
               
                if ("email".equals(method) && emailEnabled) {
                    emailUtil.sendEmail(user.getEmail(), "CRM System - Password Reset Successful", 
                        "Your password has been successfully reset.\n\nIf you didn't make this change, please contact support immediately.");
                } else if ("phone".equals(method) && smsEnabled) {
                    TwilioUtil.sendNotificationSMS(user.getPhone(), 
                        "Your CRM System password has been reset successfully. If you didn't make this change, contact support.");
                }
                
               
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                
                System.out.println("✅ Password reset successful for user: " + user.getUsername());
                response.sendRedirect(request.getContextPath() + "/login.jsp?success=Password reset successfully. Please login with your new password.");
            } else {
                response.sendRedirect(request.getContextPath() + "/password-reset?action=reset-password&method=" + method + 
                                    "&identifier=" + java.net.URLEncoder.encode(identifier, "UTF-8") + 
                                    "&error=Failed to reset password. Please try again.");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error in resetPassword: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/password-reset?action=reset-password&method=" + method + 
                                "&identifier=" + java.net.URLEncoder.encode(identifier, "UTF-8") + 
                                "&error=System error. Please try again.");
        }
    }

    private void resendOTP(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String identifier = request.getParameter("identifier");
        String method = request.getParameter("method");
        
        System.out.println("🔧 Resend OTP - Identifier: " + identifier + ", Method: " + method);
        
        try {
            
            User user = userDAO.getUserByEmail(identifier);
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/forgot-password.jsp?error=User not found");
                return;
            }
            
            
            String newOtp = PasswordUtil.generateOTP();
            System.out.println("🔑 Generated new OTP for " + user.getUsername() + ": " + newOtp);
            
            
            userDAO.storeOTP(identifier, newOtp, "email");
            
            
            boolean otpSent = false;
            String sendMethod = "";
            
            if ("email".equals(method) && emailEnabled) {
                System.out.println("📧 Resending OTP via email to: " + user.getEmail());
                emailUtil.sendOTPEmail(user.getEmail(), newOtp);
                otpSent = true;
                sendMethod = "email";
            } else if ("phone".equals(method) && smsEnabled) {
                System.out.println("📱 Resending OTP via SMS to: " + user.getPhone());
                otpSent = TwilioUtil.sendOTPSMS(user.getPhone(), newOtp);
                sendMethod = "SMS";
            } else {
               
                System.out.println("⚠️  Resending OTP via console: " + newOtp);
                otpSent = true;
                sendMethod = "console";
            }
            
            if (otpSent) {
                
                HttpSession session = request.getSession();
                session.setAttribute("resetIdentifier", identifier);
                session.setAttribute("resetMethod", method);
                session.setAttribute("resetAttempts", 0);
                session.setAttribute("userPhone", user.getPhone());
                session.setMaxInactiveInterval(600); 
                
                response.sendRedirect(request.getContextPath() + "/password-reset?action=verify-otp&method=" + method + 
                                    "&identifier=" + java.net.URLEncoder.encode(identifier, "UTF-8") + 
                                    "&success=New OTP sent successfully via " + sendMethod);
            } else {
                response.sendRedirect(request.getContextPath() + "/password-reset?action=verify-otp&method=" + method + 
                                    "&identifier=" + java.net.URLEncoder.encode(identifier, "UTF-8") + 
                                    "&error=Failed to resend OTP. Please try again.");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error in resendOTP: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/password-reset?action=verify-otp&method=" + method + 
                                "&identifier=" + java.net.URLEncoder.encode(identifier, "UTF-8") + 
                                "&error=System error. Please try again.");
        }
    }
}