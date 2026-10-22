package com.bookstore.service;

import com.bookstore.model.category.Category;

import java.util.List;
import java.util.Optional;

/**
 * Service interface managing Category operations.
 * 
 * Supports adding, fetching, and validating categories persisted in categories.txt.
 * 
 * @author IT25101062
 */
public interface CategoryService {

    /**
     * Get all active categories from categories.txt
     */
    List<Category> getAllCategories();

    /**
     * Get a list of category names (e.g. Technology, Fiction, etc.)
     */
    List<String> getAllCategoryNames();

    /**
     * Find category by name (case-insensitive)
     */
    Optional<Category> getCategoryByName(String name);

    /**
     * Check if a category name already exists (case-insensitive)
     */
    boolean existsByName(String name);

    /**
     * Add a new category and persist it to categories.txt
     * 
     * @param categoryName Name of the category (e.g., "History", "Children's")
     * @param description Short description
     * @param iconName Bootstrap icon name (e.g., "bi-bookmark")
     * @return Newly created Category object
     * @throws IllegalArgumentException if name is invalid or already exists
     */
    Category addCategory(String categoryName, String description, String iconName) throws IllegalArgumentException;
}
