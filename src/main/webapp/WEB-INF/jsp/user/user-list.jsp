<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-people-fill text-primary me-2"></i>User Management</h2>
            <p class="text-muted small mb-0">Admin view: Search, inspect, and delete users stored in <code>users.txt</code></p>
        </div>
        <div class="d-flex gap-2">
            <span class="badge bg-primary-subtle text-primary border border-primary px-3 py-2 rounded-pill">
                CRUD: Read, Search, Delete
            </span>
        </div>
    </div>

    <!-- Search Form -->
    <div class="card border-0 shadow-sm rounded-4 p-3 mb-4 bg-white">
        <form action="${pageContext.request.contextPath}/users" method="get" class="row g-2 align-items-center">
            <div class="col-md-9">
                <div class="input-group">
                    <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                    <input type="text" class="form-control" name="keyword" value="${keyword}" placeholder="Search by Username, Name, Email, or Phone...">
                </div>
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-primary rounded-pill w-100 fw-semibold">
                    Search
                </button>
                <c:if test="${not empty keyword}">
                    <a href="${pageContext.request.contextPath}/users" class="btn btn-outline-secondary rounded-pill">
                        Clear
                    </a>
                </c:if>
            </div>
        </form>
    </div>

    <!-- Users Table -->
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                    <tr>
                        <th class="ps-4">ID</th>
                        <th>User</th>
                        <th>Contact</th>
                        <th>Role & Hierarchy</th>
                        <th>Discount Rate</th>
                        <th>Registered</th>
                        <th class="text-end pe-4">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${users}" var="u">
                        <tr>
                            <td class="ps-4 fw-bold text-secondary">
                                <code>${u.userId}</code>
                            </td>
                            <td>
                                <div class="fw-bold text-dark">${u.fullName}</div>
                                <small class="text-muted">@${u.username}</small>
                            </td>
                            <td>
                                <div><i class="bi bi-envelope me-1 text-muted"></i> ${u.email}</div>
                                <small class="text-muted"><i class="bi bi-telephone me-1"></i> ${u.phoneNumber}</small>
                            </td>
                            <td>
                                <span class="badge ${u.hasAdminPrivileges() ? 'bg-danger' : 'bg-primary'} mb-1">
                                    ${u.role}
                                </span>
                                <div class="small text-muted">${u.getRoleDescription()}</div>
                            </td>
                            <td>
                                <span class="badge bg-success-subtle text-success border border-success">
                                    <fmt:formatNumber value="${u.getDiscountRate() * 100}" maxFractionDigits="0"/>% Off
                                </span>
                            </td>
                            <td class="small text-muted">
                                ${u.createdAt}
                            </td>
                            <td class="text-end pe-4">
                                <c:choose>
                                    <c:when test="${u.userId == 'U001'}">
                                        <span class="badge bg-secondary">System Protected</span>
                                    </c:when>
                                    <c:when test="${u.userId == sessionScope.currentUser.userId}">
                                        <span class="badge bg-info text-dark">Current Session</span>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/users/delete" method="post" class="d-inline" onsubmit="return confirmDelete('user @${u.username}');">
                                            <input type="hidden" name="userId" value="${u.userId}">
                                            <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3">
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
                            <td colspan="7" class="text-center py-4 text-muted">
                                <i class="bi bi-people display-6 d-block mb-2"></i>
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
