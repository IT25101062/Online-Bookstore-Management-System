package com.bookstore.controller;

import com.bookstore.model.category.Category;
import com.bookstore.model.user.User;
import com.bookstore.service.CategoryService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;

/**
 * Controller for Book Categories management.
 * 
 * Allows administrators to add new book categories dynamically.
 * 
 * @author IT25101062
 */
@Controller
@RequestMapping("/categories")
public class CategoryController {

    private final CategoryService categoryService;

    @Autowired
    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    /**
     * AJAX/Form endpoint: Add new category (Admin only)
     */
    @PostMapping(value = "/add")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addCategoryAjax(
            @RequestParam("categoryName") String categoryName,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "iconName", required = false) String iconName,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null || !currentUser.hasAdminPrivileges()) {
            response.put("success", false);
            response.put("message", "Access denied: Administrator privileges required.");
            return ResponseEntity.status(403).body(response);
        }

        try {
            Category category = categoryService.addCategory(categoryName, description, iconName);
            response.put("success", true);
            response.put("message", "Category '" + category.getCategoryName() + "' created successfully!");
            response.put("categoryId", category.getCategoryId());
            response.put("categoryName", category.getCategoryName());
            response.put("iconName", category.getIconName());
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to create category: " + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }

    /**
     * JSON endpoint: List all categories
     */
    @GetMapping(value = "/json", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<Category> getCategoriesJson() {
        return categoryService.getAllCategories();
    }
}
