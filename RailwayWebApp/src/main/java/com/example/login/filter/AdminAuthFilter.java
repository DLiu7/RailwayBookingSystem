package com.example.login.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest req, ServletResponse res,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        // get the session, but don't create one if it doesn't exist
        HttpSession session = request.getSession(false);

        // pull the role out of session
        String role = (session != null)
            ? (String) session.getAttribute("role")
            : null;

        // if not logged in as admin, redirect to login page
        if (!"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login2.jsp");
            return;
        }

        // OK, user is an admin—let the request proceed
        chain.doFilter(req, res);
    }

    // you can leave init() and destroy() empty
    @Override public void init(FilterConfig fc)  {}
    @Override public void destroy()              {}
}
