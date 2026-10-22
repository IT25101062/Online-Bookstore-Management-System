package com.bookstore.controller;

import com.bookstore.model.book.Book;
import com.bookstore.model.inventory.InventoryReport;
import com.bookstore.model.user.User;
import com.bookstore.service.InventoryService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

/**
 * InventoryController - handles Inventory & Reports CRUD.
 *
 * @author IT25101062
 */
@Controller
@RequestMapping("/inventory")
public class InventoryController {

    private final InventoryService inventoryService;

    @Autowired
    public InventoryController(InventoryService inventoryService) {
        this.inventoryService = inventoryService;
    }

    // Helper
    private User requireAdmin(HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            if (ra != null) ra.addFlashAttribute("errorMessage", "Please log in.");
            return null;
        }
        if (!user.hasAdminPrivileges()) {
            if (ra != null) ra.addFlashAttribute("errorMessage", "Access denied.");
            return null;
        }
        return user;
    }

    // =========================================================================
    // Read - Stock Levels (main inventory page)
    // =========================================================================

    @GetMapping({"", "/"})
    public String stockLevels(HttpSession session, Model model, RedirectAttributes ra) {
        User user = requireAdmin(session, ra);
        if (user == null) return "redirect:/login";

        List<Book> books         = inventoryService.getStockLevels();
        List<Book> lowStockBooks = inventoryService.getLowStockBooks();
        int        totalStock    = inventoryService.getTotalStockCount();

        model.addAttribute("books",         books);
        model.addAttribute("lowStockBooks", lowStockBooks);
        model.addAttribute("totalStock",    totalStock);
        model.addAttribute("pageTitle",     "Inventory - Chapter One");
        return "inventory/stock-levels";
    }

    // =========================================================================
    // Read - Low-Stock Alert
    // =========================================================================

    @GetMapping("/low-stock")
    public String lowStockAlert(HttpSession session, Model model, RedirectAttributes ra) {
        User user = requireAdmin(session, ra);
        if (user == null) return "redirect:/login";

        List<Book> lowStockBooks = inventoryService.getLowStockBooks();
        model.addAttribute("books",      lowStockBooks);
        model.addAttribute("pageTitle",  "Low-Stock Alert - Chapter One");
        return "inventory/low-stock";
    }

    // =========================================================================
    // Read - Reports List
    // =========================================================================

    @GetMapping("/reports")
    public String listReports(HttpSession session, Model model, RedirectAttributes ra) {
        User user = requireAdmin(session, ra);
        if (user == null) return "redirect:/login";

        List<InventoryReport> reports = inventoryService.getAllReports();
        model.addAttribute("reports",   reports);
        model.addAttribute("pageTitle", "Inventory Reports - Chapter One");
        return "inventory/reports";
    }

    // =========================================================================
    // Create - Generate Report
    // =========================================================================

    @PostMapping("/reports/generate")
    public String generateReport(@RequestParam("reportType") String reportType,
                                 HttpSession session, RedirectAttributes ra) {
        User user = requireAdmin(session, ra);
        if (user == null) return "redirect:/login";

        try {
            InventoryReport report = inventoryService.generateReport(user.getUserId(), reportType);
            ra.addFlashAttribute("successMessage",
                "Report " + report.getReportId() + " (" + report.getReportType() + ") generated successfully.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Failed to generate report: " + e.getMessage());
        }
        return "redirect:/inventory/reports";
    }

    // =========================================================================
    // Update - Adjust Stock
    // =========================================================================

    @PostMapping("/adjust-stock")
    public String adjustStock(@RequestParam("bookId") String bookId,
                              @RequestParam("delta")  int    delta,
                              HttpSession session, RedirectAttributes ra) {
        User user = requireAdmin(session, ra);
        if (user == null) return "redirect:/login";

        try {
            boolean ok = inventoryService.adjustStock(bookId, delta, user.getUserId());
            if (ok) {
                String action = delta > 0 ? "+" + delta : String.valueOf(delta);
                ra.addFlashAttribute("successMessage",
                    "Stock for book " + bookId + " adjusted by " + action + " units.");
            } else {
                ra.addFlashAttribute("errorMessage", "Could not adjust stock for book " + bookId + ".");
            }
        } catch (IllegalArgumentException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/inventory";
    }

    // =========================================================================
    // Delete - Remove Report
    // =========================================================================

    @PostMapping("/reports/delete")
    public String deleteReport(@RequestParam("reportId") String reportId,
                               HttpSession session, RedirectAttributes ra) {
        User user = requireAdmin(session, ra);
        if (user == null) return "redirect:/login";

        boolean ok = inventoryService.deleteReport(reportId);
        if (ok) {
            ra.addFlashAttribute("successMessage", "Report " + reportId + " deleted.");
        } else {
            ra.addFlashAttribute("errorMessage", "Could not delete report " + reportId + ".");
        }
        return "redirect:/inventory/reports";
    }
}
