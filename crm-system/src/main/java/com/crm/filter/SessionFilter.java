package com.crm.filter;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class SessionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("🔐 SessionFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        
        String path = requestURI.substring(contextPath.length());
        
        System.out.println("🔍 SessionFilter - Path: " + path);
        
        
        if (isPublicResource(path)) {
            System.out.println("✅ SessionFilter: Allowing public resource - " + path);
            chain.doFilter(request, response);
            return;
        }
        
        
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("🚫 SessionFilter: No valid session - Redirecting to login");
            httpResponse.sendRedirect(contextPath + "/login.jsp");
            return;
        }
        
       
        chain.doFilter(request, response);
    }
    
    private boolean isPublicResource(String path) {
        return path.equals("/login.jsp") ||
               path.equals("/signup.jsp") ||
               path.equals("/forgot-password.jsp") ||
               path.equals("/reset-password.jsp") ||
               path.equals("/verify-otp.jsp") ||
               path.equals("/index.jsp") ||
               path.equals("/error.jsp") ||
               path.equals("/auth") || 
               path.equals("/password-reset") || 
               path.startsWith("/css/") ||
               path.startsWith("/js/") ||
               path.startsWith("/images/") ||
               path.equals("/");
    }

    @Override
    public void destroy() {
        
    }
}