package com.bookstore.model.cart.validator;

/**
 * Abstraction for stock verification before cart modification.
 * Decouples Shopping Cart business logic from underlying inventory storage.
 * Demonstrates Abstraction OOP concept.
 * 
 * @author IT25101062
 */
public interface StockValidator {

    /**
     * Checks if the requested quantity of a book is available in stock.
     * 
     * @param bookId The ID of the book
     * @param requestedQuantity The desired quantity
     * @return true if sufficient stock exists; false otherwise
     */
    boolean validateStock(String bookId, int requestedQuantity);

    /**
     * Retrieves the available stock count for the book.
     */
    int getAvailableStock(String bookId);
}
