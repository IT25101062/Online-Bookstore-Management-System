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
            <div class="card border-0 rounded-4 text-center p-4 bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="mb-3 position-relative d-inline-block profile-avatar-wrap">
                    <c:choose>
                        <c:when test="${user.hasProfilePicture()}">
                            <img src="${pageContext.request.contextPath}/images/profiles/${user.profilePicture}"
                                 alt="Profile Photo"
                                 class="rounded-circle shadow-sm profile-pic-img"
                                 style="width:90px; height:90px; object-fit:cover; border:3px solid #c49a6c; background:#240e18;" />
                        </c:when>
                        <c:otherwise>
                            <div class="rounded-circle text-white d-inline-flex align-items-center justify-content-center shadow-sm profile-initial-circle"
                                 style="width:90px; height:90px; font-size:2.2rem; font-family:'Playfair Display',serif; background:linear-gradient(135deg,#240e18 0%,#502538 100%); border:3px solid #c49a6c;">
                                ${user.fullName.substring(0, 1)}
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <%-- Hidden upload form triggered by clicking camera icon --%>
                    <form id="picUploadForm" action="${pageContext.request.contextPath}/profile/upload-picture"
                          method="post" enctype="multipart/form-data" class="d-none">
                        <input type="file" id="profilePicInput" name="profilePic"
                               accept="image/jpeg,image/png,image/gif,image/webp" />
                    </form>

                    <%-- Camera icon button --%>
                    <button type="button" id="changePicBtn"
                            title="Change profile photo"
                            onclick="document.getElementById('profilePicInput').click()"
                            style="position:absolute; bottom:0; right:0; width:28px; height:28px; border-radius:50%; background:#c49a6c; border:2px solid #fff; cursor:pointer; display:flex; align-items:center; justify-content:center; padding:0; box-shadow:0 2px 6px rgba(0,0,0,0.2);">
                        <i class="bi bi-camera-fill" style="font-size:0.75rem; color:#fff;"></i>
                    </button>
                </div>
                <script>
                    document.getElementById('profilePicInput').addEventListener('change', function() {
                        if (this.files && this.files.length > 0) {
                            document.getElementById('picUploadForm').submit();
                        }
                    });
                </script>
                <h4 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">${user.fullName}</h4>
                <p class="small mb-2" style="color:#786670;">@${user.username} &bull; <span class="badge px-2 py-1" style="background:#f4ece2; color:#6b5244; border:1px solid #e8ded4; font-family:monospace;">${user.userId}</span></p>

                <div class="mt-2 mb-3">
                    <span class="badge px-3 py-2 rounded-pill fs-6"
                          style="${user.hasAdminPrivileges() ? 'background:rgba(54,23,36,0.12); color:#361724; border:1px solid rgba(54,23,36,0.25);' : 'background:rgba(196,154,108,0.15); color:#8c5b1c; border:1px solid rgba(196,154,108,0.35);'}">
                        ${user.role}
                    </span>
                </div>

                <div class="p-3 text-start small mb-3 rounded-3" style="background:#fbf8f3; border:1px solid #ede3da;">
                    <div class="mb-1" style="color:#240e18;"><strong>Role Details:</strong> <span style="color:#786670;">${user.getRoleDescription()}</span></div>
                    <div class="mb-1" style="color:#240e18;"><strong>Discount Rate:</strong> <span style="color:#2d8a2d; font-weight:600;"><fmt:formatNumber value="${user.getDiscountRate() * 100}" maxFractionDigits="0"/>%</span></div>
                    <div style="color:#240e18;"><strong>Member Since:</strong> <span style="color:#786670;">${user.createdAt}</span></div>
                </div>

                <!-- Membership Perks -->
                <div class="text-start p-3 rounded-3" style="background:#fbf8f3; border:1px solid #ede3da;">
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <i class="bi bi-gift-fill" style="color:#c49a6c;"></i>
                        <span class="fw-semibold small" style="color:#240e18;">Club Privileges</span>
                    </div>
                    <small class="d-block" style="color:#786670;">
                        Enjoy exclusive member discounts on all physical books, instant eBook access, and literary events.
                    </small>
                </div>
            </div>
        </div>

        <!-- Profile Update Form -->
        <div class="col-lg-8">
            <div class="card border-0 rounded-4 p-4 p-md-5 bg-white" style="box-shadow:0 4px 20px rgba(44,18,30,0.07); border:1px solid #ede3da !important;">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2" style="border-bottom:1px solid #f0e8e0;">
                    <div>
                        <h4 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#240e18;">
                            <i class="bi bi-person-gear me-2" style="color:#c49a6c;"></i>Edit Profile
                        </h4>
                        <small style="color:#786670;">Update your personal contact details</small>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/profile/update" method="post">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold" style="color:#240e18;">User ID (Read-only)</label>
                            <input type="text" class="form-control bg-light" value="${user.userId}" style="border-color:#ede3da;" readonly>
                        </div>
                        <div class="col-md-6">
                            <label for="newUsername" class="form-label fw-semibold" style="color:#240e18;">
                                Username
                                <span class="badge ms-1 px-2 py-1" style="background:#edf7ed; color:#2d8a2d; border:1px solid #b7dfb8; font-size:0.65rem; font-weight:600; border-radius:6px;">Editable</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text" style="background:#f4ece2; border-color:#ede3da; color:#8c5b1c; font-weight:600;">@</span>
                                <input type="text" class="form-control" id="newUsername" name="newUsername"
                                       value="${user.username}"
                                       minlength="3" maxlength="30"
                                       pattern="[a-zA-Z0-9_\.]+"
                                       title="Letters, numbers, underscores, and dots only. Min 3 characters."
                                       style="border-color:#ede3da;"
                                       placeholder="your_username">
                            </div>
                            <small style="color:#a08070;">Min 3 chars · letters, numbers, _ and . only</small>
                        </div>

                        <div class="col-12">
                            <label for="fullName" class="form-label fw-semibold" style="color:#240e18;">Full Name</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" value="${user.fullName}" style="border-color:#ede3da;" required>
                        </div>

                        <div class="col-md-6">
                            <label for="email" class="form-label fw-semibold" style="color:#240e18;">Email Address</label>
                            <input type="email" class="form-control" id="email" name="email" value="${user.email}" style="border-color:#ede3da;" required>
                        </div>

                        <div class="col-md-6">
                            <label for="phoneNumber" class="form-label fw-semibold" style="color:#240e18;">Phone Number</label>
                            <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}" style="border-color:#ede3da;">
                        </div>

                        <div class="col-12">
                            <label for="password" class="form-label fw-semibold" style="color:#240e18;">New Password (leave blank to keep current)</label>
                            <input type="password" class="form-control" id="password" name="password" minlength="6" placeholder="Leave empty to keep unchanged" style="border-color:#ede3da;">
                        </div>

                        <c:if test="${!user.hasAdminPrivileges()}">
                            <div class="col-12">
                                <label for="membershipType" class="form-label fw-semibold" style="color:#240e18;">Membership Tier</label>
                                <select class="form-select" id="membershipType" name="membershipType" style="border-color:#ede3da;">
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
                            <button type="submit" class="btn btn-plum px-4 fw-semibold">
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
