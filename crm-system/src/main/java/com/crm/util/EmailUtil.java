package com.crm.util;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;
import javax.mail.Authenticator;

public class EmailUtil {
    private final String host = "smtp.gmail.com";
    private final String port = "587";
    private final String username = "your gmail";
    private final String password = "gmail api";

    
    public void sendOTPEmail(String toEmail, String otp) {
        String subject = "CRM System - Password Reset OTP";
        String body = "Your One-Time Password (OTP) for password reset is: " + otp + 
                     "\n\nThis OTP is valid for 10 minutes." +
                     "\n\nIf you didn't request this, please ignore this email." +
                     "\n\nBest regards,\nCRM System Team";

        sendEmail(toEmail, subject, body);
    }

    
    public void sendWelcomeEmail(String toEmail, String username, String userPassword, String role, boolean isTempPassword) {
        String subject = "Welcome to CRM System - Your Account Details";
        String body = "Dear " + username + ",\n\n" +
                     "Your account has been successfully created in the CRM System.\n\n" +
                     "Account Details:\n" +
                     "Username: " + username + "\n" +
                     "Password: " + userPassword + "\n" +
                     "Role: " + role + "\n" +
                     "Email: " + toEmail + "\n\n";
        
        if (isTempPassword) {
            body += "This is a temporary password. Please change it after your first login.\n\n";
        }
        
        body += "Login URL: http://localhost:8080/crm-system/login.jsp\n\n" +
               "Best regards,\n" +
               "CRM System Administration Team";

        sendEmail(toEmail, subject, body);
    }

    public void sendPasswordResetEmail(String toEmail, String resetLink) {
        String subject = "CRM System - Password Reset";
        String body = "Click the link to reset your password: " + resetLink + 
                     "\nThis link will expire in 1 hour.";

        sendEmail(toEmail, subject, body);
    }

    public void sendComplaintUpdateEmail(String toEmail, String complaintId, String status) {
        String subject = "CRM System - Complaint Update";
        String body = "Your complaint #" + complaintId + " status has been updated to: " + status;

        sendEmail(toEmail, subject, body);
    }

    public void sendInquiryResponseEmail(String toEmail, String inquirySubject, String response) {
        String subject = "CRM System - Inquiry Response";
        String body = "Response to your inquiry '" + inquirySubject + "':\n\n" + response;

        sendEmail(toEmail, subject, body);
    }

    
    public void sendEmail(String toEmail, String subject, String body) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", port);

            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
            System.out.println("✅ Email sent successfully to: " + toEmail);
            
        } catch (Exception e) {
            System.err.println("❌ Failed to send email: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    
    public void sendUserCredentials(String toEmail, String username, String password, String role, String phone, boolean isTempPassword) {
        try {
            String subject = "Welcome to CRM System - Your Account Has Been Created";
            
            StringBuilder body = new StringBuilder();
            body.append("Dear ").append(username).append(",\n\n")
                .append("Your account has been created by the CRM Administrator. Please use the assigned password to log in and make sure to update your password upon first login.\n\n")
                .append("=== YOUR LOGIN CREDENTIALS ===\n")
                .append("Username: ").append(username).append("\n")
                .append("Password: ").append(password).append("\n")
                .append("Role: ").append(role).append("\n")
                .append("Email: ").append(toEmail).append("\n");
            
            if (phone != null && !phone.trim().isEmpty()) {
                body.append("Phone: ").append(phone).append("\n");
            }
            
            body.append("\n");
            
            if (isTempPassword) {
                body.append("⚠️  This is a temporary password. Please change it immediately after your first login.\n\n");
            }
            
            body.append("🔗 Login URL: http://localhost:8080/crm-system/login.jsp\n\n")
                .append("📱 You can also access the system from your mobile device\n\n")
                .append("Need help? Contact our support team.\n\n")
                .append("Best regards,\n")
                .append("CRM System Administration Team");

            sendEmail(toEmail, subject, body.toString());
            System.out.println("✅ User credentials email sent successfully to: " + toEmail);
            
        } catch (Exception e) {
            System.err.println("❌ Failed to send user credentials email: " + e.getMessage());
            throw new RuntimeException("Failed to send user credentials email", e);
        }
    }
}