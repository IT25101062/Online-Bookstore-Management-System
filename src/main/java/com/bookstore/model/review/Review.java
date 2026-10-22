package com.bookstore.model.review;

import com.bookstore.util.FileStorageHelper;
import java.io.Serializable;
import java.time.LocalDate;

/**
 * Model representing a Customer Review and Rating for a Book.
 */
public class Review implements Serializable {

    private static final long serialVersionUID = 1L;

    private String reviewId;
    private String bookId;
    private String userId;
    private String username;
    private int rating; // 1 to 5 stars
    private String reviewText;
    private String reviewType; // VERIFIED, PUBLIC
    private String reviewDate; // YYYY-MM-DD
    private String status; // APPROVED, PENDING_MODERATION

    public Review() {
        this.rating = 5;
        this.reviewType = "PUBLIC";
        this.reviewDate = LocalDate.now().toString();
        this.status = "APPROVED";
    }

    public Review(String reviewId, String bookId, String userId, String username, int rating, String reviewText, String reviewType, String reviewDate, String status) {
        this.reviewId = reviewId;
        this.bookId = bookId;
        this.userId = (userId != null && !userId.trim().isEmpty()) ? userId.trim() : "GUEST";
        this.username = (username != null && !username.trim().isEmpty()) ? username.trim() : "Verified Reader";
        setRating(rating);
        this.reviewText = reviewText != null ? reviewText.trim() : "";
        this.reviewType = (reviewType != null && !reviewType.trim().isEmpty()) ? reviewType.trim() : "PUBLIC";
        this.reviewDate = (reviewDate != null && !reviewDate.trim().isEmpty()) ? reviewDate.trim() : LocalDate.now().toString();
        this.status = (status != null && !status.trim().isEmpty()) ? status.trim() : "APPROVED";
    }

    public String toFileRecord() {
        String safeText = (reviewText != null) ? reviewText.replace("\r\n", "\\n").replace("\n", "\\n").replace("\r", "\\n").replace("|", "/") : "";
        return FileStorageHelper.joinPipe(
            reviewId,
            bookId,
            userId,
            username,
            String.valueOf(rating),
            safeText,
            reviewType,
            reviewDate,
            status
        );
    }

    public String getReviewerName() {
        return (username != null && !username.trim().isEmpty()) ? username : "Verified Reader";
    }

    public void setReviewerName(String reviewerName) {
        this.username = reviewerName;
    }

    public String getAvatarInitial() {
        String name = getReviewerName();
        return (name.length() > 0) ? name.substring(0, 1).toUpperCase() : "R";
    }

    public String getReviewId() {
        return reviewId;
    }

    public void setReviewId(String reviewId) {
        this.reviewId = reviewId;
    }

    public String getBookId() {
        return bookId;
    }

    public void setBookId(String bookId) {
        this.bookId = bookId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = Math.max(1, Math.min(5, rating));
    }

    public String getReviewText() {
        return reviewText;
    }

    public void setReviewText(String reviewText) {
        this.reviewText = reviewText != null ? reviewText.trim() : "";
    }

    public String getReviewType() {
        return reviewType;
    }

    public void setReviewType(String reviewType) {
        this.reviewType = reviewType;
    }

    public String getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(String reviewDate) {
        this.reviewDate = reviewDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
