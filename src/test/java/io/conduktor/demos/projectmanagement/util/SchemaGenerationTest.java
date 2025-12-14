package io.conduktor.demos.projectmanagement.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class SchemaGenerationTest {

    @Test
    public void testSchemaGeneration() {
        System.out.println("[INITIALIZING] EntityManagerFactory to trigger schema generation...");

        EntityManagerFactory emf = Persistence.createEntityManagerFactory("ProjectManagementPU");
        EntityManager em = emf.createEntityManager();

        System.out.println("[SUCCESS] EntityManager created successfully!");

        assertNotNull(em);
        assertTrue(em.isOpen());

        em.close();
        emf.close();
        System.out.println("[SUCCESS] Schema generation should be complete.");
    }
}
