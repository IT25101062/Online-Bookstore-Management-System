package com.bookstore.model.order.payment;

import java.util.UUID;

/**
 * CardPayment subclass extending Payment.
 * Demonstrates Inheritance and Polymorphic payment processing for credit/debit card transactions.
 * 
 * @author IT25101062
 */
public class CardPayment extends Payment {

    private static final long serialVersionUID = 1L;

    private String cardHolderName;
    private String cardNumberMasked;
    private String cardType = "Visa";
    private String transactionId;

    public CardPayment() {
        super();
    }

    public CardPayment(String paymentId, double amount, String cardHolderName, String fullCardNumber, String cardType) {
        super(paymentId, amount);
        this.cardHolderName = cardHolderName;
        this.cardType = (cardType != null) ? cardType : "Visa";
        this.cardNumberMasked = maskCardNumber(fullCardNumber);
    }

    private String maskCardNumber(String number) {
        if (number == null || number.trim().length() < 4) {
            return "**** **** **** 0000";
        }
        String clean = number.replaceAll("\\s+", "").trim();
        int len = clean.length();
        String last4 = clean.substring(Math.max(0, len - 4));
        return "**** **** **** " + last4;
    }

    @Override
    public PaymentResult processPayment(double amount) {
        setAmount(amount);
        if (cardHolderName == null || cardHolderName.trim().isEmpty()) {
            setStatus(PaymentStatus.FAILED);
            return new PaymentResult(false, null, "Cardholder name is required.", PaymentStatus.FAILED);
        }

        // Simulate successful card gateway authorization
        this.transactionId = "TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        setStatus(PaymentStatus.PAID);

        return new PaymentResult(true, transactionId, "Card payment authorized successfully via " + cardType, PaymentStatus.PAID);
    }

    @Override
    public String getPaymentDetailsSummary() {
        return "Card Payment (" + cardType + ", " + cardNumberMasked + ") - Txn: " + (transactionId != null ? transactionId : "N/A");
    }

    @Override
    public String getPaymentMethodCode() {
        return "CARD";
    }

    public String getCardHolderName() {
        return cardHolderName;
    }

    public void setCardHolderName(String cardHolderName) {
        this.cardHolderName = cardHolderName;
    }

    public String getCardNumberMasked() {
        return cardNumberMasked;
    }

    public void setCardNumberMasked(String cardNumberMasked) {
        this.cardNumberMasked = cardNumberMasked;
    }

    public String getCardType() {
        return cardType;
    }

    public void setCardType(String cardType) {
        this.cardType = cardType;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
}
