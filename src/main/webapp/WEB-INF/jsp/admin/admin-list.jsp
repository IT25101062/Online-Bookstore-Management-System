<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h2 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;"><i class="bi bi-shield-lock-fill me-2" style="color:#c49a6c;"></i>Admin Staff Directory</h2>
            <p class="small mb-0" style="color:#786670;">System administrators and operational moderators saved in <code>admins.txt</code></p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-plum px-3" style="font-size:0.8rem;">
                <i class="bi bi-speedometer2 me-1"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/admin/register" class="btn btn-plum px-4">
                <i class="bi bi-person-plus me-1"></i> Add New Admin
            </a>
        </div>
    </div>

    <!-- Search Form -->
    <div class="card border-0 rounded-4 p-3 mb-4 bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
        <form action="${pageContext.request.contextPath}/admin/list" method="get" class="row g-2 align-items-center">
            <div class="col-md-9">
                <div class="input-group">
                    <span class="input-group-text" style="background:#fbf8f3; border-color:#e8ded4;"><i class="bi bi-search" style="color:#786670;"></i></span>
                    <input type="text" class="form-control" name="keyword" value="${keyword}" placeholder="Search admin by username, email, ID, or type...">
                </div>
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-plum w-100 fw-semibold">
                    Search
                </button>
                <c:if test="${not empty keyword}">
                    <a href="${pageContext.request.contextPath}/admin/list" class="btn btn-outline-plum">
                        Clear
                    </a>
                </c:if>
            </div>
        </form>
    </div>

    <!-- Admins Table -->
    <div class="card border-0 rounded-4 overflow-hidden bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
        <c:choose>
            <c:when test="${empty admins}">
                <div class="p-5 text-center text-muted">
                    <i class="bi bi-person-x fs-1 d-block mb-3"></i>
                    <h5>No administrators found</h5>
                    <p class="small">Try a different search keyword or register a new admin.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead style="background:#f9f4ef;">
                            <tr>
                                <th class="ps-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">ID</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Admin Staff</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Role Type</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Active Permissions</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Created Date</th>
                                <th class="text-end pe-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${admins}" var="adm">
                                <tr style="border-color:#f5ede7;">
                                    <td class="ps-4">
                                        <span class="badge font-monospace" style="background:#f4ece2; color:#6b5244; border:1px solid #e8ded4; font-size:0.75rem;">${adm.userId}</span>
                                    </td>
                                    <td>
                                        <div class="fw-bold" style="color:#240e18;">${adm.username}</div>
                                        <small style="color:#786670;"><i class="bi bi-envelope me-1"></i>${adm.email}</small>
                                    </td>
                                    <td>
                                        <span class="badge ${adm.adminType == 'Super Admin' ? 'bg-danger' : 'bg-primary'} px-3 py-2 rounded-pill">
                                            <i class="bi ${adm.adminType == 'Super Admin' ? 'bi-shield-shaded' : 'bi-shield-check'} me-1"></i>
                                            ${adm.adminType}
                                        </span>
                                    </td>
                                    <td style="max-width: 320px;">
                                        <div class="d-flex flex-wrap gap-1">
                                            <c:forEach items="${adm.permissions}" var="p">
                                                <span class="badge bg-secondary-subtle text-secondary border small">${p}</span>
                                            </c:forEach>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="small text-muted">${adm.createdAt}</span>
                                    </td>
                                    <td class="text-end pe-4">
                                        <div class="d-inline-flex gap-1 align-items-center">
                                            <a href="${pageContext.request.contextPath}/admin/edit/${adm.userId}" 
                                                class="btn btn-sm btn-outline-plum px-3" title="Edit Admin">
                                                <i class="bi bi-pencil me-1"></i> Edit
                                            </a>

                                            <c:if test="${sessionScope.currentUser.userId != adm.userId}">
                                                <form action="${pageContext.request.contextPath}/admin/delete" method="post" 
                                                      class="d-inline" onsubmit="return confirm('Delete admin account ${adm.username} permanently?');">
                                                    <input type="hidden" name="adminId" value="${adm.userId}"/>
                                                    <button type="submit" class="btn btn-sm px-2" style="background:rgba(200,0,0,0.08); color:#a02020; border:1px solid rgba(200,0,0,0.2); border-radius:6px;" title="Delete Admin">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
