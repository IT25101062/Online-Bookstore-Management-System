package com.bookstore.controller;

import com.bookstore.model.cart.ShoppingCart;
import com.bookstore.model.order.Order;
import com.bookstore.model.order.OrderStatus;
import com.bookstore.model.user.User;
import com.bookstore.service.CartService;
import com.bookstore.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

/**
 * OrderController - handles Order & Payment Management CRUD.
 *
 * @author IT25101062
 */
@Controller
@RequestMapping("/orders")
public class OrderController {

    private final OrderService orderService;
    private final CartService  cartService;

    @Autowired
    public OrderController(OrderService orderService, CartService cartService) {
        this.orderService = orderService;
        this.cartService  = cartService;
    }

    // =========================================================================
    // Create - Place Order
    // =========================================================================

    @GetMapping({"/place", "/checkout"})
    public String showPlaceOrderForm(HttpSession session, Model model,
                                     RedirectAttributes ra) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";

        ShoppingCart cart = cartService.getCartForUser(user.getUserId(), user);
        if (cart.getItems().isEmpty()) {
            ra.addFlashAttribute("errorMessage", "Your cart is empty. Add books before checking out.");
            return "redirect:/cart";
        }

        model.addAttribute("cart", cart);
        model.addAttribute("cartItems", cart.getItems());
        model.addAttribute("cartTotal", cart.getSubtotal());
        model.addAttribute("pageTitle", "Place Order - Chapter One");
        return "order/place-order";
    }

    @PostMapping({"/place", "/checkout"})
    public String placeOrder(@RequestParam("shippingAddress") String shippingAddress,
                             @RequestParam("paymentMethod")   String paymentMethod,
                             HttpSession session,
                             RedirectAttributes ra) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";

        try {
            ShoppingCart cart = cartService.getCartForUser(user.getUserId(), user);
            if (cart.getItems().isEmpty()) {
                ra.addFlashAttribute("errorMessage", "Your cart is empty.");
                return "redirect:/cart";
            }

            double total = cart.getSubtotal();
            StringBuilder summary = new StringBuilder();
            cart.getItems().forEach(item -> {
                String title = item.getBook() != null ? item.getBook().getTitle() : item.getBookId();
                summary.append(title).append(" x").append(item.getQuantity()).append("; ");
            });

            Order order = orderService.placeOrder(
                user.getUserId(), shippingAddress, paymentMethod, total, summary.toString().trim());

            // Clear the cart after successful order
            cartService.clearCart(user.getUserId());

            ra.addFlashAttribute("successMessage",
                "Order " + order.getOrderId() + " placed successfully! Total: LKR " +
                String.format("%.2f", order.getTotalAmount()));
            return "redirect:/orders";
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Failed to place order: " + e.getMessage());
            return "redirect:/orders/place";
        }
    }

    // =========================================================================
    // Read - My Orders (customer) and All Orders (admin)
    // =========================================================================

    @GetMapping
    public String listMyOrders(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";

        List<Order> orders = orderService.getOrdersByUser(user.getUserId());
        model.addAttribute("orders", orders);
        model.addAttribute("pageTitle", "My Orders - Chapter One");
        model.addAttribute("orderStatuses", OrderStatus.values());
        return "order/order-list";
    }

    @GetMapping({"/all", "/admin"})
    public String listAllOrders(HttpSession session, Model model, RedirectAttributes ra) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null || !user.hasAdminPrivileges()) {
            ra.addFlashAttribute("errorMessage", "Access denied.");
            return "redirect:/login";
        }

        List<Order> orders = orderService.getAllOrders();
        model.addAttribute("orders", orders);
        model.addAttribute("orderStatuses", OrderStatus.values());
        model.addAttribute("pageTitle", "All Orders - Admin View");
        model.addAttribute("isAdminView", true);
        return "order/order-list";
    }

    @GetMapping("/{orderId}")
    public String viewOrder(@PathVariable("orderId") String orderId,
                            HttpSession session, Model model, RedirectAttributes ra) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";

        Optional<Order> opt = orderService.getOrderById(orderId);
        if (opt.isEmpty()) {
            ra.addFlashAttribute("errorMessage", "Order not found: " + orderId);
            return "redirect:/orders";
        }
        Order order = opt.get();

        // Customers can only view their own orders
        if (!user.hasAdminPrivileges() && !order.getUserId().equals(user.getUserId())) {
            ra.addFlashAttribute("errorMessage", "Access denied.");
            return "redirect:/orders";
        }

        model.addAttribute("order", order);
        model.addAttribute("orderStatuses", OrderStatus.values());
        model.addAttribute("pageTitle", "Order " + orderId + " - Chapter One");
        return "order/order-detail";
    }

    // =========================================================================
    // Update - Status (admin) and Cancel (user / admin)
    // =========================================================================

    @PostMapping("/update-status")
    public String updateStatus(@RequestParam("orderId")    String orderId,
                               @RequestParam("orderStatus") String status,
                               HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null || !user.hasAdminPrivileges()) {
            ra.addFlashAttribute("errorMessage", "Access denied.");
            return "redirect:/login";
        }

        try {
            OrderStatus newStatus = OrderStatus.fromString(status);
            boolean updated = orderService.updateStatus(orderId, newStatus);
            if (updated) {
                ra.addFlashAttribute("successMessage",
                    "Order " + orderId + " status updated to " + newStatus + ".");
            } else {
                ra.addFlashAttribute("errorMessage", "Failed to update order status.");
            }
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error: " + e.getMessage());
        }
        return "redirect:/orders/all";
    }

    @PostMapping("/cancel")
    public String cancelOrder(@RequestParam("orderId") String orderId,
                              HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";

        try {
            boolean cancelled = orderService.cancelOrder(orderId);
            if (cancelled) {
                ra.addFlashAttribute("successMessage", "Order " + orderId + " has been cancelled.");
            } else {
                ra.addFlashAttribute("errorMessage", "Could not cancel order " + orderId + ".");
            }
        } catch (IllegalStateException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        }
        return user.hasAdminPrivileges() ? "redirect:/orders/all" : "redirect:/orders";
    }

    // =========================================================================
    // Delete - Admin removes order record
    // =========================================================================

    @PostMapping("/delete")
    public String deleteOrder(@RequestParam("orderId") String orderId,
                              HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null || !user.hasAdminPrivileges()) {
            ra.addFlashAttribute("errorMessage", "Access denied.");
            return "redirect:/login";
        }

        boolean deleted = orderService.deleteOrder(orderId);
        if (deleted) {
            ra.addFlashAttribute("successMessage", "Order " + orderId + " deleted successfully.");
        } else {
            ra.addFlashAttribute("errorMessage", "Failed to delete order " + orderId + ".");
        }
        return "redirect:/orders/all";
    }
}
