package com.bookstore.controller;

import com.bookstore.model.book.Book;
import com.bookstore.service.BookService;
import com.bookstore.util.FileStorageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.*;

/**
 * HomeController - handles the home landing page and featured book catalog display.
 * 
 * @author IT25101062
 */
@Controller
public class HomeController {

    private final BookService bookService;

    @Autowired
    public HomeController(BookService bookService) {
        this.bookService = bookService;
    }

    @GetMapping({"", "/", "/home"})
    public String home(Model model) {
        List<Book> allBooks = bookService.getAllBooks();
        List<Book> featuredBooks = allBooks.stream().limit(4).toList();

        // Read categories from categories.txt
        List<Map<String, String>> categories = new ArrayList<>();
        List<String> catLines = FileStorageHelper.readAllLines("categories.txt");
        for (String line : catLines) {
            if (line.toLowerCase().startsWith("categoryid|")) continue;
            String[] parts = FileStorageHelper.splitPipe(line);
            if (parts.length >= 6) {
                Map<String, String> cat = new HashMap<>();
                cat.put("categoryId", parts[0]);
                cat.put("categoryName", parts[1]);
                cat.put("description", parts[2]);
                cat.put("displayOrder", parts[3]);
                cat.put("iconName", parts[4]);
                cat.put("isActive", parts[5]);
                categories.add(cat);
            }
        }

        model.addAttribute("featuredBooks", featuredBooks);
        model.addAttribute("categories", categories);
        model.addAttribute("pageTitle", "Chapter One - Online Bookstore");
        return "home";
    }
}
