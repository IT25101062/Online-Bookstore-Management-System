<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="common/header.jsp"/>
<jsp:include page="common/navbar.jsp"/>
<jsp:include page="common/alerts.jsp"/>

<main class="container my-4">
    <!-- Hero Banner -->
    <div class="hero-banner p-5 mb-5 rounded-4 shadow-sm">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-semibold mb-3">
                    <i class="bi bi-mortarboard-fill me-1"></i> SE1020 Object Oriented Programming Project
                </span>
                <h1 class="display-4 fw-extrabold text-white mb-3">Welcome to ReadVerse</h1>
                <p class="lead text-light mb-4" style="max-width: 650px;">
                    A comprehensive, file-persisted Online Bookstore Management System built with Java OOP concepts:
                    Encapsulation, Inheritance, Polymorphism, and Abstraction.
                </p>
                <div class="d-flex flex-wrap gap-2">
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-primary btn-lg rounded-pill px-4">
                        <i class="bi bi-book me-2"></i> Browse Catalog
                    </a>
                    <a href="${pageContext.request.contextPath}/books/search" class="btn btn-outline-light btn-lg rounded-pill px-4">
                        <i class="bi bi-search me-2"></i> Search Books
                    </a>
                    <c:if test="${sessionScope.currentUser == null}">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-warning btn-lg rounded-pill px-4 fw-semibold text-dark">
                            <i class="bi bi-box-arrow-in-right me-2"></i> Try Demo Login
                        </a>
                    </c:if>
                </div>
            </div>
            <div class="col-lg-4 text-center d-none d-lg-block">
                <div class="p-4 rounded-4" style="background: rgba(255, 255, 255, 0.08); backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.15);">
                    <i class="bi bi-book-half display-1 text-warning mb-2"></i>
                    <h5 class="text-white fw-bold">6 OOP Components</h5>
                    <p class="text-light small mb-0">Users • Books • Cart • Orders • Categories • Reviews</p>
                </div>
            </div>
        </div>
    </div>

    <!-- OOP Principles Showcase Strip -->
    <div class="card border-0 shadow-sm rounded-4 mb-5 p-4 bg-white">
        <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
            <i class="bi bi-cpu-fill text-primary"></i> Object-Oriented Programming (OOP) Architecture
        </h5>
        <div class="row g-3">
            <div class="col-md-3">
                <div class="p-3 rounded-3 bg-light h-100 border">
                    <span class="badge bg-primary mb-2">Encapsulation</span>
                    <h6 class="fw-bold mb-1">Information Hiding</h6>
                    <p class="text-muted small mb-0">Private fields, getter/setter validation, password masking in <code>User</code>, <code>Book</code>, <code>Order</code>, <code>Review</code>.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-3 rounded-3 bg-light h-100 border">
                    <span class="badge bg-success mb-2">Inheritance</span>
                    <h6 class="fw-bold mb-1">Class Hierarchies</h6>
                    <p class="text-muted small mb-0"><code>AdminUser</code> & <code>CustomerUser</code> extend <code>User</code>; <code>EBook</code> & <code>PrintedBook</code> extend <code>Book</code>; <code>CardPayment</code> extends <code>Payment</code>.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-3 rounded-3 bg-light h-100 border">
                    <span class="badge bg-warning text-dark mb-2">Polymorphism</span>
                    <h6 class="fw-bold mb-1">Dynamic Dispatch</h6>
                    <p class="text-muted small mb-0">Dynamic pricing calculation (<code>calculateFinalPrice()</code>), authentication roles, discount algorithms, and payment execution.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-3 rounded-3 bg-light h-100 border">
                    <span class="badge bg-info text-dark mb-2">Abstraction</span>
                    <h6 class="fw-bold mb-1">Clean Contracts</h6>
                    <p class="text-muted small mb-0">Abstract base classes (<code>Book</code>, <code>User</code>, <code>Payment</code>, <code>Review</code>) and interfaces (<code>StockValidator</code>, <code>DiscountStrategy</code>).</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Featured Categories -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="fw-bold m-0"><i class="bi bi-tags me-2 text-primary"></i> Browse by Category</h4>
        <a href="${pageContext.request.contextPath}/categories" class="text-decoration-none fw-semibold">View All <i class="bi bi-arrow-right"></i></a>
    </div>
    <div class="row g-3 mb-5">
        <c:forEach items="${categories}" var="cat">
            <div class="col-6 col-md-4 col-lg-2">
                <a href="${pageContext.request.contextPath}/books?category=${cat.categoryName}" class="card text-decoration-none text-center p-3 h-100 content-card border">
                    <div class="mb-2"><i class="bi ${cat.iconName} fs-2 text-primary"></i></div>
                    <h6 class="fw-bold text-dark mb-1 text-truncate">${cat.categoryName}</h6>
                    <small class="text-muted">Explore &rarr;</small>
                </a>
            </div>
        </c:forEach>
    </div>

    <!-- Featured Books -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="fw-bold m-0"><i class="bi bi-stars me-2 text-warning"></i> Featured Books</h4>
        <a href="${pageContext.request.contextPath}/books" class="text-decoration-none fw-semibold">View Catalog <i class="bi bi-arrow-right"></i></a>
    </div>

    <div class="row g-4 mb-5">
        <c:forEach items="${featuredBooks}" var="book">
            <div class="col-md-6 col-lg-3">
                <div class="card h-100 book-card">
                    <div class="book-cover-placeholder position-relative">
                        <i class="bi bi-book fs-1"></i>
                        <span class="position-absolute top-0 end-0 m-2 badge ${book.bookType == 'EBOOK' ? 'badge-ebook' : 'badge-printed'}">
                            ${book.bookType}
                        </span>
                    </div>
                    <div class="card-body d-flex flex-column p-3">
                        <span class="text-muted small text-uppercase fw-semibold">${book.category}</span>
                        <h6 class="card-title fw-bold text-dark mt-1 mb-1 text-truncate" title="${book.title}">${book.title}</h6>
                        <small class="text-secondary mb-2">By ${book.author}</small>
                        <p class="small text-muted mb-3 flex-grow-1" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                            ${book.description}
                        </p>
                        
                        <div class="mb-2">
                            <small class="text-muted">${book.getFormatDetails()}</small>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mt-auto pt-2 border-top">
                            <span class="fs-5 fw-bold text-primary">
                                $<fmt:formatNumber value="${book.calculateFinalPrice()}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                            </span>
                            <div class="d-flex gap-1">
                                <a href="${pageContext.request.contextPath}/books/view?id=${book.bookId}" class="btn btn-outline-secondary btn-sm rounded-pill">
                                    Details
                                </a>
                                <c:if test="${book.isInStock()}">
                                    <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-inline">
                                        <input type="hidden" name="bookId" value="${book.bookId}">
                                        <input type="hidden" name="quantity" value="1">
                                        <button type="submit" class="btn btn-primary btn-sm rounded-pill">
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
    </div>

    <!-- Quick Demo Accounts Helper -->
    <div class="alert alert-secondary border rounded-4 p-4 shadow-sm">
        <h6 class="fw-bold mb-2"><i class="bi bi-info-circle-fill text-primary me-2"></i> Demonstration Credentials (SE1020 Evaluation)</h6>
        <div class="row">
            <div class="col-md-6 mb-2 mb-md-0">
                <strong>Admin Account:</strong> Username: <code>admin</code> | Password: <code>admin123</code> (Access to full Admin Portal, CRUD operations, Stock edits, and Moderation)
            </div>
            <div class="col-md-6">
                <strong>Customer Account:</strong> Username: <code>john_doe</code> | Password: <code>password123</code> (Gold Member tier with 10% discount, Shopping Cart, and Orders)
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp"/>
