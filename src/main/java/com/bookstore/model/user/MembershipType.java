package com.bookstore.model.user;

public enum MembershipType {
    NONE(0.0),
    STANDARD(0.0),
    SILVER(0.05), // 5% discount
    GOLD(0.10);   // 10% discount

    private final double discountRate;

    MembershipType(double discountRate) {
        this.discountRate = discountRate;
    }

    public double getDiscountRate() {
        return discountRate;
    }

    public static MembershipType fromString(String str) {
        if (str == null) return STANDARD;
        try {
            return MembershipType.valueOf(str.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return STANDARD;
        }
    }
}
