package com.bookstore.model.book;

import com.bookstore.util.FileStorageHelper;

/**
 * EBook subclass extending Book.
 * Demonstrates Inheritance and Polymorphic display & price calculations for digital items.
 * 
 * @author IT25101062
 */
public class EBook extends Book {

    private static final long serialVersionUID = 1L;

    private double fileSizeMB = 10.0;
    private String downloadFormat = "PDF"; // PDF, EPUB, MOBI

    public EBook() {
        super();
        setBookType(BookType.EBOOK);
        setStockQuantity(999); // Digital inventory
    }

    public EBook(String bookId, String isbn, String title, String author, String category, double basePrice, int stockQuantity, String description, double fileSizeMB, String downloadFormat) {
        super(bookId, isbn, title, author, category, basePrice, stockQuantity, BookType.EBOOK, description);
        this.fileSizeMB = Math.max(0.1, fileSizeMB);
        this.downloadFormat = (downloadFormat != null && !downloadFormat.trim().isEmpty()) ? downloadFormat.trim() : "PDF";
    }

    @Override
    public double calculateFinalPrice() {
        // E-Books do not incur shipping costs
        return getBasePrice();
    }

    @Override
    public String getFormatDetails() {
        return "Digital E-Book (" + downloadFormat + ", " + fileSizeMB + " MB)";
    }

    @Override
    public boolean isInStock() {
        // Digital downloads never run out of physical stock
        return true;
    }

    public double getFileSizeMB() {
        return fileSizeMB;
    }

    public void setFileSizeMB(double fileSizeMB) {
        this.fileSizeMB = Math.max(0.1, fileSizeMB);
    }

    public String getDownloadFormat() {
        return downloadFormat;
    }

    public void setDownloadFormat(String downloadFormat) {
        this.downloadFormat = downloadFormat != null ? downloadFormat.trim() : "PDF";
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
            BookType.EBOOK.name(),
            String.format(java.util.Locale.US, "%.1f", fileSizeMB),
            downloadFormat,
            getDescription()
        );
    }
}
