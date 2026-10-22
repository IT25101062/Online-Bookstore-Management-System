<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container py-5">
    <!-- Breadcrumbs -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" style="color:#c49a6c; text-decoration:none;">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page" style="color:#786670;">Community Reviews & Ratings</li>
        </ol>
    </nav>

    <!-- Header Section -->
    <div class="row align-items-center mb-5">
        <div class="col-lg-8">
            <span class="badge px-3 py-2 rounded-pill mb-2" style="background:rgba(196,154,108,0.18); color:#8c5b1c; border:1px solid rgba(196,154,108,0.35);">
                <i class="bi bi-chat-heart-fill me-1"></i> Genuine Reader Community
            </span>
            <h1 class="display-5 fw-bold" style="font-family:'Playfair Display',serif; color:#240e18;">
                Chapter One Reviews
            </h1>
            <p class="lead" style="color:#6e5c66;">
                Honest feedback, ratings, and literary impressions shared by our valued book club members and book lovers.
            </p>
        </div>
        <div class="col-lg-4 text-lg-end">
            <a href="#submitReview" class="btn btn-plum btn-lg shadow-sm px-4">
                <i class="bi bi-pencil-square me-1"></i> Write a Review
            </a>
        </div>
    </div>

    <!-- Alert Messages -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show rounded-4 mb-4" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> ${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show rounded-4 mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Content Grid -->
    <div class="row g-4">
        <!-- Review Submission Card -->
        <div class="col-lg-4 order-lg-2">
            <div id="submitReview" class="card border-0 shadow-sm rounded-4 p-4 sticky-top" style="background:#fff; border:1px solid #ede3da !important; top: 100px;">
                <h4 class="fw-bold mb-3" style="font-family:'Playfair Display',serif; color:#240e18;">
                    <i class="bi bi-feather me-2" style="color:#c49a6c;"></i>Share Your Experience
                </h4>
                <p class="small text-muted mb-4">
                    Have you read one of our books? Tell our readers what you thought of it!
                </p>

                <form action="${pageContext.request.contextPath}/reviews/add" method="post">
                    <!-- Book Selection -->
                    <div class="mb-3">
                        <c:choose>
                            <c:when test="${book != null}">
                                <label for="selectedBookTitle" class="form-label small fw-semibold" style="color:#4a3b43;">Selected Book</label>
                                <input type="hidden" name="bookId" value="${book.bookId}">
                                <input type="text" id="selectedBookTitle" class="form-control" value="${book.title} (by ${book.author})" readonly style="background:#f4ece1; border-color:#ede3da;">
                            </c:when>
                            <c:otherwise>
                                <label for="bookIdSelect" class="form-label small fw-semibold" style="color:#4a3b43;">Select Book</label>
                                <select class="form-select" id="bookIdSelect" name="bookId" required style="border-color:#ede3da;">
                                    <option value="" disabled selected>-- Choose a book --</option>
                                    <c:forEach var="b" items="${books}">
                                        <option value="${b.bookId}">${b.title} - ${b.author}</option>
                                    </c:forEach>
                                </select>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Rating -->
                    <div class="mb-3">
                        <label class="form-label small fw-semibold" style="color:#4a3b43;">Your Rating</label>
                        <div class="d-flex flex-wrap gap-2">
                            <label class="btn btn-sm btn-outline-warning text-dark border d-flex align-items-center gap-1">
                                <input type="radio" name="rating" value="5" checked> 5 Stars
                            </label>
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

                    <!-- Reviewer Name -->
                    <c:choose>
                        <c:when test="${sessionScope.currentUser != null}">
                            <div class="mb-3">
                                <label for="reviewerLoggedIn" class="form-label small fw-semibold" style="color:#4a3b43;">Reviewer</label>
                                <input type="text" id="reviewerLoggedIn" class="form-control" value="${sessionScope.currentUser.fullName}" readonly style="background:#f4ece1; border-color:#ede3da;">
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="mb-3">
                                <label for="authorName" class="form-label small fw-semibold" style="color:#4a3b43;">Your Name</label>
                                <input type="text" class="form-control" id="authorName" name="reviewerName" placeholder="e.g., Emily Watson" required style="border-color:#ede3da;">
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Review Text -->
                    <div class="mb-3">
                        <label for="reviewContent" class="form-label small fw-semibold" style="color:#4a3b43;">Your Review</label>
                        <textarea class="form-control" id="reviewContent" name="reviewText" rows="4" placeholder="Share your experience, favourite parts, and who you'd recommend this book to..." required style="border-color:#ede3da;"></textarea>
                    </div>

                    <button type="submit" class="btn btn-plum w-100 py-2">
                        <i class="bi bi-send-fill me-1"></i> Post Review
                    </button>
                </form>
            </div>
        </div>

        <!-- Reviews List -->
        <div class="col-lg-8 order-lg-1">
            <c:choose>
                <c:when test="${not empty reviews}">
                    <div class="d-flex flex-column gap-3">
                        <c:forEach var="rev" items="${reviews}">
                            <div class="card border-0 shadow-sm rounded-4 p-4" style="background:#fff; border:1px solid #ede3da !important; transition: transform 0.2s ease;">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="rounded-circle d-flex align-items-center justify-content-center text-white fw-bold shadow-sm" style="width:48px; height:48px; background:linear-gradient(135deg, #240e18, #602b43); font-size:1.2rem; min-width:48px;">
                                            ${rev.avatarInitial}
                                        </div>
                                        <div>
                                            <div class="fw-bold fs-6" style="color:#240e18 !important;">${rev.reviewerName}</div>
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
                                    <div class="text-warning fs-5">
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
                                <div class="mb-2">
                                    <a href="<c:url value='/books/view'><c:param name='id' value='${rev.bookId}'/></c:url>" class="badge text-decoration-none px-2 py-1" style="background:#f4ece1; color:#602b43; border: 1px solid #ede3da;">
                                        <i class="bi bi-book me-1"></i>Book Ref: ${rev.bookId}
                                    </a>
                                </div>
                                <p class="mb-0 pt-2" style="color:#2c121e !important; line-height:1.65; font-size:1.02rem;">
                                    &ldquo;${rev.reviewText}&rdquo;
                                </p>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="p-5 text-center rounded-4 shadow-sm" style="background:#fff; border: 1px dashed #d1c4bb;">
                        <i class="bi bi-chat-heart display-3 mb-3 d-block" style="color:#c49a6c;"></i>
                        <h4 class="fw-bold" style="color:#240e18;">No Reviews Yet</h4>
                        <p class="text-muted mb-3">Be the first to share your thoughts on a book in our collection!</p>
                        <a href="#submitReview" class="btn btn-plum px-4">Submit the First Review</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
