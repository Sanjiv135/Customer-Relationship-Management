package com.crm.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("🛡️ AuthFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
        String method = httpRequest.getMethod();

        System.out.println("🔐 FILTER DEBUG - Path: " + path + ", Method: " + method);

        
        if (httpRequest.getDispatcherType() == DispatcherType.FORWARD || 
            httpRequest.getDispatcherType() == DispatcherType.INCLUDE ||
            httpRequest.getDispatcherType() == DispatcherType.ASYNC) {
            System.out.println("🔄 FILTER - Skipping for dispatcher: " + httpRequest.getDispatcherType());
            chain.doFilter(request, response);
            return;
        }

        
        if (isPublicResource(path)) {
            System.out.println("✅ FILTER - Public resource, allowing: " + path);
            chain.doFilter(request, response);
            return;
        }

        
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("❌ FILTER - No session - redirecting to login");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=Please login first");
            return;
        }

        
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");

        System.out.println("🔐 FILTER DEBUG - User ID: " + userId + ", Role: " + role);

        if (role == null) {
            System.out.println("❌ FILTER - No role found in session");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=Invalid session");
            return;
        }

        
        if (!hasAccess(role, path)) {
            System.out.println("❌ FILTER - Access denied for role: " + role + " to path: " + path);
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=Access denied");
            return;
        }

        System.out.println("✅ FILTER - Access granted, continuing to: " + path);
        chain.doFilter(request, response);
    }

    private boolean isPublicResource(String path) {
        return path.startsWith("/css/") || 
               path.startsWith("/js/") || 
               path.equals("/login.jsp") || 
               path.equals("/signup.jsp") ||
               path.equals("/index.jsp") || 
               path.startsWith("/auth") ||
               path.equals("/") || 
               path.startsWith("/testdb") ||
               path.equals("/error.jsp") || 
               path.equals("/reset-password.jsp") ||
               path.equals("/forgot-password.jsp") ||
               path.equals("/verify-otp.jsp") ||
               path.startsWith("/password-reset") ||
               path.endsWith(".css") || 
               path.endsWith(".js") ||
               path.endsWith(".png") || 
               path.endsWith(".jpg") ||
               path.endsWith(".ico") ||
               path.endsWith(".gif") ||
               path.endsWith(".svg");
    }

    private boolean hasAccess(String role, String path) {
        
        if (path.endsWith(".jsp") && !path.equals("/login.jsp") && !path.equals("/signup.jsp")) {
            return true;
        }

        
        if (path.equals("/admin") || path.equals("/employee") || path.equals("/user") || 
            path.startsWith("/admin?") || path.startsWith("/employee?") || path.startsWith("/user?")) {
            return true;
        }

        
        if ("admin".equals(role)) {
            return path.startsWith("/admin") || 
                   path.equals("/admin") ||
                   path.startsWith("/user/changePassword.jsp") ||
                   path.startsWith("/employee/changePassword.jsp") ||
                   path.equals("/change-password.jsp");
        }

        
        if ("employee".equals(role)) {
            return path.startsWith("/employee") || 
                   path.equals("/employee") ||
                   path.startsWith("/employee/") ||  
                   path.equals("/employee/changePassword.jsp") || 
                   path.equals("/change-password.jsp");
        }

        
        if ("customer".equals(role)) {
            return path.startsWith("/user") || 
                   path.equals("/user") ||
                   path.startsWith("/user/changePassword.jsp") ||
                   path.equals("/change-password.jsp");
        }

        return false;
    }
    @Override
    public void destroy() {
        System.out.println("🛡️ AuthFilter destroyed");
    }
}