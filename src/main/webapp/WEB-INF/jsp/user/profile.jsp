<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="row g-4">
        <!-- Profile Summary Card -->
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm rounded-4 text-center p-4 bg-white">
                <div class="mb-3">
                    <div class="rounded-circle bg-primary text-white d-inline-flex align-items-center justify-content-center" style="width: 90px; height: 90px; font-size: 2.5rem;">
                        ${user.fullName.substring(0, 1)}
                    </div>
                </div>
                <h4 class="fw-bold mb-1">${user.fullName}</h4>
                <p class="text-muted small mb-2">@${user.username} &bull; <span class="badge bg-secondary">${user.userId}</span></p>

                <div class="mt-2 mb-3">
                    <span class="badge ${user.hasAdminPrivileges() ? 'bg-danger' : 'bg-primary'} px-3 py-2 rounded-pill fs-6">
                        ${user.role}
                    </span>
                </div>

                <div class="p-3 bg-light rounded-3 text-start small mb-3 border">
                    <div class="mb-1"><strong>Role Details:</strong> ${user.getRoleDescription()}</div>
                    <div class="mb-1"><strong>Discount Rate:</strong> <fmt:formatNumber value="${user.getDiscountRate() * 100}" maxFractionDigits="0"/>%</div>
                    <div><strong>Member Since:</strong> ${user.createdAt}</div>
                </div>

                <!-- OOP Badge -->
                <div class="text-start p-2 bg-light rounded border">
                    <span class="oop-badge mb-1">OOP Concept</span>
                    <small class="text-muted d-block">
                        Instance of <code>${user.getClass().getSimpleName()}</code> extending abstract <code>User</code> class.
                    </small>
                </div>
            </div>
        </div>

        <!-- Profile Update Form (Update CRUD) -->
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                    <div>
                        <h4 class="fw-bold mb-1"><i class="bi bi-person-gear text-primary me-2"></i>Edit Profile</h4>
                        <small class="text-muted">Update your personal information in <code>users.txt</code></small>
                    </div>
                    <span class="badge bg-success-subtle text-success border border-success px-3 py-2 rounded-pill">
                        CRUD: Update
                    </span>
                </div>

                <form action="${pageContext.request.contextPath}/profile/update" method="post">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">User ID (Read-only)</label>
                            <input type="text" class="form-control bg-light" value="${user.userId}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Username (Read-only)</label>
                            <input type="text" class="form-control bg-light" value="${user.username}" readonly>
                        </div>

                        <div class="col-12">
                            <label for="fullName" class="form-label fw-semibold">Full Name</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" value="${user.fullName}" required>
                        </div>

                        <div class="col-md-6">
                            <label for="email" class="form-label fw-semibold">Email Address</label>
                            <input type="email" class="form-control" id="email" name="email" value="${user.email}" required>
                        </div>

                        <div class="col-md-6">
                            <label for="phoneNumber" class="form-label fw-semibold">Phone Number</label>
                            <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}">
                        </div>

                        <div class="col-12">
                            <label for="password" class="form-label fw-semibold">New Password (leave blank to keep current)</label>
                            <input type="password" class="form-control" id="password" name="password" minlength="6" placeholder="Leave empty to keep unchanged">
                        </div>

                        <c:if test="${!user.hasAdminPrivileges()}">
                            <div class="col-12">
                                <label for="membershipType" class="form-label fw-semibold">Membership Tier</label>
                                <select class="form-select" id="membershipType" name="membershipType">
                                    <c:forEach items="${membershipTypes}" var="tier">
                                        <c:if test="${tier != 'NONE'}">
                                            <option value="${tier}" ${user.membershipType == tier ? 'selected' : ''}>
                                                ${tier} Member (${tier.getDiscountRate() * 100}% Discount)
                                            </option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                        </c:if>

                        <div class="col-12 mt-4 text-end">
                            <button type="submit" class="btn btn-primary rounded-pill px-4 fw-semibold">
                                <i class="bi bi-save me-1"></i> Save Changes
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
