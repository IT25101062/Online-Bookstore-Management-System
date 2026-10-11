package com.bookstore.dao;

import com.bookstore.model.cart.CartItem;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object interface for Shopping Cart persistence in cart.txt.
 * 
 * @author IT25101062
 */
public interface CartDao {

    /**
     * Create/Add: Save or append cart item to cart.txt
     */
    boolean save(CartItem item);

    /**
     * Read: Get all cart items for a specific user
     */
    List<CartItem> findByUserId(String userId);

    /**
     * Read: Find single item by user ID and book ID
     */
    Optional<CartItem> findByUserAndBook(String userId, String bookId);

    /**
     * Read: All cart items in system
     */
    List<CartItem> findAll();

    /**
     * Update: Update quantity of existing cart item
     */
    boolean update(CartItem item);

    /**
     * Delete: Remove specific cart item by ID
     */
    boolean deleteById(String cartItemId);

    /**
     * Delete: Remove cart item by user ID and book ID
     */
    boolean deleteByUserAndBook(String userId, String bookId);

    /**
     * Delete: Clear all items for a user (e.g. after successful checkout)
     */
    boolean clearCartByUserId(String userId);

    /**
     * Generate next cart item ID (e.g. CI004)
     */
    String generateNextId();
}
