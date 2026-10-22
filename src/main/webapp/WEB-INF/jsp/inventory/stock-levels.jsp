<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-boxes text-primary me-2"></i>Inventory & Stock Control</h2>
            <p class="text-muted small mb-0">Live stock tracking, replenishment, and reorder management synced with store inventory</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/inventory/low-stock" class="btn btn-warning rounded-pill px-3 fw-semibold">
                <i class="bi bi-exclamation-triangle-fill me-1"></i> Low Stock Alerts (${lowStockBooks.size()})
            </a>
            <a href="${pageContext.request.contextPath}/inventory/reports" class="btn btn-outline-dark rounded-pill px-3">
                <i class="bi bi-file-earmark-bar-graph me-1"></i> Inventory Reports
            </a>
        </div>
    </div>

    <!-- Summary Metrics -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card border-0 rounded-4 p-4 bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; font-size:0.7rem;">Total Titles in Catalog</span>
                        <h3 class="fw-bold mb-0" style="color:#240e18; font-family:'Playfair Display',serif;">${books.size()}</h3>
                    </div>
                    <div class="p-3 rounded-3" style="background:rgba(54,23,36,0.08);">
                        <i class="bi bi-book-half fs-4" style="color:#361724;"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 rounded-4 p-4 bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; font-size:0.7rem;">Total Stock Units Available</span>
                        <h3 class="fw-bold mb-0" style="color:#2d8a2d; font-family:'Playfair Display',serif;">${totalStock}</h3>
                    </div>
                    <div class="p-3 rounded-3" style="background:rgba(76,174,76,0.1);">
                        <i class="bi bi-box-seam fs-4" style="color:#2d8a2d;"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 rounded-4 p-4 bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; font-size:0.7rem;">Critical Low Stock (&lt; 5 units)</span>
                        <h3 class="fw-bold mb-0" style="color:#a02020; font-family:'Playfair Display',serif;">${lowStockBooks.size()}</h3>
                    </div>
                    <div class="p-3 rounded-3" style="background:rgba(200,0,0,0.08);">
                        <i class="bi bi-bell-fill fs-4" style="color:#a02020;"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Stock Table -->
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                    <tr>
                        <th class="ps-4">Book ID</th>
                        <th>Title & Author</th>
                        <th>Format Type</th>
                        <th>Category</th>
                        <th>Unit Price</th>
                        <th>Current Stock</th>
                        <th class="text-end pe-4">Adjust Inventory</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${books}" var="b">
                        <tr style="border-color:#f5ede7;">
                            <td class="ps-4">
                                <span class="badge font-monospace" style="background:#f4ece2; color:#6b5244; border:1px solid #e8ded4; font-size:0.75rem;">${b.bookId}</span>
                            </td>
                            <td>
                                <div class="fw-bold" style="color:#240e18;">${b.title}</div>
                                <small style="color:#786670;">${b.author} &bull; ISBN: ${b.isbn}</small>
                            </td>
                            <td>
                                <span class="badge ${b.bookType == 'EBOOK' ? 'badge-ebook' : 'badge-printed'}">
                                    ${b.bookType}
                                </span>
                            </td>
                            <td>
                                <span class="badge bg-secondary-subtle text-secondary border small">${b.category}</span>
                            </td>
                            <td>
                                <span class="fw-semibold text-dark">Rs. <fmt:formatNumber value="${b.basePrice}" minFractionDigits="2"/></span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${b.bookType == 'EBOOK'}">
                                        <span class="badge bg-info-subtle text-info border border-info">
                                            <i class="bi bi-infinity me-1"></i>Unlimited Digital
                                        </span>
                                    </c:when>
                                    <c:when test="${b.stockQuantity <= 5}">
                                        <span class="badge bg-danger px-3 py-2 rounded-pill">
                                            <i class="bi bi-exclamation-circle-fill me-1"></i>${b.stockQuantity} Left (Low)
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success-subtle text-success border border-success px-3 py-2 rounded-pill">
                                            ${b.stockQuantity} Units
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end pe-4">
                                <!-- Fast stock adjustment form -->
                                <form action="${pageContext.request.contextPath}/inventory/adjust-stock" method="post" 
                                      class="d-inline-flex align-items-center gap-1 justify-content-end">
                                    <input type="hidden" name="bookId" value="${b.bookId}"/>
                                    <div class="input-group input-group-sm" style="width: 140px;">
                                        <input type="number" name="delta" class="form-control text-center" placeholder="&plusmn; Qty" required style="border-color:#e8ded4;">
                                        <button type="submit" class="btn btn-plum" title="Update Stock" style="padding:0.3rem 0.7rem;">
                                            <i class="bi bi-check-lg"></i>
                                        </button>
                                    </div>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
