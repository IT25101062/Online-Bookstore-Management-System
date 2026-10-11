<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-box-seam-fill text-primary me-2"></i>Inventory & Stock Management</h2>
            <p class="text-muted small mb-0">Admin Panel: Control stock levels, edit metadata, and manage books in <code>books.txt</code></p>
        </div>
        <div class="d-flex gap-2">
            <span class="badge bg-primary-subtle text-primary border border-primary px-3 py-2 rounded-pill">
                CRUD: Full Suite (C, R, U, D)
            </span>
            <a href="${pageContext.request.contextPath}/books/add" class="btn btn-success rounded-pill px-3 fw-semibold">
                <i class="bi bi-plus-lg me-1"></i> Add New Book
            </a>
        </div>
    </div>

    <!-- Inventory Table -->
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                    <tr>
                        <th class="ps-4">ID</th>
                        <th>Book Information</th>
                        <th>Category</th>
                        <th>Format & Subclass</th>
                        <th>Price (Base / Final)</th>
                        <th>Current Stock</th>
                        <th class="text-end pe-4">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${books}" var="b">
                        <tr>
                            <td class="ps-4 fw-bold text-secondary">
                                <code>${b.bookId}</code>
                            </td>
                            <td>
                                <div class="fw-bold text-dark">${b.title}</div>
                                <small class="text-muted">By ${b.author} &bull; ISBN: ${b.isbn}</small>
                            </td>
                            <td>
                                <span class="badge bg-light text-secondary border">${b.category}</span>
                            </td>
                            <td>
                                <span class="badge ${b.bookType == 'EBOOK' ? 'badge-ebook' : 'badge-printed'} mb-1">
                                    ${b.bookType}
                                </span>
                                <div class="small text-muted">${b.getFormatDetails()}</div>
                            </td>
                            <td>
                                <div class="fw-semibold text-primary">
                                    $<fmt:formatNumber value="${b.calculateFinalPrice()}" minFractionDigits="2" maxFractionDigits="2"/>
                                </div>
                                <small class="text-muted">Base: $<fmt:formatNumber value="${b.basePrice}" minFractionDigits="2" maxFractionDigits="2"/></small>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <c:choose>
                                        <c:when test="${b.bookType == 'EBOOK'}">
                                            <span class="badge bg-info-subtle text-info border border-info">Digital (Unlimited)</span>
                                        </c:when>
                                        <c:when test="${b.stockQuantity <= 5}">
                                            <span class="badge bg-danger">Low: ${b.stockQuantity}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-success-subtle text-success border border-success">${b.stockQuantity} in stock</span>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Quick stock adjuster for printed books -->
                                    <c:if test="${b.bookType == 'PRINTED'}">
                                        <div class="btn-group btn-group-sm">
                                            <form action="${pageContext.request.contextPath}/books/stock" method="post" class="d-inline">
                                                <input type="hidden" name="bookId" value="${b.bookId}">
                                                <input type="hidden" name="change" value="-5">
                                                <button type="submit" class="btn btn-outline-secondary btn-sm py-0 px-1" title="-5 stock">-5</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/books/stock" method="post" class="d-inline">
                                                <input type="hidden" name="bookId" value="${b.bookId}">
                                                <input type="hidden" name="change" value="5">
                                                <button type="submit" class="btn btn-outline-secondary btn-sm py-0 px-1" title="+5 stock">+5</button>
                                            </form>
                                        </div>
                                    </c:if>
                                </div>
                            </td>
                            <td class="text-end pe-4">
                                <div class="d-inline-flex gap-1">
                                    <a href="${pageContext.request.contextPath}/books/view?id=${b.bookId}" class="btn btn-outline-secondary btn-sm rounded-pill" title="View Details">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/books/edit?id=${b.bookId}" class="btn btn-outline-primary btn-sm rounded-pill" title="Edit Book">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <form action="${pageContext.request.contextPath}/books/delete" method="post" class="d-inline" onsubmit="return confirmDelete('book \'${b.title}\'');">
                                        <input type="hidden" name="bookId" value="${b.bookId}">
                                        <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill" title="Delete Book">
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
