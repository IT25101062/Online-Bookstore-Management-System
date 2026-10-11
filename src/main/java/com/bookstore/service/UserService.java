package com.bookstore.service;

import com.bookstore.model.user.User;
import java.util.List;
import java.util.Optional;

/**
 * Service interface for User business logic.
 * Demonstrates Abstraction by separating service contract from concrete implementation.
 * 
 * @author IT25101062
 */
public interface UserService {

    /**
     * Create: Register new user with uniqueness validation
     */
    User register(User user) throws IllegalArgumentException;

    /**
     * Authenticate user credentials polymorphically
     */
    Optional<User> authenticate(String username, String password);

    /**
     * Read: Retrieve user by ID
     */
    Optional<User> getUserById(String userId);

    /**
     * Read: Retrieve user by username
     */
    Optional<User> getUserByUsername(String username);

    /**
     * Read: List all registered users
     */
    List<User> getAllUsers();

    /**
     * Read: Search users by keyword
     */
    List<User> searchUsers(String keyword);

    /**
     * Update: Update user profile
     */
    boolean updateProfile(User user);

    /**
     * Delete: Delete user by ID
     */
    boolean deleteUser(String userId);
}
