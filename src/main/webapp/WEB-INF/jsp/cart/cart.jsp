<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-cart3 text-primary me-2"></i>My Shopping Cart</h2>
            <p class="text-muted small mb-0">Persistent cart stored in <code>cart.txt</code> with live inventory validation</p>
        </div>
        <div class="d-flex gap-2">
            <span class="badge bg-primary-subtle text-primary border border-primary px-3 py-2 rounded-pill">
                CRUD: Add, Read, Update, Remove
            </span>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty cart.items}">
            <div class="row g-4">
                <!-- Cart Items Table -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white mb-3">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th class="ps-4">Item Details</th>
                                        <th>Format</th>
                                        <th>Unit Price</th>
                                        <th style="width: 170px;">Quantity</th>
                                        <th>Subtotal</th>
                                        <th class="text-end pe-4">Remove</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${cart.items}" var="item">
                                        <tr>
                                            <td class="ps-4">
                                                <div class="fw-bold text-dark">
                                                    <c:choose>
                                                        <c:when test="${item.book != null}">
                                                            ${item.book.title}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Book #${item.bookId}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <small class="text-muted">Item ID: <code>${item.cartItemId}</code> &bull; Added: ${item.addedDate}</small>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.book != null}">
                                                        <span class="badge ${item.book.bookType == 'EBOOK' ? 'badge-ebook' : 'badge-printed'}">
                                                            ${item.book.bookType}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Book</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                $<fmt:formatNumber value="${item.pricePerUnit}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/cart/update" method="post" class="d-flex align-items-center gap-1">
                                                    <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                                    <input type="number" name="quantity" value="${item.quantity}" min="1" max="99" class="form-control form-control-sm text-center" style="width: 65px;" required>
                                                    <button type="submit" class="btn btn-outline-primary btn-sm" title="Update Quantity">
                                                        <i class="bi bi-arrow-repeat"></i>
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/cart/update?cartItemId=${item.cartItemId}" class="btn btn-outline-secondary btn-sm" title="Detailed Update Page">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                </form>
                                            </td>
                                            <td class="fw-bold text-primary">
                                                $<fmt:formatNumber value="${item.getItemSubtotal()}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td class="text-end pe-4">
                                                <form action="${pageContext.request.contextPath}/cart/remove" method="post" class="d-inline" onsubmit="return confirmDelete('this cart item');">
                                                    <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                                    <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill" title="Remove Item">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between align-items-center">
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-outline-secondary rounded-pill px-3">
                            <i class="bi bi-arrow-left me-1"></i> Continue Browsing
                        </a>
                        <form action="${pageContext.request.contextPath}/cart/clear" method="post" onsubmit="return confirmDelete('all items from your shopping cart');">
                            <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3">
                                <i class="bi bi-trash3 me-1"></i> Clear Cart
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Order Summary Column -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                        <h5 class="fw-bold mb-3"><i class="bi bi-receipt text-primary me-2"></i>Order Summary</h5>

                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Total Quantity:</span>
                            <span class="fw-semibold">${cart.getTotalQuantity()} items</span>
                        </div>

                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Subtotal:</span>
                            <span class="fw-semibold">$<fmt:formatNumber value="${cart.getSubtotal()}" minFractionDigits="2" maxFractionDigits="2"/></span>
                        </div>

                        <!-- Polymorphic Discount -->
                        <div class="d-flex justify-content-between mb-3 text-success">
                            <span>
                                <i class="bi bi-tag-fill me-1"></i> ${cart.discountStrategy.getStrategyName()}:
                            </span>
                            <span class="fw-bold">-$<fmt:formatNumber value="${cart.getDiscountAmount(sessionScope.currentUser)}" minFractionDigits="2" maxFractionDigits="2"/></span>
                        </div>

                        <hr>

                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <span class="fs-5 fw-bold text-dark">Grand Total:</span>
                            <span class="fs-4 fw-extrabold text-primary">
                                $<fmt:formatNumber value="${cart.getGrandTotal(sessionScope.currentUser)}" minFractionDigits="2" maxFractionDigits="2"/>
                            </span>
                        </div>

                        <a href="${pageContext.request.contextPath}/cart/checkout-summary" class="btn btn-primary btn-lg rounded-pill w-100 fw-semibold mb-2">
                            <i class="bi bi-bag-check me-2"></i> Review Checkout
                        </a>

                        <!-- OOP Abstraction Info -->
                        <div class="p-3 bg-light rounded-3 small text-muted border mt-3">
                            <span class="oop-badge mb-1">OOP Strategy</span>
                            <div>
                                Active Strategy: <code>${cart.discountStrategy.getClass().getSimpleName()}</code>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white my-4">
                <i class="bi bi-cart-x display-3 text-muted mb-3"></i>
                <h4 class="fw-bold">Your shopping cart is empty</h4>
                <p class="text-muted mb-4">Discover our great selection of technology, fiction, and business books!</p>
                <div>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-primary btn-lg rounded-pill px-4">
                        <i class="bi bi-bookshelf me-2"></i> Explore Book Catalog
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="../common/footer.jsp"/>
