package com.bookstore.model.cart.discount;

import com.bookstore.model.user.User;

/**
 * Membership-based discount strategy leveraging polymorphic getDiscountRate() on User.
 * 
 * @author IT25101062
 */
public class MembershipDiscountStrategy implements DiscountStrategy {

    @Override
    public double calculateDiscount(double subtotal, int totalItems, User user) {
        if (user == null) {
            return 0.0;
        }
        double rate = user.getDiscountRate();
        return Math.round((subtotal * rate) * 100.0) / 100.0;
    }

    @Override
    public String getStrategyName() {
        return "Customer Loyalty Tier Discount";
    }
}
