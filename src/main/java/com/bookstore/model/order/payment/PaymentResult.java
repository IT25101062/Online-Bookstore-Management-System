package com.bookstore.model.order.payment;

import java.io.Serializable;

public class PaymentResult implements Serializable {

    private static final long serialVersionUID = 1L;

    private final boolean success;
    private final String transactionId;
    private final String message;
    private final PaymentStatus status;

    public PaymentResult(boolean success, String transactionId, String message, PaymentStatus status) {
        this.success = success;
        this.transactionId = transactionId;
        this.message = message;
        this.status = status;
    }

    public boolean isSuccess() {
        return success;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public String getMessage() {
        return message;
    }

    public PaymentStatus getStatus() {
        return status;
    }
}
