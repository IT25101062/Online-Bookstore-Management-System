package com.bookstore.dao.impl;

import com.bookstore.dao.ReviewDao;
import com.bookstore.model.review.Review;
import com.bookstore.util.FileStorageHelper;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * File handling implementation of ReviewDao reading and persisting to reviews.txt.
 */
@Repository
public class FileReviewDaoImpl implements ReviewDao {

    private static final String FILENAME = "reviews.txt";
    private static final String HEADER = "reviewId|bookId|userId|username|rating|reviewText|reviewType|reviewDate|status";

    @Override
    public List<Review> findAll() {
        List<String> lines = FileStorageHelper.readAllLines(FILENAME);
        List<Review> reviews = new ArrayList<>();

        for (String line : lines) {
            if (line.toLowerCase().startsWith("reviewid|")) {
                continue; // Skip header
            }
            Review r = parseReview(line);
            if (r != null) {
                reviews.add(r);
            }
        }
        return reviews;
    }

    @Override
    public List<Review> findByBookId(String bookId) {
        if (bookId == null) return List.of();
        return findAll().stream()
                .filter(r -> r.getBookId() != null && r.getBookId().equalsIgnoreCase(bookId.trim()))
                .filter(r -> "APPROVED".equalsIgnoreCase(r.getStatus()))
                .collect(Collectors.toList());
    }

    @Override
    public synchronized boolean save(Review review) {
        if (review == null) return false;
        if (review.getReviewId() == null || review.getReviewId().trim().isEmpty()) {
            review.setReviewId(generateNextId());
        }
        return FileStorageHelper.appendLine(FILENAME, review.toFileRecord());
    }

    @Override
    public synchronized String generateNextId() {
        List<Review> all = findAll();
        int maxId = 0;
        for (Review r : all) {
            String idStr = r.getReviewId();
            if (idStr != null && idStr.toUpperCase().startsWith("REV")) {
                try {
                    int num = Integer.parseInt(idStr.substring(3));
                    if (num > maxId) maxId = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return String.format("REV%03d", maxId + 1);
    }

    @Override
    public double getAverageRating(String bookId) {
        List<Review> bookReviews = findByBookId(bookId);
        if (bookReviews.isEmpty()) return 5.0; // Default welcoming baseline
        double sum = 0;
        for (Review r : bookReviews) {
            sum += r.getRating();
        }
        return Math.round((sum / bookReviews.size()) * 10.0) / 10.0;
    }

    @Override
    public int getReviewCount(String bookId) {
        return findByBookId(bookId).size();
    }

    private Review parseReview(String line) {
        try {
            String[] tokens = FileStorageHelper.splitPipe(line);
            if (tokens.length < 6) return null;

            String reviewId = tokens[0].trim();
            String bookId = tokens[1].trim();
            String userId = tokens[2].trim();
            String username = tokens[3].trim();
            int rating = Integer.parseInt(tokens[4].trim());
            String reviewText = tokens[5].trim().replace("\\n", " ");
            String reviewType = tokens.length > 6 ? tokens[6].trim() : "PUBLIC";
            String reviewDate = tokens.length > 7 ? tokens[7].trim() : "";
            String status = tokens.length > 8 ? tokens[8].trim() : "APPROVED";

            return new Review(reviewId, bookId, userId, username, rating, reviewText, reviewType, reviewDate, status);
        } catch (Exception e) {
            System.err.println("Error parsing review: " + line + " -> " + e.getMessage());
            return null;
        }
    }
}
