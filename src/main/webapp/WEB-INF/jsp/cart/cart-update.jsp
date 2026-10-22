<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card border-0 rounded-4 overflow-hidden bg-white" style="box-shadow:0 10px 40px rgba(44,18,30,0.1); border:1px solid #ede3da !important;">
                <div class="p-4 text-white d-flex justify-content-between align-items-center"
                     style="background: linear-gradient(135deg, #240e18 0%, #361724 55%, #502538 100%); border-bottom: 1px solid rgba(196,154,108,0.25);">
                    <div>
                        <h4 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#fff;">
                            <i class="bi bi-pencil-square me-2" style="color:#dfb990;"></i>Update Item Quantity
                        </h4>
                        <small style="color:rgba(255,255,255,0.7);">Cart Item ID: <code>${item.cartItemId}</code></small>
                    </div>

                </div>

                <div class="card-body p-4 p-md-5">
                    <div class="p-3 rounded-3 mb-4" style="background:#fbf8f3; border: 1px solid #ede3da;">
                        <h5 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">
                            <c:choose>
                                <c:when test="${item.book != null}">
                                    ${item.book.title}
                                </c:when>
                                <c:otherwise>
                                    Book ID: ${item.bookId}
                                </c:otherwise>
                            </c:choose>
                        </h5>
                        <div class="small" style="color:#786670;">
                            Unit Price: Rs. <fmt:formatNumber value="${item.pricePerUnit}" minFractionDigits="2"/>
                            <c:if test="${item.book != null}">
                                &bull; Available Stock: <strong style="color:#240e18;">${item.book.stockQuantity}</strong>
                            </c:if>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/cart/update" method="post">
                        <input type="hidden" name="cartItemId" value="${item.cartItemId}">

                        <div class="mb-4">
                            <label for="quantity" class="form-label fw-semibold" style="color:#240e18;">New Quantity</label>
                            <input type="number" class="form-control form-control-lg" id="quantity" name="quantity" value="${item.quantity}" min="1" max="99" style="border-color:#ede3da;" required autofocus>
                            <small style="color:#786670;">Stock will be verified against inventory before updating your cart.</small>
                        </div>

                        <div class="d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-plum px-4">Cancel</a>
                            <button type="submit" class="btn btn-plum px-4 fw-semibold">
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
