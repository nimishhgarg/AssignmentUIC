package app;

import jakarta.servlet.http.*;

public final class Config {

    private Config() {
    }

    public static final String DB_URL = "jdbc:mysql://localhost:3306/project?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    public static final String DB_USER = "root";
    public static final String DB_PASS = "root123";
    public static final String API_BASE = "http://localhost:6969";
    public static final String API_GENERATE = "/graphql";
    public static final String API_DOWNLOAD = "/download/";
    public static final int LOGIN_MAX = 10;
    public static final long LOGIN_WINDOW = 900000L;
    public static final int SESSION_SHORT = 172800;
    public static final int SESSION_LONG = 1296000;

    public static boolean letter(char c) {
        return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');
    }

    public static boolean digit(char c) {
        return c >= '0' && c <= '9';
    }

    public static String esc(String v) {
        if (v == null) {
            return "";
        }
        StringBuilder b = new StringBuilder(v.length() + 16);
        for (int i = 0; i < v.length(); i++) {
            char c = v.charAt(i);
            switch (c) {
                case '&': b.append("&amp;"); break;
                case '<': b.append("&lt;"); break;
                case '>': b.append("&gt;"); break;
                case '"': b.append("&quot;"); break;
                case '\'': b.append("&#039;"); break;
                default: b.append(c);
            }
        }
        return b.toString();
    }

    public static String show(String v) {
        return (v == null || v.isEmpty()) ? "--" : v;
    }

    public static String js(String v) {
        if (v == null) {
            return "";
        }
        StringBuilder b = new StringBuilder(v.length() + 16);
        for (int i = 0; i < v.length(); i++) {
            char c = v.charAt(i);
            switch (c) {
                case '"': b.append("\\\""); break;
                case '\\': b.append("\\\\"); break;
                case '\n': b.append("\\n"); break;
                case '\r': b.append("\\r"); break;
                case '\t': b.append("\\t"); break;
                case '<': b.append("\\u003c"); break;
                case '>': b.append("\\u003e"); break;
                case '&': b.append("\\u0026"); break;
                case '\'': b.append("\\u0027"); break;
                case '\u2028': b.append("\\u2028"); break;
                case '\u2029': b.append("\\u2029"); break;
                default:
                    if (c < 0x20) {
                        b.append(String.format("\\u%04x", (int) c));
                    } else {
                        b.append(c);
                    }
            }
        }
        return b.toString();
    }

    public static String quote(String v) {
        return "\"" + js(v) + "\"";
    }

    public static String studentJson(Database.Student s) {
        if (s == null) {
            return "null";
        }
        return "{\"name\":" + quote(s.name) + ",\"uid\":" + quote(s.uid) + ",\"branch\":" + quote(s.branch)
                + ",\"section\":" + quote(s.section) + ",\"semester\":" + quote(s.semester) + "}";
    }

    public static String subjectsJson(String[][] list) {
        StringBuilder b = new StringBuilder("[");
        for (int i = 0; i < list.length; i++) {
            if (i > 0) {
                b.append(',');
            }
            b.append("{\"name\":").append(quote(list[i][0])).append(",\"code\":").append(quote(list[i][1])).append('}');
        }
        return b.append(']').toString();
    }

    public static String csrf(HttpSession session) {
        Object t = session.getAttribute("csrf");
        if (t == null) {
            t = Database.random();
            session.setAttribute("csrf", t);
        }
        return (String) t;
    }

    public static boolean validCsrf(HttpSession session, String given) {
        if (session == null || given == null) {
            return false;
        }
        Object t = session.getAttribute("csrf");
        if (!(t instanceof String) || ((String) t).length() != given.length()) {
            return false;
        }
        String s = (String) t;
        int diff = 0;
        for (int i = 0; i < s.length(); i++) {
            diff |= s.charAt(i) ^ given.charAt(i);
        }
        return diff == 0;
    }

    public static Integer userId(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) {
            return null;
        }
        Object id = s.getAttribute("userId");
        return (id instanceof Integer) ? (Integer) id : null;
    }

    public static void login(HttpServletRequest req, HttpServletResponse resp, int id, String email, boolean remember) {
        req.getSession(true);
        req.changeSessionId();
        HttpSession s = req.getSession(true);
        s.setAttribute("userId", id);
        s.setAttribute("email", email);
        s.setMaxInactiveInterval(remember ? SESSION_LONG : SESSION_SHORT);
        if (remember) {
            Cookie c = new Cookie("JSESSIONID", s.getId());
            c.setPath(path(req));
            c.setHttpOnly(true);
            c.setSecure(req.isSecure());
            c.setMaxAge(SESSION_LONG);
            resp.addCookie(c);
        }
    }

    public static void logout(HttpServletRequest req, HttpServletResponse resp) {
        HttpSession s = req.getSession(false);
        if (s != null) {
            s.invalidate();
        }
        Cookie c = new Cookie("JSESSIONID", "");
        c.setPath(path(req));
        c.setHttpOnly(true);
        c.setMaxAge(0);
        resp.addCookie(c);
    }

    private static String path(HttpServletRequest req) {
        String p = req.getContextPath();
        return p.isEmpty() ? "/" : p;
    }
}
