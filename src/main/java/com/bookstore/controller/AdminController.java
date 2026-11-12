package com.bookstore.controller;

import com.bookstore.model.admin.Admin;
import com.bookstore.model.admin.ActivityLog;
import com.bookstore.model.book.Book;
import com.bookstore.model.order.Order;
import com.bookstore.model.user.User;
import com.bookstore.service.AdminService;
import com.bookstore.service.BookService;
import com.bookstore.service.InventoryService;
import com.bookstore.service.OrderService;
import com.bookstore.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;

/**
 * AdminController - handles Admin Management CRUD, Login & Live Operations Dashboard.
 *
 * @author IT25101062
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    private final AdminService adminService;
    private final UserService userService;
    private final BookService bookService;
    private final OrderService orderService;
    private final InventoryService inventoryService;

    @Autowired
    public AdminController(AdminService adminService,
                           UserService userService,
                           BookService bookService,
                           OrderService orderService,
                           InventoryService inventoryService) {
        this.adminService = adminService;
        this.userService = userService;
        this.bookService = bookService;
        this.orderService = orderService;
        this.inventoryService = inventoryService;
    }

    // =========================================================================
    // Helper - enforce that request comes from an authenticated admin
    // =========================================================================

    private User requireAdmin(HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            if (ra != null) ra.addFlashAttribute("errorMessage", "Administrator authentication required. Please log in.");
            return null;
        }
        if (!user.hasAdminPrivileges()) {
            if (ra != null) ra.addFlashAttribute("errorMessage", "Access denied: Administrative privileges required.");
            return null;
        }
        return user;
    }

    // =========================================================================
    // Dedicated Admin Portal Login
    // =========================================================================

    @GetMapping("/login")
    public String showAdminLoginForm(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user != null && user.hasAdminPrivileges()) {
            return "redirect:/admin/dashboard";
        }
        model.addAttribute("pageTitle", "Admin Sign In - Chapter One");
        return "admin/admin-login";
    }

    @PostMapping("/login")
    public String processAdminLogin(@RequestParam("username") String username,
                                    @RequestParam("password") String password,
                                    HttpSession session,
                                    RedirectAttributes redirectAttributes) {
        // 1. Authenticate against AdminService (admins.txt: superadmin, moderator, etc.)
        Optional<Admin> authenticatedAdmin = adminService.authenticate(username, password);
        if (authenticatedAdmin.isPresent()) {
            Admin admin = authenticatedAdmin.get();
            session.setAttribute("currentUser", admin);
            redirectAttributes.addFlashAttribute("successMessage",
                "Welcome back, " + admin.getFullName() + "! Logged in as " + admin.getAdminType());
            return "redirect:/admin/dashboard";
        }

        // 2. Fallback to UserService (users.txt: staff admin accounts)
        Optional<User> authenticatedUser = userService.authenticate(username, password);
        if (authenticatedUser.isPresent()) {
            User user = authenticatedUser.get();
            if (user.hasAdminPrivileges()) {
                session.setAttribute("currentUser", user);
                redirectAttributes.addFlashAttribute("successMessage",
                    "Welcome back, " + user.getFullName() + "!");
                return "redirect:/admin/dashboard";
            }
        }

        redirectAttributes.addFlashAttribute("errorMessage",
            "Invalid credentials or administrative privileges required.");
        return "redirect:/admin/login";
    }

    // =========================================================================
    // Admin Executive Operations Dashboard
    // =========================================================================

    @GetMapping({"", "/", "/dashboard"})
    public String dashboard(HttpSession session, Model model, RedirectAttributes ra) {
        User user = requireAdmin(session, ra);
        if (user == null) return "redirect:/login";

        List<Admin> admins = adminService.getAllAdmins();
        List<ActivityLog> logs = adminService.getActivityLog();
        List<Book> allBooks = bookService.getAllBooks();
        List<User> allUsers = userService.getAllUsers();
        List<Order> allOrders = orderService.getAllOrders();
        List<Book> lowStockBooks = inventoryService.getLowStockBooks();

        double totalRevenue = allOrders.stream()
            .filter(o -> !"CANCELLED".equalsIgnoreCase(o.getOrderStatus().name()))
            .mapToDouble(Order::getTotalAmount)
            .sum();

        model.addAttribute("admins", admins);
        model.addAttribute("recentLogs", logs.stream().limit(8).toList());
        model.addAttribute("totalBooks", allBooks.size());
        model.addAttribute("totalUsers", allUsers.size());
        model.addAttribute("totalOrders", allOrders.size());
        model.addAttribute("lowStockCount", lowStockBooks.size());
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("recentOrders", allOrders.stream().limit(5).toList());
        model.addAttribute("pageTitle", "Admin Operations Dashboard - Chapter One");
        model.addAttribute("currentUser", user);
        return "admin/dashboard";
    }

    // =========================================================================
    // Create - Register Admin
    // =========================================================================

    @GetMapping("/register")
    public String showRegisterForm(HttpSession session, Model model, RedirectAttributes ra) {
        User user = requireAdmin(session, ra);
        if (user == null) return "redirect:/login";

        model.addAttribute("pageTitle", "Register Admin - Chapter One");
        model.addAttribute("availablePermissions", List.of(
            "MANAGE_BOOKS", "MANAGE_ORDERS", "MANAGE_USERS",
            "VIEW_REPORTS", "MANAGE_INVENTORY", "MANAGE_ADMINS"
        ));
        return "admin/admin-register";
    }

    @PostMapping("/register")
    public String processRegister(@RequestParam("username") String username,
                                  @RequestParam("password") String password,
                                  @RequestParam("email") String email,
                                  @RequestParam("adminType") String adminType,
                                  @RequestParam(value = "permissions", required = false) List<String> permissions,
                                  HttpSession session, RedirectAttributes ra) {

        User caller = requireAdmin(session, ra);
        if (caller == null) return "redirect:/login";

        try {
            Set<String> perms = permissions != null ? new HashSet<>(permissions) : new HashSet<>();
            Admin newAdmin = adminService.registerAdmin(
                caller.getUserId(), username, password, email, adminType, perms);
            ra.addFlashAttribute("successMessage",
                "Admin '" + newAdmin.getUsername() + "' (" + newAdmin.getAdminType() + ") registered successfully.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Registration failed: " + e.getMessage());
        }
        return "redirect:/admin/list";
    }

    // =========================================================================
    // Read - List & Search Admins
    // =========================================================================

    @GetMapping("/list")
    public String listAdmins(@RequestParam(value = "keyword", required = false) String keyword,
                             HttpSession session, Model model, RedirectAttributes ra) {
        User user = requireAdmin(session, ra);
        if (user == null) return "redirect:/login";

        List<Admin> admins = (keyword != null && !keyword.trim().isEmpty())
            ? adminService.searchAdmins(keyword)
            : adminService.getAllAdmins();

        model.addAttribute("admins", admins);
        model.addAttribute("keyword", keyword);
        model.addAttribute("pageTitle", "Admin List - Chapter One");
        return "admin/admin-list";
    }

    // =========================================================================
    // Read - Activity Log
    // =========================================================================

    @GetMapping("/logs")
    public String activityLog(@RequestParam(value = "adminId", required = false) String adminId,
                              HttpSession session, Model model, RedirectAttributes ra) {
        User user = requireAdmin(session, ra);
        if (user == null) return "redirect:/login";

        List<ActivityLog> logs = (adminId != null && !adminId.trim().isEmpty())
            ? adminService.getActivityLogByAdmin(adminId)
            : adminService.getActivityLog();

        List<Admin> allAdmins = adminService.getAllAdmins();
        model.addAttribute("logs", logs);
        model.addAttribute("allAdmins", allAdmins);
        model.addAttribute("filterAdmin", adminId);
        model.addAttribute("pageTitle", "Activity Log - Chapter One");
        return "admin/activity-log";
    }

    // =========================================================================
    // Update - Edit Admin
    // =========================================================================

    @GetMapping("/edit/{adminId}")
    public String showEditForm(@PathVariable("adminId") String adminId,
                               HttpSession session, Model model, RedirectAttributes ra) {
        User user = requireAdmin(session, ra);
        if (user == null) return "redirect:/login";

        adminService.getAdminById(adminId).ifPresentOrElse(
            admin -> {
                model.addAttribute("admin", admin);
                model.addAttribute("pageTitle", "Edit Admin - Chapter One");
                model.addAttribute("availablePermissions", List.of(
                    "MANAGE_BOOKS", "MANAGE_ORDERS", "MANAGE_USERS",
                    "VIEW_REPORTS", "MANAGE_INVENTORY", "MANAGE_ADMINS"
                ));
            },
            () -> ra.addFlashAttribute("errorMessage", "Admin not found: " + adminId)
        );
        return "admin/admin-edit";
    }

    @PostMapping("/edit")
    public String processEdit(@RequestParam("adminId") String adminId,
                              @RequestParam("email") String email,
                              @RequestParam(value = "password", required = false) String password,
                              @RequestParam(value = "permissions", required = false) List<String> permissions,
                              HttpSession session, RedirectAttributes ra) {
        User caller = requireAdmin(session, ra);
        if (caller == null) return "redirect:/login";

        try {
            Set<String> perms = permissions != null ? new HashSet<>(permissions) : new HashSet<>();
            boolean ok = adminService.updateAdmin(
                caller.getUserId(), adminId, email, password, perms);
            if (ok) {
                ra.addFlashAttribute("successMessage", "Admin " + adminId + " updated successfully.");
            } else {
                ra.addFlashAttribute("errorMessage", "Update failed. Admin not found.");
            }
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error: " + e.getMessage());
        }
        return "redirect:/admin/list";
    }

    // =========================================================================
    // Delete - Remove Admin Account
    // =========================================================================

    @PostMapping("/delete")
    public String deleteAdmin(@RequestParam("adminId") String adminId,
                              HttpSession session, RedirectAttributes ra) {
        User caller = requireAdmin(session, ra);
        if (caller == null) return "redirect:/login";

        try {
            boolean ok = adminService.deleteAdmin(caller.getUserId(), adminId);
            if (ok) {
                ra.addFlashAttribute("successMessage", "Admin " + adminId + " removed successfully.");
            } else {
                ra.addFlashAttribute("errorMessage", "Could not delete admin " + adminId + ".");
            }
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error: " + e.getMessage());
        }
        return "redirect:/admin/list";
    }
}
