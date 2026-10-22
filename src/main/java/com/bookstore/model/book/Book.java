package com.bookstore.model.book;

import java.io.Serializable;

/**
 * Abstract Book base class.
 * Demonstrates:
 * 1. Encapsulation: private attributes, input validation in price/stock setters, and information hiding.
 * 2. Abstraction: abstract methods for polymorphic calculation and format rendering.
 * 3. Polymorphism: overridden methods in EBook and PrintedBook subclasses.
 * 
 * @author IT25101062
 */
public abstract class Book implements Serializable {

    private static final long serialVersionUID = 1L;

    // Encapsulated private attributes
    private String bookId;
    private String isbn;
    private String title;
    private String author;
    private String category;
    private double basePrice;
    private int stockQuantity;
    private BookType bookType;
    private String description;
    private String imageUrl = "";

    // Default Constructor
    public Book() {
        this.basePrice = 0.0;
        this.stockQuantity = 0;
        this.imageUrl = "";
    }

    // Parameterized Constructor (without imageUrl, for backward compatibility)
    public Book(String bookId, String isbn, String title, String author, String category, double basePrice, int stockQuantity, BookType bookType, String description) {
        this(bookId, isbn, title, author, category, basePrice, stockQuantity, bookType, description, "");
    }

    // Parameterized Constructor (with imageUrl)
    public Book(String bookId, String isbn, String title, String author, String category, double basePrice, int stockQuantity, BookType bookType, String description, String imageUrl) {
        this.bookId = bookId;
        this.isbn = isbn;
        this.title = title;
        this.author = author;
        this.category = category;
        setBasePrice(basePrice); // Use validated setter
        setStockQuantity(stockQuantity); // Use validated setter
        this.bookType = bookType;
        this.description = description;
        setImageUrl(imageUrl);
    }

    // =========================================================================
    // Polymorphic Abstract Methods
    // =========================================================================

    /**
     * Polymorphic method to calculate final price.
     * Printed books factor in weight and shipping, while eBooks have digital delivery.
     */
    public abstract double calculateFinalPrice();

    /**
     * Polymorphic method providing format details (e.g. file size for eBook vs weight/cover for printed).
     */
    public abstract String getFormatDetails();

    /**
     * Polymorphic method checking stock availability.
     */
    public abstract boolean isInStock();

    /**
     * Serializes book state into a pipe-delimited text line for books.txt persistence.
     */
    public abstract String toFileRecord();

    // =========================================================================
    // Encapsulation: Getters and Setters with Validation
    // =========================================================================

    public String getBookId() {
        return bookId;
    }

    public void setBookId(String bookId) {
        this.bookId = bookId;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn != null ? isbn.trim() : "";
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        if (title != null && !title.trim().isEmpty()) {
            this.title = title.trim();
        }
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        if (author != null && !author.trim().isEmpty()) {
            this.author = author.trim();
        }
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category != null ? category.trim() : "General";
    }

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        // Encapsulation validation: price cannot be negative
        if (basePrice < 0) {
            throw new IllegalArgumentException("Book price cannot be negative.");
        }
        this.basePrice = Math.round(basePrice * 100.0) / 100.0;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        // Encapsulation validation: stock cannot be negative
        this.stockQuantity = Math.max(0, stockQuantity);
    }

    public BookType getBookType() {
        return bookType;
    }

    public void setBookType(BookType bookType) {
        this.bookType = bookType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description != null ? description.trim() : "";
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl != null ? imageUrl.trim() : "";
    }

    public boolean hasImageUrl() {
        return imageUrl != null && !imageUrl.trim().isEmpty();
    }
}
