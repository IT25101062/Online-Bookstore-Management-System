<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="bg-dark p-4 text-center text-white">
                    <i class="bi bi-person-circle display-4 text-primary"></i>
                    <h3 class="fw-bold mt-2">Welcome Back</h3>
                    <p class="text-secondary small mb-0">Sign in to your ReadVerse account</p>
                </div>
                <div class="card-body p-4 p-md-5 bg-white">
                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label fw-semibold">Username</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-person"></i></span>
                                <input type="text" class="form-control" id="username" name="username" placeholder="e.g. admin or john_doe" required autofocus>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="password" class="form-label fw-semibold">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2 rounded-pill fw-semibold">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
                        </button>
                    </form>

                    <div class="text-center mt-4 pt-3 border-top">
                        <p class="text-muted small mb-0">Don't have an account? <a href="${pageContext.request.contextPath}/register" class="fw-semibold text-primary">Register here</a></p>
                    </div>

                    <!-- Demo shortcuts -->
                    <div class="mt-4 p-3 bg-light rounded-3 border">
                        <small class="fw-bold text-secondary d-block mb-1">Quick Demo Credentials:</small>
                        <div class="d-flex justify-content-between small text-muted">
                            <span>Admin: <code>admin</code> / <code>admin123</code></span>
                            <span>Customer: <code>john_doe</code> / <code>password123</code></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
