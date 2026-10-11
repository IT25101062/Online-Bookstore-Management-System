package com.bookstore.model.cart.discount;

import com.bookstore.model.user.User;

/**
 * Bulk discount strategy applying an additional 5% discount when ordering 3 or more books.
 * 
 * @author IT25101062
 */
public class BulkDiscountStrategy implements DiscountStrategy {

    @Override
    public double calculateDiscount(double subtotal, int totalItems, User user) {
        if (totalItems >= 3) {
            // 5% volume order discount
            return Math.round((subtotal * 0.05) * 100.0) / 100.0;
        }
        return 0.0;
    }

    @Override
    public String getStrategyName() {
        return "Bulk Order Promotion (3+ items, 5% off)";
    }
}
