package io.conduktor.demos.projectmanagement.util;

import org.junit.jupiter.api.Test;
import java.sql.Connection;
import java.sql.DriverManager;

public class DbConnectionTest {

    @Test
    public void testConnection() {
        // Values from persistence.xml (MySQL)
        String url = "jdbc:mysql://localhost:3308/project_management?useSSL=false&allowPublicKeyRetrieval=true";
        String user = "root";
        String password = "root"; // Updated password

        System.out.println("Attempting to connect to: " + url);

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            System.out.println("[SUCCESS] Connection successful!");
        } catch (Exception e) {
            System.err.println("[FAILED] Connection failed!");
            e.printStackTrace();
            try (java.io.PrintWriter pw = new java.io.PrintWriter("test-error.log")) {
                e.printStackTrace(pw);
            } catch (java.io.FileNotFoundException ex) {
                ex.printStackTrace();
            }
            throw new RuntimeException("Validation failed", e);
        }
    }
}
