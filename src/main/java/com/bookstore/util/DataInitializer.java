package com.bookstore.util;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

/**
 * Initializes sample data files upon application startup if they do not exist.
 * Ensures the project is 100% demo-ready for presentation and viva evaluations.
 * 
 * @author IT25101062
 */
@Component
public class DataInitializer implements CommandLineRunner {

    @Override
    public void run(String... args) throws Exception {
        Path dataDir = Paths.get("data");
        if (!Files.exists(dataDir)) {
            Files.createDirectories(dataDir);
        }

        initializeUsers();
        initializeBooks();
        initializeCategories();
        initializeCart();
        initializeOrders();
        initializeReviews();
    }

    private void initializeUsers() {
        if (!Files.exists(FileStorageHelper.resolvePath("users.txt"))) {
            String header = "userId|username|password|fullName|email|phoneNumber|role|membershipType|createdAt";
            List<String> records = Arrays.asList(
                "U001|admin|admin123|Sarah Jenkins|admin@readverse.com|0771234567|ADMIN|NONE|2026-01-10",
                "U002|john_doe|password123|John Doe|john.doe@gmail.com|0712345678|CUSTOMER|GOLD|2026-02-15",
                "U003|jane_smith|password123|Jane Smith|jane.smith@yahoo.com|0723456789|CUSTOMER|SILVER|2026-03-01",
                "U004|kamal_perera|password123|Kamal Perera|kamal.p@gmail.com|0754567890|CUSTOMER|STANDARD|2026-03-20"
            );
            FileStorageHelper.writeAllLines("users.txt", header, records);
        }
    }

    private void initializeBooks() {
        if (!Files.exists(FileStorageHelper.resolvePath("books.txt"))) {
            String header = "bookId|isbn|title|author|category|basePrice|stockQuantity|bookType|extra1|extra2|description";
            List<String> records = Arrays.asList(
                "B001|978-0134685991|Effective Java (3rd Edition)|Joshua Bloch|Technology|45.00|25|PRINTED|0.85|Hardcover|The definitive guide to Java platform best practices and idioms.",
                "B002|978-0132350884|Clean Code: A Handbook of Agile Software Craftsmanship|Robert C. Martin|Technology|38.50|30|PRINTED|0.65|Paperback|Even bad code can function. But if code isn't clean, it can bring a development organization to its knees.",
                "B003|978-1491950357|Designing Data-Intensive Applications|Martin Kleppmann|Technology|32.00|999|EBOOK|18.5|PDF|The key principles, algorithms, and trade-offs of reliable, scalable, and maintainable systems.",
                "B004|978-0451524935|1984|George Orwell|Fiction|12.50|50|PRINTED|0.35|Paperback|A startling and haunting novel that depicts totalitarian rule and thought surveillance.",
                "B005|978-0743273565|The Great Gatsby|F. Scott Fitzgerald|Fiction|9.99|999|EBOOK|8.2|EPUB|The story of the fabulously wealthy Jay Gatsby and his love for the beautiful Daisy Buchanan.",
                "B006|978-0061120084|To Kill a Mockingbird|Harper Lee|Fiction|14.00|18|PRINTED|0.42|Paperback|Compassionate, dramatic, and deeply moving story exploring racial injustice and morality in the American South.",
                "B007|978-0307887894|The Lean Startup|Eric Ries|Business|22.00|40|PRINTED|0.52|Hardcover|How today's entrepreneurs use continuous innovation to create radically successful businesses.",
                "B008|978-0062457714|The Subtle Art of Not Giving a F*ck|Mark Manson|Self-Help|15.00|999|EBOOK|6.4|PDF|A counterintuitive approach to living a good life, accepting limitations, and embracing uncertainty."
            );
            FileStorageHelper.writeAllLines("books.txt", header, records);
        }
    }

    private void initializeCategories() {
        if (!Files.exists(FileStorageHelper.resolvePath("categories.txt"))) {
            String header = "categoryId|categoryName|description|displayOrder|iconName|isActive";
            List<String> records = Arrays.asList(
                "CAT001|Technology|Programming, Software Engineering, AI & Systems|1|bi-laptop|true",
                "CAT002|Fiction|Novels, Sci-Fi, Thrillers, and Classic Literature|2|bi-book|true",
                "CAT003|Business|Entrepreneurship, Management, Economics & Marketing|3|bi-briefcase|true",
                "CAT004|Self-Help|Personal Development, Mindfulness & Productivity|4|bi-heart|true",
                "CAT005|Science|Physics, Astronomy, Biology, Mathematics|5|bi-lightbulb|true"
            );
            FileStorageHelper.writeAllLines("categories.txt", header, records);
        }
    }

    private void initializeCart() {
        if (!Files.exists(FileStorageHelper.resolvePath("cart.txt"))) {
            String header = "cartItemId|userId|bookId|quantity|pricePerUnit|addedDate";
            List<String> records = Arrays.asList(
                "CI001|U002|B001|1|45.00|2026-10-10",
                "CI002|U002|B003|2|32.00|2026-10-10",
                "CI003|U003|B002|1|38.50|2026-10-11"
            );
            FileStorageHelper.writeAllLines("cart.txt", header, records);
        }
    }

    private void initializeOrders() {
        if (!Files.exists(FileStorageHelper.resolvePath("orders.txt"))) {
            String header = "orderId|userId|totalAmount|paymentMethod|paymentStatus|orderStatus|orderDate|shippingAddress|itemSummary";
            List<String> records = Arrays.asList(
                "ORD1001|U002|77.00|CARD|PAID|DELIVERED|2026-10-01|45 Lotus Road, Colombo 03|Effective Java (x1), Designing Data-Intensive Applications (x1)",
                "ORD1002|U003|22.49|CASH|PAID|SHIPPED|2026-10-05|12 Lake Drive, Kandy|1984 (x1), The Great Gatsby (x1)",
                "ORD1003|U004|45.00|CARD|PAID|PROCESSING|2026-10-09|78 Galle Road, Mount Lavinia|Effective Java (x1)",
                "ORD1004|U002|38.50|CASH|PENDING|PENDING|2026-10-10|45 Lotus Road, Colombo 03|Clean Code (x1)"
            );
            FileStorageHelper.writeAllLines("orders.txt", header, records);
        }
    }

    private void initializeReviews() {
        if (!Files.exists(FileStorageHelper.resolvePath("reviews.txt"))) {
            String header = "reviewId|bookId|userId|username|rating|reviewText|reviewType|reviewDate|status";
            List<String> records = Arrays.asList(
                "REV001|B001|U002|john_doe|5|Masterpiece! Joshua Bloch explains Java design idioms with tremendous clarity.|VERIFIED|2026-10-02|APPROVED",
                "REV002|B002|U003|jane_smith|4|Essential reading for all software developers. Clean Code changes how you think about coding.|VERIFIED|2026-10-06|APPROVED",
                "REV003|B004|U004|kamal_perera|5|A chilling masterpiece that remains completely relevant decades later.|PUBLIC|2026-10-09|APPROVED",
                "REV004|B003|U002|john_doe|5|The best technical book on distributed databases and streaming systems.|PUBLIC|2026-10-10|PENDING_MODERATION",
                "REV005|B005|U003|jane_smith|4|Beautifully written classic. Fitzgerald's prose is breathtaking.|PUBLIC|2026-10-11|APPROVED"
            );
            FileStorageHelper.writeAllLines("reviews.txt", header, records);
        }
    }
}
