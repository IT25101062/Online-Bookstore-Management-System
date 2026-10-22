package com.bookstore.service.impl;

import com.bookstore.dao.OrderDao;
import com.bookstore.model.order.Order;
import com.bookstore.model.order.OrderStatus;
import com.bookstore.model.order.payment.PaymentStatus;
import com.bookstore.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * OrderServiceImpl – business logic for Order & Payment Management.
 * Demonstrates Abstraction by hiding file I/O behind OrderDao.
 *
 * @author IT25101062
 */
@Service
public class OrderServiceImpl implements OrderService {

    private final OrderDao orderDao;

    @Autowired
    public OrderServiceImpl(OrderDao orderDao) {
        this.orderDao = orderDao;
    }

    @Override
    public Order placeOrder(String userId, String shippingAddress,
                            String paymentMethod, double totalAmount, String itemSummary) {
        if (userId == null || userId.trim().isEmpty()) {
            throw new IllegalArgumentException("User ID is required to place an order.");
        }
        if (totalAmount <= 0) {
            throw new IllegalArgumentException("Order total must be greater than zero.");
        }

        String orderId = orderDao.generateNextId();
        Order order = new Order(
            orderId,
            userId.trim(),
            totalAmount,
            (paymentMethod != null && !paymentMethod.trim().isEmpty()) ? paymentMethod.trim() : "CARD",
            PaymentStatus.PAID,   // treat payment as immediate
            OrderStatus.PENDING,
            LocalDate.now().toString(),
            shippingAddress != null ? shippingAddress.trim() : "",
            itemSummary != null ? itemSummary.trim() : ""
        );

        if (!orderDao.save(order)) {
            throw new RuntimeException("Failed to persist order to data file.");
        }
        return order;
    }

    @Override
    public List<Order> getAllOrders() {
        return orderDao.findAll();
    }

    @Override
    public List<Order> getOrdersByUser(String userId) {
        if (userId == null || userId.trim().isEmpty()) {
            return List.of();
        }
        return orderDao.findByUserId(userId.trim());
    }

    @Override
    public Optional<Order> getOrderById(String orderId) {
        if (orderId == null || orderId.trim().isEmpty()) {
            return Optional.empty();
        }
        return orderDao.findById(orderId.trim());
    }

    @Override
    public boolean updateStatus(String orderId, OrderStatus newStatus) {
        if (orderId == null || newStatus == null) return false;
        Optional<Order> opt = orderDao.findById(orderId.trim());
        if (opt.isEmpty()) return false;

        Order order = opt.get();
        order.setOrderStatus(newStatus);
        return orderDao.update(order);
    }

    @Override
    public boolean cancelOrder(String orderId) {
        if (orderId == null) return false;
        Optional<Order> opt = orderDao.findById(orderId.trim());
        if (opt.isEmpty()) return false;

        Order order = opt.get();
        if (!order.canBeCancelled()) {
            throw new IllegalStateException("Order " + orderId + " cannot be cancelled in its current status: " + order.getOrderStatus());
        }
        order.setOrderStatus(OrderStatus.CANCELLED);
        order.setPaymentStatus(PaymentStatus.REFUNDED);
        return orderDao.update(order);
    }

    @Override
    public boolean deleteOrder(String orderId) {
        if (orderId == null) return false;
        return orderDao.deleteById(orderId.trim());
    }
}
