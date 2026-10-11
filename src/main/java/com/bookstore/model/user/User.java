package com.bookstore.model.user;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * Abstract User base class demonstrating:
 * 1. Encapsulation: private attributes, input validation in setters, and information hiding.
 * 2. Abstraction: abstract methods for role-specific behaviors.
 * 3. Polymorphism: overridden methods in subclasses (AdminUser and CustomerUser).
 * 
 * @author IT25101062
 */
public abstract class User implements Serializable {

    private static final long serialVersionUID = 1L;

    // Encapsulated private attributes
    private String userId;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String phoneNumber;
    private UserRole role;
    private String createdAt;

    // Default Constructor
    public User() {
        this.createdAt = LocalDate.now().toString();
    }

    // Parameterized Constructor
    public User(String userId, String username, String password, String fullName, String email, String phoneNumber, UserRole role) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.role = role;
        this.createdAt = LocalDate.now().toString();
    }

    public User(String userId, String username, String password, String fullName, String email, String phoneNumber, UserRole role, String createdAt) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.role = role;
        this.createdAt = (createdAt != null && !createdAt.isEmpty()) ? createdAt : LocalDate.now().toString();
    }

    // =========================================================================
    // Polymorphic Abstract Methods
    // =========================================================================
    
    /**
     * Polymorphic method to describe user's role and privileges.
     */
    public abstract String getRoleDescription();

    /**
     * Polymorphic method checking if user possesses administrative privileges.
     */
    public abstract boolean hasAdminPrivileges();

    /**
     * Polymorphic method for authenticating against provided credentials.
     * Subclasses can implement role-specific authentication rules or logging.
     */
    public boolean authenticate(String inputPassword) {
        if (inputPassword == null || this.password == null) {
            return false;
        }
        return this.password.equals(inputPassword.trim());
    }

    /**
     * Polymorphic method to obtain member discount percentage.
     */
    public abstract double getDiscountRate();

    // =========================================================================
    // Encapsulation: Getters and Setters with Validation
    // =========================================================================

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        if (username != null && !username.trim().isEmpty()) {
            this.username = username.trim();
        }
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        if (password != null && !password.trim().isEmpty()) {
            this.password = password.trim();
        }
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        if (fullName != null && !fullName.trim().isEmpty()) {
            this.fullName = fullName.trim();
        }
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        if (email != null && email.contains("@")) {
            this.email = email.trim();
        }
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber != null ? phoneNumber.trim() : "";
    }

    public UserRole getRole() {
        return role;
    }

    public void setRole(UserRole role) {
        this.role = role;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    /**
     * Serializes user state into a pipe-delimited string format for file persistence.
     */
    public abstract String toFileRecord();
}
