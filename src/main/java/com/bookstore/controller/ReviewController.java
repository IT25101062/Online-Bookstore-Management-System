package com.bookstore.controller;

import com.bookstore.model.book.Book;
import com.bookstore.model.review.Review;
import com.bookstore.model.user.User;
import com.bookstore.service.BookService;
import com.bookstore.service.ReviewService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Controller managing customer reviews and ratings.
 */
@Controller
public class ReviewController {

    private final ReviewService reviewService;
    private final BookService bookService;

    @Autowired
    public ReviewController(ReviewService reviewService, BookService bookService) {
        this.reviewService = reviewService;
        this.bookService = bookService;
    }

    @GetMapping("/reviews")
    public String listReviews(@RequestParam(value = "bookId", required = false) String bookId,
                              Model model) {
        if (bookId != null && !bookId.trim().isEmpty()) {
            Optional<Book> bookOpt = bookService.getBookById(bookId.trim());
            if (bookOpt.isPresent()) {
                Book book = bookOpt.get();
                List<Review> reviews = reviewService.getReviewsForBook(bookId.trim());
                double avgRating = reviewService.getAverageRating(bookId.trim());
                int count = reviewService.getReviewCount(bookId.trim());

                model.addAttribute("book", book);
                model.addAttribute("reviews", reviews);
                model.addAttribute("averageRating", avgRating);
                model.addAttribute("reviewCount", count);
                model.addAttribute("pageTitle", "Customer Reviews - " + book.getTitle());
                return "review/reviews";
            }
        }

        // Show all recent reviews
        List<Review> allReviews = reviewService.getAllReviews();
        List<Book> allBooks = bookService.getAllBooks();
        model.addAttribute("reviews", allReviews);
        model.addAttribute("books", allBooks);
        model.addAttribute("pageTitle", "Customer Reviews & Testimonials - Chapter One");
        return "review/reviews";
    }

    @PostMapping("/reviews/add")
    public String addReview(@RequestParam("bookId") String bookId,
                            @RequestParam("rating") int rating,
                            @RequestParam("reviewText") String reviewText,
                            @RequestParam(value = "reviewerName", required = false) String reviewerName,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        if (bookId == null || bookId.trim().isEmpty() || reviewText == null || reviewText.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Review comment and book selection are required.");
            return "redirect:/books/view?id=" + bookId;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        String userId = (currentUser != null) ? currentUser.getUserId() : "GUEST";
        String username = (currentUser != null) ? currentUser.getFullName() : (reviewerName != null && !reviewerName.trim().isEmpty() ? reviewerName.trim() : "Verified Reader");
        String reviewType = (currentUser != null) ? "VERIFIED" : "PUBLIC";

        String cleanText = reviewText.replace("\r\n", " ").replace("\n", " ").replace("\r", " ").trim();
        Review newReview = new Review(
            null,
            bookId.trim(),
            userId,
            username,
            rating,
            cleanText,
            reviewType,
            LocalDate.now().toString(),
            "APPROVED"
        );

        boolean saved = reviewService.addReview(newReview);
        if (saved) {
            redirectAttributes.addFlashAttribute("successMessage", "Thank you for sharing your review! It is now live.");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Unable to save review. Please try again.");
        }

        return "redirect:/books/view?id=" + bookId + "#reviewsSection";
    }
}
