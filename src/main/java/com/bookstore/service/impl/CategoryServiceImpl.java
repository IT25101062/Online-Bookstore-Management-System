package com.bookstore.service.impl;

import com.bookstore.model.category.Category;
import com.bookstore.service.CategoryService;
import com.bookstore.util.FileStorageHelper;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Implementation of CategoryService managing categories.txt.
 * 
 * Thread-safe file operations using FileStorageHelper.
 * 
 * @author IT25101062
 */
@Service
public class CategoryServiceImpl implements CategoryService {

    private static final String FILE_NAME = "categories.txt";
    private static final String HEADER = "categoryId|categoryName|description|displayOrder|iconName|isActive";

    @Override
    public List<Category> getAllCategories() {
        List<String> lines = FileStorageHelper.readAllLines(FILE_NAME);
        List<Category> categories = new ArrayList<>();

        for (String line : lines) {
            if (line.toLowerCase().startsWith("categoryid|")) continue;
            String[] parts = FileStorageHelper.splitPipe(line);
            if (parts.length >= 2) {
                String id = parts[0].trim();
                String name = parts[1].trim();
                String desc = parts.length > 2 ? parts[2].trim() : "";
                int order = 1;
                try {
                    if (parts.length > 3) order = Integer.parseInt(parts[3].trim());
                } catch (NumberFormatException ignored) {}
                String icon = parts.length > 4 && !parts[4].trim().isEmpty() ? parts[4].trim() : "bi-journal-bookmark";
                boolean active = parts.length <= 5 || !"false".equalsIgnoreCase(parts[5].trim());

                if (active) {
                    categories.add(new Category(id, name, desc, order, icon, active));
                }
            }
        }

        // If file was empty or missing defaults, seed common defaults
        if (categories.isEmpty()) {
            categories.add(new Category("CAT001", "Technology", "Programming, Software Engineering & Systems", 1, "bi-laptop", true));
            categories.add(new Category("CAT002", "Fiction", "Novels, Sci-Fi, Thrillers & Literature", 2, "bi-book", true));
            categories.add(new Category("CAT003", "Business", "Entrepreneurship, Management & Marketing", 3, "bi-briefcase", true));
            categories.add(new Category("CAT004", "Self-Help", "Personal Development & Productivity", 4, "bi-heart", true));
            categories.add(new Category("CAT005", "Science", "Physics, Astronomy, Biology & Mathematics", 5, "bi-lightbulb", true));
        }

        categories.sort(Comparator.comparingInt(Category::getDisplayOrder));
        return categories;
    }

    @Override
    public List<String> getAllCategoryNames() {
        return getAllCategories().stream()
                .map(Category::getCategoryName)
                .distinct()
                .collect(Collectors.toList());
    }

    @Override
    public Optional<Category> getCategoryByName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return Optional.empty();
        }
        return getAllCategories().stream()
                .filter(c -> c.getCategoryName().equalsIgnoreCase(name.trim()))
                .findFirst();
    }

    @Override
    public boolean existsByName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return false;
        }
        return getAllCategories().stream()
                .anyMatch(c -> c.getCategoryName().equalsIgnoreCase(name.trim()));
    }

    @Override
    public synchronized Category addCategory(String categoryName, String description, String iconName) throws IllegalArgumentException {
        if (categoryName == null || categoryName.trim().isEmpty()) {
            throw new IllegalArgumentException("Category name cannot be empty.");
        }
        String cleanName = categoryName.trim();
        if (cleanName.length() < 2) {
            throw new IllegalArgumentException("Category name must be at least 2 characters.");
        }
        if (cleanName.length() > 50) {
            throw new IllegalArgumentException("Category name cannot exceed 50 characters.");
        }
        if (cleanName.contains("|")) {
            throw new IllegalArgumentException("Category name cannot contain the '|' character.");
        }

        // Check if already exists
        if (existsByName(cleanName)) {
            throw new IllegalArgumentException("Category '" + cleanName + "' already exists.");
        }

        List<Category> currentCategories = getAllCategories();
        int maxIdNum = 0;
        int maxOrder = 0;
        for (Category c : currentCategories) {
            if (c.getCategoryId() != null && c.getCategoryId().toUpperCase().startsWith("CAT")) {
                try {
                    int num = Integer.parseInt(c.getCategoryId().substring(3));
                    if (num > maxIdNum) maxIdNum = num;
                } catch (NumberFormatException ignored) {}
            }
            if (c.getDisplayOrder() > maxOrder) {
                maxOrder = c.getDisplayOrder();
            }
        }

        String nextId = String.format("CAT%03d", maxIdNum + 1);
        int nextOrder = maxOrder + 1;
        String cleanDesc = (description != null && !description.trim().isEmpty())
                ? description.trim().replace("|", " ")
                : "Curated collection of " + cleanName + " books and literary editions.";
        String cleanIcon = (iconName != null && !iconName.trim().isEmpty())
                ? iconName.trim().replace("|", "")
                : "bi-journal-bookmark";

        Category newCategory = new Category(nextId, cleanName, cleanDesc, nextOrder, cleanIcon, true);

        // Append to file
        boolean saved = FileStorageHelper.appendLine(FILE_NAME, newCategory.toFileRecord());
        if (!saved) {
            // Fallback: write entire list
            List<String> records = currentCategories.stream()
                    .map(Category::toFileRecord)
                    .collect(Collectors.toList());
            records.add(newCategory.toFileRecord());
            FileStorageHelper.writeAllLines(FILE_NAME, HEADER, records);
        }

        return newCategory;
    }
}
