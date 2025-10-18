package com.crm.util;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import com.twilio.exception.ApiException;

import java.util.Random;
import java.util.logging.Logger;

public class TwilioUtil {
    
    public static final String ACCOUNT_SID = "YOUR ACCOUNT_SID ";
    public static final String AUTH_TOKEN = "YOUR AUTH_TOKEN";
    public static final String TWILIO_PHONE_NUMBER = "YOUR TWILIO_PHONE_NUMBER";
    
    private static final Logger logger = Logger.getLogger(TwilioUtil.class.getName());
    
    private static boolean initialized = false;
    
   
    private static synchronized void initialize() {
        if (!initialized) {
            try {
                Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
                initialized = true;
                System.out.println("✅ Twilio initialized successfully");
            } catch (Exception e) {
                System.err.println("❌ Failed to initialize Twilio: " + e.getMessage());
            }
        }
    }
    
   
    public static String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
    
    
    public static boolean sendOTPSMS(String toPhoneNumber, String otp) {
        try {
            initialize(); 
            
            
            if (toPhoneNumber == null || toPhoneNumber.trim().isEmpty()) {
                System.err.println("❌ Phone number is null or empty");
                return false;
            }
            
            
            String formattedNumber = formatPhoneNumber(toPhoneNumber);
            
            String messageBody = "Your CRM System OTP code is: " + otp + 
                               ". This OTP is valid for 10 minutes.";
            
            System.out.println("📱 Attempting to send SMS to: " + formattedNumber);
            
            Message message = Message.creator(
                new PhoneNumber(formattedNumber),
                new PhoneNumber(TWILIO_PHONE_NUMBER),
                messageBody
            ).create();
            
            System.out.println("✅ SMS sent successfully to: " + formattedNumber);
            System.out.println("📱 Message SID: " + message.getSid());
            return true;
            
        } catch (ApiException e) {
            System.err.println("❌ Twilio API Error: " + e.getMessage());
            System.err.println("❌ Error code: " + e.getCode());
            return false;
        } catch (Exception e) {
            System.err.println("❌ Failed to send SMS: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }



   
    public static boolean sendWelcomeSMS(String toPhoneNumber, String username, String password, String role) {
        try {
            
            if (toPhoneNumber == null || toPhoneNumber.trim().isEmpty()) {
                logger.warning("Phone number is null or empty");
                return false;
            }
            
            
            String formattedNumber = toPhoneNumber.startsWith("+") ? toPhoneNumber : "+" + toPhoneNumber;
            
            Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
            
            String messageBody = String.format(
                "Your CRM account has been created by Administrator.\n\n" +
                "Username: %s\n" +
                "Password: %s\n" +
                "Role: %s\n\n" +
                "Please login and change your password.\n" +
                "Login: http://localhost:8080/crm-system/login.jsp\n\n" +
                "This is a temporary password. Change it after first login.",
                username, password, role
            );
            
            Message message = Message.creator(
                new PhoneNumber(formattedNumber),
                new PhoneNumber(TWILIO_PHONE_NUMBER),
                messageBody
            ).create();
            
            logger.info("SMS sent successfully to: " + formattedNumber);
            return true;
            
        } catch (ApiException e) {
            logger.severe("Twilio API Error: " + e.getMessage());
            logger.severe("Please check your Twilio credentials in twilio.properties");
            return false;
        } catch (Exception e) {
            logger.severe("Failed to send SMS: " + e.getMessage());
            return false;
        }
    }
    
    
    public static boolean sendWelcomeSMS(String toPhoneNumber, String username) {
        
        String tempPassword = generateTempPassword();
        
        return sendWelcomeSMS(toPhoneNumber, username, tempPassword, "customer");
    }
    
    
    private static String generateTempPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder password = new StringBuilder();
        Random random = new Random();
        
        for (int i = 0; i < 8; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return password.toString();
    }
    
   
    private static String formatPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            throw new IllegalArgumentException("Phone number cannot be null or empty");
        }
        
        
        String digitsOnly = phoneNumber.replaceAll("[^0-9]", "");
        
        
        if (digitsOnly.length() == 10) {
            return "+91" + digitsOnly; 
        }
        
        else if (digitsOnly.length() == 11 && digitsOnly.startsWith("0")) {
            return "+91" + digitsOnly.substring(1);
        }
        
        else if (digitsOnly.length() == 12 && digitsOnly.startsWith("91")) {
            return "+" + digitsOnly;
        }
        
        else if (!digitsOnly.startsWith("+")) {
            return "+" + digitsOnly;
        } else {
            return digitsOnly;
        }
    }
    
    public static boolean testConnection() {
        try {
            initialize(); 
            
            Message.reader().limit(1).read();
            System.out.println("✅ Twilio connection test: SUCCESS");
            return true;
        } catch (Exception e) {
            System.err.println("❌ Twilio connection test: FAILED - " + e.getMessage());
            return false;
        }
    }    
   
    
    public static boolean sendNotificationSMS(String toPhoneNumber, String message) {
        try {
            String formattedNumber = formatPhoneNumber(toPhoneNumber);
            
            Message sms = Message.creator(
                new PhoneNumber(formattedNumber),
                new PhoneNumber(TWILIO_PHONE_NUMBER),
                message
            ).create();
            
            logger.info("Notification SMS sent to: " + formattedNumber);
            return true;
            
        } catch (ApiException e) {
            logger.severe("Twilio API Error sending notification: " + e.getMessage());
            return false;
        } catch (Exception e) {
            logger.severe("Failed to send notification SMS: " + e.getMessage());
            return false;
        }
    }
    
    
    public static boolean sendComplaintUpdateSMS(String toPhoneNumber, String complaintId, String status, String resolution) {
        try {
            String formattedNumber = formatPhoneNumber(toPhoneNumber);
            
            String messageBody = String.format(
                "Your complaint #%s has been updated.\n" +
                "Status: %s\n" +
                "Resolution: %s\n\n" +
                "Thank you for using our CRM System.",
                complaintId, status, resolution
            );
            
            Message message = Message.creator(
                new PhoneNumber(formattedNumber),
                new PhoneNumber(TWILIO_PHONE_NUMBER),
                messageBody
            ).create();
            
            logger.info("Complaint update SMS sent to: " + formattedNumber);
            return true;
            
        } catch (Exception e) {
            logger.severe("Failed to send complaint update SMS: " + e.getMessage());
            return false;
        }
    }
}