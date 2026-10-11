package com.bookstore.model.cart;

import com.bookstore.model.book.Book;
import com.bookstore.util.FileStorageHelper;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * Encapsulated CartItem model representing an item in a user's shopping cart.
 * Demonstrates Encapsulation with private fields, data validation, and calculation methods.
 * 
 * @author IT25101062
 */
public class CartItem implements Serializable {

    private static final long serialVersionUID = 1L;

    private String cartItemId;
    private String userId;
    private String bookId;
    private int quantity;
    private double pricePerUnit;
    private String addedDate;

    // Optional transient reference to the Book object for rich display
    private Book book;

    public CartItem() {
        this.addedDate = LocalDate.now().toString();
        this.quantity = 1;
    }

    public CartItem(String cartItemId, String userId, String bookId, int quantity, double pricePerUnit) {
        this.cartItemId = cartItemId;
        this.userId = userId;
        this.bookId = bookId;
        setQuantity(quantity);
        setPricePerUnit(pricePerUnit);
        this.addedDate = LocalDate.now().toString();
    }

    public CartItem(String cartItemId, String userId, String bookId, int quantity, double pricePerUnit, String addedDate) {
        this.cartItemId = cartItemId;
        this.userId = userId;
        this.bookId = bookId;
        setQuantity(quantity);
        setPricePerUnit(pricePerUnit);
        this.addedDate = (addedDate != null && !addedDate.isEmpty()) ? addedDate : LocalDate.now().toString();
    }

    /**
     * Calculates the subtotal for this cart line item.
     */
    public double getItemSubtotal() {
        return Math.round((quantity * pricePerUnit) * 100.0) / 100.0;
    }

    // =========================================================================
    // Getters and Setters with Encapsulation & Validation
    // =========================================================================

    public String getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(String cartItemId) {
        this.cartItemId = cartItemId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getBookId() {
        return bookId;
    }

    public void setBookId(String bookId) {
        this.bookId = bookId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        if (quantity < 1) {
            throw new IllegalArgumentException("Cart quantity must be at least 1.");
        }
        this.quantity = quantity;
    }

    public double getPricePerUnit() {
        return pricePerUnit;
    }

    public void setPricePerUnit(double pricePerUnit) {
        if (pricePerUnit < 0) {
            throw new IllegalArgumentException("Price cannot be negative.");
        }
        this.pricePerUnit = Math.round(pricePerUnit * 100.0) / 100.0;
    }

    public String getAddedDate() {
        return addedDate;
    }

    public void setAddedDate(String addedDate) {
        this.addedDate = addedDate;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    public String toFileRecord() {
        return FileStorageHelper.joinPipe(
            cartItemId,
            userId,
            bookId,
            String.valueOf(quantity),
            String.format(java.util.Locale.US, "%.2f", pricePerUnit),
            addedDate
        );
    }
}
