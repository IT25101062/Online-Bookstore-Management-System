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
                <i class="bi bi-bookshelf me-2" style="color:#c49a6c;"></i>Books Catalog
            </h2>
            <p class="small mb-0" style="color:#786670;">Browse through our collection of physical editions and digital e-books</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/books/search" class="btn btn-outline-plum px-3">
                <i class="bi bi-search me-1"></i> Filter & Search
            </a>
            <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.hasAdminPrivileges()}">
                <a href="${pageContext.request.contextPath}/books/add" class="btn btn-plum px-3">
                    <i class="bi bi-plus-circle me-1"></i> Add New Book
                </a>
            </c:if>
        </div>
    </div>

    <!-- Category Pills -->
    <div class="d-flex flex-wrap gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/books" class="btn btn-sm ${empty selectedCategory ? 'btn-plum' : 'btn-outline-plum'} px-3">
            All Categories
        </a>
        <c:forEach items="${categories}" var="cat">
            <a href="${pageContext.request.contextPath}/books?category=${cat}" class="btn btn-sm ${selectedCategory == cat ? 'btn-plum' : 'btn-outline-plum'} px-3">
                ${cat}
            </a>
        </c:forEach>
    </div>

    <!-- Books Grid -->
    <div class="row g-4">
        <c:forEach items="${books}" var="book" varStatus="loop">
            <div class="col-md-6 col-lg-3 animate-card-rise delay-${(loop.index % 8) + 1}">
                <div class="card h-100 book-card border-0 rounded-4 overflow-hidden bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                    <div class="book-cover-placeholder position-relative" style="background: linear-gradient(135deg, #240e18 0%, #361724 100%); min-height: 200px; height: 200px; display: flex; align-items: center; justify-content: center; color: #dfb990; overflow: hidden;">
                        <c:choose>
                            <c:when test="${not empty book.imageUrl}">
                                <img src="${book.imageUrl}" alt="${book.title}" style="width: 100%; height: 100%; object-fit: cover;"
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                                <i class="bi bi-journal-bookmark fs-1" style="display: none;"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-journal-bookmark fs-1"></i>
                            </c:otherwise>
                        </c:choose>
                        <span class="position-absolute top-0 end-0 m-2 badge ${book.bookType == 'EBOOK' ? 'badge-ebook' : 'badge-printed'} shadow-sm">
                            ${book.bookType}
                        </span>
                    </div>
                    <div class="card-body d-flex flex-column p-3">
                        <span class="badge px-2 py-1 align-self-start mb-2" style="background:rgba(196,154,108,0.15); color:#8c5b1c; border:1px solid rgba(196,154,108,0.35); font-size:0.7rem;">${book.category}</span>
                        <h6 class="card-title fw-bold mb-1 text-truncate" style="font-family:'Playfair Display',serif; color:#240e18;" title="${book.title}">${book.title}</h6>
                        <small class="mb-2" style="color:#786670;">By ${book.author}</small>
                        <p class="small mb-3 flex-grow-1" style="color:#786670; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                            ${book.description}
                        </p>

                        <div class="small mb-2" style="color:#786670;">
                            <i class="bi bi-info-circle me-1" style="color:#c49a6c;"></i> ${book.getFormatDetails()}
                        </div>

                        <div class="d-flex justify-content-between align-items-center mt-auto pt-2" style="border-top:1px solid #f5ede7;">
                            <div>
                                <span class="fs-5 fw-bold" style="color:#240e18;">
                                    Rs. <fmt:formatNumber value="${book.calculateFinalPrice()}" minFractionDigits="2" maxFractionDigits="2"/>
                                </span>
                                <c:if test="${book.bookType == 'PRINTED' && book.calculateFinalPrice() != book.basePrice}">
                                    <small class="d-block" style="color:#786670; font-size: 0.7rem;">(incl. packaging)</small>
                                </c:if>
                            </div>
                            <div class="d-flex gap-1">
                                <a href="${pageContext.request.contextPath}/books/view?id=${book.bookId}" class="btn btn-outline-plum btn-sm px-3">
                                    Details
                                </a>
                                <c:choose>
                                    <c:when test="${book.isInStock()}">
                                        <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-inline">
                                            <input type="hidden" name="bookId" value="${book.bookId}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit" class="btn btn-plum btn-sm px-2" title="Add to Cart">
                                                <i class="bi bi-cart-plus"></i>
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge px-2 py-1 rounded-pill align-self-center" style="background:rgba(200,0,0,0.1); color:#a02020; border:1px solid rgba(200,0,0,0.25);">Out of Stock</span>
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.hasAdminPrivileges()}">
                                    <a href="${pageContext.request.contextPath}/books/edit?id=${book.bookId}" class="btn btn-outline-secondary btn-sm px-2" title="Edit Book">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty books}">
            <div class="col-12 text-center py-5">
                <i class="bi bi-journal-x display-4 d-block mb-3" style="color:#d8ccce;"></i>
                <h5 class="fw-bold" style="font-family:'Playfair Display',serif; color:#240e18;">No books found</h5>
                <p style="color:#786670;">No books currently match this category filter.</p>
                <a href="${pageContext.request.contextPath}/books" class="btn btn-plum px-4">View All Books</a>
            </div>
        </c:if>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
