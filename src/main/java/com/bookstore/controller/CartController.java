package com.bookstore.controller;

import com.bookstore.model.cart.CartItem;
import com.bookstore.model.cart.ShoppingCart;
import com.bookstore.model.user.User;
import com.bookstore.service.CartService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * Controller handling Shopping Cart CRUD operations.
 * 
 * CRUD Operations:
 * 1. Create: /cart/add (Add book to cart with stock validation)
 * 2. Read  : /cart (View cart items, totals, and discounts)
 * 3. Update: /cart/update (Modify quantity)
 * 4. Delete: /cart/remove (Remove item), /cart/clear (Empty cart)
 * 
 * @author IT25101062
 */
@Controller
public class CartController {

    private final CartService cartService;

    @Autowired
    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    private String resolveUserId(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            return currentUser.getUserId();
        }
        // Guest session fallback
        String guestId = (String) session.getAttribute("guestCartId");
        if (guestId == null) {
            guestId = "GUEST_" + session.getId().substring(0, Math.min(8, session.getId().length()));
            session.setAttribute("guestCartId", guestId);
        }
        return guestId;
    }

    private void updateSessionCartCount(HttpSession session, String userId) {
        int count = cartService.getCartItemCount(userId);
        session.setAttribute("cartCount", count);
    }

    // =========================================================================
    // Read: View Cart
    // =========================================================================

    @GetMapping("/cart")
    public String viewCart(HttpSession session, Model model) {
        String userId = resolveUserId(session);
        User currentUser = (User) session.getAttribute("currentUser");

        ShoppingCart cart = cartService.getCartForUser(userId, currentUser);
        updateSessionCartCount(session, userId);

        model.addAttribute("cart", cart);
        model.addAttribute("pageTitle", "Shopping Cart - ReadVerse");
        return "cart/cart";
    }

    // =========================================================================
    // Create: Add to Cart (with Abstraction: Stock Validation)
    // =========================================================================

    @PostMapping("/cart/add")
    public String addToCart(@RequestParam("bookId") String bookId,
                            @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        String userId = resolveUserId(session);
        try {
            boolean added = cartService.addToCart(userId, bookId, quantity);
            if (added) {
                updateSessionCartCount(session, userId);
                redirectAttributes.addFlashAttribute("successMessage", "Item successfully added to your shopping cart!");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Could not add item to cart.");
            }
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error: " + e.getMessage());
        }

        return "redirect:/cart";
    }

    // =========================================================================
    // Update: Dedicated Update Quantity UI
    // =========================================================================

    @GetMapping("/cart/update")
    public String showUpdateQuantityPage(@RequestParam("cartItemId") String cartItemId,
                                         HttpSession session,
                                         Model model,
                                         RedirectAttributes redirectAttributes) {
        String userId = resolveUserId(session);
        User currentUser = (User) session.getAttribute("currentUser");
        ShoppingCart cart = cartService.getCartForUser(userId, currentUser);

        CartItem targetItem = cart.getItems().stream()
                .filter(i -> i.getCartItemId().equalsIgnoreCase(cartItemId))
                .findFirst()
                .orElse(null);

        if (targetItem == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Cart item not found.");
            return "redirect:/cart";
        }

        model.addAttribute("item", targetItem);
        model.addAttribute("pageTitle", "Update Cart Item Quantity - ReadVerse");
        return "cart/cart-update";
    }

    @PostMapping("/cart/update")
    public String processUpdateQuantity(@RequestParam("cartItemId") String cartItemId,
                                        @RequestParam("quantity") int quantity,
                                        HttpSession session,
                                        RedirectAttributes redirectAttributes) {
        String userId = resolveUserId(session);
        try {
            boolean updated = cartService.updateQuantity(userId, cartItemId, quantity);
            if (updated) {
                updateSessionCartCount(session, userId);
                redirectAttributes.addFlashAttribute("successMessage", "Cart quantity updated successfully!");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Failed to update item quantity.");
            }
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/cart";
    }

    // =========================================================================
    // Delete: Remove Item & Clear Cart
    // =========================================================================

    @PostMapping("/cart/remove")
    public String removeItem(@RequestParam("cartItemId") String cartItemId,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        String userId = resolveUserId(session);
        boolean removed = cartService.removeItem(cartItemId);
        if (removed) {
            updateSessionCartCount(session, userId);
            redirectAttributes.addFlashAttribute("infoMessage", "Item removed from cart.");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to remove item.");
        }
        return "redirect:/cart";
    }

    @PostMapping("/cart/clear")
    public String clearCart(HttpSession session, RedirectAttributes redirectAttributes) {
        String userId = resolveUserId(session);
        cartService.clearCart(userId);
        updateSessionCartCount(session, userId);
        redirectAttributes.addFlashAttribute("infoMessage", "Shopping cart cleared.");
        return "redirect:/cart";
    }

    // =========================================================================
    // Read: Checkout Summary
    // =========================================================================

    @GetMapping("/cart/checkout-summary")
    public String showCheckoutSummary(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        String userId = resolveUserId(session);
        User currentUser = (User) session.getAttribute("currentUser");

        ShoppingCart cart = cartService.getCartForUser(userId, currentUser);
        if (cart.getItems().isEmpty()) {
            redirectAttributes.addFlashAttribute("warningMessage", "Your cart is empty. Add items before checking out.");
            return "redirect:/books";
        }

        model.addAttribute("cart", cart);
        model.addAttribute("pageTitle", "Checkout Summary - ReadVerse");
        return "cart/checkout-summary";
    }
}
