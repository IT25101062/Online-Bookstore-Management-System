<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
        <div>
            <h2 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">
                <i class="bi bi-cart3 me-2" style="color:#c49a6c;"></i>My Shopping Cart
            </h2>
            <p class="small mb-0" style="color:#786670;">Review your selected books and proceed securely to checkout</p>
        </div>

    </div>

    <c:choose>
        <c:when test="${not empty cart.items}">
            <div class="row g-4">
                <!-- Cart Items Table -->
                <div class="col-lg-8">
                    <div class="card border-0 rounded-4 overflow-hidden bg-white mb-3" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead style="background:#f9f4ef;">
                                    <tr>
                                        <th class="ps-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Item Details</th>
                                        <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Format</th>
                                        <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Unit Price</th>
                                        <th class="small fw-semibold" style="width: 170px; color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Quantity</th>
                                        <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Subtotal</th>
                                        <th class="text-end pe-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Remove</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${cart.items}" var="item">
                                        <tr style="border-color:#f5ede7;">
                                            <td class="ps-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <c:choose>
                                                        <c:when test="${item.book != null && not empty item.book.imageUrl}">
                                                            <img src="${item.book.imageUrl}" alt="${item.book.title}" class="rounded shadow-sm" style="width: 44px; height: 56px; object-fit: cover;"
                                                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                            <div class="rounded align-items-center justify-content-center text-muted" style="width: 44px; height: 56px; background: #f0e8e0; display: none;">
                                                                <i class="bi bi-book"></i>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="rounded d-flex align-items-center justify-content-center text-muted" style="width: 44px; height: 56px; background: #f0e8e0;">
                                                                <i class="bi bi-book"></i>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div>
                                                        <div class="fw-bold" style="color:#240e18;">
                                                            <c:choose>
                                                                <c:when test="${item.book != null}">
                                                                    <a href="${pageContext.request.contextPath}/books/view?id=${item.bookId}" class="text-decoration-none" style="color:#240e18;">
                                                                        ${item.book.title}
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Book #${item.bookId}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <small style="color:#786670;">Item ID: <code>${item.cartItemId}</code> &bull; Added: ${item.addedDate}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.book != null}">
                                                        <span class="badge ${item.book.bookType == 'EBOOK' ? 'badge-ebook' : 'badge-printed'}">
                                                            ${item.book.bookType}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge px-2 py-1" style="background:#f4ece2; color:#6b5244; border:1px solid #e8ded4;">Book</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="color:#4a3b43;">
                                                Rs. <fmt:formatNumber value="${item.pricePerUnit}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/cart/update" method="post" class="d-flex align-items-center gap-1">
                                                    <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                                    <input type="number" name="quantity" value="${item.quantity}" min="1" max="99" class="form-control form-control-sm text-center" style="width: 65px; border-color:#ede3da;" required>
                                                    <button type="submit" class="btn btn-outline-plum btn-sm" title="Update Quantity">
                                                        <i class="bi bi-arrow-repeat"></i>
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/cart/update?cartItemId=${item.cartItemId}" class="btn btn-outline-plum btn-sm" title="Detailed Update Page">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                </form>
                                            </td>
                                            <td class="fw-bold" style="color:#240e18;">
                                                Rs. <fmt:formatNumber value="${item.getItemSubtotal()}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td class="text-end pe-4">
                                                <form action="${pageContext.request.contextPath}/cart/remove" method="post" class="d-inline" onsubmit="return confirmDelete('this cart item');">
                                                    <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                                    <button type="submit" class="btn btn-outline-plum btn-sm rounded-pill" style="color:#a02020; border-color:rgba(200,0,0,0.3);" title="Remove Item">
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
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-outline-plum px-3">
                            <i class="bi bi-arrow-left me-1"></i> Continue Browsing
                        </a>
                        <form action="${pageContext.request.contextPath}/cart/clear" method="post" onsubmit="return confirmDelete('all items from your shopping cart');">
                            <button type="submit" class="btn btn-outline-plum btn-sm px-3" style="color:#a02020; border-color:rgba(200,0,0,0.3);">
                                <i class="bi bi-trash3 me-1"></i> Clear Cart
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Order Summary Column -->
                <div class="col-lg-4">
                    <div class="card border-0 rounded-4 p-4 bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                        <h5 class="fw-bold mb-3" style="font-family:'Playfair Display',serif; color:#240e18;">
                            <i class="bi bi-receipt me-2" style="color:#c49a6c;"></i>Order Summary
                        </h5>

                        <div class="d-flex justify-content-between mb-2">
                            <span style="color:#786670;">Total Quantity:</span>
                            <span class="fw-semibold" style="color:#240e18;">${cart.getTotalQuantity()} items</span>
                        </div>

                        <div class="d-flex justify-content-between mb-2">
                            <span style="color:#786670;">Subtotal:</span>
                            <span class="fw-semibold" style="color:#240e18;">Rs. <fmt:formatNumber value="${cart.getSubtotal()}" minFractionDigits="2" maxFractionDigits="2"/></span>
                        </div>

                        <!-- Polymorphic Discount -->
                        <div class="d-flex justify-content-between mb-3" style="color:#2d8a2d;">
                            <span>
                                <i class="bi bi-tag-fill me-1"></i> ${cart.discountStrategy.getStrategyName()}:
                            </span>
                            <span class="fw-bold">-Rs. <fmt:formatNumber value="${cart.getDiscountAmount(sessionScope.currentUser)}" minFractionDigits="2" maxFractionDigits="2"/></span>
                        </div>

                        <hr style="border-color:#ede3da;">

                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <span class="fs-5 fw-bold" style="font-family:'Playfair Display',serif; color:#240e18;">Grand Total:</span>
                            <span class="fs-4 fw-bold" style="color:#240e18;">
                                Rs. <fmt:formatNumber value="${cart.getGrandTotal(sessionScope.currentUser)}" minFractionDigits="2" maxFractionDigits="2"/>
                            </span>
                        </div>

                        <a href="${pageContext.request.contextPath}/cart/checkout-summary" class="btn btn-plum btn-lg rounded-pill w-100 fw-semibold mb-2">
                            <i class="bi bi-bag-check me-2"></i> Review Checkout
                        </a>

                        <!-- Safe & Secure Checkout Guarantee -->
                        <div class="p-3 rounded-3 small mt-3" style="background:#fbf8f3; border:1px solid #ede3da; color:#786670;">
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <i class="bi bi-shield-lock-fill" style="color:#c49a6c;"></i>
                                <span class="fw-semibold" style="color:#240e18;">Safe & Secure Checkout</span>
                            </div>
                            <div>
                                Orders are processed with instant order tracking and pristine doorstep packaging.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card border-0 rounded-4 p-5 text-center bg-white my-4" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <i class="bi bi-cart-x display-3 mb-3" style="color:#d8ccce;"></i>
                <h4 class="fw-bold" style="font-family:'Playfair Display',serif; color:#240e18;">Your shopping cart is empty</h4>
                <p class="mb-4" style="color:#786670;">Discover our great selection of technology, fiction, and business books!</p>
                <div>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-plum btn-lg px-4">
                        <i class="bi bi-bookshelf me-2"></i> Explore Book Catalog
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="../common/footer.jsp"/>
