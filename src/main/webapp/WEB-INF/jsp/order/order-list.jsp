<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <!-- Page Header -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h2 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">
                <i class="bi bi-box-seam-fill me-2" style="color:#c49a6c;"></i>
                <c:choose>
                    <c:when test="${isAdminView}">All Bookstore Orders</c:when>
                    <c:otherwise>My Order History</c:otherwise>
                </c:choose>
            </h2>
            <p class="small mb-0" style="color:#786670;">
                <c:choose>
                    <c:when test="${isAdminView}">Manage, review, dispatch, and update statuses of customer orders</c:when>
                    <c:otherwise>Track the shipment, payment status, and order receipts of your purchases</c:otherwise>
                </c:choose>
            </p>
        </div>
        <div class="d-flex gap-2">
            <c:if test="${isAdminView}">
                <a href="${pageContext.request.contextPath}/admin" class="btn btn-outline-plum px-3" style="font-size:0.8rem;">
                    <i class="bi bi-speedometer2 me-1"></i> Dashboard
                </a>
            </c:if>
            <a href="${pageContext.request.contextPath}/books" class="btn btn-plum px-4">
                <i class="bi bi-book me-1"></i> Browse Books
            </a>
        </div>
    </div>

    <!-- Orders Table Card -->
    <div class="card border-0 rounded-4 overflow-hidden bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
        <c:choose>
            <c:when test="${empty orders}">
                <div class="p-5 text-center">
                    <i class="bi bi-inbox" style="font-size:4rem; color:#d8ccce; display:block; margin-bottom:1rem;"></i>
                    <h5 class="fw-bold" style="font-family:'Playfair Display',serif; color:#240e18;">No orders found</h5>
                    <p style="color:#786670;">You haven't placed any orders yet, or no orders match your search.</p>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-plum px-4">
                        Start Shopping Now
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead style="background:#f9f4ef;">
                            <tr>
                                <th class="ps-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Order ID</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Date</th>
                                <c:if test="${isAdminView}">
                                    <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Customer ID</th>
                                </c:if>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Items Summary</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Total</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Payment</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Status</th>
                                <th class="text-end pe-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orders}" var="ord">
                                <tr style="border-color:#f5ede7;">
                                    <td class="ps-4">
                                        <a href="${pageContext.request.contextPath}/orders/${ord.orderId}" class="fw-bold text-decoration-none" style="color:#361724;">
                                            #${ord.orderId}
                                        </a>
                                    </td>
                                    <td>
                                        <span class="small" style="color:#786670;">${ord.orderDate}</span>
                                    </td>
                                    <c:if test="${isAdminView}">
                                        <td>
                                            <span class="badge bg-light text-dark border">${ord.userId}</span>
                                        </td>
                                    </c:if>
                                    <td style="max-width: 280px;" class="text-truncate">
                                        <span class="small text-dark" title="${ord.itemSummary}">${ord.itemSummary}</span>
                                    </td>
                                    <td>
                                        <span class="fw-bold text-dark">
                                            Rs. <fmt:formatNumber value="${ord.totalAmount}" minFractionDigits="2"/>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="d-flex flex-column gap-1">
                                            <span class="badge bg-secondary-subtle text-secondary border small">
                                                ${ord.paymentMethod}
                                            </span>
                                            <span class="badge ${ord.paymentStatus == 'PAID' ? 'bg-success' : 'bg-warning text-dark'} small">
                                                ${ord.paymentStatus}
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ord.orderStatus == 'DELIVERED'}">
                                                <span class="badge px-2 py-1" style="background:rgba(76,174,76,0.12); color:#2d8a2d; border:1px solid rgba(76,174,76,0.3); font-size:0.75rem;">
                                                    <i class="bi bi-check-circle me-1"></i>Delivered
                                                </span>
                                            </c:when>
                                            <c:when test="${ord.orderStatus == 'SHIPPED'}">
                                                <span class="badge px-2 py-1" style="background:rgba(0,150,200,0.1); color:#006a8a; border:1px solid rgba(0,150,200,0.25); font-size:0.75rem;">
                                                    <i class="bi bi-truck me-1"></i>Shipped
                                                </span>
                                            </c:when>
                                            <c:when test="${ord.orderStatus == 'PROCESSING'}">
                                                <span class="badge px-2 py-1" style="background:rgba(196,154,108,0.15); color:#8c5b1c; border:1px solid rgba(196,154,108,0.35); font-size:0.75rem;">
                                                    <i class="bi bi-gear me-1"></i>Processing
                                                </span>
                                            </c:when>
                                            <c:when test="${ord.orderStatus == 'CANCELLED'}">
                                                <span class="badge px-2 py-1" style="background:rgba(200,0,0,0.08); color:#a02020; border:1px solid rgba(200,0,0,0.2); font-size:0.75rem;">
                                                    <i class="bi bi-x-circle me-1"></i>Cancelled
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge px-2 py-1" style="background:rgba(100,100,100,0.1); color:#555; border:1px solid rgba(100,100,100,0.2); font-size:0.75rem;">
                                                    <i class="bi bi-hourglass-split me-1"></i>Pending
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end pe-4">
                                        <div class="d-inline-flex gap-1 align-items-center">
                                            <!-- View Details Button -->
                                            <a href="${pageContext.request.contextPath}/orders/${ord.orderId}" 
                                               class="btn btn-sm btn-outline-plum px-3" style="font-size:0.75rem;" title="View Order Details">
                                                <i class="bi bi-eye"></i> Details
                                            </a>

                                            <!-- Admin Update Status Inline Form -->
                                            <c:if test="${isAdminView}">
                                                <button type="button" class="btn btn-sm btn-outline-secondary rounded-pill px-2" 
                                                        data-bs-toggle="modal" data-bs-target="#statusModal_${ord.orderId}" title="Change Status">
                                                    <i class="bi bi-pencil-square"></i>
                                                </button>

                                                <!-- Delete Order Form -->
                                                <form action="${pageContext.request.contextPath}/orders/delete" method="post" 
                                                      class="d-inline" onsubmit="return confirm('Delete order #${ord.orderId} permanently?');">
                                                    <input type="hidden" name="orderId" value="${ord.orderId}"/>
                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-2" title="Delete Order">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>

                                                <!-- Modal for Status Change -->
                                                <div class="modal fade" id="statusModal_${ord.orderId}" tabindex="-1" aria-hidden="true">
                                                    <div class="modal-dialog modal-dialog-centered">
                                                        <div class="modal-content rounded-4 border-0 shadow">
                                                            <form action="${pageContext.request.contextPath}/orders/update-status" method="post">
                                                                <input type="hidden" name="orderId" value="${ord.orderId}"/>
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title fw-bold">Update Order Status: #${ord.orderId}</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                                </div>
                                                                <div class="modal-body text-start">
                                                                    <div class="mb-3">
                                                                        <label class="form-label fw-semibold">Select New Status</label>
                                                                        <select name="orderStatus" class="form-select rounded-3">
                                                                            <c:forEach items="${orderStatuses}" var="st">
                                                                                <option value="${st}" ${ord.orderStatus == st ? 'selected' : ''}>
                                                                                    ${st}
                                                                                </option>
                                                                            </c:forEach>
                                                                        </select>
                                                                    </div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Close</button>
                                                                    <button type="submit" class="btn btn-primary rounded-pill">Save Status</button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>

                                            <!-- Cancel Order (for customer or admin if cancellable) -->
                                            <c:if test="${ord.canBeCancelled()}">
                                                <form action="${pageContext.request.contextPath}/orders/cancel" method="post" class="d-inline"
                                                      onsubmit="return confirm('Are you sure you want to cancel order #${ord.orderId}?');">
                                                    <input type="hidden" name="orderId" value="${ord.orderId}"/>
                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-2" title="Cancel Order">
                                                        <i class="bi bi-x-circle"></i> Cancel
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
