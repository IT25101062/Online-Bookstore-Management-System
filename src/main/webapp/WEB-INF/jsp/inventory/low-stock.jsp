<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h2 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">
                <i class="bi bi-exclamation-triangle-fill me-2" style="color:#a02020;"></i>Critical Low-Stock Alerts
            </h2>
            <p class="small mb-0" style="color:#786670;">Printed book titles nearing depletion (Stock quantity &le; 5 units)</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/inventory" class="btn btn-outline-plum px-3">
                <i class="bi bi-arrow-left me-1"></i> Full Inventory
            </a>
        </div>
    </div>

    <!-- Alert Box -->
    <div class="rounded-4 p-4 mb-4 d-flex align-items-center gap-3" style="background:rgba(196,154,108,0.12); border:1px solid rgba(196,154,108,0.35);">
        <i class="bi bi-bell-fill fs-2" style="color:#c49a6c;"></i>
        <div>
            <h5 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">Attention Required</h5>
            <p class="mb-0 small" style="color:#5c4838;">
                The books listed below have fallen below the threshold reorder level. Please adjust or restock from supplier to avoid customer checkout failures.
            </p>
        </div>
    </div>

    <!-- Low Stock Table -->
    <div class="card border-0 rounded-4 overflow-hidden bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
        <c:choose>
            <c:when test="${empty books}">
                <div class="p-5 text-center" style="color:#2d8a2d;">
                    <i class="bi bi-check-circle-fill display-4 d-block mb-3" style="color:#2d8a2d;"></i>
                    <h5 class="fw-bold" style="font-family:'Playfair Display',serif; color:#240e18;">All printed books have healthy stock levels!</h5>
                    <p class="small" style="color:#786670;">No items currently below the minimum stock threshold.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead style="background:#f9f4ef;">
                            <tr>
                                <th class="ps-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Book ID</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Book Title</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Author</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Category</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Unit Price</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Units Remaining</th>
                                <th class="text-end pe-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Quick Restock Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${books}" var="b">
                                <tr style="border-color:#f5ede7;">
                                    <td class="ps-4">
                                        <span class="badge px-2 py-1" style="background:#f4ece2; color:#6b5244; border:1px solid #e8ded4; font-family:monospace;">${b.bookId}</span>
                                    </td>
                                    <td>
                                        <div class="fw-bold" style="color:#240e18;">${b.title}</div>
                                        <small style="color:#786670;">ISBN: ${b.isbn}</small>
                                    </td>
                                    <td style="color:#4a3b43;">${b.author}</td>
                                    <td><span class="badge px-2 py-1" style="background:rgba(196,154,108,0.15); color:#8c5b1c; border:1px solid rgba(196,154,108,0.35);">${b.category}</span></td>
                                    <td class="fw-semibold" style="color:#240e18;">Rs. <fmt:formatNumber value="${b.basePrice}" minFractionDigits="2"/></td>
                                    <td>
                                        <span class="badge fs-6 px-3 py-1 rounded-pill" style="background:rgba(200,0,0,0.1); color:#a02020; border:1px solid rgba(200,0,0,0.25);">
                                            <i class="bi bi-exclamation-circle me-1"></i>${b.stockQuantity} Left
                                        </span>
                                    </td>
                                    <td class="text-end pe-4">
                                        <div class="d-inline-flex gap-1 align-items-center justify-content-end">
                                            <!-- Quick restock buttons -->
                                            <form action="${pageContext.request.contextPath}/inventory/adjust-stock" method="post" class="d-inline">
                                                <input type="hidden" name="bookId" value="${b.bookId}"/>
                                                <input type="hidden" name="delta" value="10"/>
                                                <button type="submit" class="btn btn-sm btn-outline-plum rounded-pill px-2" title="Add 10 units">
                                                    +10 Units
                                                </button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/inventory/adjust-stock" method="post" class="d-inline">
                                                <input type="hidden" name="bookId" value="${b.bookId}"/>
                                                <input type="hidden" name="delta" value="25"/>
                                                <button type="submit" class="btn btn-sm btn-plum rounded-pill px-2" title="Add 25 units">
                                                    +25 Units
                                                </button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/inventory/adjust-stock" method="post" class="d-inline">
                                                <input type="hidden" name="bookId" value="${b.bookId}"/>
                                                <input type="hidden" name="delta" value="50"/>
                                                <button type="submit" class="btn btn-sm rounded-pill px-2" style="background:#c49a6c; color:#fff; border:1px solid #c49a6c;" title="Add 50 units">
                                                    +50 Units
                                                </button>
                                            </form>
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
