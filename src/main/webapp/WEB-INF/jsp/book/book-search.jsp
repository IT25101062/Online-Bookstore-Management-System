<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="mb-4">
        <h2 class="fw-bold mb-1"><i class="bi bi-search text-primary me-2"></i>Search & Filter Books</h2>
        <p class="text-muted small mb-0">Search across titles, authors, categories, ISBNs, and price ranges</p>
    </div>

    <!-- Filter Form -->
    <div class="card border-0 shadow-sm rounded-4 p-4 mb-5 bg-white">
        <form action="${pageContext.request.contextPath}/books/search" method="get">
            <div class="row g-3">
                <div class="col-md-5">
                    <label class="form-label fw-semibold">Search Keywords</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                        <input type="text" class="form-control" name="keyword" value="${keyword}" placeholder="Title, author, or ISBN...">
                    </div>
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-semibold">Category</label>
                    <select class="form-select" name="category">
                        <option value="ALL">All Categories</option>
                        <option value="Technology" ${category == 'Technology' ? 'selected' : ''}>Technology</option>
                        <option value="Fiction" ${category == 'Fiction' ? 'selected' : ''}>Fiction</option>
                        <option value="Business" ${category == 'Business' ? 'selected' : ''}>Business</option>
                        <option value="Self-Help" ${category == 'Self-Help' ? 'selected' : ''}>Self-Help</option>
                        <option value="Science" ${category == 'Science' ? 'selected' : ''}>Science</option>
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label fw-semibold">Min Price ($)</label>
                    <input type="number" step="0.01" class="form-control" name="minPrice" value="${minPrice}" placeholder="0.00">
                </div>

                <div class="col-md-2">
                    <label class="form-label fw-semibold">Max Price ($)</label>
                    <input type="number" step="0.01" class="form-control" name="maxPrice" value="${maxPrice}" placeholder="100.00">
                </div>

                <div class="col-12 d-flex justify-content-end gap-2 mt-3 pt-2 border-top">
                    <a href="${pageContext.request.contextPath}/books/search" class="btn btn-outline-secondary rounded-pill px-4">
                        Reset Filters
                    </a>
                    <button type="submit" class="btn btn-primary rounded-pill px-4 fw-semibold">
                        <i class="bi bi-filter me-1"></i> Apply Filters
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Search Results -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold m-0">Search Results (${books.size()} books found)</h5>
    </div>

    <div class="row g-4">
        <c:forEach items="${books}" var="book">
            <div class="col-md-6 col-lg-3">
                <div class="card h-100 book-card border">
                    <div class="book-cover-placeholder position-relative">
                        <i class="bi bi-journal-text fs-1"></i>
                        <span class="position-absolute top-0 end-0 m-2 badge ${book.bookType == 'EBOOK' ? 'badge-ebook' : 'badge-printed'}">
                            ${book.bookType}
                        </span>
                    </div>
                    <div class="card-body d-flex flex-column p-3">
                        <span class="badge bg-light text-secondary border align-self-start mb-2">${book.category}</span>
                        <h6 class="card-title fw-bold text-dark mb-1 text-truncate" title="${book.title}">${book.title}</h6>
                        <small class="text-secondary mb-2">By ${book.author}</small>
                        <p class="small text-muted mb-3 flex-grow-1" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                            ${book.description}
                        </p>

                        <div class="small text-muted mb-2">
                            ${book.getFormatDetails()}
                        </div>

                        <div class="d-flex justify-content-between align-items-center mt-auto pt-2 border-top">
                            <span class="fs-5 fw-bold text-primary">
                                $<fmt:formatNumber value="${book.calculateFinalPrice()}" minFractionDigits="2" maxFractionDigits="2"/>
                            </span>
                            <div class="d-flex gap-1">
                                <a href="${pageContext.request.contextPath}/books/view?id=${book.bookId}" class="btn btn-outline-secondary btn-sm rounded-pill">
                                    Details
                                </a>
                                <c:if test="${book.isInStock()}">
                                    <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-inline">
                                        <input type="hidden" name="bookId" value="${book.bookId}">
                                        <input type="hidden" name="quantity" value="1">
                                        <button type="submit" class="btn btn-primary btn-sm rounded-pill" title="Add to Cart">
                                            <i class="bi bi-cart-plus"></i>
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty books}">
            <div class="col-12 text-center py-5">
                <i class="bi bi-search display-4 text-muted d-block mb-3"></i>
                <h5>No books matched your criteria</h5>
                <p class="text-muted">Try adjusting your keyword or loosening the price filters.</p>
            </div>
        </c:if>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
