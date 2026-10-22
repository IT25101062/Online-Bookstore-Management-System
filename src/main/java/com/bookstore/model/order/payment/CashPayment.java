package com.bookstore.model.order.payment;

/**
 * CashPayment subclass extending Payment.
 * Demonstrates Inheritance and Polymorphic cash-on-delivery handling.
 * 
 * @author IT25101062
 */
public class CashPayment extends Payment {

    private static final long serialVersionUID = 1L;

    private String deliveryNotes = "Standard Delivery";
    private String changeRequired = "Exact Amount";

    public CashPayment() {
        super();
    }

    public CashPayment(String paymentId, double amount, String deliveryNotes, String changeRequired) {
        super(paymentId, amount);
        this.deliveryNotes = deliveryNotes != null ? deliveryNotes : "";
        this.changeRequired = changeRequired != null ? changeRequired : "Exact Amount";
    }

    @Override
    public PaymentResult processPayment(double amount) {
        setAmount(amount);
        // Cash on delivery marks order verified with payment due upon courier arrival
        setStatus(PaymentStatus.PAID);
        String code = "COD-" + (int)(Math.random() * 90000 + 10000);
        return new PaymentResult(true, code, "Cash on Delivery registered with courier reference: " + code, PaymentStatus.PAID);
    }

    @Override
    public String getPaymentDetailsSummary() {
        return "Cash on Delivery (Notes: " + deliveryNotes + ", " + changeRequired + ")";
    }

    @Override
    public String getPaymentMethodCode() {
        return "CASH";
    }

    public String getDeliveryNotes() {
        return deliveryNotes;
    }

    public void setDeliveryNotes(String deliveryNotes) {
        this.deliveryNotes = deliveryNotes;
    }

    public String getChangeRequired() {
        return changeRequired;
    }

    public void setChangeRequired(String changeRequired) {
        this.changeRequired = changeRequired;
    }
}
