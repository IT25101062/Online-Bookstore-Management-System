package com.bookstore.dao;

import com.bookstore.model.book.Book;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object interface for Book CRUD operations.
 * Demonstrates Abstraction by isolating file handling logic from high-level services.
 * 
 * @author IT25101062
 */
public interface BookDao {

    /**
     * Create: Save new book to books.txt
     */
    boolean save(Book book);

    /**
     * Read: Find book by unique ID
     */
    Optional<Book> findById(String bookId);

    /**
     * Read: Find book by ISBN
     */
    Optional<Book> findByIsbn(String isbn);

    /**
     * Read: Retrieve all books from books.txt
     */
    List<Book> findAll();

    /**
     * Read: Filter books by category
     */
    List<Book> findByCategory(String category);

    /**
     * Read: Search books across title, author, category, and ISBN
     */
    List<Book> search(String keyword, String category, Double minPrice, Double maxPrice);

    /**
     * Update: Update book information in books.txt
     */
    boolean update(Book book);

    /**
     * Update: Atomically adjust stock quantity
     */
    boolean updateStock(String bookId, int quantityChange);

    /**
     * Delete: Remove book from books.txt
     */
    boolean deleteById(String bookId);

    /**
     * Generate next incremental book ID (e.g. B009)
     */
    String generateNextId();
}
