<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <div class="card border-0 rounded-4 overflow-hidden" style="box-shadow:0 10px 40px rgba(44,18,30,0.12); border:1px solid #ede3da !important;">
                <div class="p-4 text-center text-white" style="background: linear-gradient(135deg, #240e18 0%, #361724 55%, #502538 100%); border-bottom: 1px solid rgba(196,154,108,0.25);">
                    <i class="bi bi-person-plus display-4" style="color:#dfb990;"></i>
                    <h3 class="fw-bold mt-2" style="font-family:'Playfair Display',serif; color:#fff;">Create an Account</h3>
                    <p class="small mb-0" style="color:rgba(255,255,255,0.65);">Join Chapter One and explore thousands of books</p>
                </div>
                <div class="card-body p-4 p-md-5 bg-white">
                    <form action="${pageContext.request.contextPath}/register" method="post">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="username" class="form-label fw-semibold" style="color:#240e18;">Username <span style="color:#c49a6c;">*</span></label>
                                <input type="text" class="form-control" id="username" name="username" placeholder="e.g. alex_reader" style="border-color:#ede3da;" required>
                            </div>
                            <div class="col-md-6">
                                <label for="password" class="form-label fw-semibold" style="color:#240e18;">Password <span style="color:#c49a6c;">*</span></label>
                                <input type="password" class="form-control" id="password" name="password" minlength="6" placeholder="Min. 6 characters" style="border-color:#ede3da;" required>
                            </div>

                            <div class="col-12">
                                <label for="fullName" class="form-label fw-semibold" style="color:#240e18;">Full Name <span style="color:#c49a6c;">*</span></label>
                                <input type="text" class="form-control" id="fullName" name="fullName" placeholder="e.g. Alex Henderson" style="border-color:#ede3da;" required>
                            </div>

                            <div class="col-md-6">
                                <label for="email" class="form-label fw-semibold" style="color:#240e18;">Email Address <span style="color:#c49a6c;">*</span></label>
                                <input type="email" class="form-control" id="email" name="email" placeholder="alex@example.com" style="border-color:#ede3da;" required>
                            </div>

                            <div class="col-md-6">
                                <label for="phoneNumber" class="form-label fw-semibold" style="color:#240e18;">Phone Number</label>
                                <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" placeholder="07X-XXXXXXX" style="border-color:#ede3da;">
                            </div>

                            <div class="col-12">
                                <label for="membershipType" class="form-label fw-semibold" style="color:#240e18;">Membership Tier</label>
                                <select class="form-select" id="membershipType" name="membershipType" style="border-color:#ede3da;">
                                    <option value="STANDARD" selected>Standard Member (No discount)</option>
                                    <option value="SILVER">Silver Member (5% Member Discount)</option>
                                    <option value="GOLD">Gold Member (10% Member Discount)</option>
                                </select>
                                <small style="color:#786670;">Demonstrates Polymorphism in discount calculations based on CustomerUser membership.</small>
                            </div>

                            <div class="col-12 mt-4">
                                <button type="submit" class="btn btn-plum w-100 py-2 fw-semibold" style="letter-spacing:1px; font-size:0.95rem;">
                                    <i class="bi bi-check-circle me-1"></i> Register Account
                                </button>
                            </div>
                        </div>
                    </form>

                    <div class="text-center mt-4 pt-3" style="border-top:1px solid #f0e8e0;">
                        <p class="small mb-0" style="color:#786670;">Already registered? <a href="${pageContext.request.contextPath}/login" style="color:#c49a6c; font-weight:600; text-decoration:none;">Login here</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
