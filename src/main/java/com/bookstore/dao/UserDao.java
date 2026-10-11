package com.bookstore.dao;

import com.bookstore.model.user.User;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object interface for User CRUD operations.
 * Demonstrates Abstraction by decoupling business logic from file storage.
 * 
 * @author IT25101062
 */
public interface UserDao {

    /**
     * Create: Save a new user to users.txt
     */
    boolean save(User user);

    /**
     * Read: Find user by unique ID
     */
    Optional<User> findById(String userId);

    /**
     * Read: Find user by username
     */
    Optional<User> findByUsername(String username);

    /**
     * Read: Find user by email
     */
    Optional<User> findByEmail(String email);

    /**
     * Read: List all users from users.txt
     */
    List<User> findAll();

    /**
     * Read: Search users by keyword (username, name, email, or phone)
     */
    List<User> search(String keyword);

    /**
     * Update: Modify user details in users.txt
     */
    boolean update(User user);

    /**
     * Delete: Remove user record from users.txt
     */
    boolean deleteById(String userId);

    /**
     * Generate next incremental user ID (e.g., U005)
     */
    String generateNextId();
}
