package com.bookstore.model.order.payment;

public enum PaymentStatus {
    PENDING,
    PAID,
    FAILED,
    REFUNDED;

    public static PaymentStatus fromString(String str) {
        if (str == null) return PENDING;
        try {
            return PaymentStatus.valueOf(str.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return PENDING;
        }
    }
}
