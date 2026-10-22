package com.bookstore.service.impl;

import com.bookstore.dao.BookDao;
import com.bookstore.model.book.Book;
import com.bookstore.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Concrete implementation of BookService.
 * Validates book data, guarantees unique ISBNs, and delegates persistence to BookDao.
 * 
 * @author IT25101062
 */
@Service
public class BookServiceImpl implements BookService {

    private final BookDao bookDao;

    @Autowired
    public BookServiceImpl(BookDao bookDao) {
        this.bookDao = bookDao;
    }

    @Override
    public Book addBook(Book book) throws IllegalArgumentException {
        if (book == null) {
            throw new IllegalArgumentException("Book details cannot be empty.");
        }
        if (book.getTitle() == null || book.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Book title is required.");
        }
        if (book.getAuthor() == null || book.getAuthor().trim().isEmpty()) {
            throw new IllegalArgumentException("Author name is required.");
        }
        validateIsbn(book.getIsbn(), null);

        if (book.getBasePrice() < 0) {
            throw new IllegalArgumentException("Base price cannot be negative.");
        }

        // Generate ID if missing
        if (book.getBookId() == null || book.getBookId().trim().isEmpty()) {
            book.setBookId(bookDao.generateNextId());
        }

        boolean saved = bookDao.save(book);
        if (!saved) {
            throw new RuntimeException("Failed to persist book to books.txt file.");
        }
        return book;
    }

    @Override
    public Optional<Book> getBookById(String bookId) {
        return bookDao.findById(bookId);
    }

    @Override
    public Optional<Book> getBookByIsbn(String isbn) {
        return bookDao.findByIsbn(isbn);
    }

    @Override
    public List<Book> getAllBooks() {
        return bookDao.findAll();
    }

    @Override
    public List<Book> getBooksByCategory(String category) {
        return bookDao.findByCategory(category);
    }

    @Override
    public List<Book> searchBooks(String keyword, String category, Double minPrice, Double maxPrice) {
        return bookDao.search(keyword, category, minPrice, maxPrice);
    }

    @Override
    public boolean updateBook(Book book) {
        if (book == null || book.getBookId() == null) {
            return false;
        }
        if (book.getTitle() == null || book.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Book title is required.");
        }
        if (book.getAuthor() == null || book.getAuthor().trim().isEmpty()) {
            throw new IllegalArgumentException("Author name is required.");
        }
        validateIsbn(book.getIsbn(), book.getBookId());
        return bookDao.update(book);
    }

    /**
     * Validates ISBN format and digit limit:
     * - Must not be empty
     * - Allowed characters: digits 0-9, hyphens (-), and 'X'/'x'
     * - Limit: Must contain exactly 10 digits (ISBN-10) or 13 digits (ISBN-13)
     * - Total length with hyphens: 10 to 17 characters
     */
    private void validateIsbn(String isbn, String excludeBookId) {
        if (isbn == null || isbn.trim().isEmpty()) {
            throw new IllegalArgumentException("ISBN number is required.");
        }
        String clean = isbn.trim();
        if (clean.length() < 10) {
            throw new IllegalArgumentException("ISBN is too short. Minimum length is 10 characters.");
        }
        if (clean.length() > 17) {
            throw new IllegalArgumentException("ISBN exceeds maximum length limit of 17 characters.");
        }
        if (!clean.matches("^[0-9Xx\\-]+$")) {
            throw new IllegalArgumentException("ISBN may only contain numbers (0-9) and hyphens (-).");
        }
        String digitsOnly = clean.replaceAll("[^0-9Xx]", "");
        int digitCount = digitsOnly.length();
        if (digitCount < 10) {
            throw new IllegalArgumentException("ISBN digit limit: Minimum 10 digits required (you entered " + digitCount + " digits).");
        }
        if (digitCount > 13) {
            throw new IllegalArgumentException("ISBN digit limit: Maximum 13 digits allowed (you entered " + digitCount + " digits).");
        }
        if (digitCount != 10 && digitCount != 13) {
            throw new IllegalArgumentException("Invalid ISBN digit count (" + digitCount + "). Standard ISBN must be either 10 digits (ISBN-10) or 13 digits (ISBN-13).");
        }

        // Check if ISBN is already used by another book
        Optional<Book> existing = bookDao.findByIsbn(clean);
        if (existing.isPresent()) {
            if (excludeBookId == null || !existing.get().getBookId().equalsIgnoreCase(excludeBookId)) {
                throw new IllegalArgumentException("A book with ISBN '" + clean + "' already exists in catalog.");
            }
        }
    }

    @Override
    public boolean adjustStock(String bookId, int quantityChange) {
        if (bookId == null) return false;
        return bookDao.updateStock(bookId, quantityChange);
    }

    @Override
    public boolean deleteBook(String bookId) {
        if (bookId == null) return false;
        return bookDao.deleteById(bookId);
    }
}
