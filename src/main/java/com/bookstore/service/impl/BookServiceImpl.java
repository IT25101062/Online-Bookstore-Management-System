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
        if (book.getIsbn() == null || book.getIsbn().trim().isEmpty()) {
            throw new IllegalArgumentException("ISBN number is required.");
        }
        if (book.getBasePrice() < 0) {
            throw new IllegalArgumentException("Base price cannot be negative.");
        }

        // Check if ISBN already exists
        if (bookDao.findByIsbn(book.getIsbn()).isPresent()) {
            throw new IllegalArgumentException("A book with ISBN '" + book.getIsbn() + "' already exists in catalog.");
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
        return bookDao.update(book);
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
