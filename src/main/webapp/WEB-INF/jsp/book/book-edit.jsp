<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-lg rounded-4 overflow-hidden bg-white">
                <div class="bg-dark p-4 text-white d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="fw-bold mb-1"><i class="bi bi-pencil-square text-primary me-2"></i>Edit Book & Stock</h4>
                        <small class="text-secondary">Update details for Book ID: <code>${book.bookId}</code></small>
                    </div>
                    <span class="badge bg-warning-subtle text-warning border border-warning px-3 py-2 rounded-pill">
                        CRUD: Update
                    </span>
                </div>

                <div class="card-body p-4 p-md-5">
                    <form action="${pageContext.request.contextPath}/books/edit" method="post">
                        <input type="hidden" name="bookId" value="${book.bookId}">

                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Book ID (Read-only)</label>
                                <input type="text" class="form-control bg-light" value="${book.bookId}" readonly>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Format Type (Read-only)</label>
                                <input type="text" class="form-control bg-light" value="${book.bookType}" readonly>
                            </div>
                            <div class="col-md-4">
                                <label for="isbn" class="form-label fw-semibold">ISBN Number <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="isbn" name="isbn" value="${book.isbn}" required>
                            </div>

                            <div class="col-md-8">
                                <label for="title" class="form-label fw-semibold">Book Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="title" name="title" value="${book.title}" required>
                            </div>

                            <div class="col-md-4">
                                <label for="author" class="form-label fw-semibold">Author Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="author" name="author" value="${book.author}" required>
                            </div>

                            <div class="col-md-4">
                                <label for="category" class="form-label fw-semibold">Category <span class="text-danger">*</span></label>
                                <select class="form-select" id="category" name="category" required>
                                    <option value="Technology" ${book.category == 'Technology' ? 'selected' : ''}>Technology</option>
                                    <option value="Fiction" ${book.category == 'Fiction' ? 'selected' : ''}>Fiction</option>
                                    <option value="Business" ${book.category == 'Business' ? 'selected' : ''}>Business</option>
                                    <option value="Self-Help" ${book.category == 'Self-Help' ? 'selected' : ''}>Self-Help</option>
                                    <option value="Science" ${book.category == 'Science' ? 'selected' : ''}>Science</option>
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label for="basePrice" class="form-label fw-semibold">Base Price ($) <span class="text-danger">*</span></label>
                                <input type="number" step="0.01" min="0" class="form-control" id="basePrice" name="basePrice" value="${book.basePrice}" required>
                            </div>

                            <div class="col-md-4">
                                <label for="stockQuantity" class="form-label fw-semibold">Stock Quantity <span class="text-danger">*</span></label>
                                <input type="number" min="0" class="form-control" id="stockQuantity" name="stockQuantity" value="${book.stockQuantity}" required>
                            </div>

                            <!-- Type Specific Attributes -->
                            <c:choose>
                                <c:when test="${book.bookType == 'EBOOK'}">
                                    <div class="col-md-6">
                                        <label for="fileSizeMB" class="form-label fw-semibold">File Size (MB)</label>
                                        <input type="number" step="0.1" class="form-control" id="fileSizeMB" name="fileSizeMB" value="${book.fileSizeMB}">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="downloadFormat" class="form-label fw-semibold">Download Format</label>
                                        <select class="form-select" id="downloadFormat" name="downloadFormat">
                                            <option value="PDF" ${book.downloadFormat == 'PDF' ? 'selected' : ''}>PDF</option>
                                            <option value="EPUB" ${book.downloadFormat == 'EPUB' ? 'selected' : ''}>EPUB</option>
                                            <option value="MOBI" ${book.downloadFormat == 'MOBI' ? 'selected' : ''}>MOBI</option>
                                        </select>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="col-md-6">
                                        <label for="weightKg" class="form-label fw-semibold">Weight (kg)</label>
                                        <input type="number" step="0.01" class="form-control" id="weightKg" name="weightKg" value="${book.weightKg}">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="coverType" class="form-label fw-semibold">Cover Type</label>
                                        <select class="form-select" id="coverType" name="coverType">
                                            <option value="Paperback" ${book.coverType == 'Paperback' ? 'selected' : ''}>Paperback</option>
                                            <option value="Hardcover" ${book.coverType == 'Hardcover' ? 'selected' : ''}>Hardcover</option>
                                        </select>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <div class="col-12">
                                <label for="description" class="form-label fw-semibold">Book Description</label>
                                <textarea class="form-control" id="description" name="description" rows="3">${book.description}</textarea>
                            </div>

                            <div class="col-12 d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                                <a href="${pageContext.request.contextPath}/books/manage" class="btn btn-outline-secondary rounded-pill px-4">Cancel</a>
                                <button type="submit" class="btn btn-primary rounded-pill px-4 fw-semibold">
                                    <i class="bi bi-save me-1"></i> Update in Books.txt
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
