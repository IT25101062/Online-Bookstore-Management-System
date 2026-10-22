<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h2 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">
                <i class="bi bi-file-earmark-bar-graph-fill me-2" style="color:#c49a6c;"></i>Inventory Audit Reports
            </h2>
            <p class="small mb-0" style="color:#786670;">Generated stock level, reorder analysis, and catalog reports persisted in <code>reports.txt</code></p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/inventory" class="btn btn-outline-plum px-3">
                <i class="bi bi-arrow-left me-1"></i> Stock Control
            </a>
            <button type="button" class="btn btn-plum px-4" data-bs-toggle="modal" data-bs-target="#generateReportModal">
                <i class="bi bi-plus-circle me-1"></i> Generate New Report
            </button>
        </div>
    </div>

    <!-- Generate Report Modal -->
    <div class="modal fade" id="generateReportModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow-lg overflow-hidden">
                <form action="${pageContext.request.contextPath}/inventory/reports/generate" method="post">
                    <div class="modal-header p-4 text-white" style="background: linear-gradient(135deg, #240e18 0%, #361724 100%); border-bottom: 1px solid rgba(196,154,108,0.3);">
                        <h5 class="modal-title fw-bold" style="font-family:'Playfair Display',serif;">
                            <i class="bi bi-clipboard2-data me-2" style="color:#dfb990;"></i>Generate Inventory Audit Report
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4" style="background:#fdfcfb;">
                        <div class="mb-3">
                            <label class="form-label fw-semibold" style="color:#240e18;">Select Report Type</label>
                            <select name="reportType" class="form-select rounded-3" style="border: 1px solid #ede3da;" required>
                                <option value="STOCK_SUMMARY">Stock Summary Report (Total catalog valuation & units)</option>
                                <option value="LOW_STOCK_ALERT">Low-Stock Alert Audit (Items requiring immediate supplier restock)</option>
                                <option value="FULL_INVENTORY">Full Inventory Audit (Comprehensive catalog snapshot)</option>
                            </select>
                        </div>
                        <p class="small mb-0" style="color:#786670;">
                            The report will analyze live quantities from <code>books.txt</code> and save the immutable audit log under your Admin ID.
                        </p>
                    </div>
                    <div class="modal-footer p-3" style="background:#f9f4ef; border-top:1px solid #ede3da;">
                        <button type="button" class="btn btn-outline-plum px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-plum px-4 fw-semibold">Generate Now</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Reports Table Card -->
    <div class="card border-0 rounded-4 overflow-hidden bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
        <c:choose>
            <c:when test="${empty reports}">
                <div class="p-5 text-center" style="color:#786670;">
                    <i class="bi bi-clipboard-x fs-1 d-block mb-3" style="color:#d8ccce;"></i>
                    <h5 class="fw-bold" style="font-family:'Playfair Display',serif; color:#240e18;">No inventory reports generated yet</h5>
                    <p class="small">Click "Generate New Report" to create an instant snapshot of your inventory.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead style="background:#f9f4ef;">
                            <tr>
                                <th class="ps-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Report ID</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Report Type</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Generated By</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Date</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Titles</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Total Stock</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Low Stock</th>
                                <th class="small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Summary Details</th>
                                <th class="text-end pe-4 small fw-semibold" style="color:#786670; text-transform:uppercase; letter-spacing:1px; border:none;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${reports}" var="r">
                                <tr style="border-color:#f5ede7;">
                                    <td class="ps-4">
                                        <span class="badge px-2 py-1" style="background:#f4ece2; color:#6b5244; border:1px solid #e8ded4; font-family:monospace;">${r.reportId}</span>
                                    </td>
                                    <td>
                                        <span class="badge px-2 py-1" style="background:rgba(54,23,36,0.08); color:#361724; border:1px solid rgba(54,23,36,0.2);">
                                            ${r.reportType}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="small" style="color:#786670;"><i class="bi bi-person me-1"></i>${r.generatedBy}</span>
                                    </td>
                                    <td>
                                        <span class="small" style="color:#786670;">${r.generatedDate}</span>
                                    </td>
                                    <td><span class="fw-semibold" style="color:#240e18;">${r.totalBooks}</span></td>
                                    <td><span class="fw-semibold" style="color:#2d8a2d;">${r.totalStock}</span></td>
                                    <td>
                                        <span class="badge px-2 py-1" style="${r.lowStockCount > 0 ? 'background:rgba(200,0,0,0.1); color:#a02020; border:1px solid rgba(200,0,0,0.25);' : 'background:rgba(76,174,76,0.12); color:#2d8a2d; border:1px solid rgba(76,174,76,0.3);'}">
                                            ${r.lowStockCount}
                                        </span>
                                    </td>
                                    <td style="max-width: 250px;" class="text-truncate">
                                        <span class="small" style="color:#786670;" title="${r.content}">${r.content}</span>
                                    </td>
                                    <td class="text-end pe-4">
                                        <form action="${pageContext.request.contextPath}/inventory/reports/delete" method="post" 
                                              class="d-inline" onsubmit="return confirm('Delete report ${r.reportId}?');">
                                            <input type="hidden" name="reportId" value="${r.reportId}"/>
                                            <button type="submit" class="btn btn-sm btn-outline-plum px-2" style="color:#a02020; border-color:rgba(200,0,0,0.3);" title="Delete Report">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
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
