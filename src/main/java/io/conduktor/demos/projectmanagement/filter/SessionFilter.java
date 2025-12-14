package io.conduktor.demos.projectmanagement.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * Session Filter - Ensures users are authenticated before accessing protected
 * resources
 */
@WebFilter("/*")
public class SessionFilter implements Filter {

    // Pages that don't require authentication
    private static final List<String> PUBLIC_PATHS = Arrays.asList(
            "/",
            "/index.jsp",
            "/auth/login.jsp",
            "/auth/register.jsp",
            "/error.jsp",
            "/css/",
            "/js/",
            "/images/",
            "/api/users/register",
            "/api/users/login");

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization logic if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // Remove context path to get the relative path
        String relativePath = path.substring(contextPath.length());

        // Check if this is a public path
        if (isPublicPath(relativePath)) {
            chain.doFilter(request, response);
            return;
        }

        // Check session
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (!isLoggedIn) {
            // Store the original URL for redirect after login
            session = httpRequest.getSession(true);
            session.setAttribute("redirectUrl", path);

            // Redirect to login
            httpResponse.sendRedirect(contextPath + "/auth/login.jsp");
            return;
        }

        // User is authenticated, continue
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup logic if needed
    }

    /**
     * Check if the given path is a public path (doesn't require authentication)
     */
    private boolean isPublicPath(String path) {
        // Exact match or starts with check
        for (String publicPath : PUBLIC_PATHS) {
            if (path.equals(publicPath) || path.startsWith(publicPath)) {
                return true;
            }
        }
        return false;
    }
}
