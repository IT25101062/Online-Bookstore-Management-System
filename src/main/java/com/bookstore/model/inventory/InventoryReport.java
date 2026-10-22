package com.bookstore.model.inventory;

import com.bookstore.util.FileStorageHelper;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * InventoryReport – Encapsulated model for generated stock/inventory reports.
 * Demonstrates Encapsulation with private fields and controlled access.
 *
 * File format (reports.txt):
 *   reportId|reportType|generatedBy|generatedDate|totalBooks|totalStock|lowStockCount|content
 *
 * @author IT25101062
 */
public class InventoryReport implements Serializable {

    private static final long serialVersionUID = 1L;

    // All fields encapsulated as private
    private String reportId;
    private String reportType;      // STOCK_SUMMARY, LOW_STOCK_ALERT, FULL_INVENTORY
    private String generatedBy;     // adminId
    private String generatedDate;
    private int    totalBooks;
    private int    totalStock;
    private int    lowStockCount;
    private String content;         // Human-readable summary text

    public InventoryReport() {
        this.generatedDate = LocalDate.now().toString();
    }

    public InventoryReport(String reportId, String reportType, String generatedBy,
                           int totalBooks, int totalStock, int lowStockCount, String content) {
        this.reportId      = reportId;
        this.reportType    = reportType;
        this.generatedBy   = generatedBy;
        this.generatedDate = LocalDate.now().toString();
        this.totalBooks    = totalBooks;
        this.totalStock    = totalStock;
        this.lowStockCount = lowStockCount;
        this.content       = content != null ? content : "";
    }

    public InventoryReport(String reportId, String reportType, String generatedBy,
                           String generatedDate, int totalBooks, int totalStock,
                           int lowStockCount, String content) {
        this.reportId      = reportId;
        this.reportType    = reportType;
        this.generatedBy   = generatedBy;
        this.generatedDate = (generatedDate != null && !generatedDate.isEmpty())
                             ? generatedDate : LocalDate.now().toString();
        this.totalBooks    = totalBooks;
        this.totalStock    = totalStock;
        this.lowStockCount = lowStockCount;
        this.content       = content != null ? content : "";
    }

    // =========================================================================
    // Encapsulation – Getters and Setters
    // =========================================================================

    public String getReportId()            { return reportId; }
    public void   setReportId(String id)   { this.reportId = id; }

    public String getReportType()               { return reportType; }
    public void   setReportType(String type)    { this.reportType = type; }

    public String getGeneratedBy()              { return generatedBy; }
    public void   setGeneratedBy(String adminId){ this.generatedBy = adminId; }

    public String getGeneratedDate()            { return generatedDate; }
    public void   setGeneratedDate(String date) { this.generatedDate = date; }

    public int  getTotalBooks()             { return totalBooks; }
    public void setTotalBooks(int n)        { this.totalBooks = Math.max(0, n); }

    public int  getTotalStock()             { return totalStock; }
    public void setTotalStock(int n)        { this.totalStock = Math.max(0, n); }

    public int  getLowStockCount()          { return lowStockCount; }
    public void setLowStockCount(int n)     { this.lowStockCount = Math.max(0, n); }

    public String getContent()              { return content; }
    public void   setContent(String c)      { this.content = c != null ? c : ""; }

    /** Serialize to pipe-delimited line for reports.txt */
    public String toFileRecord() {
        return FileStorageHelper.joinPipe(
            reportId,
            reportType,
            generatedBy,
            generatedDate,
            String.valueOf(totalBooks),
            String.valueOf(totalStock),
            String.valueOf(lowStockCount),
            content.replace("|", " ")  // sanitize content so it doesn't break pipe parsing
        );
    }
}
