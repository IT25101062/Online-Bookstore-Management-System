<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<footer class="footer-editorial">
    <div class="container">
        <div class="row g-4 justify-content-between">
            <!-- Brand Column -->
            <div class="col-lg-3 col-md-6">
                <div class="footer-brand">
                    <span>Chapter One</span>
                    <i class="bi bi-book-half" style="color: #c49a6c; font-size: 1.35rem;"></i>
                </div>
                <div class="footer-tagline">
                    Chapter One – Online Bookstore
                </div>
                <p class="small text-white-50">
                    A boutique online literary haven and bookstore. Discover bestselling novels, technology guides, and enduring classics.
                </p>
            </div>

            <!-- Quick Links -->
            <div class="col-lg-2 col-md-6 col-6">
                <div class="footer-heading">Quick Links</div>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/books">Books Catalog</a></li>
                    <li><a href="${pageContext.request.contextPath}/books/search">Search Collection</a></li>
                    <li><a href="${pageContext.request.contextPath}/reviews">Customer Reviews</a></li>
                    <li><a href="${pageContext.request.contextPath}/orders">My Orders</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart">Shopping Cart</a></li>
                </ul>
            </div>

            <!-- Follow Us -->
            <div class="col-lg-2 col-md-6 col-6">
                <div class="footer-heading">Follow Us</div>
                <div class="d-flex flex-wrap gap-2 mb-3">
                    <a href="#" class="social-circle-link" title="Instagram"><i class="bi bi-instagram"></i></a>
                    <a href="#" class="social-circle-link" title="TikTok"><i class="bi bi-tiktok"></i></a>
                    <a href="#" class="social-circle-link" title="Facebook"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="social-circle-link" title="Twitter"><i class="bi bi-twitter-x"></i></a>
                    <a href="#" class="social-circle-link" title="Pinterest"><i class="bi bi-pinterest"></i></a>
                </div>
                <div class="small text-white-50">
                    Join our reader discussions across socials.
                </div>
            </div>

            <!-- Newsletter -->
            <div class="col-lg-4 col-md-6">
                <div class="footer-heading">Newsletter</div>
                <p class="small text-white-50 mb-3">
                    Get story updates, new releases, and literary insights directly to your inbox.
                </p>
                <form onsubmit="event.preventDefault(); alert('Thank you for subscribing to Chapter One!');">
                    <div class="newsletter-input-group shadow-sm">
                        <input type="email" class="newsletter-input" placeholder="Your email address" required>
                        <button type="submit" class="newsletter-btn">
                            <i class="bi bi-send-fill text-white"></i>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="footer-bottom-bar d-flex flex-wrap justify-content-between align-items-center">
            <div>
                &copy; 2026 Chapter One – Online Bookstore. All rights reserved.
            </div>
            <div>
                Crafted with love for book lovers &bull; Chapter One – Online Bookstore
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Application JS -->
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
