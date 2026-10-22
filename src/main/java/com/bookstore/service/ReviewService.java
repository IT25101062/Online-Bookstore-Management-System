package com.bookstore.service;

import com.bookstore.model.review.Review;
import java.util.List;

/**
 * Service interface for Customer Reviews and Ratings.
 */
public interface ReviewService {

    List<Review> getReviewsForBook(String bookId);

    List<Review> getAllReviews();

    boolean addReview(Review review);

    double getAverageRating(String bookId);

    int getReviewCount(String bookId);
}
