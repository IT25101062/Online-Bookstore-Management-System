<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-literary sticky-top">
    <div class="container">
        <!-- Brand Logo with Quill Feather -->
        <a class="navbar-brand navbar-brand-literary" href="${pageContext.request.contextPath}/">
            <span>Chapter One</span>
            <i class="bi bi-book-half" style="color: #c49a6c; font-size: 1.35rem;"></i>
        </a>

        <!-- Mobile Toggler -->
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Navigation Links -->
        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav mx-auto mb-2 mb-lg-0 gap-1 align-items-center">
                <li class="nav-item">
                    <a class="nav-link nav-link-literary ${pageContext.request.requestURI.endsWith('home.jsp') || pageContext.request.requestURI.equals('/') ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/">
                        Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-link-literary" href="${pageContext.request.contextPath}/books">
                        Books Catalog
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-link-literary" href="${pageContext.request.contextPath}/books/search">
                        Search
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-link-literary" href="${pageContext.request.contextPath}/reviews">
                        Reviews
                    </a>
                </li>
                <c:if test="${sessionScope.currentUser != null}">
                    <li class="nav-item">
                        <a class="nav-link nav-link-literary" href="${pageContext.request.contextPath}/orders">
                            My Orders
                        </a>
                    </li>
                </c:if>
                <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.hasAdminPrivileges()}">
                    <li class="nav-item dropdown">
                        <a class="nav-link nav-link-literary dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false" style="color: var(--gold-accent) !important;">
                            <i class="bi bi-shield-lock me-1"></i> Admin Portal
                        </a>
                        <ul class="dropdown-menu shadow border-0 rounded-3 p-2" style="background: var(--plum-dark);">
                            <li><a class="dropdown-item text-white small py-2" href="${pageContext.request.contextPath}/admin"><i class="bi bi-speedometer2 me-2 text-warning"></i>Admin Dashboard</a></li>
                            <li><hr class="dropdown-divider border-secondary"></li>
                            <li><a class="dropdown-item text-white small py-2" href="${pageContext.request.contextPath}/books/manage"><i class="bi bi-bookshelf me-2 text-info"></i>Manage Books & Catalog</a></li>
                            <li><a class="dropdown-item text-white small py-2" href="${pageContext.request.contextPath}/inventory"><i class="bi bi-boxes me-2 text-success"></i>Inventory & Stock Control</a></li>
                            <li><a class="dropdown-item text-white small py-2" href="${pageContext.request.contextPath}/inventory/reports"><i class="bi bi-file-earmark-bar-graph me-2 text-warning"></i>Inventory Reports</a></li>
                            <li><hr class="dropdown-divider border-secondary"></li>
                            <li><a class="dropdown-item text-white small py-2" href="${pageContext.request.contextPath}/orders/all"><i class="bi bi-truck me-2 text-light"></i>Customer Orders</a></li>
                            <li><a class="dropdown-item text-white small py-2" href="${pageContext.request.contextPath}/users"><i class="bi bi-people me-2 text-light"></i>Manage Users</a></li>
                            <li><hr class="dropdown-divider border-secondary"></li>
                            <li><a class="dropdown-item text-white small py-2" href="${pageContext.request.contextPath}/admin/list"><i class="bi bi-person-badge me-2 text-warning"></i>Admin Staff Directory</a></li>
                            <li><a class="dropdown-item text-white small py-2" href="${pageContext.request.contextPath}/admin/logs"><i class="bi bi-clock-history me-2 text-info"></i>System Activity Logs</a></li>
                        </ul>
                    </li>
                </c:if>
            </ul>

            <!-- Right Actions: Cart & User / Admin Login -->
            <div class="d-flex align-items-center gap-2">
                <a class="btn btn-outline-plum position-relative px-3 py-2" href="${pageContext.request.contextPath}/cart" title="Shopping Cart">
                    <i class="bi bi-bag me-1"></i>
                    <span>Cart</span>
                    <c:if test="${sessionScope.cartCount != null && sessionScope.cartCount > 0}">
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                            ${sessionScope.cartCount}
                        </span>
                    </c:if>
                </a>

                <c:choose>
                    <c:when test="${sessionScope.currentUser != null}">
                        <div class="dropdown">
                            <button class="btn btn-plum dropdown-toggle d-flex align-items-center gap-2" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <c:choose>
                                    <c:when test="${sessionScope.currentUser.hasProfilePicture()}">
                                        <img src="${pageContext.request.contextPath}/images/profiles/${sessionScope.currentUser.profilePicture}"
                                             alt="Profile"
                                             style="width:26px; height:26px; border-radius:50%; object-fit:cover; border:1.5px solid rgba(255,255,255,0.5);" />
                                    </c:when>
                                    <c:otherwise>
                                        <span style="width:26px; height:26px; border-radius:50%; background:rgba(255,255,255,0.18); display:inline-flex; align-items:center; justify-content:center; font-size:0.85rem; font-weight:700; border:1.5px solid rgba(255,255,255,0.4);">
                                            ${sessionScope.currentUser.fullName.substring(0,1)}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                                <span>${sessionScope.currentUser.fullName}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 rounded-3 p-2 mt-2" style="background: var(--plum-dark);">
                                <li class="px-3 py-2 text-white-50 small border-bottom border-secondary mb-1">
                                    Signed in as <strong class="text-white">${sessionScope.currentUser.username}</strong><br>
                                    <span class="badge bg-secondary mt-1">${sessionScope.currentUser.getRoleDescription()}</span>
                                </li>
                                <c:if test="${sessionScope.currentUser.hasAdminPrivileges()}">
                                    <li><a class="dropdown-item text-warning small py-2" href="${pageContext.request.contextPath}/admin"><i class="bi bi-shield-lock me-2"></i>Admin Dashboard</a></li>
                                </c:if>
                                <li><a class="dropdown-item text-white small py-2" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person-gear me-2"></i>My Profile</a></li>
                                <li><a class="dropdown-item text-white small py-2" href="${pageContext.request.contextPath}/orders"><i class="bi bi-receipt me-2"></i>Order History</a></li>
                                <li><hr class="dropdown-divider border-secondary"></li>
                                <li><a class="dropdown-item text-danger small py-2" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Sign Out</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-plum py-2 px-3">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-plum py-2 px-3">
                            <i class="bi bi-person-plus me-1"></i> Register
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
