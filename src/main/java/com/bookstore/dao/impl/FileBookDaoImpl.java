package com.bookstore.dao.impl;

import com.bookstore.dao.BookDao;
import com.bookstore.model.book.*;
import com.bookstore.util.FileStorageHelper;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.stream.Collectors;

/**
 * File Handling implementation of BookDao reading from and writing to books.txt.
 * Satisfies the SE1020 File Handling requirement.
 * 
 * @author IT25101062
 */
@Repository
public class FileBookDaoImpl implements BookDao {

    private static final String FILENAME = "books.txt";
    private static final String HEADER = "bookId|isbn|title|author|category|basePrice|stockQuantity|bookType|extra1|extra2|description|imageUrl";

    @Override
    public synchronized boolean save(Book book) {
        if (book == null || book.getBookId() == null) {
            return false;
        }
        return FileStorageHelper.appendLine(FILENAME, book.toFileRecord());
    }

    @Override
    public Optional<Book> findById(String bookId) {
        if (bookId == null) return Optional.empty();
        return findAll().stream()
                .filter(b -> b.getBookId().equalsIgnoreCase(bookId.trim()))
                .findFirst();
    }

    @Override
    public Optional<Book> findByIsbn(String isbn) {
        if (isbn == null) return Optional.empty();
        return findAll().stream()
                .filter(b -> b.getIsbn().equalsIgnoreCase(isbn.trim()))
                .findFirst();
    }

    @Override
    public List<Book> findAll() {
        List<String> lines = FileStorageHelper.readAllLines(FILENAME);
        List<Book> books = new ArrayList<>();

        for (String line : lines) {
            if (line.toLowerCase().startsWith("bookid|")) {
                continue; // Skip header
            }
            Book book = parseBook(line);
            if (book != null) {
                books.add(book);
            }
        }
        return books;
    }

    @Override
    public List<Book> findByCategory(String category) {
        if (category == null || category.trim().isEmpty()) {
            return findAll();
        }
        return findAll().stream()
                .filter(b -> b.getCategory().equalsIgnoreCase(category.trim()))
                .collect(Collectors.toList());
    }

    @Override
    public List<Book> search(String keyword, String category, Double minPrice, Double maxPrice) {
        List<Book> books = findAll();

        if (keyword != null && !keyword.trim().isEmpty()) {
            String term = keyword.trim().toLowerCase();
            books = books.stream()
                    .filter(b -> (b.getTitle() != null && b.getTitle().toLowerCase().contains(term))
                            || (b.getAuthor() != null && b.getAuthor().toLowerCase().contains(term))
                            || (b.getIsbn() != null && b.getIsbn().toLowerCase().contains(term))
                            || (b.getDescription() != null && b.getDescription().toLowerCase().contains(term)))
                    .collect(Collectors.toList());
        }

        if (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("ALL")) {
            books = books.stream()
                    .filter(b -> b.getCategory().equalsIgnoreCase(category.trim()))
                    .collect(Collectors.toList());
        }

        if (minPrice != null) {
            books = books.stream()
                    .filter(b -> b.calculateFinalPrice() >= minPrice)
                    .collect(Collectors.toList());
        }

        if (maxPrice != null) {
            books = books.stream()
                    .filter(b -> b.calculateFinalPrice() <= maxPrice)
                    .collect(Collectors.toList());
        }

        return books;
    }

    @Override
    public synchronized boolean update(Book updatedBook) {
        if (updatedBook == null || updatedBook.getBookId() == null) {
            return false;
        }

        List<Book> allBooks = findAll();
        boolean found = false;
        List<String> updatedLines = new ArrayList<>();

        for (Book b : allBooks) {
            if (b.getBookId().equalsIgnoreCase(updatedBook.getBookId())) {
                updatedLines.add(updatedBook.toFileRecord());
                found = true;
            } else {
                updatedLines.add(b.toFileRecord());
            }
        }

        if (found) {
            return FileStorageHelper.writeAllLines(FILENAME, HEADER, updatedLines);
        }
        return false;
    }

    @Override
    public synchronized boolean updateStock(String bookId, int quantityChange) {
        Optional<Book> bookOpt = findById(bookId);
        if (bookOpt.isPresent()) {
            Book book = bookOpt.get();
            int newStock = book.getStockQuantity() + quantityChange;
            if (newStock < 0) {
                return false; // Insufficient stock
            }
            book.setStockQuantity(newStock);
            return update(book);
        }
        return false;
    }

    @Override
    public synchronized boolean deleteById(String bookId) {
        if (bookId == null) return false;

        List<Book> allBooks = findAll();
        int initialSize = allBooks.size();
        List<String> retainedLines = allBooks.stream()
                .filter(b -> !b.getBookId().equalsIgnoreCase(bookId.trim()))
                .map(Book::toFileRecord)
                .collect(Collectors.toList());

        if (retainedLines.size() < initialSize) {
            return FileStorageHelper.writeAllLines(FILENAME, HEADER, retainedLines);
        }
        return false;
    }

    @Override
    public synchronized String generateNextId() {
        List<Book> books = findAll();
        int maxId = 0;
        for (Book b : books) {
            String idStr = b.getBookId();
            if (idStr != null && idStr.toUpperCase().startsWith("B")) {
                try {
                    int num = Integer.parseInt(idStr.substring(1));
                    if (num > maxId) maxId = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return String.format("B%03d", maxId + 1);
    }

    /**
     * Factory method parsing a pipe-delimited text record into EBook or PrintedBook instance.
     * Demonstrates Polymorphism and Object Instantiation.
     */
    private Book parseBook(String line) {
        try {
            String[] tokens = FileStorageHelper.splitPipe(line);
            if (tokens.length < 8) {
                return null;
            }

            String bookId = tokens[0].trim();
            String isbn = tokens[1].trim();
            String title = tokens[2].trim();
            String author = tokens[3].trim();
            String category = tokens[4].trim();
            double basePrice = Double.parseDouble(tokens[5].trim());
            int stockQuantity = Integer.parseInt(tokens[6].trim());
            BookType bookType = BookType.fromString(tokens[7].trim());
            String extra1 = tokens.length > 8 ? tokens[8].trim() : "";
            String extra2 = tokens.length > 9 ? tokens[9].trim() : "";
            String description = tokens.length > 10 ? tokens[10].trim() : "";
            String imageUrl = tokens.length > 11 ? tokens[11].trim() : "";

            if (bookType == BookType.EBOOK) {
                double fileSizeMB = !extra1.isEmpty() ? Double.parseDouble(extra1) : 5.0;
                String format = !extra2.isEmpty() ? extra2 : "PDF";
                return new EBook(bookId, isbn, title, author, category, basePrice, stockQuantity, description, fileSizeMB, format, imageUrl);
            } else {
                double weightKg = !extra1.isEmpty() ? Double.parseDouble(extra1) : 0.5;
                String coverType = !extra2.isEmpty() ? extra2 : "Paperback";
                return new PrintedBook(bookId, isbn, title, author, category, basePrice, stockQuantity, description, weightKg, coverType, imageUrl);
            }
        } catch (Exception e) {
            System.err.println("Error parsing book record: " + line + " -> " + e.getMessage());
            return null;
        }
    }
}
