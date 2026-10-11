package com.bookstore.model.cart.validator;

import com.bookstore.dao.BookDao;
import com.bookstore.model.book.Book;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

/**
 * Concrete implementation of StockValidator checking against BookDao inventory.
 * 
 * @author IT25101062
 */
@Component
public class InventoryStockValidator implements StockValidator {

    private final BookDao bookDao;

    @Autowired
    public InventoryStockValidator(BookDao bookDao) {
        this.bookDao = bookDao;
    }

    @Override
    public boolean validateStock(String bookId, int requestedQuantity) {
        if (bookId == null || requestedQuantity <= 0) {
            return false;
        }

        Optional<Book> bookOpt = bookDao.findById(bookId);
        if (bookOpt.isPresent()) {
            Book book = bookOpt.get();
            // E-books have unlimited digital stock
            if (!book.isInStock()) {
                return false;
            }
            return book.getStockQuantity() >= requestedQuantity;
        }
        return false;
    }

    @Override
    public int getAvailableStock(String bookId) {
        if (bookId == null) return 0;
        Optional<Book> bookOpt = bookDao.findById(bookId);
        return bookOpt.map(Book::getStockQuantity).orElse(0);
    }
}
