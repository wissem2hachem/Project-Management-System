package io.conduktor.demos.projectmanagement.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.nio.file.Files;
import java.nio.file.Paths;

public class DatabaseUtil {
    private static final String PERSISTENCE_UNIT_NAME = "ProjectManagementPU";
    private static EntityManagerFactory entityManagerFactory;

    static {
        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Initialize database with schema if needed
            initializeDatabase();

            // Create EntityManagerFactory
            entityManagerFactory = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);

            System.out.println("MySQL database connection established successfully.");
        } catch (Exception e) {
            System.err.println("Failed to create EntityManagerFactory: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize database connection", e);
        }
    }

    private static void initializeDatabase() {
        try (Connection conn = getConnection()) {
            // Check if tables exist
            boolean tablesExist = checkTablesExist(conn);

            if (!tablesExist) {
                System.out.println("Creating database tables...");
                executeSQLScript(conn, "schema.sql");
                System.out.println("Tables created successfully.");

                // Insert sample data
                System.out.println("Inserting sample data...");
                executeSQLScript(conn, "data.sql");
                System.out.println("Sample data inserted successfully.");
            } else {
                System.out.println("Database tables already exist.");
            }
        } catch (Exception e) {
            System.err.println("Failed to initialize database: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static boolean checkTablesExist(Connection conn) throws SQLException {
        var sql = """
                SELECT COUNT(*) as table_count
                FROM information_schema.tables
                WHERE table_schema = 'project_management'
                AND table_name IN ('users', 'projects', 'tasks')
                """;

        try (var stmt = conn.createStatement();
                var rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("table_count") >= 3;
            }
        }
        return false;
    }

    private static void executeSQLScript(Connection conn, String scriptName) throws Exception {
        // Try to load script from classpath
        var resource = DatabaseUtil.class.getClassLoader().getResource(scriptName);
        if (resource != null) {
            String sql = new String(Files.readAllBytes(Paths.get(resource.toURI())));
            String[] statements = sql.split(";");

            try (Statement stmt = conn.createStatement()) {
                for (String statement : statements) {
                    String trimmed = statement.trim();
                    if (!trimmed.isEmpty()) {
                        stmt.execute(trimmed);
                    }
                }
            }
        }
    }

    public static EntityManager getEntityManager() {
        if (entityManagerFactory == null || !entityManagerFactory.isOpen()) {
            entityManagerFactory = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
        }
        return entityManagerFactory.createEntityManager();
    }

    public static Connection getConnection() throws SQLException {
        String url = "jdbc:mysql://localhost:3308/project_management?useSSL=false&allowPublicKeyRetrieval=true";
        String user = "root";
        String password = "root"; // Updated password

        return DriverManager.getConnection(url, user, password);
    }

    public static void close() {
        if (entityManagerFactory != null && entityManagerFactory.isOpen()) {
            entityManagerFactory.close();
        }
    }
}