package com.bookstore.service.impl;

import com.bookstore.dao.BookDao;
import com.bookstore.dao.CartDao;
import com.bookstore.model.book.Book;
import com.bookstore.model.cart.CartItem;
import com.bookstore.model.cart.ShoppingCart;
import com.bookstore.model.cart.discount.BulkDiscountStrategy;
import com.bookstore.model.cart.discount.MembershipDiscountStrategy;
import com.bookstore.model.cart.validator.StockValidator;
import com.bookstore.model.user.User;
import com.bookstore.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Concrete implementation of CartService.
 * Demonstrates:
 * 1. Abstraction: uses StockValidator to check stock before adding/updating.
 * 2. Polymorphism: uses dynamic discount strategies (Membership vs Bulk) to compute savings.
 * 
 * @author IT25101062
 */
@Service
public class CartServiceImpl implements CartService {

    private final CartDao cartDao;
    private final BookDao bookDao;
    private final StockValidator stockValidator;

    @Autowired
    public CartServiceImpl(CartDao cartDao, BookDao bookDao, StockValidator stockValidator) {
        this.cartDao = cartDao;
        this.bookDao = bookDao;
        this.stockValidator = stockValidator;
    }

    @Override
    public boolean addToCart(String userId, String bookId, int quantity) throws IllegalArgumentException {
        if (userId == null || bookId == null || quantity <= 0) {
            throw new IllegalArgumentException("Invalid user, book, or quantity provided.");
        }

        Optional<Book> bookOpt = bookDao.findById(bookId);
        if (bookOpt.isEmpty()) {
            throw new IllegalArgumentException("Book does not exist in bookstore catalog.");
        }
        Book book = bookOpt.get();

        // Check if item is already in user's cart
        Optional<CartItem> existingItemOpt = cartDao.findByUserAndBook(userId, bookId);
        int targetQuantity = quantity;
        if (existingItemOpt.isPresent()) {
            targetQuantity += existingItemOpt.get().getQuantity();
        }

        // Abstraction in action: Validate stock availability before modifying cart
        if (!stockValidator.validateStock(bookId, targetQuantity)) {
            int available = stockValidator.getAvailableStock(bookId);
            throw new IllegalArgumentException("Insufficient inventory: Only " + available + " copies available for '" + book.getTitle() + "'.");
        }

        if (existingItemOpt.isPresent()) {
            CartItem existingItem = existingItemOpt.get();
            existingItem.setQuantity(targetQuantity);
            return cartDao.update(existingItem);
        } else {
            String newCartItemId = cartDao.generateNextId();
            double price = book.calculateFinalPrice();
            CartItem newItem = new CartItem(newCartItemId, userId, bookId, quantity, price);
            return cartDao.save(newItem);
        }
    }

    @Override
    public ShoppingCart getCartForUser(String userId, User user) {
        ShoppingCart cart = new ShoppingCart(userId);
        if (userId == null) return cart;

        List<CartItem> items = cartDao.findByUserId(userId);
        for (CartItem item : items) {
            Optional<Book> bookOpt = bookDao.findById(item.getBookId());
            bookOpt.ifPresent(item::setBook);
            cart.addItem(item);
        }

        // Polymorphic strategy selection:
        // If user is Gold/Silver member, MembershipDiscountStrategy applies.
        // If regular user has 3+ items, BulkDiscountStrategy applies!
        if (user != null && user.getDiscountRate() > 0) {
            cart.setDiscountStrategy(new MembershipDiscountStrategy());
        } else if (cart.getTotalQuantity() >= 3) {
            cart.setDiscountStrategy(new BulkDiscountStrategy());
        }

        return cart;
    }

    @Override
    public boolean updateQuantity(String userId, String cartItemId, int newQuantity) throws IllegalArgumentException {
        if (cartItemId == null || newQuantity < 0) {
            throw new IllegalArgumentException("Invalid cart item or quantity.");
        }

        if (newQuantity == 0) {
            return cartDao.deleteById(cartItemId);
        }

        List<CartItem> userItems = cartDao.findByUserId(userId);
        Optional<CartItem> itemOpt = userItems.stream()
                .filter(i -> i.getCartItemId().equalsIgnoreCase(cartItemId))
                .findFirst();

        if (itemOpt.isEmpty()) {
            throw new IllegalArgumentException("Cart item not found.");
        }

        CartItem item = itemOpt.get();

        // Abstraction: Check stock before updating
        if (!stockValidator.validateStock(item.getBookId(), newQuantity)) {
            int available = stockValidator.getAvailableStock(item.getBookId());
            throw new IllegalArgumentException("Only " + available + " copies available in stock.");
        }

        item.setQuantity(newQuantity);
        return cartDao.update(item);
    }

    @Override
    public boolean removeItem(String cartItemId) {
        return cartDao.deleteById(cartItemId);
    }

    @Override
    public boolean clearCart(String userId) {
        return cartDao.clearCartByUserId(userId);
    }

    @Override
    public int getCartItemCount(String userId) {
        if (userId == null) return 0;
        return cartDao.findByUserId(userId).stream().mapToInt(CartItem::getQuantity).sum();
    }
}
