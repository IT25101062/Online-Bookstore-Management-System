package com.bookstore.dao;

import com.bookstore.model.order.Order;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object interface for Order persistence in orders.txt.
 * 
 * @author IT25101062
 */
public interface OrderDao {

    /**
     * Create: Save new order record to orders.txt
     */
    boolean save(Order order);

    /**
     * Read: Find order by ID
     */
    Optional<Order> findById(String orderId);

    /**
     * Read: Retrieve all orders for a specific customer
     */
    List<Order> findByUserId(String userId);

    /**
     * Read: Retrieve all orders across bookstore (admin view)
     */
    List<Order> findAll();

    /**
     * Update: Update order details or status in orders.txt
     */
    boolean update(Order order);

    /**
     * Delete: Delete or cancel order record
     */
    boolean deleteById(String orderId);

    /**
     * Generate next incremental order ID (e.g. ORD1005)
     */
    String generateNextId();
}
