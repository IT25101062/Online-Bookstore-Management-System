package com.bookstore.model.book;

import com.bookstore.util.FileStorageHelper;

/**
 * PrintedBook subclass extending Book.
 * Demonstrates Inheritance and Polymorphic display & price calculations factoring physical packaging/weight.
 * 
 * @author IT25101062
 */
public class PrintedBook extends Book {

    private static final long serialVersionUID = 1L;

    private double weightKg = 0.5;
    private String coverType = "Paperback"; // Hardcover, Paperback

    public PrintedBook() {
        super();
        setBookType(BookType.PRINTED);
    }

    public PrintedBook(String bookId, String isbn, String title, String author, String category, double basePrice, int stockQuantity, String description, double weightKg, String coverType) {
        super(bookId, isbn, title, author, category, basePrice, stockQuantity, BookType.PRINTED, description);
        this.weightKg = Math.max(0.05, weightKg);
        this.coverType = (coverType != null && !coverType.trim().isEmpty()) ? coverType.trim() : "Paperback";
    }

    @Override
    public double calculateFinalPrice() {
        // Physical books incur packaging and weight surcharge ($1.50/kg)
        double packagingFee = Math.round(weightKg * 1.50 * 100.0) / 100.0;
        return Math.round((getBasePrice() + packagingFee) * 100.0) / 100.0;
    }

    @Override
    public String getFormatDetails() {
        return "Physical Book (" + coverType + ", " + weightKg + " kg)";
    }

    @Override
    public boolean isInStock() {
        return getStockQuantity() > 0;
    }

    public double getWeightKg() {
        return weightKg;
    }

    public void setWeightKg(double weightKg) {
        this.weightKg = Math.max(0.05, weightKg);
    }

    public String getCoverType() {
        return coverType;
    }

    public void setCoverType(String coverType) {
        this.coverType = coverType != null ? coverType.trim() : "Paperback";
    }

    @Override
    public String toFileRecord() {
        return FileStorageHelper.joinPipe(
            getBookId(),
            getIsbn(),
            getTitle(),
            getAuthor(),
            getCategory(),
            String.format(java.util.Locale.US, "%.2f", getBasePrice()),
            String.valueOf(getStockQuantity()),
            BookType.PRINTED.name(),
            String.format(java.util.Locale.US, "%.2f", weightKg),
            coverType,
            getDescription()
        );
    }
}
