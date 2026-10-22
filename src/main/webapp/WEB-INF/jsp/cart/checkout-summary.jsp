<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 rounded-4 overflow-hidden bg-white" style="box-shadow:0 10px 40px rgba(44,18,30,0.1); border:1px solid #ede3da !important;">
                <div class="p-4 text-white d-flex justify-content-between align-items-center"
                     style="background: linear-gradient(135deg, #240e18 0%, #361724 55%, #502538 100%); border-bottom: 1px solid rgba(196,154,108,0.25);">
                    <div>
                        <h4 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#fff;">
                            <i class="bi bi-shield-check me-2" style="color:#dfb990;"></i>Order & Checkout Summary
                        </h4>
                        <small style="color:rgba(255,255,255,0.7);">Review your cart before selecting payment method</small>
                    </div>
                    <span class="badge px-3 py-2 rounded-pill" style="background:rgba(196,154,108,0.15); color:#dfb990; border:1px solid rgba(196,154,108,0.35);">
                        Pre-Order Review
                    </span>
                </div>

                <div class="card-body p-4 p-md-5">
                    <h5 class="fw-bold mb-3" style="font-family:'Playfair Display',serif; color:#240e18;">Item Breakdown</h5>
                    <div class="table-responsive mb-4">
                        <table class="table align-middle">
                            <thead style="background:#f9f4ef;">
                                <tr>
                                    <th class="ps-3 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Item</th>
                                    <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Format</th>
                                    <th class="text-center small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Qty</th>
                                    <th class="text-end small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Price</th>
                                    <th class="text-end pe-3 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${cart.items}" var="item">
                                    <tr style="border-color:#f5ede7;">
                                        <td class="ps-3">
                                            <div class="fw-semibold" style="color:#240e18;">
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
                                                <c:otherwise><span class="badge px-2 py-1" style="background:#f4ece2; color:#6b5244; border:1px solid #e8ded4;">Book</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center" style="color:#240e18;">${item.quantity}</td>
                                        <td class="text-end" style="color:#4a3b43;">Rs. <fmt:formatNumber value="${item.pricePerUnit}" minFractionDigits="2"/></td>
                                        <td class="text-end pe-3 fw-bold" style="color:#240e18;">Rs. <fmt:formatNumber value="${item.getItemSubtotal()}" minFractionDigits="2"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Financial Summary -->
                    <div class="p-4 rounded-4 mb-4" style="background:#fbf8f3; border: 1px solid #ede3da;">
                        <div class="d-flex justify-content-between mb-2">
                            <span style="color:#786670;">Cart Subtotal:</span>
                            <span class="fw-semibold" style="color:#240e18;">Rs. <fmt:formatNumber value="${cart.getSubtotal()}" minFractionDigits="2"/></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2" style="color:#2d8a2d;">
                            <span><i class="bi bi-tag-fill me-1"></i> Discount (${cart.discountStrategy.getStrategyName()}):</span>
                            <span class="fw-bold">-Rs. <fmt:formatNumber value="${cart.getDiscountAmount(sessionScope.currentUser)}" minFractionDigits="2"/></span>
                        </div>
                        <hr style="border-color:#ede3da;">
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="fs-5 fw-bold" style="font-family:'Playfair Display',serif; color:#240e18;">Total Amount Due:</span>
                            <span class="display-6 fw-bold" style="font-family:'Playfair Display',serif; color:#240e18;">
                                Rs. <fmt:formatNumber value="${cart.getGrandTotal(sessionScope.currentUser)}" minFractionDigits="2"/>
                            </span>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between align-items-center pt-2">
                        <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-plum px-4">
                            <i class="bi bi-arrow-left me-1"></i> Back to Cart
                        </a>
                        <a href="${pageContext.request.contextPath}/orders/checkout" class="btn btn-plum btn-lg px-5 fw-semibold">
                            <i class="bi bi-credit-card me-2"></i> Proceed to Payment
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
