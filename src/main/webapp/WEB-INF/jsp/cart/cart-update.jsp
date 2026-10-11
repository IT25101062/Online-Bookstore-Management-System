<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card border-0 shadow-lg rounded-4 overflow-hidden bg-white">
                <div class="bg-dark p-4 text-white d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="fw-bold mb-1"><i class="bi bi-pencil-square text-primary me-2"></i>Update Item Quantity</h4>
                        <small class="text-secondary">Cart Item ID: <code>${item.cartItemId}</code></small>
                    </div>
                    <span class="badge bg-warning-subtle text-warning border border-warning px-3 py-2 rounded-pill">
                        CRUD: Update
                    </span>
                </div>

                <div class="card-body p-4 p-md-5">
                    <div class="p-3 bg-light rounded-3 mb-4 border">
                        <h5 class="fw-bold mb-1 text-dark">
                            <c:choose>
                                <c:when test="${item.book != null}">
                                    ${item.book.title}
                                </c:when>
                                <c:otherwise>
                                    Book ID: ${item.bookId}
                                </c:otherwise>
                            </c:choose>
                        </h5>
                        <div class="text-muted small">
                            Unit Price: $<fmt:formatNumber value="${item.pricePerUnit}" minFractionDigits="2"/>
                            <c:if test="${item.book != null}">
                                &bull; Available Stock: <strong>${item.book.stockQuantity}</strong>
                            </c:if>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/cart/update" method="post">
                        <input type="hidden" name="cartItemId" value="${item.cartItemId}">

                        <div class="mb-4">
                            <label for="quantity" class="form-label fw-semibold">New Quantity</label>
                            <input type="number" class="form-control form-control-lg" id="quantity" name="quantity" value="${item.quantity}" min="1" max="99" required autofocus>
                            <small class="text-muted">Stock will be verified against inventory before updating <code>cart.txt</code>.</small>
                        </div>

                        <div class="d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-secondary rounded-pill px-4">Cancel</a>
                            <button type="submit" class="btn btn-primary rounded-pill px-4 fw-semibold">
                                <i class="bi bi-save me-1"></i> Update Quantity
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
