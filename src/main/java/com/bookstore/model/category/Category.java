package com.bookstore.model.category;

import java.io.Serializable;

/**
 * Model class representing a Book Category in the bookstore.
 * 
 * Persisted in categories.txt
 * Format: categoryId|categoryName|description|displayOrder|iconName|isActive
 * 
 * @author IT25101062
 */
public class Category implements Serializable {
    private static final long serialVersionUID = 1L;

    private String categoryId;
    private String categoryName;
    private String description;
    private int displayOrder;
    private String iconName;
    private boolean active;

    public Category() {
        this.active = true;
        this.iconName = "bi-journal-bookmark";
    }

    public Category(String categoryId, String categoryName, String description, int displayOrder, String iconName, boolean active) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.description = description;
        this.displayOrder = displayOrder;
        this.iconName = (iconName != null && !iconName.trim().isEmpty()) ? iconName.trim() : "bi-journal-bookmark";
        this.active = active;
    }

    public String getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(String categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    public String getIconName() {
        return iconName;
    }

    public void setIconName(String iconName) {
        this.iconName = iconName;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String toFileRecord() {
        return String.join("|",
            categoryId != null ? categoryId : "",
            categoryName != null ? categoryName.trim() : "",
            description != null ? description.trim() : "",
            String.valueOf(displayOrder),
            iconName != null ? iconName.trim() : "bi-journal-bookmark",
            String.valueOf(active)
        );
    }

    @Override
    public String toString() {
        return categoryName;
    }
}
