package com.crm.filter;

import com.crm.dao.AuditLogDAO;
import com.crm.model.AuditLog;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class AuditFilter implements Filter {
    private AuditLogDAO auditLogDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        auditLogDAO = new AuditLogDAO();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        
        if (shouldLogRequest(httpRequest)) {
            HttpSession session = httpRequest.getSession(false);
            Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
            
            if (userId != null) {
                AuditLog log = new AuditLog(
                    userId,
                    httpRequest.getMethod(),
                    httpRequest.getRequestURI() + (httpRequest.getQueryString() != null ? "?" + httpRequest.getQueryString() : ""),
                    httpRequest.getRemoteAddr()
                );
                
                auditLogDAO.logAction(log);
            }
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        
    }
    
    private boolean shouldLogRequest(HttpServletRequest request) {
        String path = request.getRequestURI();
       
        return !path.contains("/css/") && 
               !path.contains("/js/") && 
               !path.contains("/uploads/") &&
               "POST".equalsIgnoreCase(request.getMethod());
    }
}
