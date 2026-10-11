package com.bookstore.model.cart.discount;

import com.bookstore.model.user.User;

public class NoDiscountStrategy implements DiscountStrategy {

    @Override
    public double calculateDiscount(double subtotal, int totalItems, User user) {
        return 0.0;
    }

    @Override
    public String getStrategyName() {
        return "Standard Rate (No Discount)";
    }
}
