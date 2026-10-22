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
                            <i class="bi bi-pencil-square me-2" style="color:#dfb990;"></i>Edit Admin Privileges
                        </h4>
                        <small style="color:rgba(255,255,255,0.7);">Modifying credentials and permission boundaries for <strong>${admin.username}</strong></small>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/list" class="btn btn-outline-plum btn-sm px-3">
                        <i class="bi bi-arrow-left me-1"></i> Admin List
                    </a>
                </div>

                <div class="card-body p-4 p-md-5">
                    <form action="${pageContext.request.contextPath}/admin/edit" method="post">
                        <input type="hidden" name="adminId" value="${admin.userId}"/>

                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold" style="color:#786670;">Admin ID</label>
                                <input type="text" class="form-control bg-light" value="${admin.userId}" style="border-color:#ede3da;" readonly disabled>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold" style="color:#786670;">Username</label>
                                <input type="text" class="form-control bg-light" value="${admin.username}" style="border-color:#ede3da;" readonly disabled>
                            </div>
                            <div class="col-md-6">
                                <label for="email" class="form-label fw-semibold" style="color:#240e18;">Email Address <span style="color:#c49a6c;">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light" style="border-color:#ede3da;"><i class="bi bi-envelope" style="color:#c49a6c;"></i></span>
                                    <input type="email" class="form-control" id="email" name="email" value="${admin.email}" style="border-color:#ede3da;" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="password" class="form-label fw-semibold" style="color:#240e18;">New Password (Optional)</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light" style="border-color:#ede3da;"><i class="bi bi-key" style="color:#c49a6c;"></i></span>
                                    <input type="password" class="form-control" id="password" name="password" placeholder="Leave blank to keep existing password" style="border-color:#ede3da;">
                                </div>
                            </div>
                        </div>

                        <!-- Permissions Checkboxes -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold d-block" style="color:#240e18;">
                                <i class="bi bi-shield-lock me-1" style="color:#c49a6c;"></i> Update Permissions
                            </label>
                            <div class="p-3 rounded-4" style="background:#fbf8f3; border: 1px solid #ede3da;">
                                <div class="row g-3">
                                    <c:forEach items="${availablePermissions}" var="perm">
                                        <div class="col-md-6">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="permissions" value="${perm}" id="perm_${perm}"
                                                       ${admin.hasPermission(perm) ? 'checked' : ''}>
                                                <label class="form-check-label fw-semibold small" for="perm_${perm}" style="color:#240e18;">
                                                    <code>${perm}</code>
                                                </label>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <!-- Submit Buttons -->
                        <div class="d-flex justify-content-end gap-2 pt-3" style="border-top:1px solid #f0e8e0;">
                            <a href="${pageContext.request.contextPath}/admin/list" class="btn btn-outline-plum px-4">
                                Cancel
                            </a>
                            <button type="submit" class="btn btn-plum px-5 fw-semibold">
                                <i class="bi bi-save me-1"></i> Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
