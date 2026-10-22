package com.bookstore.service.impl;

import com.bookstore.dao.UserDao;
import com.bookstore.model.user.User;
import com.bookstore.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Concrete implementation of UserService.
 * Applies business validation, password verification, and delegates storage to UserDao.
 * 
 * @author IT25101062
 */
@Service
public class UserServiceImpl implements UserService {

    private final UserDao userDao;

    @Autowired
    public UserServiceImpl(UserDao userDao) {
        this.userDao = userDao;
    }

    @Override
    public User register(User user) throws IllegalArgumentException {
        if (user == null) {
            throw new IllegalArgumentException("User object cannot be null.");
        }
        if (user.getUsername() == null || user.getUsername().trim().length() < 3) {
            throw new IllegalArgumentException("Username must be at least 3 characters long.");
        }
        if (user.getPassword() == null || user.getPassword().trim().length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters long.");
        }
        if (user.getEmail() == null || !user.getEmail().contains("@")) {
            throw new IllegalArgumentException("A valid email address is required.");
        }

        // Check for duplicate username
        if (userDao.findByUsername(user.getUsername()).isPresent()) {
            throw new IllegalArgumentException("Username '" + user.getUsername() + "' is already registered.");
        }

        // Check for duplicate email
        if (userDao.findByEmail(user.getEmail()).isPresent()) {
            throw new IllegalArgumentException("Email '" + user.getEmail() + "' is already registered.");
        }

        // Generate ID if missing
        if (user.getUserId() == null || user.getUserId().trim().isEmpty()) {
            user.setUserId(userDao.generateNextId());
        }

        boolean saved = userDao.save(user);
        if (!saved) {
            throw new RuntimeException("Failed to persist user to file storage.");
        }

        return user;
    }

    @Override
    public Optional<User> authenticate(String username, String password) {
        if (username == null || password == null) {
            return Optional.empty();
        }

        Optional<User> userOpt = userDao.findByUsername(username.trim());
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // Polymorphic authentication check
            if (user.authenticate(password.trim())) {
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }

    @Override
    public Optional<User> getUserById(String userId) {
        return userDao.findById(userId);
    }

    @Override
    public Optional<User> getUserByUsername(String username) {
        return userDao.findByUsername(username);
    }

    @Override
    public List<User> getAllUsers() {
        return userDao.findAll();
    }

    @Override
    public List<User> searchUsers(String keyword) {
        return userDao.search(keyword);
    }

    @Override
    public boolean updateProfile(User user) {
        if (user == null || user.getUserId() == null) {
            return false;
        }
        return userDao.update(user);
    }

    @Override
    public boolean isUsernameTaken(String username, String excludeUserId) {
        if (username == null || username.trim().isEmpty()) return false;
        Optional<User> existing = userDao.findByUsername(username.trim());
        // Taken if exists AND belongs to a different user
        return existing.isPresent() && !existing.get().getUserId().equalsIgnoreCase(excludeUserId);
    }

    @Override
    public boolean deleteUser(String userId) {
        if (userId == null) return false;
        // Prevent deleting primary super admin
        if ("U001".equalsIgnoreCase(userId)) {
            System.err.println("Cannot delete primary system administrator account (U001).");
            return false;
        }
        return userDao.deleteById(userId);
    }
}
