<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h2 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">
                <i class="bi bi-clock-history me-2" style="color:#c49a6c;"></i>Admin Audit & Activity Log
            </h2>
            <p class="small mb-0" style="color:#786670;">Traceability audit trail of operations recorded in <code>activity_logs.txt</code></p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-plum px-3">
                <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
            </a>
        </div>
    </div>

    <!-- Filter Card -->
    <div class="card border-0 rounded-4 p-3 mb-4 bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
        <form action="${pageContext.request.contextPath}/admin/logs" method="get" class="row g-2 align-items-center">
            <div class="col-md-9">
                <div class="input-group">
                    <span class="input-group-text bg-light" style="border-color:#ede3da;"><i class="bi bi-filter" style="color:#c49a6c;"></i></span>
                    <select name="adminId" class="form-select" style="border-color:#ede3da;">
                        <option value="">All Administrators (Showing Everything)</option>
                        <c:forEach items="${allAdmins}" var="adm">
                            <option value="${adm.userId}" ${filterAdmin == adm.userId ? 'selected' : ''}>
                                ${adm.username} (${adm.userId}) - ${adm.adminType}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-plum w-100 fw-semibold">
                    Apply Filter
                </button>
                <c:if test="${not empty filterAdmin}">
                    <a href="${pageContext.request.contextPath}/admin/logs" class="btn btn-outline-plum">
                        Clear
                    </a>
                </c:if>
            </div>
        </form>
    </div>

    <!-- Logs Table -->
    <div class="card border-0 rounded-4 overflow-hidden bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
        <c:choose>
            <c:when test="${empty logs}">
                <div class="p-5 text-center" style="color:#786670;">
                    <i class="bi bi-journal-x fs-1 d-block mb-3" style="color:#d8ccce;"></i>
                    <h5 class="fw-bold" style="font-family:'Playfair Display',serif; color:#240e18;">No activity log entries found</h5>
                    <p class="small">No administrative transactions recorded for the selected filter.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead style="background:#f9f4ef;">
                            <tr>
                                <th class="ps-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Log ID</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Timestamp</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Operator Admin ID</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Action Performed</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${logs}" var="entry">
                                <tr style="border-color:#f5ede7;">
                                    <td class="ps-4">
                                        <span class="badge px-2 py-1" style="background:#f4ece2; color:#6b5244; border:1px solid #e8ded4; font-family:monospace;">${entry.logId}</span>
                                    </td>
                                    <td>
                                        <span class="small" style="color:#786670;"><i class="bi bi-calendar-event me-1"></i>${entry.timestamp}</span>
                                    </td>
                                    <td>
                                        <span class="badge px-3 py-1 rounded-pill" style="background:rgba(196,154,108,0.15); color:#8c5b1c; border:1px solid rgba(196,154,108,0.35);">
                                            <i class="bi bi-person-fill me-1"></i>${entry.adminId}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="fw-semibold" style="color:#240e18;">${entry.action}</div>
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
