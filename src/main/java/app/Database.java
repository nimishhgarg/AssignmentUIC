package app;

import java.sql.*;

public final class Database {

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
        }
    }

    private Database() {
    }

    public static final class Student {
        public final String name, uid, branch, section, semester;

        public Student(String name, String uid, String branch, String section, String semester) {
            this.name = name == null ? "" : name;
            this.uid = uid == null ? "" : uid;
            this.branch = branch == null ? "" : branch;
            this.section = section == null ? "" : section;
            this.semester = semester == null ? "" : semester;
        }

        public String get(String key) {
            switch (key) {
                case "name": return name;
                case "uid": return uid;
                case "branch": return branch;
                case "section": return section;
                case "semester": return semester;
                default: return "";
            }
        }
    }

    private static final String[][] COLUMNS = {
        {"name", "student_name"}, {"uid", "student_uid"}, {"branch", "student_branch"},
        {"section", "student_section"}, {"semester", "student_semester"}
    };

    public static boolean knownField(String key) {
        return column(key) != null;
    }

    private static String column(String key) {
        for (String[] c : COLUMNS) {
            if (c[0].equals(key)) {
                return c[1];
            }
        }
        return null;
    }

    private static Connection connect() throws SQLException {
        return DriverManager.getConnection(Config.DB_URL, Config.DB_USER, Config.DB_PASS);
    }

    public static String random() {
        try (Connection con = connect(); Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT HEX(RANDOM_BYTES(32))")) {
            if (rs.next()) {
                return rs.getString(1).toLowerCase();
            }
        } catch (SQLException e) {
        }
        StringBuilder b = new StringBuilder();
        for (int i = 0; i < 4; i++) {
            b.append(Long.toHexString(Double.doubleToLongBits(Math.random())));
        }
        return b.append(Long.toHexString(System.nanoTime())).toString();
    }

    public static int login(String email, String pass) throws SQLException {
        String sql = "SELECT id FROM users WHERE email = ? AND password = SHA2(CONCAT(salt, ?), 256) LIMIT 1";
        try (Connection con = connect(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, pass);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : -1;
            }
        }
    }

    public static int register(String email, String pass) throws SQLException {
        String salt = random();
        try (Connection con = connect()) {
            con.setAutoCommit(false);
            try {
                int id;
                String sql = "INSERT INTO users (email, salt, password) VALUES (?, ?, SHA2(CONCAT(?, ?), 256))";
                try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, email);
                    ps.setString(2, salt);
                    ps.setString(3, salt);
                    ps.setString(4, pass);
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        keys.next();
                        id = keys.getInt(1);
                    }
                }
                try (PreparedStatement ps = con.prepareStatement("INSERT INTO student (user_id) VALUES (?)")) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
                con.commit();
                return id;
            } catch (SQLException e) {
                con.rollback();
                if (e.getSQLState() != null && e.getSQLState().startsWith("23")) {
                    return -1;
                }
                throw e;
            }
        }
    }

    public static boolean blocked(String ip) {
        String sql = "SELECT tries FROM login_attempts WHERE ip = ? AND first_try > ?";
        try (Connection con = connect(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, ip);
            ps.setLong(2, System.currentTimeMillis() - Config.LOGIN_WINDOW);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) >= Config.LOGIN_MAX;
            }
        } catch (SQLException e) {
            return false;
        }
    }

    public static void failed(String ip) {
        long now = System.currentTimeMillis();
        String sql = "INSERT INTO login_attempts (ip, tries, first_try) VALUES (?, 1, ?) ON DUPLICATE KEY UPDATE "
                + "tries = IF(? - first_try > ?, 1, tries + 1), first_try = IF(? - first_try > ?, ?, first_try)";
        try (Connection con = connect(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, ip);
            ps.setLong(2, now);
            ps.setLong(3, now);
            ps.setLong(4, Config.LOGIN_WINDOW);
            ps.setLong(5, now);
            ps.setLong(6, Config.LOGIN_WINDOW);
            ps.setLong(7, now);
            ps.executeUpdate();
        } catch (SQLException e) {
        }
    }

    public static void cleared(String ip) {
        try (Connection con = connect(); PreparedStatement ps = con.prepareStatement("DELETE FROM login_attempts WHERE ip = ?")) {
            ps.setString(1, ip);
            ps.executeUpdate();
        } catch (SQLException e) {
        }
    }

    public static Student findStudent(int userId) throws SQLException {
        String sql = "SELECT student_name, student_uid, student_branch, student_section, student_semester FROM student WHERE user_id = ?";
        try (Connection con = connect(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? new Student(rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5)) : null;
            }
        }
    }

    public static void saveField(int userId, String key, String value) throws SQLException {
        String col = column(key);
        if (col == null) {
            throw new SQLException("Unknown field");
        }
        String sql = "INSERT INTO student (user_id, " + col + ") VALUES (?, ?) ON DUPLICATE KEY UPDATE " + col + " = VALUES(" + col + ")";
        try (Connection con = connect(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (value.isEmpty()) {
                ps.setNull(2, Types.VARCHAR);
            } else {
                ps.setString(2, value);
            }
            ps.executeUpdate();
        }
    }

    public static String courseCode(String uid) {
        if (uid == null) {
            return "";
        }
        int n = uid.length();
        if (n > 3 && Config.digit(uid.charAt(0)) && Config.digit(uid.charAt(1))) {
            int i = 2;
            while (i < n && Config.letter(uid.charAt(i))) {
                i++;
            }
            if (i > 2 && i < n && Config.digit(uid.charAt(i))) {
                return uid.substring(2, i).toUpperCase();
            }
        }
        int s = 0;
        while (s < n && !Config.letter(uid.charAt(s))) {
            s++;
        }
        int e = s;
        while (e < n && Config.letter(uid.charAt(e))) {
            e++;
        }
        return uid.substring(s, e).toUpperCase();
    }

    public static String[][] findSubjects(String code, String semester) throws SQLException {
        if (code.isEmpty() || semester.isEmpty()) {
            return new String[0][];
        }
        String sql = "SELECT subject_name, subject_code, course FROM subject WHERE UPPER(uid) = UPPER(?) AND UPPER(semester) = UPPER(?) ORDER BY subject_name";
        try (Connection con = connect();
             PreparedStatement ps = con.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY)) {
            ps.setString(1, code);
            ps.setString(2, semester);
            try (ResultSet rs = ps.executeQuery()) {
                rs.last();
                String[][] list = new String[rs.getRow()][];
                rs.beforeFirst();
                int i = 0;
                while (rs.next()) {
                    list[i++] = new String[] {rs.getString(1), rs.getString(2), rs.getString(3)};
                }
                return list;
            }
        }
    }
}
