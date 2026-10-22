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
                <i class="bi bi-box-seam-fill me-2" style="color:#c49a6c;"></i>Inventory & Stock Management
            </h2>
            <p class="small mb-0" style="color:#786670;">Admin Panel: Control stock levels, edit metadata, and manage the Chapter One catalog</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/books/add" class="btn btn-plum px-3 fw-semibold">
                <i class="bi bi-plus-lg me-1"></i> Add New Book
            </a>
        </div>
    </div>

    <!-- Inventory Table -->
    <div class="card border-0 rounded-4 overflow-hidden bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead style="background:#f9f4ef;">
                    <tr>
                        <th class="ps-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">ID</th>
                        <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Book Information</th>
                        <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Category</th>
                        <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Format & Subclass</th>
                        <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Price (Base / Final)</th>
                        <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Current Stock</th>
                        <th class="text-end pe-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${books}" var="b">
                        <tr style="border-color:#f5ede7;">
                            <td class="ps-4">
                                <span class="badge px-2 py-1" style="background:#f4ece2; color:#6b5244; border:1px solid #e8ded4; font-family:monospace;">${b.bookId}</span>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <c:choose>
                                        <c:when test="${not empty b.imageUrl}">
                                            <img src="${b.imageUrl}" alt="${b.title}" class="rounded shadow-sm" style="width: 38px; height: 48px; object-fit: cover;"
                                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                            <div class="rounded align-items-center justify-content-center text-muted" style="width: 38px; height: 48px; background: #f0e8e0; display: none;">
                                                <i class="bi bi-book"></i>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="rounded d-flex align-items-center justify-content-center text-muted" style="width: 38px; height: 48px; background: #f0e8e0;">
                                                <i class="bi bi-book"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div>
                                        <div class="fw-bold" style="color:#240e18;">${b.title}</div>
                                        <small style="color:#786670;">By ${b.author} &bull; ISBN: ${b.isbn}</small>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="badge px-2 py-1" style="background:rgba(196,154,108,0.15); color:#8c5b1c; border:1px solid rgba(196,154,108,0.35);">${b.category}</span>
                            </td>
                            <td>
                                <span class="badge ${b.bookType == 'EBOOK' ? 'badge-ebook' : 'badge-printed'} mb-1">
                                    ${b.bookType}
                                </span>
                                <div class="small" style="color:#786670;">${b.getFormatDetails()}</div>
                            </td>
                            <td>
                                <div class="fw-semibold" style="color:#240e18;">
                                    Rs. <fmt:formatNumber value="${b.calculateFinalPrice()}" minFractionDigits="2" maxFractionDigits="2"/>
                                </div>
                                <small style="color:#786670;">Base: Rs. <fmt:formatNumber value="${b.basePrice}" minFractionDigits="2" maxFractionDigits="2"/></small>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <c:choose>
                                        <c:when test="${b.bookType == 'EBOOK'}">
                                            <span class="badge px-2 py-1" style="background:rgba(196,154,108,0.15); color:#8c5b1c; border:1px solid rgba(196,154,108,0.35);">Digital (Unlimited)</span>
                                        </c:when>
                                        <c:when test="${b.stockQuantity <= 5}">
                                            <span class="badge px-2 py-1" style="background:rgba(200,0,0,0.1); color:#a02020; border:1px solid rgba(200,0,0,0.25);">Low: ${b.stockQuantity}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge px-2 py-1" style="background:rgba(76,174,76,0.12); color:#2d8a2d; border:1px solid rgba(76,174,76,0.3);">${b.stockQuantity} in stock</span>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Quick stock adjuster for printed books -->
                                    <c:if test="${b.bookType == 'PRINTED'}">
                                        <div class="btn-group btn-group-sm">
                                            <form action="${pageContext.request.contextPath}/books/stock" method="post" class="d-inline">
                                                <input type="hidden" name="bookId" value="${b.bookId}">
                                                <input type="hidden" name="change" value="-5">
                                                <button type="submit" class="btn btn-outline-plum btn-sm py-0 px-2" title="-5 stock">-5</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/books/stock" method="post" class="d-inline">
                                                <input type="hidden" name="bookId" value="${b.bookId}">
                                                <input type="hidden" name="change" value="5">
                                                <button type="submit" class="btn btn-outline-plum btn-sm py-0 px-2" title="+5 stock">+5</button>
                                            </form>
                                        </div>
                                    </c:if>
                                </div>
                            </td>
                            <td class="text-end pe-4">
                                <div class="d-inline-flex gap-1">
                                    <a href="${pageContext.request.contextPath}/books/view?id=${b.bookId}" class="btn btn-outline-plum btn-sm rounded-pill" title="View Details">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/books/edit?id=${b.bookId}" class="btn btn-outline-plum btn-sm rounded-pill" title="Edit Book">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <form action="${pageContext.request.contextPath}/books/delete" method="post" class="d-inline" onsubmit="return confirmDelete('book \'${b.title}\'');">
                                        <input type="hidden" name="bookId" value="${b.bookId}">
                                        <button type="submit" class="btn btn-outline-plum btn-sm rounded-pill" style="color:#a02020; border-color:rgba(200,0,0,0.3);" title="Delete Book">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
