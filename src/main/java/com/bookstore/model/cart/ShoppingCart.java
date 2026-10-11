package com.bookstore.model.cart;

import com.bookstore.model.cart.discount.DiscountStrategy;
import com.bookstore.model.cart.discount.MembershipDiscountStrategy;
import com.bookstore.model.user.User;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Encapsulated ShoppingCart class holding items and executing pricing calculations.
 * Demonstrates:
 * 1. Encapsulation: private items list, accessors, total recalculation.
 * 2. Polymorphism: uses polymorphic DiscountStrategy to dynamically compute discounts.
 * 
 * @author IT25101062
 */
public class ShoppingCart implements Serializable {

    private static final long serialVersionUID = 1L;

    private String userId;
    private List<CartItem> items = new ArrayList<>();
    private DiscountStrategy discountStrategy = new MembershipDiscountStrategy();

    public ShoppingCart() {}

    public ShoppingCart(String userId) {
        this.userId = userId;
    }

    public void addItem(CartItem item) {
        if (item != null) {
            // Check if item for same book exists
            for (CartItem existing : items) {
                if (existing.getBookId().equalsIgnoreCase(item.getBookId())) {
                    existing.setQuantity(existing.getQuantity() + item.getQuantity());
                    return;
                }
            }
            items.add(item);
        }
    }

    public void removeItem(String bookId) {
        items.removeIf(item -> item.getBookId().equalsIgnoreCase(bookId));
    }

    public void updateQuantity(String bookId, int quantity) {
        for (CartItem item : items) {
            if (item.getBookId().equalsIgnoreCase(bookId)) {
                item.setQuantity(quantity);
                return;
            }
        }
    }

    public int getTotalQuantity() {
        return items.stream().mapToInt(CartItem::getQuantity).sum();
    }

    public double getSubtotal() {
        double subtotal = items.stream().mapToDouble(CartItem::getItemSubtotal).sum();
        return Math.round(subtotal * 100.0) / 100.0;
    }

    /**
     * Polymorphic discount calculation using the active DiscountStrategy.
     */
    public double getDiscountAmount(User user) {
        if (discountStrategy == null) {
            return 0.0;
        }
        return discountStrategy.calculateDiscount(getSubtotal(), getTotalQuantity(), user);
    }

    public double getGrandTotal(User user) {
        double total = getSubtotal() - getDiscountAmount(user);
        return Math.max(0.0, Math.round(total * 100.0) / 100.0);
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = items != null ? items : new ArrayList<>();
    }

    public DiscountStrategy getDiscountStrategy() {
        return discountStrategy;
    }

    public void setDiscountStrategy(DiscountStrategy discountStrategy) {
        this.discountStrategy = discountStrategy;
    }
}
