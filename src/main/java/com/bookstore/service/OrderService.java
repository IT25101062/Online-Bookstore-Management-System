package com.bookstore.service;

import com.bookstore.model.order.Order;
import com.bookstore.model.order.OrderStatus;

import java.util.List;
import java.util.Optional;

/**
 * OrderService interface defining Order and Payment Management CRUD operations.
 * <p>
 * CRUD:
 * - Create : placeOrder (generates new order from cart data)
 * - Read   : getAllOrders, getOrdersByUser, getOrderById
 * - Update : updateStatus (admin), cancelOrder (user/admin)
 * - Delete : deleteOrder (admin removes old records)
 *
 * @author IT25101062
 */
public interface OrderService {

    /** Create – place a new order */
    Order placeOrder(String userId, String shippingAddress,
                     String paymentMethod, double totalAmount, String itemSummary);

    /** Read – all orders (admin) */
    List<Order> getAllOrders();

    /** Read – orders belonging to a specific user */
    List<Order> getOrdersByUser(String userId);

    /** Read – single order by ID */
    Optional<Order> getOrderById(String orderId);

    /** Update – change order status (admin workflow) */
    boolean updateStatus(String orderId, OrderStatus newStatus);

    /** Update – cancel a pending order */
    boolean cancelOrder(String orderId);

    /** Delete – permanently remove an order record */
    boolean deleteOrder(String orderId);
}
