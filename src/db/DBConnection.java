package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DBConnection {
    private static boolean initialized = false;

    public static Connection getConnection() throws Exception {
        Class.forName("org.sqlite.JDBC");
        
        String dbPath = System.getenv("SQLITE_DB_PATH");
        if (dbPath == null) {
            dbPath = "expense_db.db"; // Local dev default
        }
        
        Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
        
        if (!initialized) {
            initDatabase(conn);
            initialized = true;
        }
        return conn;
    }

    private static void initDatabase(Connection conn) {
        try (Statement stmt = conn.createStatement()) {
            stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "name TEXT NOT NULL, " +
                "email TEXT NOT NULL UNIQUE, " +
                "password TEXT NOT NULL" +
            ")");
            try {
                stmt.execute("ALTER TABLE users ADD COLUMN salary REAL DEFAULT 0.0");
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
                "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "user_id INTEGER NOT NULL, " +
                "title TEXT NOT NULL, " +
                "amount REAL NOT NULL, " +
                "category TEXT NOT NULL, " +
                "expense_date TEXT NOT NULL, " +
                "FOREIGN KEY (user_id) REFERENCES users(id)" +
            ")");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
