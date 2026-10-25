package app;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet(urlPatterns = {"/login", "/register", "/logout", "/prompt", "/worksheet", "/settings", "/settings/update"})
public class Page extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String GENERIC = "Invalid email address or password. Please try again.";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        route(req, resp, false);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        route(req, resp, true);
    }

    private void route(HttpServletRequest req, HttpServletResponse resp, boolean post) throws ServletException, IOException {
        switch (req.getServletPath()) {
            case "/login": login(req, resp, post); break;
            case "/register": register(req, resp, post); break;
            case "/logout": logout(req, resp, post); break;
            case "/prompt": if (post) denied(resp); else view(req, resp, "prompt"); break;
            case "/worksheet": if (post) denied(resp); else worksheet(req, resp); break;
            case "/settings": if (post) denied(resp); else settings(req, resp); break;
            case "/settings/update": if (post) update(req, resp); else denied(resp); break;
            default: resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private static void denied(HttpServletResponse resp) throws IOException {
        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    private static void view(HttpServletRequest req, HttpServletResponse resp, String name) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/" + name + ".jsp").forward(req, resp);
    }

    private static void go(HttpServletRequest req, HttpServletResponse resp, String path) throws IOException {
        resp.sendRedirect(req.getContextPath() + path);
    }

    private static void again(HttpServletRequest req, HttpServletResponse resp, String page, String title, String body, String email)
            throws ServletException, IOException {
        req.setAttribute("csrf", Config.csrf(req.getSession(true)));
        req.setAttribute("popupTitle", title);
        req.setAttribute("popupBody", body);
        req.setAttribute("email", email);
        view(req, resp, page);
    }

    private static String clean(String v) {
        if (v == null) {
            return "";
        }
        StringBuilder b = new StringBuilder(v.length());
        for (int i = 0; i < v.length(); i++) {
            if (!Character.isISOControl(v.charAt(i))) {
                b.append(v.charAt(i));
            }
        }
        return b.toString().trim();
    }

    private static boolean hasCookie(HttpServletRequest req, String name) {
        Cookie[] all = req.getCookies();
        if (all != null) {
            for (Cookie c : all) {
                if (name.equals(c.getName())) {
                    return true;
                }
            }
        }
        return false;
    }

    private static boolean validEmail(String e) {
        int at = e.indexOf('@');
        if (e.length() < 5 || e.length() > 100 || at < 1 || at != e.lastIndexOf('@')) {
            return false;
        }
        String local = e.substring(0, at);
        String domain = e.substring(at + 1);
        for (int i = 0; i < local.length(); i++) {
            char c = local.charAt(i);
            if (!Config.letter(c) && !Config.digit(c) && "._%+'-".indexOf(c) < 0) {
                return false;
            }
        }
        int dot = domain.lastIndexOf('.');
        if (dot < 1 || domain.length() - dot - 1 < 2 || domain.contains("..")) {
            return false;
        }
        for (int i = 0; i < domain.length(); i++) {
            char c = domain.charAt(i);
            boolean tld = i > dot;
            if (tld ? !Config.letter(c) : (!Config.letter(c) && !Config.digit(c) && c != '.' && c != '-')) {
                return false;
            }
        }
        return true;
    }

    private static boolean validUid(String u) {
        int n = u.length();
        if (n < 4 || !Config.digit(u.charAt(0)) || !Config.digit(u.charAt(1))) {
            return false;
        }
        int i = 2;
        while (i < n && Config.letter(u.charAt(i))) {
            i++;
        }
        if (i == 2 || i == n) {
            return false;
        }
        for (; i < n; i++) {
            if (!Config.digit(u.charAt(i))) {
                return false;
            }
        }
        return true;
    }

    private static boolean validSemester(String s) {
        if (s.isEmpty() || s.length() > 2) {
            return false;
        }
        for (int i = 0; i < s.length(); i++) {
            if (!Config.digit(s.charAt(i))) {
                return false;
            }
        }
        return true;
    }

    private void login(HttpServletRequest req, HttpServletResponse resp, boolean post) throws ServletException, IOException {
        if (Config.userId(req) != null) {
            go(req, resp, "/prompt");
            return;
        }
        if (!post || req.getParameter("uic_submit") == null) {
            if (!hasCookie(req, "uic_tc")) {
                Cookie probe = new Cookie("uic_tc", "1");
                probe.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
                probe.setHttpOnly(true);
                probe.setSecure(req.isSecure());
                resp.addCookie(probe);
            }
            again(req, resp, "login", "", "", "");
            return;
        }

        String email = clean(req.getParameter("email"));
        String pass = req.getParameter("pass") == null ? "" : req.getParameter("pass");
        String ip = req.getRemoteAddr();
        String title;
        String body;

        if (!Config.validCsrf(req.getSession(false), req.getParameter("uic_nonce"))) {
            title = "Session Expired";
            body = "Please refresh the page and try again.";
        } else if (!hasCookie(req, "uic_tc")) {
            title = "Cookies Disabled";
            body = "Please enable cookies in your browser and try again.";
        } else if (email.isEmpty() || pass.isEmpty()) {
            title = "Missing Information";
            body = "Please enter your email address and password.";
        } else if (email.length() > 254 || pass.length() > 1024) {
            title = "Incorrect Information";
            body = GENERIC;
        } else if (Database.blocked(ip)) {
            title = "Too Many Attempts";
            body = "Please wait 15 minutes before trying again.";
        } else {
            try {
                int id = validEmail(email) ? Database.login(email.toLowerCase(), pass) : -1;
                if (id > 0) {
                    Database.cleared(ip);
                    Config.login(req, resp, id, email.toLowerCase(), req.getParameter("remember") != null);
                    go(req, resp, "/prompt");
                    return;
                }
                Database.failed(ip);
                title = "Incorrect Information";
                body = GENERIC;
            } catch (SQLException e) {
                log("Login failed", e);
                title = "Server Error";
                body = "Could not reach the database. Please try again later.";
            }
        }
        again(req, resp, "login", title, body, email);
    }

    private void register(HttpServletRequest req, HttpServletResponse resp, boolean post) throws ServletException, IOException {
        if (Config.userId(req) != null) {
            go(req, resp, "/prompt");
            return;
        }
        if (!post || req.getParameter("uic_register_submit") == null) {
            again(req, resp, "register", "", "", "");
            return;
        }

        String email = clean(req.getParameter("email")).toLowerCase();
        String pass = req.getParameter("password") == null ? "" : req.getParameter("password");
        String confirm = req.getParameter("confirm_password") == null ? "" : req.getParameter("confirm_password");
        String title = "Registration Failed";
        String body = "";

        if (!Config.validCsrf(req.getSession(false), req.getParameter("uic_register_nonce"))) {
            title = "Session Expired";
            body = "Please refresh the page and try again.";
        } else if (!validEmail(email)) {
            title = "Invalid Email";
            body = "Please enter a valid email address.";
        } else if (pass.length() < 8 || pass.length() > 64) {
            title = "Weak Password";
            body = "Password must be between 8 and 64 characters.";
        } else if (!pass.equals(confirm)) {
            title = "Password Mismatch";
            body = "Both passwords must be the same.";
        } else {
            try {
                int id = Database.register(email, pass);
                if (id < 0) {
                    title = "Account Exists";
                    body = "An account with this email address already exists.";
                } else {
                    Config.login(req, resp, id, email, true);
                    go(req, resp, "/prompt");
                    return;
                }
            } catch (SQLException e) {
                log("Registration failed", e);
                body = "We could not create your account. Please try again.";
            }
        }
        again(req, resp, "register", title, body, email);
    }

    private void logout(HttpServletRequest req, HttpServletResponse resp, boolean post) throws IOException {
        if (post && Config.validCsrf(req.getSession(false), req.getParameter("nonce"))) {
            Config.logout(req, resp);
            go(req, resp, "/login");
        } else {
            go(req, resp, "/prompt");
        }
    }

    private void worksheet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Database.Student student = null;
        String[][] subjects = new String[0][];
        try {
            student = Database.findStudent(Config.userId(req));
            if (student != null) {
                subjects = Database.findSubjects(Database.courseCode(student.uid), student.semester.trim());
            }
        } catch (SQLException e) {
            log("Worksheet data failed", e);
        }
        req.setAttribute("student", student);
        req.setAttribute("configJson", "{\"apiBase\":" + Config.quote(Config.API_BASE) + ",\"generatePath\":"
                + Config.quote(Config.API_GENERATE) + ",\"downloadPath\":" + Config.quote(Config.API_DOWNLOAD)
                + ",\"timeoutMs\":120000}");
        req.setAttribute("studentJson", Config.studentJson(student));
        req.setAttribute("subjectsJson", Config.subjectsJson(subjects));
        view(req, resp, "worksheet");
    }

    private void settings(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Database.Student student = new Database.Student("", "", "", "", "");
        String[][] subjects = new String[0][];
        try {
            Database.Student found = Database.findStudent(Config.userId(req));
            if (found != null) {
                student = found;
            }
            subjects = Database.findSubjects(Database.courseCode(student.uid), student.semester.trim());
        } catch (SQLException e) {
            log("Settings data failed", e);
        }
        String status = (student.uid.isEmpty() || student.semester.isEmpty()) ? "missing" : subjects.length == 0 ? "unsupported" : "ok";
        req.setAttribute("student", student);
        req.setAttribute("subjects", subjects);
        req.setAttribute("subjectStatus", status);
        view(req, resp, "settings");
    }

    private void update(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        if (!Config.validCsrf(req.getSession(false), req.getParameter("nonce"))) {
            fail(resp, HttpServletResponse.SC_FORBIDDEN, "Session expired. Please refresh the page.");
            return;
        }
        String key = req.getParameter("key");
        String value = clean(req.getParameter("value")).replaceAll("\\s+", " ");
        if (key == null || !Database.knownField(key)) {
            fail(resp, HttpServletResponse.SC_BAD_REQUEST, "Unknown field.");
            return;
        }

        String error = null;
        switch (key) {
            case "name": if (value.length() > 100) error = "Name is too long."; break;
            case "uid":
                value = value.toUpperCase();
                if (!value.isEmpty() && (value.length() > 20 || !validUid(value))) error = "UID must look like 26MCI10253.";
                break;
            case "branch": if (value.length() > 100) error = "Branch is too long."; break;
            case "section": if (value.length() > 50) error = "Section is too long."; break;
            case "semester": if (!value.isEmpty() && !validSemester(value)) error = "Semester must be a number."; break;
            default: error = "Unknown field.";
        }
        if (error != null) {
            fail(resp, HttpServletResponse.SC_BAD_REQUEST, error);
            return;
        }

        try {
            Database.saveField(Config.userId(req), key, value);
            resp.getWriter().write("{\"success\":true,\"data\":{\"value\":" + Config.quote(value) + "}}");
        } catch (SQLException e) {
            log("Profile update failed", e);
            fail(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not save. Please try again.");
        }
    }

    private static void fail(HttpServletResponse resp, int status, String message) throws IOException {
        resp.setStatus(status);
        resp.getWriter().write("{\"success\":false,\"data\":{\"message\":" + Config.quote(message) + "}}");
    }
}
