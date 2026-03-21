package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DBConnection {
    private static boolean initialized = false;

    public static Connection getConnection() throws Exception {
        String dbUrl = System.getenv("DATABASE_URL");
        Connection conn;

        if (dbUrl != null && dbUrl.startsWith("jdbc:postgresql:")) {
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(dbUrl);
        } else {
            Class.forName("org.sqlite.JDBC");
            String dbPath = System.getenv("SQLITE_DB_PATH");
            if (dbPath == null) {
                dbPath = "expense_db.db";
            }
            conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
        }
        
        if (!initialized) {
            initDatabase(conn);
            initialized = true;
        }
        return conn;
    }

    private static void initDatabase(Connection conn) {
        try {
            // Detect database type
            String dbProductName = conn.getMetaData().getDatabaseProductName().toLowerCase();
            boolean isPostgres = dbProductName.contains("postgresql");
            String autoIncrement = isPostgres ? "SERIAL PRIMARY KEY" : "INTEGER PRIMARY KEY AUTOINCREMENT";
            String realType = isPostgres ? "DOUBLE PRECISION" : "REAL";

            try (Statement stmt = conn.createStatement()) {
                stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
                    "id " + autoIncrement + ", " +
                    "name TEXT NOT NULL, " +
                    "email TEXT NOT NULL UNIQUE, " +
                    "password TEXT NOT NULL" +
                ")");
                try {
                    stmt.execute("ALTER TABLE users ADD COLUMN salary " + realType + " DEFAULT 0.0");
                } catch (Exception ignored) {
                    // Column likely already exists
                }
                try {
                    stmt.execute("ALTER TABLE users ADD COLUMN split_needs INTEGER DEFAULT 50");
                    stmt.execute("ALTER TABLE users ADD COLUMN split_wants INTEGER DEFAULT 30");
                    stmt.execute("ALTER TABLE users ADD COLUMN split_savings INTEGER DEFAULT 20");
                } catch (Exception ignored) {
                    // Columns likely already exist
                }
                stmt.execute("CREATE TABLE IF NOT EXISTS expenses (" +
                    "id " + autoIncrement + ", " +
                    "user_id INTEGER NOT NULL, " +
                    "title TEXT NOT NULL, " +
                    "amount " + realType + " NOT NULL, " +
                    "category TEXT NOT NULL, " +
                    "expense_date TEXT NOT NULL, " +
                    "FOREIGN KEY (user_id) REFERENCES users(id)" +
                ")");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
