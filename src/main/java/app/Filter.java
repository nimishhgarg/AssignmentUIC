package app;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebFilter("/*")
public class Filter implements jakarta.servlet.Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        req.setCharacterEncoding("UTF-8");

        String path = req.getServletPath() + (req.getPathInfo() == null ? "" : req.getPathInfo());
        boolean asset = path.startsWith("/assets/");

        resp.setHeader("X-Content-Type-Options", "nosniff");
        resp.setHeader("X-Frame-Options", "SAMEORIGIN");
        if (!asset) {
            resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            resp.setHeader("Pragma", "no-cache");
        }

        Integer userId = Config.userId(req);
        boolean open = asset || path.equals("/login") || path.equals("/register");

        if (!open && userId == null) {
            if (path.equals("/settings/update")) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write("{\"success\":false,\"data\":{\"message\":\"Session expired.\"}}");
            } else {
                resp.sendRedirect(req.getContextPath() + "/login");
            }
            return;
        }

        if (userId != null) {
            req.setAttribute("csrf", Config.csrf(req.getSession()));
        }
        chain.doFilter(request, response);
    }
}
