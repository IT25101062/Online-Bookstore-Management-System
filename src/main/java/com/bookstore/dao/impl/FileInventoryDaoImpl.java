package com.bookstore.dao.impl;

import com.bookstore.dao.InventoryDao;
import com.bookstore.model.inventory.InventoryReport;
import com.bookstore.util.FileStorageHelper;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.stream.Collectors;

/**
 * FileInventoryDaoImpl – file-based Inventory DAO.
 * Reads/writes reports.txt using FileStorageHelper.
 *
 * reports.txt format:
 *   reportId|reportType|generatedBy|generatedDate|totalBooks|totalStock|lowStockCount|content
 *
 * @author IT25101062
 */
@Repository
public class FileInventoryDaoImpl implements InventoryDao {

    private static final String FILENAME = "reports.txt";
    private static final String HEADER   =
        "reportId|reportType|generatedBy|generatedDate|totalBooks|totalStock|lowStockCount|content";

    @Override
    public synchronized boolean saveReport(InventoryReport report) {
        if (report == null || report.getReportId() == null) return false;
        return FileStorageHelper.appendLine(FILENAME, report.toFileRecord());
    }

    @Override
    public Optional<InventoryReport> findReportById(String reportId) {
        if (reportId == null) return Optional.empty();
        return findAllReports().stream()
               .filter(r -> r.getReportId().equalsIgnoreCase(reportId.trim()))
               .findFirst();
    }

    @Override
    public List<InventoryReport> findAllReports() {
        List<String>          lines   = FileStorageHelper.readAllLines(FILENAME);
        List<InventoryReport> reports = new ArrayList<>();
        for (String line : lines) {
            if (line.toLowerCase().startsWith("reportid|")) continue;
            InventoryReport r = parseReport(line);
            if (r != null) reports.add(r);
        }
        // Newest first
        Collections.reverse(reports);
        return reports;
    }

    @Override
    public synchronized boolean deleteReportById(String reportId) {
        if (reportId == null) return false;
        List<InventoryReport> all    = findAllReports();
        int                   before = all.size();
        List<String>          kept   = all.stream()
            .filter(r -> !r.getReportId().equalsIgnoreCase(reportId.trim()))
            .map(InventoryReport::toFileRecord)
            .collect(Collectors.toList());
        if (kept.size() < before) {
            return FileStorageHelper.writeAllLines(FILENAME, HEADER, kept);
        }
        return false;
    }

    @Override
    public synchronized String generateNextReportId() {
        List<InventoryReport> all = findAllReports();
        int max = 0;
        for (InventoryReport r : all) {
            String id = r.getReportId();
            if (id != null && id.toUpperCase().startsWith("RPT")) {
                try {
                    int num = Integer.parseInt(id.substring(3));
                    if (num > max) max = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return String.format("RPT%04d", max + 1);
    }

    private InventoryReport parseReport(String line) {
        try {
            String[] t = FileStorageHelper.splitPipe(line);
            if (t.length < 7) return null;
            return new InventoryReport(
                t[0].trim(), t[1].trim(), t[2].trim(), t[3].trim(),
                Integer.parseInt(t[4].trim()),
                Integer.parseInt(t[5].trim()),
                Integer.parseInt(t[6].trim()),
                t.length > 7 ? t[7].trim() : ""
            );
        } catch (Exception e) {
            System.err.println("Error parsing report line: " + line + " -> " + e.getMessage());
            return null;
        }
    }
}
