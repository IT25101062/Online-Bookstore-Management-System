<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/books">Books</a></li>
            <li class="breadcrumb-item active" aria-current="page">${book.title}</li>
        </ol>
    </nav>

    <div class="row g-5">
        <!-- Book Visual Column -->
        <div class="col-md-5">
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white text-center p-4">
                <div class="p-5 rounded-4 mb-4 text-white d-flex flex-column align-items-center justify-content-center" style="background: linear-gradient(135deg, #1e293b 0%, #334155 100%); min-height: 280px;">
                    <i class="bi bi-book-half display-1 text-primary mb-3"></i>
                    <h5 class="fw-bold px-3">${book.title}</h5>
                    <small class="text-secondary">${book.author}</small>
                </div>

                <div class="d-flex justify-content-center gap-2 mb-3">
                    <span class="badge ${book.bookType == 'EBOOK' ? 'badge-ebook' : 'badge-printed'} px-3 py-2 rounded-pill fs-6">
                        ${book.bookType} Edition
                    </span>
                    <span class="badge bg-secondary-subtle text-secondary px-3 py-2 rounded-pill fs-6">
                        ${book.category}
                    </span>
                </div>

                <!-- OOP Badge -->
                <div class="p-3 bg-light rounded-3 text-start small border">
                    <span class="oop-badge mb-1">OOP Hierarchy</span>
                    <div class="text-muted">
                        Subclass <code>${book.getClass().getSimpleName()}</code> inheriting from abstract <code>Book</code>.
                    </div>
                </div>
            </div>
        </div>

        <!-- Book Details Column -->
        <div class="col-md-7">
            <span class="text-uppercase text-muted fw-semibold small tracking-wider">${book.category}</span>
            <h1 class="display-6 fw-bold text-dark mt-1 mb-2">${book.title}</h1>
            <h5 class="text-secondary mb-4">By <span class="text-dark fw-semibold">${book.author}</span></h5>

            <!-- Pricing Box -->
            <div class="p-4 rounded-4 bg-light border mb-4">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small d-block">Calculated Price (Polymorphic):</span>
                        <span class="display-6 fw-bold text-primary">
                            $<fmt:formatNumber value="${book.calculateFinalPrice()}" minFractionDigits="2" maxFractionDigits="2"/>
                        </span>
                        <c:if test="${book.bookType == 'PRINTED'}">
                            <span class="text-muted small ms-2">(Base: $<fmt:formatNumber value="${book.basePrice}" minFractionDigits="2"/> + Packaging)</span>
                        </c:if>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${book.isInStock()}">
                                <span class="badge bg-success-subtle text-success border border-success px-3 py-2 rounded-pill">
                                    <i class="bi bi-check-circle me-1"></i> In Stock (${book.stockQuantity} available)
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger px-3 py-2 rounded-pill">
                                    <i class="bi bi-x-circle me-1"></i> Out of Stock
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Description -->
            <h5 class="fw-bold mb-2">Description</h5>
            <p class="text-secondary leading-relaxed mb-4">${book.description}</p>

            <!-- Specification Table -->
            <h5 class="fw-bold mb-2">Specification & Format</h5>
            <table class="table table-bordered mb-4 small">
                <tbody>
                    <tr>
                        <th class="bg-light" style="width: 35%;">Book ID</th>
                        <td><code>${book.bookId}</code></td>
                    </tr>
                    <tr>
                        <th class="bg-light">ISBN</th>
                        <td>${book.isbn}</td>
                    </tr>
                    <tr>
                        <th class="bg-light">Format Details</th>
                        <td><strong>${book.getFormatDetails()}</strong></td>
                    </tr>
                </tbody>
            </table>

            <!-- Add to Cart Form -->
            <div class="d-flex flex-wrap gap-3 align-items-center pt-3 border-top">
                <c:choose>
                    <c:when test="${book.isInStock()}">
                        <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-flex gap-2">
                            <input type="hidden" name="bookId" value="${book.bookId}">
                            <input type="number" name="quantity" value="1" min="1" max="${book.stockQuantity}" class="form-control" style="width: 90px;" required>
                            <button type="submit" class="btn btn-primary btn-lg rounded-pill px-4">
                                <i class="bi bi-cart-plus me-1"></i> Add to Cart
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-secondary btn-lg rounded-pill px-4" disabled>
                            Currently Unavailable
                        </button>
                    </c:otherwise>
                </c:choose>

                <!-- Reviews Link -->
                <a href="${pageContext.request.contextPath}/reviews?bookId=${book.bookId}" class="btn btn-outline-secondary btn-lg rounded-pill px-4">
                    <i class="bi bi-star-fill text-warning me-1"></i> Customer Reviews
                </a>

                <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.hasAdminPrivileges()}">
                    <a href="${pageContext.request.contextPath}/books/edit?id=${book.bookId}" class="btn btn-outline-dark btn-lg rounded-pill px-3">
                        <i class="bi bi-pencil me-1"></i> Edit Book
                    </a>
                </c:if>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
