<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-lg rounded-4 overflow-hidden bg-white">
                <div class="bg-dark p-4 text-white d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="fw-bold mb-1"><i class="bi bi-shield-check text-success me-2"></i>Order & Checkout Summary</h4>
                        <small class="text-secondary">Review your cart before selecting payment method</small>
                    </div>
                    <span class="badge bg-info-subtle text-info border border-info px-3 py-2 rounded-pill">
                        Pre-Order Review
                    </span>
                </div>

                <div class="card-body p-4 p-md-5">
                    <h5 class="fw-bold mb-3">Item Breakdown</h5>
                    <div class="table-responsive mb-4">
                        <table class="table align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Item</th>
                                    <th>Format</th>
                                    <th class="text-center">Qty</th>
                                    <th class="text-end">Price</th>
                                    <th class="text-end">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${cart.items}" var="item">
                                    <tr>
                                        <td>
                                            <div class="fw-semibold text-dark">
                                                <c:choose>
                                                    <c:when test="${item.book != null}">${item.book.title}</c:when>
                                                    <c:otherwise>Book #${item.bookId}</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.book != null}">
                                                    <span class="badge ${item.book.bookType == 'EBOOK' ? 'badge-ebook' : 'badge-printed'}">
                                                        ${item.book.bookType}
                                                    </span>
                                                </c:when>
                                                <c:otherwise><span class="badge bg-secondary">Book</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">${item.quantity}</td>
                                        <td class="text-end">$<fmt:formatNumber value="${item.pricePerUnit}" minFractionDigits="2"/></td>
                                        <td class="text-end fw-bold">$<fmt:formatNumber value="${item.getItemSubtotal()}" minFractionDigits="2"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Financial Summary -->
                    <div class="p-4 bg-light rounded-4 border mb-4">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Cart Subtotal:</span>
                            <span class="fw-semibold">$<fmt:formatNumber value="${cart.getSubtotal()}" minFractionDigits="2"/></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2 text-success">
                            <span><i class="bi bi-tag-fill me-1"></i> Discount (${cart.discountStrategy.getStrategyName()}):</span>
                            <span class="fw-bold">-$<fmt:formatNumber value="${cart.getDiscountAmount(sessionScope.currentUser)}" minFractionDigits="2"/></span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="fs-5 fw-bold text-dark">Total Amount Due:</span>
                            <span class="display-6 fw-extrabold text-primary">
                                $<fmt:formatNumber value="${cart.getGrandTotal(sessionScope.currentUser)}" minFractionDigits="2"/>
                            </span>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between align-items-center pt-2">
                        <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-secondary rounded-pill px-4">
                            <i class="bi bi-arrow-left me-1"></i> Back to Cart
                        </a>
                        <a href="${pageContext.request.contextPath}/orders/checkout" class="btn btn-success btn-lg rounded-pill px-5 fw-semibold shadow-sm">
                            <i class="bi bi-credit-card me-2"></i> Proceed to Payment
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
