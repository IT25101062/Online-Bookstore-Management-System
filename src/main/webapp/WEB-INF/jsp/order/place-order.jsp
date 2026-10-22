<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="row g-4">
        <!-- Order Placement Form -->
        <div class="col-lg-7">
            <div class="card border-0 rounded-4 overflow-hidden bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="card-header p-4 text-white" style="background: linear-gradient(135deg, #240e18 0%, #361724 55%, #502538 100%); border-bottom: 1px solid rgba(196,154,108,0.25);">
                    <div class="d-flex align-items-center gap-3">
                        <div class="p-2 rounded-3" style="background:rgba(196,154,108,0.2); color:#dfb990; border:1px solid rgba(196,154,108,0.4);">
                            <i class="bi bi-bag-check-fill fs-4"></i>
                        </div>
                        <div>
                            <h4 class="fw-bold mb-0" style="font-family:'Playfair Display',serif; color:#fff;">Complete Your Order</h4>
                            <small style="color:rgba(255,255,255,0.7);">Provide your delivery address and payment choice</small>
                        </div>
                    </div>
                </div>

                <div class="card-body p-4 p-md-5">
                    <form action="${pageContext.request.contextPath}/orders/place" method="post" id="placeOrderForm">
                        <!-- Shipping Address Section -->
                        <div class="mb-4">
                            <label for="shippingAddress" class="form-label fw-semibold" style="color:#240e18;">
                                <i class="bi bi-geo-alt-fill me-1" style="color:#c49a6c;"></i> Shipping Address <span style="color:#c49a6c;">*</span>
                            </label>
                            <textarea class="form-control rounded-3 p-3" id="shippingAddress" name="shippingAddress" rows="3" 
                                      placeholder="Enter complete street address, city, and postal code..." style="border: 1px solid #ede3da;" required></textarea>
                            <div class="form-text" style="color:#786670;">Orders are dispatched within 24 hours of placement.</div>
                        </div>

                        <!-- Payment Method Section -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold d-block" style="color:#240e18;">
                                <i class="bi bi-credit-card-2-front-fill me-1" style="color:#c49a6c;"></i> Payment Method <span style="color:#c49a6c;">*</span>
                            </label>

                            <div class="row g-3">
                                <div class="col-sm-6">
                                    <div class="form-check p-3 rounded-3 h-100" style="background:#fbf8f3; border: 1px solid #ede3da;">
                                        <input class="form-check-input ms-0 me-2" type="radio" name="paymentMethod" id="payCard" value="CARD" checked onchange="toggleCardDetails(true)">
                                        <label class="form-check-label fw-semibold w-100" for="payCard" style="color:#240e18;">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span>Credit / Debit Card</span>
                                                <i class="bi bi-credit-card fs-5" style="color:#c49a6c;"></i>
                                            </div>
                                            <small class="d-block fw-normal mt-1" style="color:#786670;">Visa, MasterCard, Amex</small>
                                        </label>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="form-check p-3 rounded-3 h-100" style="background:#fbf8f3; border: 1px solid #ede3da;">
                                        <input class="form-check-input ms-0 me-2" type="radio" name="paymentMethod" id="payCash" value="CASH" onchange="toggleCardDetails(false)">
                                        <label class="form-check-label fw-semibold w-100" for="payCash" style="color:#240e18;">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span>Cash on Delivery</span>
                                                <i class="bi bi-cash-stack fs-5" style="color:#2d8a2d;"></i>
                                            </div>
                                            <small class="d-block fw-normal mt-1" style="color:#786670;">Pay when order arrives</small>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Card details interactive simulation -->
                        <div id="cardDetailsBox" class="p-3 rounded-3 mb-4" style="background:#fbf8f3; border: 1px solid #ede3da;">
                            <div class="mb-3">
                                <label class="form-label small fw-semibold" style="color:#786670;">Card Number</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white" style="border-color:#ede3da;"><i class="bi bi-credit-card" style="color:#c49a6c;"></i></span>
                                    <input type="text" class="form-control bg-white" placeholder="4242 &bull;&bull;&bull;&bull; &bull;&bull;&bull;&bull; 4242" maxlength="19" style="border-color:#ede3da;">
                                </div>
                            </div>
                            <div class="row g-2">
                                <div class="col-6">
                                    <label class="form-label small fw-semibold" style="color:#786670;">Expiry (MM/YY)</label>
                                    <input type="text" class="form-control bg-white" placeholder="12/28" maxlength="5" style="border-color:#ede3da;">
                                </div>
                                <div class="col-6">
                                    <label class="form-label small fw-semibold" style="color:#786670;">CVV</label>
                                    <input type="password" class="form-control bg-white" placeholder="123" maxlength="4" style="border-color:#ede3da;">
                                </div>
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="d-flex gap-3 pt-3">
                            <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-plum px-4">
                                <i class="bi bi-arrow-left me-1"></i> Back to Cart
                            </a>
                            <button type="submit" class="btn btn-plum px-5 fw-semibold flex-grow-1" style="font-size:1rem;">
                                <i class="bi bi-check-circle-fill me-2"></i> Confirm & Place Order
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Order Summary Column -->
        <div class="col-lg-5">
            <div class="card border-0 rounded-4 overflow-hidden bg-white sticky-top" style="top: 80px; box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="card-header p-4 text-white" style="background: linear-gradient(135deg, #361724 0%, #240e18 100%); border-bottom:1px solid rgba(196,154,108,0.25);">
                    <h5 class="fw-bold mb-0" style="font-family:'Playfair Display',serif; color:#fff;"><i class="bi bi-receipt me-2" style="color:#dfb990;"></i>Order Summary</h5>
                    <small style="color:rgba(255,255,255,0.7);">${cartItems.size()} items in your cart</small>
                </div>
                <div class="card-body p-4">
                    <div class="list-group list-group-flush mb-3">
                        <c:forEach items="${cartItems}" var="item">
                            <div class="list-group-item px-0 py-3 d-flex justify-content-between align-items-start" style="border-color:#f5ede7;">
                                <div class="me-auto pe-2">
                                    <div class="fw-semibold" style="color:#240e18;">
                                        <c:choose>
                                            <c:when test="${item.book != null}">${item.book.title}</c:when>
                                            <c:otherwise>Book ID: ${item.bookId}</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <small style="color:#786670;">Qty: ${item.quantity} &times; Rs. <fmt:formatNumber value="${item.pricePerUnit}" minFractionDigits="2"/></small>
                                </div>
                                <span class="fw-bold" style="color:#240e18;">Rs. <fmt:formatNumber value="${item.getItemSubtotal()}" minFractionDigits="2"/></span>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="p-3 rounded-3" style="background:#fbf8f3; border:1px solid #ede3da;">
                        <div class="d-flex justify-content-between mb-2">
                            <span style="color:#786670;">Subtotal:</span>
                            <span class="fw-semibold" style="color:#240e18;">Rs. <fmt:formatNumber value="${cart.getSubtotal()}" minFractionDigits="2"/></span>
                        </div>
                        <c:if test="${cart.getDiscountAmount(sessionScope.currentUser) > 0}">
                            <div class="d-flex justify-content-between mb-2" style="color:#2d8a2d;">
                                <span>Discount (${cart.discountStrategy.getStrategyName()}):</span>
                                <span class="fw-bold">-Rs. <fmt:formatNumber value="${cart.getDiscountAmount(sessionScope.currentUser)}" minFractionDigits="2"/></span>
                            </div>
                        </c:if>
                        <div class="d-flex justify-content-between mb-2">
                            <span style="color:#786670;">Delivery:</span>
                            <span class="fw-semibold" style="color:#2d8a2d;">FREE</span>
                        </div>
                        <hr style="border-color:#ede3da;">
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="fs-5 fw-bold" style="font-family:'Playfair Display',serif; color:#240e18;">Total:</span>
                            <span class="fs-4 fw-bold" style="color:#240e18;">
                                Rs. <fmt:formatNumber value="${cart.getGrandTotal(sessionScope.currentUser)}" minFractionDigits="2"/>
                            </span>
                        </div>
                    </div>

                    <div class="mt-4 text-center small" style="color:#786670;">
                        <i class="bi bi-shield-lock-fill me-1" style="color:#c49a6c;"></i>
                        Safe & Secure 256-bit Encrypted Checkout
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
function toggleCardDetails(show) {
    const box = document.getElementById('cardDetailsBox');
    if (box) {
        box.style.display = show ? 'block' : 'none';
    }
}
</script>

<jsp:include page="../common/footer.jsp"/>
