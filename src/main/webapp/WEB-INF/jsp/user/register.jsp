<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="bg-dark p-4 text-center text-white">
                    <i class="bi bi-person-plus-fill display-4 text-success"></i>
                    <h3 class="fw-bold mt-2">Create an Account</h3>
                    <p class="text-secondary small mb-0">Join ReadVerse and explore thousands of books</p>
                </div>
                <div class="card-body p-4 p-md-5 bg-white">
                    <form action="${pageContext.request.contextPath}/register" method="post">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="username" class="form-label fw-semibold">Username <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="username" name="username" placeholder="e.g. alex_reader" required>
                            </div>
                            <div class="col-md-6">
                                <label for="password" class="form-label fw-semibold">Password <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="password" name="password" minlength="6" placeholder="Min. 6 characters" required>
                            </div>

                            <div class="col-12">
                                <label for="fullName" class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="fullName" name="fullName" placeholder="e.g. Alex Henderson" required>
                            </div>

                            <div class="col-md-6">
                                <label for="email" class="form-label fw-semibold">Email Address <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="email" name="email" placeholder="alex@example.com" required>
                            </div>

                            <div class="col-md-6">
                                <label for="phoneNumber" class="form-label fw-semibold">Phone Number</label>
                                <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" placeholder="07X-XXXXXXX">
                            </div>

                            <div class="col-12">
                                <label for="membershipType" class="form-label fw-semibold">Membership Tier</label>
                                <select class="form-select" id="membershipType" name="membershipType">
                                    <option value="STANDARD" selected>Standard Member (No discount)</option>
                                    <option value="SILVER">Silver Member (5% Member Discount)</option>
                                    <option value="GOLD">Gold Member (10% Member Discount)</option>
                                </select>
                                <small class="text-muted">Demonstrates Polymorphism in discount calculations based on CustomerUser membership.</small>
                            </div>

                            <div class="col-12 mt-4">
                                <button type="submit" class="btn btn-success w-100 py-2 rounded-pill fw-semibold">
                                    <i class="bi bi-check-circle me-1"></i> Register Account
                                </button>
                            </div>
                        </div>
                    </form>

                    <div class="text-center mt-4 pt-3 border-top">
                        <p class="text-muted small mb-0">Already registered? <a href="${pageContext.request.contextPath}/login" class="fw-semibold text-primary">Login here</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
