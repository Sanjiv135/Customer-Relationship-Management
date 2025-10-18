package com.crm.controller;


import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletException;
import javax.servlet.http.Part;

import com.crm.dao.UserDAO;
import com.crm.dao.ComplaintDAO;
import com.crm.util.PasswordUtil;
import com.crm.util.EmailUtil;
import com.crm.model.Complaint;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;

@WebServlet("/file-upload")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 10, 
    maxRequestSize = 1024 * 1024 * 50 
)
public class FileUploadServlet extends HttpServlet {
    private ComplaintDAO complaintDAO;
    private final String UPLOAD_DIR = "uploads";

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
        
        
        Path uploadPath = Paths.get(UPLOAD_DIR);
        try {
            Files.createDirectories(uploadPath);
        } catch (IOException e) {
            throw new ServletException("Could not create upload directory", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        Part filePart = request.getPart("attachment");

        Complaint complaint = new Complaint();
        complaint.setUserId(userId);
        complaint.setTitle(title);
        complaint.setDescription(description);
        complaint.setStatus("PENDING");

        
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + 
                Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            
            Path filePath = Paths.get(UPLOAD_DIR, fileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
            }
            
            complaint.setAttachmentPath(filePath.toString());
            complaint.setOriginalFileName(filePart.getSubmittedFileName());
        }

        if (complaintDAO.addComplaint(complaint)) {
            response.sendRedirect("user/complaints.jsp?success=Complaint submitted successfully");
        } else {
            response.sendRedirect("user/complaintForm.jsp?error=Failed to submit complaint");
        }
    }
}