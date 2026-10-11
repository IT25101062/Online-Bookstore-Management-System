package com.bookstore.dao.impl;

import com.bookstore.dao.CartDao;
import com.bookstore.model.cart.CartItem;
import com.bookstore.util.FileStorageHelper;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.stream.Collectors;

/**
 * File Handling implementation of CartDao persisting cart items into cart.txt.
 * Satisfies SE1020 File Handling requirement.
 * 
 * @author IT25101062
 */
@Repository
public class FileCartDaoImpl implements CartDao {

    private static final String FILENAME = "cart.txt";
    private static final String HEADER = "cartItemId|userId|bookId|quantity|pricePerUnit|addedDate";

    @Override
    public synchronized boolean save(CartItem item) {
        if (item == null) return false;
        return FileStorageHelper.appendLine(FILENAME, item.toFileRecord());
    }

    @Override
    public List<CartItem> findByUserId(String userId) {
        if (userId == null) return Collections.emptyList();
        return findAll().stream()
                .filter(item -> item.getUserId().equalsIgnoreCase(userId.trim()))
                .collect(Collectors.toList());
    }

    @Override
    public Optional<CartItem> findByUserAndBook(String userId, String bookId) {
        if (userId == null || bookId == null) return Optional.empty();
        return findAll().stream()
                .filter(item -> item.getUserId().equalsIgnoreCase(userId.trim()) && item.getBookId().equalsIgnoreCase(bookId.trim()))
                .findFirst();
    }

    @Override
    public List<CartItem> findAll() {
        List<String> lines = FileStorageHelper.readAllLines(FILENAME);
        List<CartItem> items = new ArrayList<>();

        for (String line : lines) {
            if (line.toLowerCase().startsWith("cartitemid|")) {
                continue; // Skip header
            }
            CartItem item = parseCartItem(line);
            if (item != null) {
                items.add(item);
            }
        }
        return items;
    }

    @Override
    public synchronized boolean update(CartItem updatedItem) {
        if (updatedItem == null || updatedItem.getCartItemId() == null) {
            return false;
        }

        List<CartItem> allItems = findAll();
        boolean found = false;
        List<String> updatedLines = new ArrayList<>();

        for (CartItem item : allItems) {
            if (item.getCartItemId().equalsIgnoreCase(updatedItem.getCartItemId())) {
                updatedLines.add(updatedItem.toFileRecord());
                found = true;
            } else {
                updatedLines.add(item.toFileRecord());
            }
        }

        if (found) {
            return FileStorageHelper.writeAllLines(FILENAME, HEADER, updatedLines);
        }
        return false;
    }

    @Override
    public synchronized boolean deleteById(String cartItemId) {
        if (cartItemId == null) return false;

        List<CartItem> allItems = findAll();
        int initialSize = allItems.size();
        List<String> retained = allItems.stream()
                .filter(item -> !item.getCartItemId().equalsIgnoreCase(cartItemId.trim()))
                .map(CartItem::toFileRecord)
                .collect(Collectors.toList());

        if (retained.size() < initialSize) {
            return FileStorageHelper.writeAllLines(FILENAME, HEADER, retained);
        }
        return false;
    }

    @Override
    public synchronized boolean deleteByUserAndBook(String userId, String bookId) {
        if (userId == null || bookId == null) return false;

        List<CartItem> allItems = findAll();
        int initialSize = allItems.size();
        List<String> retained = allItems.stream()
                .filter(item -> !(item.getUserId().equalsIgnoreCase(userId.trim()) && item.getBookId().equalsIgnoreCase(bookId.trim())))
                .map(CartItem::toFileRecord)
                .collect(Collectors.toList());

        if (retained.size() < initialSize) {
            return FileStorageHelper.writeAllLines(FILENAME, HEADER, retained);
        }
        return false;
    }

    @Override
    public synchronized boolean clearCartByUserId(String userId) {
        if (userId == null) return false;

        List<CartItem> allItems = findAll();
        List<String> retained = allItems.stream()
                .filter(item -> !item.getUserId().equalsIgnoreCase(userId.trim()))
                .map(CartItem::toFileRecord)
                .collect(Collectors.toList());

        return FileStorageHelper.writeAllLines(FILENAME, HEADER, retained);
    }

    @Override
    public synchronized String generateNextId() {
        List<CartItem> items = findAll();
        int maxId = 0;
        for (CartItem item : items) {
            String idStr = item.getCartItemId();
            if (idStr != null && idStr.toUpperCase().startsWith("CI")) {
                try {
                    int num = Integer.parseInt(idStr.substring(2));
                    if (num > maxId) maxId = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return String.format("CI%03d", maxId + 1);
    }

    private CartItem parseCartItem(String line) {
        try {
            String[] tokens = FileStorageHelper.splitPipe(line);
            if (tokens.length < 5) return null;

            String cartItemId = tokens[0].trim();
            String userId = tokens[1].trim();
            String bookId = tokens[2].trim();
            int quantity = Integer.parseInt(tokens[3].trim());
            double pricePerUnit = Double.parseDouble(tokens[4].trim());
            String addedDate = tokens.length > 5 ? tokens[5].trim() : "";

            return new CartItem(cartItemId, userId, bookId, quantity, pricePerUnit, addedDate);
        } catch (Exception e) {
            System.err.println("Error parsing cart line: " + line + " -> " + e.getMessage());
            return null;
        }
    }
}
