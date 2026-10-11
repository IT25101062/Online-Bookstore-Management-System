package com.bookstore.model.book;

public enum BookType {
    PRINTED,
    EBOOK;

    public static BookType fromString(String str) {
        if (str == null) return PRINTED;
        try {
            return BookType.valueOf(str.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return PRINTED;
        }
    }
}
