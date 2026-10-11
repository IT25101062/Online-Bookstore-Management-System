package com.bookstore.model.user;

public enum UserRole {
    ADMIN,
    CUSTOMER;

    public static UserRole fromString(String roleStr) {
        if (roleStr == null) return CUSTOMER;
        try {
            return UserRole.valueOf(roleStr.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return CUSTOMER;
        }
    }
}
