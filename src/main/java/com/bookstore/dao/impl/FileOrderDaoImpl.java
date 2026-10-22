package com.bookstore.dao.impl;

import com.bookstore.dao.OrderDao;
import com.bookstore.model.order.Order;
import com.bookstore.model.order.OrderStatus;
import com.bookstore.model.order.payment.PaymentStatus;
import com.bookstore.util.FileStorageHelper;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.stream.Collectors;

/**
 * File Handling implementation of OrderDao persisting orders into orders.txt.
 * Satisfies SE1020 File Handling requirement.
 * 
 * @author IT25101062
 */
@Repository
public class FileOrderDaoImpl implements OrderDao {

    private static final String FILENAME = "orders.txt";
    private static final String HEADER = "orderId|userId|totalAmount|paymentMethod|paymentStatus|orderStatus|orderDate|shippingAddress|itemSummary";

    @Override
    public synchronized boolean save(Order order) {
        if (order == null || order.getOrderId() == null) {
            return false;
        }
        return FileStorageHelper.appendLine(FILENAME, order.toFileRecord());
    }

    @Override
    public Optional<Order> findById(String orderId) {
        if (orderId == null) return Optional.empty();
        return findAll().stream()
                .filter(o -> o.getOrderId().equalsIgnoreCase(orderId.trim()))
                .findFirst();
    }

    @Override
    public List<Order> findByUserId(String userId) {
        if (userId == null) return Collections.emptyList();
        return findAll().stream()
                .filter(o -> o.getUserId().equalsIgnoreCase(userId.trim()))
                .collect(Collectors.toList());
    }

    @Override
    public List<Order> findAll() {
        List<String> lines = FileStorageHelper.readAllLines(FILENAME);
        List<Order> orders = new ArrayList<>();

        for (String line : lines) {
            if (line.toLowerCase().startsWith("orderid|")) {
                continue; // Skip header line
            }
            Order order = parseOrder(line);
            if (order != null) {
                orders.add(order);
            }
        }
        return orders;
    }

    @Override
    public synchronized boolean update(Order updatedOrder) {
        if (updatedOrder == null || updatedOrder.getOrderId() == null) {
            return false;
        }

        List<Order> allOrders = findAll();
        boolean found = false;
        List<String> updatedLines = new ArrayList<>();

        for (Order o : allOrders) {
            if (o.getOrderId().equalsIgnoreCase(updatedOrder.getOrderId())) {
                updatedLines.add(updatedOrder.toFileRecord());
                found = true;
            } else {
                updatedLines.add(o.toFileRecord());
            }
        }

        if (found) {
            return FileStorageHelper.writeAllLines(FILENAME, HEADER, updatedLines);
        }
        return false;
    }

    @Override
    public synchronized boolean deleteById(String orderId) {
        if (orderId == null) return false;

        List<Order> allOrders = findAll();
        int initialSize = allOrders.size();
        List<String> retained = allOrders.stream()
                .filter(o -> !o.getOrderId().equalsIgnoreCase(orderId.trim()))
                .map(Order::toFileRecord)
                .collect(Collectors.toList());

        if (retained.size() < initialSize) {
            return FileStorageHelper.writeAllLines(FILENAME, HEADER, retained);
        }
        return false;
    }

    @Override
    public synchronized String generateNextId() {
        List<Order> orders = findAll();
        int maxId = 1000;
        for (Order o : orders) {
            String idStr = o.getOrderId();
            if (idStr != null && idStr.toUpperCase().startsWith("ORD")) {
                try {
                    int num = Integer.parseInt(idStr.substring(3));
                    if (num > maxId) maxId = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return String.format("ORD%04d", maxId + 1);
    }

    private Order parseOrder(String line) {
        try {
            String[] tokens = FileStorageHelper.splitPipe(line);
            if (tokens.length < 8) return null;

            String orderId = tokens[0].trim();
            String userId = tokens[1].trim();
            double totalAmount = Double.parseDouble(tokens[2].trim());
            String paymentMethod = tokens[3].trim();
            PaymentStatus paymentStatus = PaymentStatus.fromString(tokens[4].trim());
            OrderStatus orderStatus = OrderStatus.fromString(tokens[5].trim());
            String orderDate = tokens[6].trim();
            String shippingAddress = tokens[7].trim();
            String itemSummary = tokens.length > 8 ? tokens[8].trim() : "";

            return new Order(orderId, userId, totalAmount, paymentMethod, paymentStatus, orderStatus, orderDate, shippingAddress, itemSummary);
        } catch (Exception e) {
            System.err.println("Error parsing order line: " + line + " -> " + e.getMessage());
            return null;
        }
    }
}
