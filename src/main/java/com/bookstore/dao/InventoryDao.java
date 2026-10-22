package com.bookstore.dao;

import com.bookstore.model.inventory.InventoryReport;

import java.util.List;
import java.util.Optional;

/**
 * InventoryDao – Data Access Object interface for Inventory & Reports.
 *
 * @author IT25101062
 */
public interface InventoryDao {

    /** Save (create) a new report */
    boolean saveReport(InventoryReport report);

    /** Find report by ID */
    Optional<InventoryReport> findReportById(String reportId);

    /** List all reports */
    List<InventoryReport> findAllReports();

    /** Delete a report by ID */
    boolean deleteReportById(String reportId);

    /** Generate next report ID */
    String generateNextReportId();
}
