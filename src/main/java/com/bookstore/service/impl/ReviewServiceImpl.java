package com.bookstore.service.impl;

import com.bookstore.dao.ReviewDao;
import com.bookstore.model.review.Review;
import com.bookstore.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Concrete implementation of ReviewService.
 */
@Service
public class ReviewServiceImpl implements ReviewService {

    private final ReviewDao reviewDao;

    @Autowired
    public ReviewServiceImpl(ReviewDao reviewDao) {
        this.reviewDao = reviewDao;
    }

    @Override
    public List<Review> getReviewsForBook(String bookId) {
        return reviewDao.findByBookId(bookId);
    }

    @Override
    public List<Review> getAllReviews() {
        return reviewDao.findAll();
    }

    @Override
    public boolean addReview(Review review) {
        if (review == null || review.getBookId() == null || review.getBookId().trim().isEmpty()) {
            return false;
        }
        return reviewDao.save(review);
    }

    @Override
    public double getAverageRating(String bookId) {
        return reviewDao.getAverageRating(bookId);
    }

    @Override
    public int getReviewCount(String bookId) {
        return reviewDao.getReviewCount(bookId);
    }
}
