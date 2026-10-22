<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 rounded-4 overflow-hidden bg-white" style="box-shadow:0 10px 40px rgba(44,18,30,0.1); border:1px solid #ede3da !important;">
                <div class="card-header p-4 text-white d-flex justify-content-between align-items-center"
                     style="background: linear-gradient(135deg, #240e18 0%, #361724 55%, #502538 100%); border-bottom: 1px solid rgba(196,154,108,0.25);">
                    <div>
                        <h4 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#fff;">
                            <i class="bi bi-person-plus-fill me-2" style="color:#dfb990;"></i>Register New Admin Account
                        </h4>
                        <small style="color:rgba(255,255,255,0.7);">Create an administrative staff user with designated permissions</small>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/list" class="btn btn-outline-plum btn-sm px-3">
                        <i class="bi bi-arrow-left me-1"></i> Admin List
                    </a>
                </div>

                <div class="card-body p-4 p-md-5">
                    <form action="${pageContext.request.contextPath}/admin/register" method="post">
                        <!-- Account Details -->
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label for="username" class="form-label fw-semibold" style="color:#240e18;">Username <span style="color:#c49a6c;">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light" style="border-color:#ede3da;"><i class="bi bi-person" style="color:#c49a6c;"></i></span>
                                    <input type="text" class="form-control" id="username" name="username" required placeholder="e.g. admin_kasun" style="border-color:#ede3da;">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="email" class="form-label fw-semibold" style="color:#240e18;">Email Address <span style="color:#c49a6c;">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light" style="border-color:#ede3da;"><i class="bi bi-envelope" style="color:#c49a6c;"></i></span>
                                    <input type="email" class="form-control" id="email" name="email" required placeholder="kasun@readerscafe.com" style="border-color:#ede3da;">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="password" class="form-label fw-semibold" style="color:#240e18;">Password <span style="color:#c49a6c;">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light" style="border-color:#ede3da;"><i class="bi bi-key" style="color:#c49a6c;"></i></span>
                                    <input type="password" class="form-control" id="password" name="password" required minlength="6" placeholder="At least 6 characters" style="border-color:#ede3da;">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="adminType" class="form-label fw-semibold" style="color:#240e18;">Admin Hierarchy Type <span style="color:#c49a6c;">*</span></label>
                                <select class="form-select" id="adminType" name="adminType" style="border-color:#ede3da;" required>
                                    <option value="MODERATOR" selected>Moderator Admin (Standard Operations)</option>
                                    <option value="SUPER">Super Admin (Full Root Permissions)</option>
                                </select>
                            </div>
                        </div>

                        <!-- Permissions Checkboxes -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold d-block" style="color:#240e18;">
                                <i class="bi bi-shield-check me-1" style="color:#c49a6c;"></i> Assigned Privileges & Permissions
                            </label>
                            <div class="p-3 rounded-4" style="background:#fbf8f3; border: 1px solid #ede3da;">
                                <div class="row g-3">
                                    <c:forEach items="${availablePermissions}" var="perm">
                                        <div class="col-md-6">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="permissions" value="${perm}" id="perm_${perm}">
                                                <label class="form-check-label fw-semibold small" for="perm_${perm}" style="color:#240e18;">
                                                    <code>${perm}</code>
                                                </label>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="form-text mt-2" style="color:#786670;">
                                Super Admins inherently possess all managerial privileges.
                            </div>
                        </div>

                        <!-- Submit Buttons -->
                        <div class="d-flex justify-content-end gap-2 pt-3" style="border-top:1px solid #f0e8e0;">
                            <a href="${pageContext.request.contextPath}/admin/list" class="btn btn-outline-plum px-4">
                                Cancel
                            </a>
                            <button type="submit" class="btn btn-plum px-5 fw-semibold">
                                <i class="bi bi-check-circle me-1"></i> Register Admin
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
