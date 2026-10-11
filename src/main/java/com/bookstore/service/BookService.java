package com.bookstore.service;

import com.bookstore.model.book.Book;
import java.util.List;
import java.util.Optional;

/**
 * Service interface for Book Catalog and Stock management.
 * 
 * @author IT25101062
 */
public interface BookService {

    /**
     * Create: Add new book to catalog
     */
    Book addBook(Book book) throws IllegalArgumentException;

    /**
     * Read: Retrieve book by ID
     */
    Optional<Book> getBookById(String bookId);

    /**
     * Read: Retrieve book by ISBN
     */
    Optional<Book> getBookByIsbn(String isbn);

    /**
     * Read: Retrieve all books in catalog
     */
    List<Book> getAllBooks();

    /**
     * Read: Filter books by category
     */
    List<Book> getBooksByCategory(String category);

    /**
     * Read: Comprehensive multi-parameter search
     */
    List<Book> searchBooks(String keyword, String category, Double minPrice, Double maxPrice);

    /**
     * Update: Update book details and inventory
     */
    boolean updateBook(Book book);

    /**
     * Update: Direct stock adjustment
     */
    boolean adjustStock(String bookId, int quantityChange);

    /**
     * Delete: Remove book from catalog
     */
    boolean deleteBook(String bookId);
}
