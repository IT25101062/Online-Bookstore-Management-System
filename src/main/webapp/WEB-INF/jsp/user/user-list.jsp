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
                <i class="bi bi-people-fill me-2" style="color:#c49a6c;"></i>User Management
            </h2>
            <p class="small mb-0" style="color:#786670;">Manage customer and admin accounts, search directory, and records</p>
        </div>
    </div>

    <!-- Search Form -->
    <div class="card border-0 rounded-4 p-3 mb-4 bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
        <form action="${pageContext.request.contextPath}/users" method="get" class="row g-2 align-items-center">
            <div class="col-md-9">
                <div class="input-group">
                    <span class="input-group-text bg-light" style="border-color:#ede3da;"><i class="bi bi-search" style="color:#c49a6c;"></i></span>
                    <input type="text" class="form-control" name="keyword" value="${keyword}" placeholder="Search by Username, Name, Email, or Phone..." style="border-color:#ede3da;">
                </div>
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-plum w-100 fw-semibold">
                    Search
                </button>
                <c:if test="${not empty keyword}">
                    <a href="${pageContext.request.contextPath}/users" class="btn btn-outline-plum">
                        Clear
                    </a>
                </c:if>
            </div>
        </form>
    </div>

    <!-- Users Table -->
    <div class="card border-0 rounded-4 overflow-hidden bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead style="background:#f9f4ef;">
                    <tr>
                        <th class="ps-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">ID</th>
                        <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">User</th>
                        <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Contact</th>
                        <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Role & Hierarchy</th>
                        <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Discount Rate</th>
                        <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Registered</th>
                        <th class="text-end pe-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${users}" var="u">
                        <tr style="border-color:#f5ede7;">
                            <td class="ps-4">
                                <span class="badge px-2 py-1" style="background:#f4ece2; color:#6b5244; border:1px solid #e8ded4; font-family:monospace;">${u.userId}</span>
                            </td>
                            <td>
                                <div class="fw-bold" style="color:#240e18;">${u.fullName}</div>
                                <small style="color:#786670;">@${u.username}</small>
                            </td>
                            <td>
                                <div style="color:#4a3b43;"><i class="bi bi-envelope me-1" style="color:#c49a6c;"></i> ${u.email}</div>
                                <small style="color:#786670;"><i class="bi bi-telephone me-1" style="color:#c49a6c;"></i> ${u.phoneNumber}</small>
                            </td>
                            <td>
                                <span class="badge px-2 py-1 mb-1" style="${u.hasAdminPrivileges() ? 'background:rgba(54,23,36,0.12); color:#361724; border:1px solid rgba(54,23,36,0.25);' : 'background:rgba(196,154,108,0.15); color:#8c5b1c; border:1px solid rgba(196,154,108,0.35);'}">
                                    ${u.role}
                                </span>
                                <div class="small" style="color:#786670;">${u.getRoleDescription()}</div>
                            </td>
                            <td>
                                <span class="badge px-2 py-1" style="background:rgba(76,174,76,0.12); color:#2d8a2d; border:1px solid rgba(76,174,76,0.3);">
                                    <fmt:formatNumber value="${u.getDiscountRate() * 100}" maxFractionDigits="0"/>% Off
                                </span>
                            </td>
                            <td class="small" style="color:#786670;">
                                ${u.createdAt}
                            </td>
                            <td class="text-end pe-4">
                                <c:choose>
                                    <c:when test="${u.userId == 'U001'}">
                                        <span class="badge px-2 py-1" style="background:#f4ece2; color:#786670; border:1px solid #e8ded4;">System Protected</span>
                                    </c:when>
                                    <c:when test="${u.userId == sessionScope.currentUser.userId}">
                                        <span class="badge px-2 py-1" style="background:rgba(196,154,108,0.2); color:#8c5b1c; border:1px solid rgba(196,154,108,0.4);">Current Session</span>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/users/delete" method="post" class="d-inline" onsubmit="return confirmDelete('user @${u.username}');">
                                            <input type="hidden" name="userId" value="${u.userId}">
                                            <button type="submit" class="btn btn-outline-plum btn-sm px-3" style="color:#a02020; border-color:rgba(200,0,0,0.3);">
                                                <i class="bi bi-trash"></i> Delete
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="7" class="text-center py-5" style="color:#786670;">
                                <i class="bi bi-people display-6 d-block mb-2" style="color:#d8ccce;"></i>
                                No users found matching your search criteria.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
