package com.bookstore.dao;

import com.bookstore.model.review.Review;
import java.util.List;

/**
 * Data Access Object interface for Review management.
 */
public interface ReviewDao {

    /**
     * Retrieve all reviews from reviews.txt
     */
    List<Review> findAll();

    /**
     * Retrieve reviews for a specific book
     */
    List<Review> findByBookId(String bookId);

    /**
     * Save a new review
     */
    boolean save(Review review);

    /**
     * Generate the next incremental review ID (e.g. REV006)
     */
    String generateNextId();

    /**
     * Calculate average star rating for a book
     */
    double getAverageRating(String bookId);

    /**
     * Count reviews for a book
     */
    int getReviewCount(String bookId);
}
