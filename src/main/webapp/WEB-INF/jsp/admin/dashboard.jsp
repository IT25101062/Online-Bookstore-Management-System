<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <!-- Welcome Hero Banner -->
    <div class="rounded-4 p-4 p-md-5 mb-4 text-white position-relative overflow-hidden"
         style="background: linear-gradient(135deg, #180911 0%, #2e111e 50%, #4a1f32 100%); border: 1px solid rgba(196,154,108,0.35); box-shadow:0 10px 40px rgba(44,18,30,0.12);">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <span class="badge px-3 py-2 rounded-pill text-uppercase fw-bold mb-3 d-inline-block"
                      style="background: rgba(196,154,108,0.2); color: #dfb990; border: 1px solid rgba(196,154,108,0.4); letter-spacing: 1.5px; font-size:0.7rem;">
                    <i class="bi bi-shield-fill-check me-1"></i> Executive Operations Center
                </span>
                <h1 class="display-6 fw-bold mb-2" style="font-family: 'Playfair Display', serif; color: #fff;">
                    Welcome, <span style="color: #dfb990;">${currentUser.fullName}</span>
                </h1>
                <p style="color: rgba(255,255,255,0.7); font-size: 0.97rem; line-height: 1.7; margin-bottom: 1.8rem;">
                    Monitor real-time sales metrics, supervise bookstore inventory, manage reader accounts, and track system security audits.
                </p>
                <div class="d-flex flex-wrap gap-2">
                    <a href="${pageContext.request.contextPath}/books/add" class="btn btn-plum px-4" style="background:#c49a6c !important; border-color:#c49a6c !important;">
                        <i class="bi bi-plus-circle me-1"></i> Add New Book
                    </a>
                    <a href="${pageContext.request.contextPath}/orders/all" class="btn" style="background:rgba(255,255,255,0.1); color:#fff; border:1px solid rgba(255,255,255,0.25); border-radius:6px; font-size:0.8rem; font-weight:600; letter-spacing:1.2px; text-transform:uppercase; padding:0.7rem 1.4rem;">
                        <i class="bi bi-truck me-1"></i> Customer Orders
                    </a>
                    <a href="${pageContext.request.contextPath}/inventory/low-stock" class="btn" style="background:rgba(255,255,255,0.1); color:#fff; border:1px solid rgba(255,255,255,0.25); border-radius:6px; font-size:0.8rem; font-weight:600; letter-spacing:1.2px; text-transform:uppercase; padding:0.7rem 1.4rem;">
                        <i class="bi bi-exclamation-triangle me-1"></i> Low Stock Alerts
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/logs" class="btn" style="background:rgba(255,255,255,0.1); color:#fff; border:1px solid rgba(255,255,255,0.25); border-radius:6px; font-size:0.8rem; font-weight:600; letter-spacing:1.2px; text-transform:uppercase; padding:0.7rem 1.4rem;">
                        <i class="bi bi-journal-text me-1"></i> Audit Trail
                    </a>
                </div>
            </div>
            <div class="col-lg-4 text-center d-none d-lg-block">
                <i class="bi bi-shield-lock" style="font-size: 8.5rem; color: rgba(196,154,108,0.18);"></i>
            </div>
        </div>
    </div>

    <!-- Live Executive KPI Summary Cards -->
    <div class="row g-3 mb-5">
        <!-- KPI 1: Total Revenue -->
        <div class="col-md-6 col-lg-3">
            <div class="card border-0 rounded-4 p-4 bg-white h-100 position-relative overflow-hidden"
                 style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="small fw-semibold text-uppercase" style="color:#786670; letter-spacing:0.8px; font-size:0.75rem;">Total Sales Revenue</span>
                    <div class="p-2 rounded-3" style="background:rgba(196,154,108,0.2); color:#8c5b1c;">
                        <i class="bi bi-cash-stack fs-5"></i>
                    </div>
                </div>
                <h3 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">
                    Rs. <fmt:formatNumber value="${totalRevenue}" minFractionDigits="2" maxFractionDigits="2"/>
                </h3>
                <small style="color:#2d8a2d;"><i class="bi bi-graph-up me-1"></i>All Active Orders</small>
            </div>
        </div>

        <!-- KPI 2: Total Orders -->
        <div class="col-md-6 col-lg-3">
            <div class="card border-0 rounded-4 p-4 bg-white h-100 position-relative overflow-hidden"
                 style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="small fw-semibold text-uppercase" style="color:#786670; letter-spacing:0.8px; font-size:0.75rem;">Customer Orders</span>
                    <div class="p-2 rounded-3" style="background:rgba(54,23,36,0.1); color:#361724;">
                        <i class="bi bi-bag-check fs-5"></i>
                    </div>
                </div>
                <h3 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">
                    ${totalOrders}
                </h3>
                <small style="color:#786670;"><a href="${pageContext.request.contextPath}/orders/all" style="color:#c49a6c; text-decoration:none;">View all orders &rarr;</a></small>
            </div>
        </div>

        <!-- KPI 3: Books in Catalog -->
        <div class="col-md-6 col-lg-3">
            <div class="card border-0 rounded-4 p-4 bg-white h-100 position-relative overflow-hidden"
                 style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="small fw-semibold text-uppercase" style="color:#786670; letter-spacing:0.8px; font-size:0.75rem;">Catalog Titles</span>
                    <div class="p-2 rounded-3" style="background:rgba(76,174,76,0.12); color:#2d8a2d;">
                        <i class="bi bi-bookshelf fs-5"></i>
                    </div>
                </div>
                <h3 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">
                    ${totalBooks}
                </h3>
                <small style="color:#786670;"><a href="${pageContext.request.contextPath}/books/manage" style="color:#c49a6c; text-decoration:none;">Manage catalog &rarr;</a></small>
            </div>
        </div>

        <!-- KPI 4: Low Stock Alerts -->
        <div class="col-md-6 col-lg-3">
            <div class="card border-0 rounded-4 p-4 bg-white h-100 position-relative overflow-hidden"
                 style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="small fw-semibold text-uppercase" style="color:#786670; letter-spacing:0.8px; font-size:0.75rem;">Low-Stock Warnings</span>
                    <div class="p-2 rounded-3" style="background:rgba(200,0,0,0.1); color:#a02020;">
                        <i class="bi bi-exclamation-triangle fs-5"></i>
                    </div>
                </div>
                <h3 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:${lowStockCount > 0 ? '#a02020' : '#240e18'};">
                    ${lowStockCount}
                </h3>
                <small style="color:${lowStockCount > 0 ? '#a02020' : '#2d8a2d'};">
                    <c:choose>
                        <c:when test="${lowStockCount > 0}">
                            <a href="${pageContext.request.contextPath}/inventory/low-stock" style="color:#a02020; font-weight:600; text-decoration:none;">Requires restock &rarr;</a>
                        </c:when>
                        <c:otherwise>All items healthy</c:otherwise>
                    </c:choose>
                </small>
            </div>
        </div>
    </div>

    <!-- Quick Navigation Management Cards -->
    <div class="row g-3 mb-5">
        <div class="col-md-6 col-lg-3">
            <div class="card border-0 rounded-4 h-100 p-4 bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="small fw-semibold" style="color:#786670;">Book Catalog</span>
                    <div class="p-2 rounded-3" style="background:rgba(54,23,36,0.08); color:#361724;">
                        <i class="bi bi-bookshelf fs-5"></i>
                    </div>
                </div>
                <h4 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">Books & Stock</h4>
                <p class="small mb-3" style="color:#786670;">Add books, edit prices, format types & stock</p>
                <a href="${pageContext.request.contextPath}/books/manage" class="btn btn-sm btn-outline-plum rounded-pill mt-auto">
                    Manage Books &rarr;
                </a>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="card border-0 rounded-4 h-100 p-4 bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="small fw-semibold" style="color:#786670;">Order Fulfillment</span>
                    <div class="p-2 rounded-3" style="background:rgba(76,174,76,0.12); color:#2d8a2d;">
                        <i class="bi bi-truck fs-5"></i>
                    </div>
                </div>
                <h4 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">Orders & Payments</h4>
                <p class="small mb-3" style="color:#786670;">Track orders, update statuses & payments</p>
                <a href="${pageContext.request.contextPath}/orders/all" class="btn btn-sm btn-outline-plum rounded-pill mt-auto">
                    Manage Orders &rarr;
                </a>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="card border-0 rounded-4 h-100 p-4 bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="small fw-semibold" style="color:#786670;">Stock Control</span>
                    <div class="p-2 rounded-3" style="background:rgba(196,154,108,0.2); color:#8c5b1c;">
                        <i class="bi bi-graph-up-arrow fs-5"></i>
                    </div>
                </div>
                <h4 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">Inventory Reports</h4>
                <p class="small mb-3" style="color:#786670;">Track low-stock items and generate audit reports</p>
                <a href="${pageContext.request.contextPath}/inventory/reports" class="btn btn-sm btn-outline-plum rounded-pill mt-auto">
                    View Reports &rarr;
                </a>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="card border-0 rounded-4 h-100 p-4 bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="small fw-semibold" style="color:#786670;">Administration</span>
                    <div class="p-2 rounded-3" style="background:rgba(54,23,36,0.12); color:#502538;">
                        <i class="bi bi-person-badge fs-5"></i>
                    </div>
                </div>
                <h4 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">Admins & Logs</h4>
                <p class="small mb-3" style="color:#786670;">Staff accounts, role permissions & activity logs</p>
                <a href="${pageContext.request.contextPath}/admin/list" class="btn btn-sm btn-outline-plum rounded-pill mt-auto">
                    Admin Staff &rarr;
                </a>
            </div>
        </div>
    </div>

    <!-- 2 Column Section: Admin Team & Recent Activity Log -->
    <div class="row g-4">
        <!-- Admin Accounts -->
        <div class="col-lg-6">
            <div class="card border-0 rounded-4 h-100 bg-white overflow-hidden" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="card-header bg-white p-4 d-flex justify-content-between align-items-center" style="border-bottom:1px solid #f0e8e0;">
                    <div>
                        <h5 class="fw-bold mb-0" style="font-family:'Playfair Display',serif; color:#240e18;">
                            <i class="bi bi-people-fill me-2" style="color:#c49a6c;"></i>Admin Staff Accounts
                        </h5>
                        <small style="color:#786670;">Managed via <code>admins.txt</code></small>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/register" class="btn btn-plum btn-sm px-3">
                        <i class="bi bi-person-plus me-1"></i> Register Admin
                    </a>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead style="background:#f9f4ef;">
                            <tr>
                                <th class="ps-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Admin</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Role</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Permissions</th>
                                <th class="text-end pe-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${admins}" var="adm">
                                <tr style="border-color:#f5ede7;">
                                    <td class="ps-4">
                                        <div class="fw-semibold" style="color:#240e18;">${adm.username}</div>
                                        <small style="color:#786670;">${adm.email}</small>
                                    </td>
                                    <td>
                                        <span class="badge px-2 py-1" style="${adm.adminType == 'Super Admin' ? 'background:rgba(196,154,108,0.2); color:#8c5b1c; border:1px solid rgba(196,154,108,0.4);' : 'background:rgba(54,23,36,0.1); color:#361724; border:1px solid rgba(54,23,36,0.2);'} font-size:0.7rem; font-weight:600;">
                                            ${adm.adminType}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="small" style="color:#786670;" title="${adm.permissionsAsString}">
                                            ${adm.permissions.size()} permissions
                                        </span>
                                    </td>
                                    <td class="text-end pe-4">
                                        <a href="${pageContext.request.contextPath}/admin/edit/${adm.userId}"
                                           class="btn btn-sm btn-outline-plum px-3" style="font-size:0.75rem;">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty admins}">
                                <tr>
                                    <td colspan="4" class="text-center py-5" style="color:#786670;">
                                        <i class="bi bi-person-badge" style="font-size:2.5rem; color:#d8ccce; display:block; margin-bottom:0.5rem;"></i>
                                        No admin accounts found.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Recent Activity Logs -->
        <div class="col-lg-6">
            <div class="card border-0 rounded-4 h-100 bg-white overflow-hidden" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="card-header bg-white p-4 d-flex justify-content-between align-items-center" style="border-bottom:1px solid #f0e8e0;">
                    <div>
                        <h5 class="fw-bold mb-0" style="font-family:'Playfair Display',serif; color:#240e18;">
                            <i class="bi bi-clock-history me-2" style="color:#c49a6c;"></i>Recent System Activity
                        </h5>
                        <small style="color:#786670;">Real-time audit from <code>activity_logs.txt</code></small>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/logs" class="btn btn-outline-plum btn-sm px-3">
                        View All &rarr;
                    </a>
                </div>
                <div class="card-body p-4">
                    <c:choose>
                        <c:when test="${empty recentLogs}">
                            <div class="text-center py-4" style="color:#786670;">
                                <i class="bi bi-journal-text" style="font-size:2.5rem; color:#d8ccce; display:block; margin-bottom:0.5rem;"></i>
                                No activity logs recorded yet.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="d-flex flex-column gap-2">
                                <c:forEach items="${recentLogs}" var="log">
                                    <div class="p-3 rounded-3 d-flex justify-content-between align-items-center"
                                         style="background:#fbf8f3; border:1px solid #ede3da;">
                                        <div>
                                            <div class="fw-semibold small" style="color:#240e18;">${log.action}</div>
                                            <small style="color:#786670;"><i class="bi bi-person me-1"></i>${log.adminId}</small>
                                        </div>
                                        <span class="badge px-2 py-1" style="background:rgba(196,154,108,0.12); color:#8c6040; border:1px solid rgba(196,154,108,0.25); font-size:0.68rem; white-space:nowrap;">${log.timestamp}</span>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
