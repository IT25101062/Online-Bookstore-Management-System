package com.bookstore.controller;

import com.bookstore.model.book.*;
import com.bookstore.model.user.User;
import com.bookstore.service.BookService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

/**
 * Controller handling Book Management CRUD operations, search, and stock tracking.
 * 
 * CRUD Operations:
 * 1. Create: /books/add (Add new EBook or PrintedBook)
 * 2. Read  : /books (Catalog), /books/view (Details), /books/search (Search), /books/manage (Admin view)
 * 3. Update: /books/edit (Update details & stock), /books/stock (Adjust stock quantity)
 * 4. Delete: /books/delete (Delete book from catalog)
 * 
 * @author IT25101062
 */
@Controller
public class BookController {

    private final BookService bookService;

    @Autowired
    public BookController(BookService bookService) {
        this.bookService = bookService;
    }

    // =========================================================================
    // Read: Book Catalog & Category Filter
    // =========================================================================

    @GetMapping("/books")
    public String listCatalog(@RequestParam(value = "category", required = false) String category,
                              Model model) {
        List<Book> books = (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("ALL"))
                ? bookService.getBooksByCategory(category)
                : bookService.getAllBooks();

        model.addAttribute("books", books);
        model.addAttribute("selectedCategory", category);
        model.addAttribute("pageTitle", "Book Catalog - ReadVerse");
        return "book/book-list";
    }

    @GetMapping("/books/view")
    public String viewBookDetails(@RequestParam("id") String bookId,
                                  Model model,
                                  RedirectAttributes redirectAttributes) {
        Optional<Book> bookOpt = bookService.getBookById(bookId);
        if (bookOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Book not found with ID: " + bookId);
            return "redirect:/books";
        }

        Book book = bookOpt.get();
        model.addAttribute("book", book);
        model.addAttribute("pageTitle", book.getTitle() + " - ReadVerse");
        return "book/book-details";
    }

    // =========================================================================
    // Read: Search Books
    // =========================================================================

    @GetMapping("/books/search")
    public String searchBooks(@RequestParam(value = "keyword", required = false) String keyword,
                              @RequestParam(value = "category", required = false) String category,
                              @RequestParam(value = "minPrice", required = false) Double minPrice,
                              @RequestParam(value = "maxPrice", required = false) Double maxPrice,
                              Model model) {
        List<Book> searchResults = bookService.searchBooks(keyword, category, minPrice, maxPrice);

        model.addAttribute("books", searchResults);
        model.addAttribute("keyword", keyword);
        model.addAttribute("category", category);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("pageTitle", "Search Books - ReadVerse");
        return "book/book-search";
    }

    // =========================================================================
    // Create: Add Book (Admin Only)
    // =========================================================================

    @GetMapping("/books/add")
    public String showAddBookForm(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.hasAdminPrivileges()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Access Denied: Administrator privileges required.");
            return "redirect:/login";
        }

        model.addAttribute("pageTitle", "Add New Book - ReadVerse");
        model.addAttribute("bookTypes", BookType.values());
        return "book/book-add";
    }

    @PostMapping("/books/add")
    public String processAddBook(@RequestParam("isbn") String isbn,
                                 @RequestParam("title") String title,
                                 @RequestParam("author") String author,
                                 @RequestParam("category") String category,
                                 @RequestParam("basePrice") double basePrice,
                                 @RequestParam("stockQuantity") int stockQuantity,
                                 @RequestParam("bookType") String bookTypeStr,
                                 @RequestParam(value = "fileSizeMB", defaultValue = "5.0") double fileSizeMB,
                                 @RequestParam(value = "downloadFormat", defaultValue = "PDF") String downloadFormat,
                                 @RequestParam(value = "weightKg", defaultValue = "0.5") double weightKg,
                                 @RequestParam(value = "coverType", defaultValue = "Paperback") String coverType,
                                 @RequestParam("description") String description,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.hasAdminPrivileges()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Access Denied: Administrator privileges required.");
            return "redirect:/login";
        }

        try {
            BookType bookType = BookType.fromString(bookTypeStr);
            Book newBook;

            if (bookType == BookType.EBOOK) {
                newBook = new EBook(null, isbn, title, author, category, basePrice, stockQuantity, description, fileSizeMB, downloadFormat);
            } else {
                newBook = new PrintedBook(null, isbn, title, author, category, basePrice, stockQuantity, description, weightKg, coverType);
            }

            bookService.addBook(newBook);
            redirectAttributes.addFlashAttribute("successMessage", "Book '" + title + "' added successfully with ID: " + newBook.getBookId());
            return "redirect:/books/manage";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/books/add";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error adding book: " + e.getMessage());
            return "redirect:/books/add";
        }
    }

    // =========================================================================
    // Read: Admin Inventory & Stock Management View
    // =========================================================================

    @GetMapping("/books/manage")
    public String manageBooks(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.hasAdminPrivileges()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Access Denied: Administrator privileges required.");
            return "redirect:/login";
        }

        List<Book> books = bookService.getAllBooks();
        model.addAttribute("books", books);
        model.addAttribute("pageTitle", "Inventory & Stock Management - ReadVerse");
        return "book/book-manage";
    }

    // =========================================================================
    // Update: Edit Book & Stock (Admin Only)
    // =========================================================================

    @GetMapping("/books/edit")
    public String showEditBookForm(@RequestParam("id") String bookId,
                                   HttpSession session,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.hasAdminPrivileges()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Access Denied: Administrator privileges required.");
            return "redirect:/login";
        }

        Optional<Book> bookOpt = bookService.getBookById(bookId);
        if (bookOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Book not found with ID: " + bookId);
            return "redirect:/books/manage";
        }

        model.addAttribute("book", bookOpt.get());
        model.addAttribute("pageTitle", "Edit Book - " + bookOpt.get().getTitle());
        return "book/book-edit";
    }

    @PostMapping("/books/edit")
    public String processEditBook(@RequestParam("bookId") String bookId,
                                  @RequestParam("isbn") String isbn,
                                  @RequestParam("title") String title,
                                  @RequestParam("author") String author,
                                  @RequestParam("category") String category,
                                  @RequestParam("basePrice") double basePrice,
                                  @RequestParam("stockQuantity") int stockQuantity,
                                  @RequestParam(value = "fileSizeMB", required = false) Double fileSizeMB,
                                  @RequestParam(value = "downloadFormat", required = false) String downloadFormat,
                                  @RequestParam(value = "weightKg", required = false) Double weightKg,
                                  @RequestParam(value = "coverType", required = false) String coverType,
                                  @RequestParam("description") String description,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.hasAdminPrivileges()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Access Denied: Administrator privileges required.");
            return "redirect:/login";
        }

        Optional<Book> bookOpt = bookService.getBookById(bookId);
        if (bookOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Book not found with ID: " + bookId);
            return "redirect:/books/manage";
        }

        Book book = bookOpt.get();
        book.setIsbn(isbn);
        book.setTitle(title);
        book.setAuthor(author);
        book.setCategory(category);
        book.setBasePrice(basePrice);
        book.setStockQuantity(stockQuantity);
        book.setDescription(description);

        if (book instanceof EBook) {
            EBook eBook = (EBook) book;
            if (fileSizeMB != null) eBook.setFileSizeMB(fileSizeMB);
            if (downloadFormat != null) eBook.setDownloadFormat(downloadFormat);
        } else if (book instanceof PrintedBook) {
            PrintedBook printed = (PrintedBook) book;
            if (weightKg != null) printed.setWeightKg(weightKg);
            if (coverType != null) printed.setCoverType(coverType);
        }

        boolean updated = bookService.updateBook(book);
        if (updated) {
            redirectAttributes.addFlashAttribute("successMessage", "Book '" + title + "' updated successfully in books.txt!");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to update book in data file.");
        }

        return "redirect:/books/manage";
    }

    // Direct Stock Quantity Adjustment
    @PostMapping("/books/stock")
    public String adjustStock(@RequestParam("bookId") String bookId,
                              @RequestParam("change") int change,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.hasAdminPrivileges()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Access Denied: Administrator privileges required.");
            return "redirect:/login";
        }

        boolean adjusted = bookService.adjustStock(bookId, change);
        if (adjusted) {
            redirectAttributes.addFlashAttribute("successMessage", "Stock updated for Book ID: " + bookId);
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Cannot reduce stock below zero or book not found.");
        }

        return "redirect:/books/manage";
    }

    // =========================================================================
    // Delete: Remove Book (Admin Only)
    // =========================================================================

    @PostMapping("/books/delete")
    public String deleteBook(@RequestParam("bookId") String bookId,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.hasAdminPrivileges()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Access Denied: Administrator privileges required.");
            return "redirect:/login";
        }

        boolean deleted = bookService.deleteBook(bookId);
        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Book " + bookId + " removed from catalog.");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to delete book with ID " + bookId);
        }

        return "redirect:/books/manage";
    }
}
