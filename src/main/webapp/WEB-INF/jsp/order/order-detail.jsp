<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-9">
            <!-- Header bar -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
                <a href="${sessionScope.currentUser.hasAdminPrivileges() ? pageContext.request.contextPath.concat('/orders/all') : pageContext.request.contextPath.concat('/orders')}" 
                   class="btn btn-outline-plum px-3">
                    <i class="bi bi-arrow-left me-1"></i> Back to Orders
                </a>
                <div class="d-flex gap-2">
                    <button onclick="window.print()" class="btn btn-plum px-3">
                        <i class="bi bi-printer me-1"></i> Print Receipt
                    </button>
                </div>
            </div>

            <!-- Receipt Card -->
            <div class="card border-0 rounded-4 overflow-hidden bg-white mb-4" style="box-shadow:0 10px 40px rgba(44,18,30,0.1); border:1px solid #ede3da !important;">
                <div class="p-4 d-flex flex-wrap justify-content-between align-items-center gap-3 text-white"
                     style="background: linear-gradient(135deg, #240e18 0%, #361724 55%, #502538 100%); border-bottom:1px solid rgba(196,154,108,0.25);">
                    <div>
                        <div class="small text-uppercase fw-semibold" style="color:#dfb990; letter-spacing:1.5px;">Order Receipt</div>
                        <h3 class="fw-bold mb-0" style="font-family:'Playfair Display',serif; color:#fff;">Order #${order.orderId}</h3>
                    </div>
                    <div class="text-end">
                        <c:choose>
                            <c:when test="${order.orderStatus == 'DELIVERED'}">
                                <span class="badge fs-6 px-3 py-2 rounded-pill" style="background:rgba(76,174,76,0.15); color:#2d8a2d; border:1px solid rgba(76,174,76,0.35);"><i class="bi bi-check-circle me-1"></i>Delivered</span>
                            </c:when>
                            <c:when test="${order.orderStatus == 'SHIPPED'}">
                                <span class="badge fs-6 px-3 py-2 rounded-pill" style="background:rgba(196,154,108,0.2); color:#dfb990; border:1px solid rgba(196,154,108,0.4);"><i class="bi bi-truck me-1"></i>Shipped</span>
                            </c:when>
                            <c:when test="${order.orderStatus == 'PROCESSING'}">
                                <span class="badge fs-6 px-3 py-2 rounded-pill" style="background:rgba(196,154,108,0.15); color:#8c5b1c; border:1px solid rgba(196,154,108,0.35);"><i class="bi bi-gear me-1"></i>Processing</span>
                            </c:when>
                            <c:when test="${order.orderStatus == 'CANCELLED'}">
                                <span class="badge fs-6 px-3 py-2 rounded-pill" style="background:rgba(200,0,0,0.12); color:#a02020; border:1px solid rgba(200,0,0,0.3);"><i class="bi bi-x-circle me-1"></i>Cancelled</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge fs-6 px-3 py-2 rounded-pill" style="background:rgba(196,154,108,0.15); color:#8c5b1c; border:1px solid rgba(196,154,108,0.35);"><i class="bi bi-hourglass-split me-1"></i>Pending</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="card-body p-4 p-md-5">
                    <!-- Meta Grid -->
                    <div class="row g-4 mb-4 pb-4" style="border-bottom:1px solid #f0e8e0;">
                        <div class="col-sm-6 col-md-3">
                            <small class="d-block mb-1" style="color:#786670;">Order Date</small>
                            <span class="fw-semibold" style="color:#240e18;"><i class="bi bi-calendar3 me-1" style="color:#c49a6c;"></i>${order.orderDate}</span>
                        </div>
                        <div class="col-sm-6 col-md-3">
                            <small class="d-block mb-1" style="color:#786670;">Customer ID</small>
                            <span class="badge px-2 py-1" style="background:#f4ece2; color:#6b5244; border:1px solid #e8ded4; font-family:monospace;"><i class="bi bi-person me-1"></i>${order.userId}</span>
                        </div>
                        <div class="col-sm-6 col-md-3">
                            <small class="d-block mb-1" style="color:#786670;">Payment Method</small>
                            <span class="fw-semibold" style="color:#240e18;"><i class="bi bi-credit-card me-1" style="color:#c49a6c;"></i>${order.paymentMethod}</span>
                        </div>
                        <div class="col-sm-6 col-md-3">
                            <small class="d-block mb-1" style="color:#786670;">Payment Status</small>
                            <span class="badge px-2 py-1" style="${order.paymentStatus == 'PAID' ? 'background:rgba(76,174,76,0.12); color:#2d8a2d; border:1px solid rgba(76,174,76,0.3);' : 'background:rgba(196,154,108,0.15); color:#8c5b1c; border:1px solid rgba(196,154,108,0.35);'}">
                                ${order.paymentStatus}
                            </span>
                        </div>
                    </div>

                    <!-- Shipping Address -->
                    <div class="p-4 rounded-4 mb-4" style="background:#fbf8f3; border:1px solid #ede3da;">
                        <h6 class="fw-bold mb-2" style="font-family:'Playfair Display',serif; color:#240e18;">
                            <i class="bi bi-geo-alt-fill me-2" style="color:#c49a6c;"></i>Shipping Delivery Address
                        </h6>
                        <p class="mb-0" style="color:#4a3b43;">${order.shippingAddress}</p>
                    </div>

                    <!-- Items Summary -->
                    <div class="mb-4">
                        <h5 class="fw-bold mb-3" style="font-family:'Playfair Display',serif; color:#240e18;">
                            <i class="bi bi-card-checklist me-2" style="color:#c49a6c;"></i>Purchased Items
                        </h5>
                        <div class="p-4 rounded-4" style="background:#fbf8f3; border:1px solid #ede3da;">
                            <p class="fs-6 mb-0" style="color:#240e18; line-height:1.7;">${order.itemSummary}</p>
                        </div>
                    </div>

                    <!-- Financial Total -->
                    <div class="p-4 rounded-4 d-flex justify-content-between align-items-center text-white"
                         style="background: linear-gradient(135deg, #240e18 0%, #361724 100%); border:1px solid rgba(196,154,108,0.25);">
                        <span class="fs-5 fw-semibold">Grand Total Amount Paid / Due:</span>
                        <span class="display-6 fw-bold" style="font-family:'Playfair Display',serif; color:#dfb990;">
                            Rs. <fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2"/>
                        </span>
                    </div>

                    <!-- Actions Bar (Status management / Cancellation) -->
                    <div class="mt-4 pt-3 d-flex flex-wrap justify-content-between align-items-center gap-3" style="border-top:1px solid #f0e8e0;">
                        <c:if test="${sessionScope.currentUser.hasAdminPrivileges()}">
                            <!-- Admin Status Update Form -->
                            <form action="${pageContext.request.contextPath}/orders/update-status" method="post" class="d-flex align-items-center gap-2">
                                <input type="hidden" name="orderId" value="${order.orderId}"/>
                                <label class="fw-semibold small mb-0" style="color:#240e18;">Update Status:</label>
                                <select name="orderStatus" class="form-select form-select-sm rounded-pill" style="width: auto; border:1px solid #ede3da;">
                                    <c:forEach items="${orderStatuses}" var="st">
                                        <option value="${st}" ${order.orderStatus == st ? 'selected' : ''}>${st}</option>
                                    </c:forEach>
                                </select>
                                <button type="submit" class="btn btn-sm btn-plum rounded-pill px-3">Save</button>
                            </form>

                            <!-- Admin Delete Order -->
                            <form action="${pageContext.request.contextPath}/orders/delete" method="post" 
                                  onsubmit="return confirm('Permanently remove order #${order.orderId}?');">
                                <input type="hidden" name="orderId" value="${order.orderId}"/>
                                <button type="submit" class="btn btn-sm btn-outline-plum rounded-pill px-3" style="color:#a02020; border-color:rgba(200,0,0,0.3);">
                                    <i class="bi bi-trash me-1"></i> Delete Order
                                </button>
                            </form>
                        </c:if>

                        <c:if test="${order.canBeCancelled()}">
                            <form action="${pageContext.request.contextPath}/orders/cancel" method="post"
                                  onsubmit="return confirm('Cancel this order?');">
                                <input type="hidden" name="orderId" value="${order.orderId}"/>
                                <button type="submit" class="btn btn-outline-plum rounded-pill px-4" style="color:#a02020; border-color:rgba(200,0,0,0.3);">
                                    <i class="bi bi-x-circle me-1"></i> Cancel This Order
                                </button>
                            </form>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
