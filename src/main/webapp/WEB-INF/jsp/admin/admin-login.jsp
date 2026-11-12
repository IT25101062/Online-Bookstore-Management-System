<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card border-0 rounded-4 overflow-hidden" style="box-shadow:0 12px 45px rgba(44,18,30,0.15); border:1px solid #ede3da !important;">
                <!-- Admin Security Header -->
                <div class="p-4 p-md-5 text-center text-white position-relative"
                     style="background: linear-gradient(135deg, #180911 0%, #2e111e 50%, #4a1f32 100%); border-bottom: 2px solid #c49a6c;">
                    <div class="mb-3 d-inline-flex p-3 rounded-circle" style="background: rgba(196,154,108,0.15); border: 1px solid rgba(196,154,108,0.35);">
                        <i class="bi bi-shield-lock-fill" style="font-size: 2.8rem; color: #dfb990;"></i>
                    </div>
                    <span class="badge px-3 py-1 rounded-pill text-uppercase d-block mx-auto mb-2"
                          style="background: rgba(196,154,108,0.2); color: #dfb990; border: 1px solid rgba(196,154,108,0.4); font-size:0.68rem; letter-spacing:1.5px; width: fit-content;">
                        Authorized Staff Only
                    </span>
                    <h3 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#fff;">Admin Portal Sign In</h3>
                    <p class="small mb-0" style="color:rgba(255,255,255,0.65);">Access catalog, orders, stock audits & system logs</p>
                </div>

                <div class="card-body p-4 p-md-5 bg-white">
                    <form action="${pageContext.request.contextPath}/admin/login" method="post">
                        <div class="mb-3">
                            <label for="adminUsername" class="form-label fw-semibold" style="color:#240e18;">Administrator Username</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light" style="border-color:#ede3da;"><i class="bi bi-person-badge" style="color:#c49a6c;"></i></span>
                                <input type="text" class="form-control" id="adminUsername" name="username" placeholder="e.g. admin" style="border-color:#ede3da;" required autofocus>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="adminPassword" class="form-label fw-semibold" style="color:#240e18;">Security Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light" style="border-color:#ede3da;"><i class="bi bi-key-fill" style="color:#c49a6c;"></i></span>
                                <input type="password" class="form-control" id="adminPassword" name="password" placeholder="Enter admin password" style="border-color:#ede3da;" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-plum w-100 py-2 fw-semibold" style="letter-spacing:1px; font-size:0.95rem;">
                            <i class="bi bi-unlock-fill me-1"></i> Authenticate & Enter Portal
                        </button>
                    </form>

                    <!-- Fast Switch to Customer Login -->
                    <div class="text-center mt-4 pt-3" style="border-top:1px solid #f0e8e0;">
                        <p class="small mb-2" style="color:#786670;">Are you a customer or reader?</p>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-outline-plum px-4 rounded-pill">
                            <i class="bi bi-person me-1"></i> Switch to Customer Sign In
                        </a>
                    </div>

                    <!-- Demo shortcuts -->
                    <div class="mt-4 p-3 rounded-3" style="background:#fbf8f3; border:1px solid #ede3da;">
                        <small class="fw-bold d-block mb-1" style="color:#240e18;">Staff Demo Credentials:</small>
                        <div class="small mb-1" style="color:#786670;">
                            Super Admin: <code>superadmin</code> &bull; Password: <code>admin123</code>
                        </div>
                        <div class="small" style="color:#786670;">
                            Moderator: <code>moderator</code> &bull; Password: <code>mod123</code>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
