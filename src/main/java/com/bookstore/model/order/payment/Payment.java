package com.bookstore.model.order.payment;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Abstract Payment base class.
 * Demonstrates:
 * 1. Encapsulation: private attributes, status management, amount verification.
 * 2. Abstraction: abstract payment processing and receipt generation contract.
 * 3. Polymorphism: overridden methods in CardPayment and CashPayment.
 * 
 * @author IT25101062
 */
public abstract class Payment implements Serializable {

    private static final long serialVersionUID = 1L;

    private String paymentId;
    private double amount;
    private PaymentStatus status = PaymentStatus.PENDING;
    private String paymentTimestamp;

    public Payment() {
        this.paymentTimestamp = LocalDateTime.now().toString();
    }

    public Payment(String paymentId, double amount) {
        this.paymentId = paymentId;
        setAmount(amount);
        this.paymentTimestamp = LocalDateTime.now().toString();
    }

    // =========================================================================
    // Polymorphic Abstract Methods
    // =========================================================================

    /**
     * Polymorphic method to execute payment transaction.
     */
    public abstract PaymentResult processPayment(double amount);

    /**
     * Polymorphic method returning a human-readable summary of payment channel details.
     */
    public abstract String getPaymentDetailsSummary();

    /**
     * Polymorphic payment method code string (e.g. "CARD", "CASH").
     */
    public abstract String getPaymentMethodCode();

    // =========================================================================
    // Encapsulation: Getters and Setters with Validation
    // =========================================================================

    public String getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(String paymentId) {
        this.paymentId = paymentId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("Payment amount cannot be negative.");
        }
        this.amount = Math.round(amount * 100.0) / 100.0;
    }

    public PaymentStatus getStatus() {
        return status;
    }

    public void setStatus(PaymentStatus status) {
        this.status = status;
    }

    public String getPaymentTimestamp() {
        return paymentTimestamp;
    }

    public void setPaymentTimestamp(String paymentTimestamp) {
        this.paymentTimestamp = paymentTimestamp;
    }
}
