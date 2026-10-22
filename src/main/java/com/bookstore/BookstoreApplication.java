package com.bookstore;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * SE1020 - Object Oriented Programming
 * Online Bookstore Management System (Chapter One)
 * 
 * Main Application Entry Point
 * Demonstrates:
 * - Pure OOP architecture (Encapsulation, Inheritance, Polymorphism, Abstraction)
 * - File-based persistent storage (users.txt, books.txt, cart.txt, orders.txt, categories.txt, reviews.txt)
 * - Complete CRUD across 6 core components
 * - JSP / Servlet-compatible MVC presentation layer
 * 
 * @author IT25101062
 */
@SpringBootApplication
public class BookstoreApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(BookstoreApplication.class, args);
        System.out.println("==================================================================");
        System.out.println("  Chapter One - Online Bookstore Started Successfully! ");
        System.out.println("  Access application at: http://localhost:8080/                    ");
        System.out.println("  Default Admin Login  : admin / admin123                          ");
        System.out.println("  Default Customer     : john_doe / password123                    ");
        System.out.println("==================================================================");
    }
}
