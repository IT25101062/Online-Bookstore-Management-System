package com.bookstore.model.order;

import com.bookstore.model.order.payment.PaymentStatus;
import com.bookstore.util.FileStorageHelper;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * Encapsulated Order model stored in orders.txt.
 * Demonstrates Encapsulation with status progression validation and string serialization.
 * 
 * @author IT25101062
 */
public class Order implements Serializable {

    private static final long serialVersionUID = 1L;

    private String orderId;
    private String userId;
    private double totalAmount;
    private String paymentMethod; // CARD, CASH
    private PaymentStatus paymentStatus;
    private OrderStatus orderStatus;
    private String orderDate;
    private String shippingAddress;
    private String itemSummary;

    public Order() {
        this.orderDate = LocalDate.now().toString();
        this.orderStatus = OrderStatus.PENDING;
        this.paymentStatus = PaymentStatus.PENDING;
    }

    public Order(String orderId, String userId, double totalAmount, String paymentMethod, PaymentStatus paymentStatus, OrderStatus orderStatus, String orderDate, String shippingAddress, String itemSummary) {
        this.orderId = orderId;
        this.userId = userId;
        setTotalAmount(totalAmount);
        this.paymentMethod = paymentMethod != null ? paymentMethod : "CARD";
        this.paymentStatus = paymentStatus != null ? paymentStatus : PaymentStatus.PENDING;
        this.orderStatus = orderStatus != null ? orderStatus : OrderStatus.PENDING;
        this.orderDate = (orderDate != null && !orderDate.isEmpty()) ? orderDate : LocalDate.now().toString();
        this.shippingAddress = shippingAddress != null ? shippingAddress : "";
        this.itemSummary = itemSummary != null ? itemSummary : "";
    }

    public boolean canBeCancelled() {
        return this.orderStatus == OrderStatus.PENDING || this.orderStatus == OrderStatus.PROCESSING;
    }

    // =========================================================================
    // Encapsulation: Getters and Setters
    // =========================================================================

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        if (totalAmount < 0) {
            throw new IllegalArgumentException("Total amount cannot be negative.");
        }
        this.totalAmount = Math.round(totalAmount * 100.0) / 100.0;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public PaymentStatus getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public OrderStatus getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(OrderStatus orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(String orderDate) {
        this.orderDate = orderDate;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getItemSummary() {
        return itemSummary;
    }

    public void setItemSummary(String itemSummary) {
        this.itemSummary = itemSummary;
    }

    public String toFileRecord() {
        return FileStorageHelper.joinPipe(
            orderId,
            userId,
            String.format(java.util.Locale.US, "%.2f", totalAmount),
            paymentMethod,
            paymentStatus != null ? paymentStatus.name() : PaymentStatus.PENDING.name(),
            orderStatus != null ? orderStatus.name() : OrderStatus.PENDING.name(),
            orderDate,
            shippingAddress,
            itemSummary
        );
    }
}
