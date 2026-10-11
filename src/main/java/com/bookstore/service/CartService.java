package com.bookstore.service;

import com.bookstore.model.cart.ShoppingCart;
import com.bookstore.model.user.User;

/**
 * Service interface for Shopping Cart management.
 * Demonstrates Abstraction and stock validation before modification.
 * 
 * @author IT25101062
 */
public interface CartService {

    /**
     * Create/Add: Add book to cart after validating stock availability.
     */
    boolean addToCart(String userId, String bookId, int quantity) throws IllegalArgumentException;

    /**
     * Read: Retrieve populated ShoppingCart for user with books and calculated totals.
     */
    ShoppingCart getCartForUser(String userId, User user);

    /**
     * Update: Update item quantity in cart with stock validation.
     */
    boolean updateQuantity(String userId, String cartItemId, int newQuantity) throws IllegalArgumentException;

    /**
     * Delete: Remove single item from cart.
     */
    boolean removeItem(String cartItemId);

    /**
     * Delete: Clear all items in user's cart.
     */
    boolean clearCart(String userId);

    /**
     * Read: Count total items in user's cart.
     */
    int getCartItemCount(String userId);
}
