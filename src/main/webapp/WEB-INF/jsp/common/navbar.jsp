<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-dark sticky-top shadow-sm py-2">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/">
            <i class="bi bi-book-half text-primary fs-3"></i>
            <span class="fw-bold tracking-tight">ReadVerse</span>
            <span class="brand-badge ms-1">OOP Edition</span>
        </a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-3 gap-1">
                <li class="nav-item">
                    <a class="nav-link text-white" href="${pageContext.request.contextPath}/books">
                        <i class="bi bi-grid me-1"></i> Books Catalog
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="${pageContext.request.contextPath}/books/search">
                        <i class="bi bi-search me-1"></i> Search
                    </a>
                </li>
                <c:if test="${sessionScope.currentUser != null}">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/orders">
                            <i class="bi bi-bag-check me-1"></i> My Orders
                        </a>
                    </li>
                </c:if>
                <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.hasAdminPrivileges()}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle text-warning fw-semibold" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-shield-lock me-1"></i> Admin Portal
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark shadow">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/books/manage"><i class="bi bi-bookshelf me-2"></i>Manage Books & Stock</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/categories"><i class="bi bi-tags me-2"></i>Manage Categories</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/users"><i class="bi bi-people me-2"></i>Manage Users</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/orders"><i class="bi bi-truck me-2"></i>Manage Orders</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/reviews/admin"><i class="bi bi-chat-square-quote me-2"></i>Review Moderation</a></li>
                        </ul>
                    </li>
                </c:if>
            </ul>

            <!-- Right Actions: Cart & Auth -->
            <div class="d-flex align-items-center gap-2">
                <a class="btn btn-outline-light position-relative btn-sm px-3 rounded-pill" href="${pageContext.request.contextPath}/cart">
                    <i class="bi bi-cart3 me-1"></i> Cart
                    <c:if test="${sessionScope.cartCount != null && sessionScope.cartCount > 0}">
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                            ${sessionScope.cartCount}
                        </span>
                    </c:if>
                </a>

                <c:choose>
                    <c:when test="${sessionScope.currentUser != null}">
                        <div class="dropdown">
                            <button class="btn btn-sm btn-outline-light dropdown-toggle rounded-pill px-3 d-flex align-items-center gap-2" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle fs-6"></i>
                                <span>${sessionScope.currentUser.fullName}</span>
                                <span class="badge ${sessionScope.currentUser.hasAdminPrivileges() ? 'bg-danger' : 'bg-primary'} ms-1">
                                    ${sessionScope.currentUser.role}
                                </span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow">
                                <li class="px-3 py-1 text-muted small">
                                    Signed in as <strong>${sessionScope.currentUser.username}</strong><br>
                                    <span class="badge bg-secondary mt-1">${sessionScope.currentUser.getRoleDescription()}</span>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person-gear me-2"></i>My Profile</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders"><i class="bi bi-receipt me-2"></i>Order History</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light btn-sm rounded-pill px-3">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Login
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm rounded-pill px-3">
                            <i class="bi bi-person-plus me-1"></i> Register
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
