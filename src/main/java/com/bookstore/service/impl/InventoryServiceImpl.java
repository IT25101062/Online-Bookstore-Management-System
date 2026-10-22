package com.bookstore.service.impl;

import com.bookstore.dao.BookDao;
import com.bookstore.dao.InventoryDao;
import com.bookstore.model.book.Book;
import com.bookstore.model.inventory.InventoryReport;
import com.bookstore.service.InventoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * InventoryServiceImpl – business logic for Inventory & Reports module.
 * Demonstrates Abstraction: hides BookDao and InventoryDao details from controller.
 *
 * @author IT25101062
 */
@Service
public class InventoryServiceImpl implements InventoryService {

    private static final int LOW_STOCK_THRESHOLD = 5;

    private final BookDao      bookDao;
    private final InventoryDao inventoryDao;

    @Autowired
    public InventoryServiceImpl(BookDao bookDao, InventoryDao inventoryDao) {
        this.bookDao      = bookDao;
        this.inventoryDao = inventoryDao;
    }

    // =========================================================================
    // Create – Generate Report
    // =========================================================================

    @Override
    public InventoryReport generateReport(String adminId, String reportType) {
        List<Book> allBooks      = bookDao.findAll();
        List<Book> lowStockBooks = allBooks.stream()
            .filter(b -> b.getStockQuantity() <= LOW_STOCK_THRESHOLD)
            .collect(Collectors.toList());

        int totalBooks      = allBooks.size();
        int totalStock      = allBooks.stream().mapToInt(Book::getStockQuantity).sum();
        int lowStockCount   = lowStockBooks.size();

        // Build human-readable content based on type
        StringBuilder sb = new StringBuilder();
        switch (reportType.toUpperCase()) {
            case "LOW_STOCK_ALERT":
                sb.append("LOW STOCK ALERT — Books at or below ")
                  .append(LOW_STOCK_THRESHOLD).append(" units: ");
                if (lowStockBooks.isEmpty()) {
                    sb.append("None");
                } else {
                    lowStockBooks.forEach(b ->
                        sb.append(b.getTitle()).append(" (").append(b.getStockQuantity()).append("), "));
                }
                break;

            case "FULL_INVENTORY":
                sb.append("FULL INVENTORY: ");
                allBooks.forEach(b ->
                    sb.append(b.getBookId()).append(":").append(b.getTitle())
                      .append("=").append(b.getStockQuantity()).append(" units, "));
                break;

            default: // STOCK_SUMMARY
                sb.append("STOCK SUMMARY: Total books=").append(totalBooks)
                  .append(", Total units=").append(totalStock)
                  .append(", Low-stock items=").append(lowStockCount);
                break;
        }

        String reportId = inventoryDao.generateNextReportId();
        InventoryReport report = new InventoryReport(
            reportId, reportType.toUpperCase(), adminId,
            totalBooks, totalStock, lowStockCount, sb.toString().trim()
        );

        if (!inventoryDao.saveReport(report)) {
            throw new RuntimeException("Failed to persist report to data file.");
        }
        return report;
    }

    // =========================================================================
    // Read
    // =========================================================================

    @Override
    public List<InventoryReport> getAllReports() {
        return inventoryDao.findAllReports();
    }

    @Override
    public Optional<InventoryReport> getReportById(String reportId) {
        return inventoryDao.findReportById(reportId);
    }

    @Override
    public List<Book> getStockLevels() {
        // Return all books ordered by stock ascending (lowest first)
        return bookDao.findAll().stream()
            .sorted((a, b) -> Integer.compare(a.getStockQuantity(), b.getStockQuantity()))
            .collect(Collectors.toList());
    }

    @Override
    public List<Book> getLowStockBooks() {
        return bookDao.findAll().stream()
            .filter(b -> b.getStockQuantity() <= LOW_STOCK_THRESHOLD)
            .collect(Collectors.toList());
    }

    @Override
    public int getTotalStockCount() {
        return bookDao.findAll().stream().mapToInt(Book::getStockQuantity).sum();
    }

    // =========================================================================
    // Update – Adjust Stock
    // =========================================================================

    @Override
    public boolean adjustStock(String bookId, int delta, String adminId) {
        if (bookId == null || delta == 0) return false;
        Optional<Book> opt = bookDao.findById(bookId);
        if (opt.isEmpty()) return false;

        Book book = opt.get();
        int newStock = book.getStockQuantity() + delta;
        if (newStock < 0) {
            throw new IllegalArgumentException(
                "Stock cannot go below 0 (current=" + book.getStockQuantity() + ", delta=" + delta + ").");
        }
        return bookDao.updateStock(bookId, delta);
    }

    // =========================================================================
    // Delete
    // =========================================================================

    @Override
    public boolean deleteReport(String reportId) {
        return inventoryDao.deleteReportById(reportId);
    }
}
