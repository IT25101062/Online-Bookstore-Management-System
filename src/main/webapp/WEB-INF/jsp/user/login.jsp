<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card border-0 rounded-4 overflow-hidden" style="box-shadow:0 10px 40px rgba(44,18,30,0.12); border:1px solid #ede3da !important;">
                <div class="p-4 text-center text-white" style="background: linear-gradient(135deg, #240e18 0%, #361724 55%, #502538 100%); border-bottom: 1px solid rgba(196,154,108,0.25);">
                    <i class="bi bi-book-half display-4" style="color:#dfb990;"></i>
                    <h3 class="fw-bold mt-2" style="font-family:'Playfair Display',serif; color:#fff;">Sign In to Chapter One</h3>
                    <p class="small mb-0" style="color:rgba(255,255,255,0.65);">Access your shopping cart, personal library, or administrative portal</p>
                </div>
                <div class="card-body p-4 p-md-5 bg-white">
                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label fw-semibold" style="color:#240e18;">Username</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light" style="border-color:#ede3da;"><i class="bi bi-person" style="color:#c49a6c;"></i></span>
                                <input type="text" class="form-control" id="username" name="username" placeholder="Enter username" style="border-color:#ede3da;" required autofocus>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="password" class="form-label fw-semibold" style="color:#240e18;">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light" style="border-color:#ede3da;"><i class="bi bi-lock" style="color:#c49a6c;"></i></span>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" style="border-color:#ede3da;" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-plum w-100 py-2 fw-semibold" style="letter-spacing:1px; font-size:0.95rem;">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
                        </button>
                    </form>

                    <div class="text-center mt-4 pt-3" style="border-top:1px solid #f0e8e0;">
                        <p class="small mb-0" style="color:#786670;">New to Chapter One? <a href="${pageContext.request.contextPath}/register" style="color:#c49a6c; font-weight:600; text-decoration:none;">Create an account</a></p>
                    </div>

                    <!-- Demo shortcuts -->
                    <div class="mt-4 p-3 rounded-3" style="background:#fbf8f3; border:1px solid #ede3da;">
                        <small class="fw-bold d-block mb-2" style="color:#240e18;">Demo Accounts for Testing:</small>
                        <div class="small mb-1" style="color:#786670;">
                            <span class="badge bg-secondary me-1">Customer</span> <code>john_doe</code> &bull; <code>password123</code>
                        </div>
                        <div class="small" style="color:#786670;">
                            <span class="badge bg-plum me-1" style="background:#361724 !important;">Admin</span> <code>admin</code> &bull; <code>admin123</code>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
