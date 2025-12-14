package io.conduktor.demos.projectmanagement.service;

import io.conduktor.demos.projectmanagement.entity.User;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class UserServiceTest {

    private static final String TEST_EMAIL = "test_user_unique_" + System.currentTimeMillis() + "@example.com";
    private static final String TEST_PASSWORD = "password123";

    @Test
    @Order(1)
    public void testRegisterUser() {
        System.out.println("🧪 Testing Registration with email: " + TEST_EMAIL);

        UserService userService = new UserService();
        User user = userService.registerUser("Test User", TEST_EMAIL, TEST_PASSWORD);

        assertNotNull(user);
        assertNotNull(user.getId());
        assertEquals(TEST_EMAIL, user.getEmail());
        assertEquals("MEMBER", user.getRole());

        System.out.println("✅ Registration successful! User ID: " + user.getId());
    }

    @Test
    @Order(2)
    public void testLoginSuccess() {
        System.out.println("🧪 Testing Login Success...");

        UserService userService = new UserService();
        User user = userService.login(TEST_EMAIL, TEST_PASSWORD);

        assertNotNull(user);
        assertEquals(TEST_EMAIL, user.getEmail());

        System.out.println("✅ Login successful!");
    }

    @Test
    @Order(3)
    public void testLoginFailure() {
        System.out.println("🧪 Testing Login Failure...");

        UserService userService = new UserService();
        User user = userService.login(TEST_EMAIL, "wrong_password");

        assertNull(user);

        System.out.println("✅ Login failed as expected with wrong password!");
    }

    @Test
    @Order(4)
    public void testGetUserByEmail() {
        System.out.println("🧪 Testing Get User By Email...");

        UserService userService = new UserService();
        User user = userService.getUserByEmail(TEST_EMAIL);

        assertNotNull(user);
        assertEquals(TEST_EMAIL, user.getEmail());

        System.out.println("✅ Get User By Email successful!");
    }
}
