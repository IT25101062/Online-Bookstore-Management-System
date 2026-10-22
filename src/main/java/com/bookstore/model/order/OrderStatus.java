package com.bookstore.model.order;

public enum OrderStatus {
    PENDING,
    PROCESSING,
    SHIPPED,
    DELIVERED,
    CANCELLED;

    public static OrderStatus fromString(String str) {
        if (str == null) return PENDING;
        try {
            return OrderStatus.valueOf(str.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return PENDING;
        }
    }
}
