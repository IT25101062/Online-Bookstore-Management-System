package com.bookstore.service;

import com.bookstore.model.book.Book;
import com.bookstore.model.inventory.InventoryReport;

import java.util.List;
import java.util.Optional;

/**
 * InventoryService interface for Inventory & Reports module.
 *
 * CRUD:
 * - Create : generateReport (stock summary, low-stock alert, full inventory)
 * - Read   : getAllReports, getStockLevels, getLowStockBooks
 * - Update : adjustStock (add/remove stock units for a book)
 * - Delete : deleteReport
 *
 * @author IT25101062
 */
public interface InventoryService {

    /** Create – generate and persist a new inventory report */
    InventoryReport generateReport(String adminId, String reportType);

    /** Read – retrieve all saved reports */
    List<InventoryReport> getAllReports();

    /** Read – get a single report by ID */
    Optional<InventoryReport> getReportById(String reportId);

    /** Read – all books with their current stock levels */
    List<Book> getStockLevels();

    /** Read – books with stock at or below the low-stock threshold (default: 5) */
    List<Book> getLowStockBooks();

    /** Read – total stock count across all books */
    int getTotalStockCount();

    /** Update – add or subtract units from a book's stock */
    boolean adjustStock(String bookId, int delta, String adminId);

    /** Delete – remove an old report */
    boolean deleteReport(String reportId);
}
