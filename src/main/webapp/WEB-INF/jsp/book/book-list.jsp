<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-bookshelf text-primary me-2"></i>Books Catalog</h2>
            <p class="text-muted small mb-0">Browse through our collection of physical editions and digital e-books</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/books/search" class="btn btn-outline-primary rounded-pill px-3">
                <i class="bi bi-search me-1"></i> Filter & Search
            </a>
            <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.hasAdminPrivileges()}">
                <a href="${pageContext.request.contextPath}/books/add" class="btn btn-success rounded-pill px-3">
                    <i class="bi bi-plus-circle me-1"></i> Add New Book
                </a>
            </c:if>
        </div>
    </div>

    <!-- Category Pills -->
    <div class="d-flex flex-wrap gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/books" class="btn btn-sm ${empty selectedCategory ? 'btn-primary' : 'btn-outline-secondary'} rounded-pill px-3">
            All Categories
        </a>
        <a href="${pageContext.request.contextPath}/books?category=Technology" class="btn btn-sm ${selectedCategory == 'Technology' ? 'btn-primary' : 'btn-outline-secondary'} rounded-pill px-3">
            Technology
        </a>
        <a href="${pageContext.request.contextPath}/books?category=Fiction" class="btn btn-sm ${selectedCategory == 'Fiction' ? 'btn-primary' : 'btn-outline-secondary'} rounded-pill px-3">
            Fiction
        </a>
        <a href="${pageContext.request.contextPath}/books?category=Business" class="btn btn-sm ${selectedCategory == 'Business' ? 'btn-primary' : 'btn-outline-secondary'} rounded-pill px-3">
            Business
        </a>
        <a href="${pageContext.request.contextPath}/books?category=Self-Help" class="btn btn-sm ${selectedCategory == 'Self-Help' ? 'btn-primary' : 'btn-outline-secondary'} rounded-pill px-3">
            Self-Help
        </a>
        <a href="${pageContext.request.contextPath}/books?category=Science" class="btn btn-sm ${selectedCategory == 'Science' ? 'btn-primary' : 'btn-outline-secondary'} rounded-pill px-3">
            Science
        </a>
    </div>

    <!-- Books Grid -->
    <div class="row g-4">
        <c:forEach items="${books}" var="book">
            <div class="col-md-6 col-lg-3">
                <div class="card h-100 book-card border">
                    <div class="book-cover-placeholder position-relative">
                        <i class="bi bi-journal-bookmark fs-1"></i>
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
                            <i class="bi bi-info-circle me-1"></i> ${book.getFormatDetails()}
                        </div>

                        <div class="d-flex justify-content-between align-items-center mt-auto pt-2 border-top">
                            <div>
                                <span class="fs-5 fw-bold text-primary">
                                    $<fmt:formatNumber value="${book.calculateFinalPrice()}" minFractionDigits="2" maxFractionDigits="2"/>
                                </span>
                                <c:if test="${book.bookType == 'PRINTED' && book.calculateFinalPrice() != book.basePrice}">
                                    <small class="text-muted d-block" style="font-size: 0.7rem;">(incl. packaging)</small>
                                </c:if>
                            </div>
                            <div class="d-flex gap-1">
                                <a href="${pageContext.request.contextPath}/books/view?id=${book.bookId}" class="btn btn-outline-secondary btn-sm rounded-pill">
                                    Details
                                </a>
                                <c:choose>
                                    <c:when test="${book.isInStock()}">
                                        <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-inline">
                                            <input type="hidden" name="bookId" value="${book.bookId}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit" class="btn btn-primary btn-sm rounded-pill" title="Add to Cart">
                                                <i class="bi bi-cart-plus"></i>
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger align-self-center">Out of Stock</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty books}">
            <div class="col-12 text-center py-5">
                <i class="bi bi-journal-x display-4 text-muted d-block mb-3"></i>
                <h5>No books found</h5>
                <p class="text-muted">No books currently match this category filter.</p>
                <a href="${pageContext.request.contextPath}/books" class="btn btn-primary rounded-pill">View All Books</a>
            </div>
        </c:if>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
