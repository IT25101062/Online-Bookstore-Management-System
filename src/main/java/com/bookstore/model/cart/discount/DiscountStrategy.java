package com.bookstore.model.cart.discount;

import com.bookstore.model.user.User;

/**
 * Strategy interface demonstrating Polymorphism in shopping cart discount calculations.
 * Allows interchangeable pricing algorithms based on membership tiers, volume orders, or promotions.
 * 
 * @author IT25101062
 */
public interface DiscountStrategy {

    /**
     * Calculates the monetary discount amount based on subtotal, item count, and active user.
     * 
     * @param subtotal Total cart amount before discount
     * @param totalItems Number of book items in cart
     * @param user Active user context
     * @return Discount dollar amount
     */
    double calculateDiscount(double subtotal, int totalItems, User user);

    /**
     * Description of the applied discount strategy.
     */
    String getStrategyName();
}
