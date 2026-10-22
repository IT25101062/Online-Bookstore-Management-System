<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" style="color:#c49a6c; text-decoration:none;">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/books" style="color:#c49a6c; text-decoration:none;">Books</a></li>
            <li class="breadcrumb-item active" aria-current="page" style="color:#786670;">${book.title}</li>
        </ol>
    </nav>

    <div class="row g-5">
        <!-- Book Visual Column -->
        <div class="col-md-5">
            <div class="card border-0 rounded-4 overflow-hidden bg-white text-center p-4" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="rounded-4 mb-4 overflow-hidden position-relative shadow-sm"
                     style="background: linear-gradient(135deg, #240e18 0%, #361724 55%, #502538 100%); min-height: 320px; border: 1px solid rgba(196,154,108,0.25); display: flex; align-items: center; justify-content: center;">
                    <c:choose>
                        <c:when test="${not empty book.imageUrl}">
                            <img src="${book.imageUrl}" alt="${book.title}" style="width: 100%; max-height: 420px; object-fit: contain; background: #240e18;"
                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                            <div class="p-5 text-white flex-column align-items-center justify-content-center text-center" style="display: none;">
                                <i class="bi bi-book-half display-1 mb-3" style="color:#dfb990;"></i>
                                <h5 class="fw-bold px-3" style="font-family:'Playfair Display',serif; color:#fff;">${book.title}</h5>
                                <small style="color:rgba(255,255,255,0.7);">${book.author}</small>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="p-5 text-white d-flex flex-column align-items-center justify-content-center text-center">
                                <i class="bi bi-book-half display-1 mb-3" style="color:#dfb990;"></i>
                                <h5 class="fw-bold px-3" style="font-family:'Playfair Display',serif; color:#fff;">${book.title}</h5>
                                <small style="color:rgba(255,255,255,0.7);">${book.author}</small>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="d-flex justify-content-center gap-2 mb-3">
                    <span class="badge ${book.bookType == 'EBOOK' ? 'badge-ebook' : 'badge-printed'} px-3 py-2 rounded-pill fs-6">
                        ${book.bookType} Edition
                    </span>
                    <span class="badge px-3 py-2 rounded-pill fs-6" style="background:rgba(196,154,108,0.15); color:#8c5b1c; border:1px solid rgba(196,154,108,0.35);">
                        ${book.category}
                    </span>
                </div>

                <!-- Store Quality Guarantee -->
                <div class="p-3 rounded-3 text-start small" style="background:#fbf8f3; border:1px solid #ede3da;">
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <i class="bi bi-patch-check-fill" style="color:#c49a6c; font-size:1.2rem;"></i>
                        <span class="fw-semibold" style="color:#240e18;">Chapter One Guarantee</span>
                    </div>
                    <div style="color:#786670;">
                        100% Genuine, hand-inspected edition with instant reader support & fast delivery.
                    </div>
                </div>
            </div>
        </div>

        <!-- Book Details Column -->
        <div class="col-md-7">
            <span class="small text-uppercase fw-semibold" style="color:#c49a6c; letter-spacing:1px;">${book.category}</span>
            <h1 class="display-6 fw-bold mt-1 mb-2" style="font-family:'Playfair Display',serif; color:#240e18;">${book.title}</h1>
            <h5 class="mb-4" style="color:#786670;">By <span class="fw-semibold" style="color:#240e18;">${book.author}</span></h5>

            <!-- Pricing Box -->
            <div class="p-4 rounded-4 mb-4" style="background:#fbf8f3; border:1px solid #ede3da;">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="small d-block" style="color:#786670;">Retail Price:</span>
                        <span class="display-6 fw-bold" style="font-family:'Playfair Display',serif; color:#240e18;">
                            Rs. <fmt:formatNumber value="${book.calculateFinalPrice()}" minFractionDigits="2" maxFractionDigits="2"/>
                        </span>
                        <c:if test="${book.bookType == 'PRINTED'}">
                            <span class="small ms-2" style="color:#786670;">(Base: Rs. <fmt:formatNumber value="${book.basePrice}" minFractionDigits="2"/> + Packaging)</span>
                        </c:if>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${book.isInStock()}">
                                <span class="badge px-3 py-2 rounded-pill" style="background:rgba(76,174,76,0.12); color:#2d8a2d; border:1px solid rgba(76,174,76,0.3);">
                                    <i class="bi bi-check-circle me-1"></i> In Stock (${book.stockQuantity} available)
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge px-3 py-2 rounded-pill" style="background:rgba(200,0,0,0.1); color:#a02020; border:1px solid rgba(200,0,0,0.25);">
                                    <i class="bi bi-x-circle me-1"></i> Out of Stock
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Description -->
            <h5 class="fw-bold mb-2" style="font-family:'Playfair Display',serif; color:#240e18;">Description</h5>
            <p class="leading-relaxed mb-4" style="color:#4a3b43; line-height:1.7;">${book.description}</p>

            <!-- Specification Table -->
            <h5 class="fw-bold mb-2" style="font-family:'Playfair Display',serif; color:#240e18;">Specification & Format</h5>
            <table class="table table-bordered mb-4 small" style="border-color:#ede3da;">
                <tbody>
                    <tr>
                        <th style="background:#f9f4ef; color:#786670; width: 35%;">Book ID</th>
                        <td><code>${book.bookId}</code></td>
                    </tr>
                    <tr>
                        <th style="background:#f9f4ef; color:#786670;">ISBN</th>
                        <td>${book.isbn}</td>
                    </tr>
                    <tr>
                        <th style="background:#f9f4ef; color:#786670;">Format Details</th>
                        <td><strong>${book.getFormatDetails()}</strong></td>
                    </tr>
                </tbody>
            </table>

            <!-- Add to Cart Form -->
            <div class="d-flex flex-wrap gap-3 align-items-center pt-3" style="border-top:1px solid #f0e8e0;">
                <c:choose>
                    <c:when test="${book.isInStock()}">
                        <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-flex gap-2">
                            <input type="hidden" name="bookId" value="${book.bookId}">
                            <input type="number" name="quantity" value="1" min="1" max="${book.stockQuantity}" class="form-control" style="width: 90px; border-color:#ede3da;" required>
                            <button type="submit" class="btn btn-plum btn-lg px-4">
                                <i class="bi bi-cart-plus me-1"></i> Add to Cart
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-outline-plum btn-lg px-4" disabled>
                            Currently Unavailable
                        </button>
                    </c:otherwise>
                </c:choose>

                <!-- Reviews Link / Button -->
                <a href="#reviewsSection" class="btn btn-outline-plum btn-lg px-4">
                    <i class="bi bi-star-fill me-1" style="color:#c49a6c;"></i> Customer Reviews (${reviewCount != null ? reviewCount : 0})
                </a>

                <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.hasAdminPrivileges()}">
                    <a href="${pageContext.request.contextPath}/books/edit?id=${book.bookId}" class="btn btn-outline-plum btn-lg px-3">
                        <i class="bi bi-pencil me-1"></i> Edit Book
                    </a>
                    <form action="${pageContext.request.contextPath}/books/delete" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this book?');">
                        <input type="hidden" name="bookId" value="${book.bookId}">
                        <button type="submit" class="btn btn-outline-danger btn-lg px-3">
                            <i class="bi bi-trash me-1"></i> Delete
                        </button>
                    </form>
                </c:if>
            </div>
        </div>
    </div>

    <!-- ========================================================================= -->
    <!-- CUSTOMER REVIEWS & RATINGS SECTION -->
    <!-- ========================================================================= -->
    <div id="reviewsSection" class="mt-5 pt-4" style="border-top: 2px solid #ede3da;">
        <div class="row g-4">
            <!-- Review Summary & Add Review Form -->
            <div class="col-lg-5">
                <div class="card border-0 shadow-sm rounded-4 p-4 mb-4" style="background:#fff; border:1px solid #ede3da !important;">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h4 class="fw-bold mb-0" style="font-family:'Playfair Display',serif; color:#240e18;">
                            Customer Reviews
                        </h4>
                        <span class="badge rounded-pill px-3 py-2" style="background:rgba(196,154,108,0.15); color:#8c5b1c; font-size:0.9rem;">
                            ${reviewCount} ${reviewCount == 1 ? 'Review' : 'Reviews'}
                        </span>
                    </div>

                    <!-- Overall Rating Display -->
                    <div class="p-3 rounded-3 text-center mb-4" style="background:#fbf8f3; border:1px solid #ede3da;">
                        <div class="display-5 fw-bold" style="font-family:'Playfair Display',serif; color:#240e18;">
                            <fmt:formatNumber value="${averageRating}" minFractionDigits="1" maxFractionDigits="1"/>
                            <span class="fs-5 text-muted">/ 5.0</span>
                        </div>
                        <div class="text-warning fs-5 my-1">
                            <c:forEach var="i" begin="1" end="5">
                                <c:choose>
                                    <c:when test="${i <= averageRating}">
                                        <i class="bi bi-star-fill text-warning"></i>
                                    </c:when>
                                    <c:when test="${i - 0.5 <= averageRating}">
                                        <i class="bi bi-star-half text-warning"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-star text-muted" style="opacity:0.4;"></i>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                        <small style="color:#786670;">Based on reader ratings across the store</small>
                    </div>

                    <!-- Add Review Form -->
                    <div class="pt-2">
                        <h5 class="fw-bold mb-3" style="font-family:'Playfair Display',serif; color:#240e18;">
                            <i class="bi bi-pencil-square me-2" style="color:#c49a6c;"></i>Write a Review
                        </h5>
                        <form action="${pageContext.request.contextPath}/reviews/add" method="post">
                            <input type="hidden" name="bookId" value="${book.bookId}">

                            <div class="mb-3">
                                <label class="form-label small fw-semibold" style="color:#4a3b43;">Your Rating</label>
                                <div class="rating-picker d-flex gap-2">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="rating" id="rate5" value="5" checked>
                                        <label class="form-check-label small" for="rate5">⭐⭐⭐⭐⭐ (5/5)</label>
                                    </div>
                                </div>
                                <div class="d-flex flex-wrap gap-2 mt-2">
                                    <label class="btn btn-sm btn-outline-warning text-dark border d-flex align-items-center gap-1">
                                        <input type="radio" name="rating" value="4"> 4 Stars
                                    </label>
                                    <label class="btn btn-sm btn-outline-warning text-dark border d-flex align-items-center gap-1">
                                        <input type="radio" name="rating" value="3"> 3 Stars
                                    </label>
                                    <label class="btn btn-sm btn-outline-warning text-dark border d-flex align-items-center gap-1">
                                        <input type="radio" name="rating" value="2"> 2 Stars
                                    </label>
                                    <label class="btn btn-sm btn-outline-warning text-dark border d-flex align-items-center gap-1">
                                        <input type="radio" name="rating" value="1"> 1 Star
                                    </label>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${sessionScope.currentUser != null}">
                                    <div class="mb-3">
                                        <label class="form-label small fw-semibold" style="color:#4a3b43;">Reviewer</label>
                                        <input type="text" class="form-control" value="${sessionScope.currentUser.fullName} (${sessionScope.currentUser.role})" readonly style="background:#f4ece1; border-color:#ede3da;">
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="mb-3">
                                        <label for="reviewerName" class="form-label small fw-semibold" style="color:#4a3b43;">Your Name</label>
                                        <input type="text" class="form-control" id="reviewerName" name="reviewerName" placeholder="e.g., Sarah Fernando" required style="border-color:#ede3da;">
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <div class="mb-3">
                                <label for="reviewText" class="form-label small fw-semibold" style="color:#4a3b43;">Your Thoughts & Recommendation</label>
                                <textarea class="form-control" id="reviewText" name="reviewText" rows="3" placeholder="What did you love about this book? How was the writing style or plot?" required style="border-color:#ede3da;"></textarea>
                            </div>

                            <button type="submit" class="btn btn-plum w-100 py-2">
                                <i class="bi bi-send-fill me-1"></i> Submit Review
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- List of Reviews -->
            <div class="col-lg-7">
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <h5 class="fw-bold mb-0" style="font-family:'Playfair Display',serif; color:#240e18;">
                        Reader Experiences (${reviewCount})
                    </h5>
                    <a href="${pageContext.request.contextPath}/reviews" class="small text-decoration-none fw-semibold" style="color:#c49a6c;">
                        View all Chapter One reviews <i class="bi bi-arrow-right"></i>
                    </a>
                </div>

                <c:choose>
                    <c:when test="${not empty reviews}">
                        <div class="d-flex flex-column gap-3">
                            <c:forEach var="rev" items="${reviews}">
                                <div class="card border-0 shadow-sm rounded-4 p-4" style="background:#fff; border:1px solid #ede3da !important; transition: transform 0.2s ease;">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="rounded-circle d-flex align-items-center justify-content-center text-white fw-bold shadow-sm" style="width:44px; height:44px; background:linear-gradient(135deg, #240e18, #602b43); font-size:1.15rem; min-width:44px;">
                                                ${rev.avatarInitial}
                                            </div>
                                            <div>
                                                <div class="fw-bold" style="color:#240e18 !important; font-size:1.02rem;">${rev.reviewerName}</div>
                                                <div class="small d-flex align-items-center gap-2" style="color:#786670;">
                                                    <span><i class="bi bi-calendar3 me-1"></i>${rev.reviewDate}</span>
                                                    <c:if test="${rev.reviewType == 'VERIFIED'}">
                                                        <span class="badge rounded-pill" style="background:rgba(76,174,76,0.15); color:#2d8a2d; font-size:0.75rem;">
                                                            <i class="bi bi-patch-check-fill me-1"></i>Verified Buyer
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="text-warning fs-6">
                                            <c:forEach var="i" begin="1" end="5">
                                                <c:choose>
                                                    <c:when test="${i <= rev.rating}">
                                                        <i class="bi bi-star-fill text-warning"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="bi bi-star text-muted" style="opacity:0.35;"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <p class="mb-0 pt-2" style="color:#2c121e !important; line-height:1.65; font-size:0.98rem;">
                                        &ldquo;${rev.reviewText}&rdquo;
                                    </p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="p-5 text-center rounded-4 shadow-sm" style="background:#fff; border: 1px dashed #d1c4bb;">
                            <i class="bi bi-chat-heart display-4 mb-3 d-block" style="color:#c49a6c;"></i>
                            <h5 class="fw-bold" style="color:#240e18;">Be the First to Review!</h5>
                            <p class="text-muted small mb-0">No reviews have been submitted for this book yet. Share your literary opinion using the form on the left.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
