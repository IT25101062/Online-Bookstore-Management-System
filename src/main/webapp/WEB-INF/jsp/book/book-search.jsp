<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="mb-4">
        <h2 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">
            <i class="bi bi-search me-2" style="color:#c49a6c;"></i>Search & Filter Books
        </h2>
        <p class="small mb-0" style="color:#786670;">Search across titles, authors, categories, ISBNs, and price ranges</p>
    </div>

    <!-- Filter Form -->
    <div class="card border-0 rounded-4 p-4 mb-5 bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
        <form action="${pageContext.request.contextPath}/books/search" method="get">
            <div class="row g-3">
                <div class="col-md-5">
                    <label class="form-label fw-semibold" style="color:#240e18;">Search Keywords</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light" style="border-color:#ede3da;"><i class="bi bi-search" style="color:#c49a6c;"></i></span>
                        <input type="text" class="form-control" name="keyword" value="${keyword}" placeholder="Title, author, or ISBN..." style="border-color:#ede3da;">
                    </div>
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-semibold" style="color:#240e18;">Category</label>
                    <select class="form-select" name="category" style="border-color:#ede3da;">
                        <option value="ALL">All Categories</option>
                        <c:forEach items="${categories}" var="cat">
                            <option value="${cat}" ${category == cat ? 'selected' : ''}>${cat}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label fw-semibold" style="color:#240e18;">Min Price (Rs.)</label>
                    <input type="number" step="0.01" class="form-control" name="minPrice" value="${minPrice}" placeholder="0.00" style="border-color:#ede3da;">
                </div>

                <div class="col-md-2">
                    <label class="form-label fw-semibold" style="color:#240e18;">Max Price (Rs.)</label>
                    <input type="number" step="0.01" class="form-control" name="maxPrice" value="${maxPrice}" placeholder="100.00" style="border-color:#ede3da;">
                </div>

                <div class="col-12 d-flex justify-content-end gap-2 mt-3 pt-3" style="border-top:1px solid #f0e8e0;">
                    <a href="${pageContext.request.contextPath}/books/search" class="btn btn-outline-plum px-4">
                        Reset Filters
                    </a>
                    <button type="submit" class="btn btn-plum px-4 fw-semibold">
                        <i class="bi bi-filter me-1"></i> Apply Filters
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Search Results -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold m-0" style="font-family:'Playfair Display',serif; color:#240e18;">Search Results (${books.size()} books found)</h5>
    </div>

    <div class="row g-4">
        <c:forEach items="${books}" var="book" varStatus="loop">
            <div class="col-md-6 col-lg-3 animate-card-rise delay-${(loop.index % 8) + 1}">
                <div class="card h-100 book-card border-0 rounded-4 overflow-hidden bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                    <div class="book-cover-placeholder position-relative" style="background: linear-gradient(135deg, #240e18 0%, #361724 100%); min-height: 200px; height: 200px; display: flex; align-items: center; justify-content: center; color: #dfb990; overflow: hidden;">
                        <c:choose>
                            <c:when test="${not empty book.imageUrl}">
                                <img src="${book.imageUrl}" alt="${book.title}" style="width: 100%; height: 100%; object-fit: cover;"
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                                <i class="bi bi-journal-text fs-1" style="display: none;"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-journal-text fs-1"></i>
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
                            <span class="fs-5 fw-bold" style="color:#240e18;">
                                Rs. <fmt:formatNumber value="${book.calculateFinalPrice()}" minFractionDigits="2" maxFractionDigits="2"/>
                            </span>
                            <div class="d-flex gap-1">
                                <a href="${pageContext.request.contextPath}/books/view?id=${book.bookId}" class="btn btn-outline-plum btn-sm px-3">
                                    Details
                                </a>
                                <c:if test="${book.isInStock()}">
                                    <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-inline">
                                        <input type="hidden" name="bookId" value="${book.bookId}">
                                        <input type="hidden" name="quantity" value="1">
                                        <button type="submit" class="btn btn-plum btn-sm px-2" title="Add to Cart">
                                            <i class="bi bi-cart-plus"></i>
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty books}">
            <div class="col-12 text-center py-5">
                <i class="bi bi-search display-4 d-block mb-3" style="color:#d8ccce;"></i>
                <h5 class="fw-bold" style="font-family:'Playfair Display',serif; color:#240e18;">No books matched your criteria</h5>
                <p style="color:#786670;">Try adjusting your keyword or loosening the price filters.</p>
            </div>
        </c:if>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
