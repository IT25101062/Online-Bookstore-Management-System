<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-lg rounded-4 overflow-hidden bg-white">
                <div class="bg-dark p-4 text-white d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="fw-bold mb-1"><i class="bi bi-plus-circle text-primary me-2"></i>Add New Book</h4>
                        <small class="text-secondary">Create a new entry in <code>books.txt</code></small>
                    </div>
                    <span class="badge bg-success-subtle text-success border border-success px-3 py-2 rounded-pill">
                        CRUD: Create
                    </span>
                </div>

                <div class="card-body p-4 p-md-5">
                    <form action="${pageContext.request.contextPath}/books/add" method="post">
                        <div class="row g-3">
                            <div class="col-md-8">
                                <label for="title" class="form-label fw-semibold">Book Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="title" name="title" placeholder="e.g. Clean Architecture" required>
                            </div>
                            <div class="col-md-4">
                                <label for="isbn" class="form-label fw-semibold">ISBN Number <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="isbn" name="isbn" placeholder="e.g. 978-0134494166" required>
                            </div>

                            <div class="col-md-6">
                                <label for="author" class="form-label fw-semibold">Author Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="author" name="author" placeholder="e.g. Robert C. Martin" required>
                            </div>

                            <div class="col-md-6">
                                <label for="category" class="form-label fw-semibold">Category <span class="text-danger">*</span></label>
                                <select class="form-select" id="category" name="category" required>
                                    <option value="Technology">Technology</option>
                                    <option value="Fiction">Fiction</option>
                                    <option value="Business">Business</option>
                                    <option value="Self-Help">Self-Help</option>
                                    <option value="Science">Science</option>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label for="basePrice" class="form-label fw-semibold">Base Price ($) <span class="text-danger">*</span></label>
                                <input type="number" step="0.01" min="0" class="form-control" id="basePrice" name="basePrice" placeholder="29.99" required>
                            </div>

                            <div class="col-md-6">
                                <label for="stockQuantity" class="form-label fw-semibold">Stock Quantity <span class="text-danger">*</span></label>
                                <input type="number" min="0" class="form-control" id="stockQuantity" name="stockQuantity" value="20" required>
                            </div>

                            <!-- Polymorphic Book Type Selection -->
                            <div class="col-12 p-3 bg-light rounded-3 border">
                                <label for="bookType" class="form-label fw-bold text-dark">
                                    <i class="bi bi-diagram-3-fill text-primary me-1"></i> Book Type (OOP Inheritance Subclass)
                                </label>
                                <select class="form-select mb-3" id="bookType" name="bookType" onchange="toggleBookTypeFields()" required>
                                    <option value="PRINTED" selected>Printed Book (Subclass: PrintedBook)</option>
                                    <option value="EBOOK">E-Book (Subclass: EBook)</option>
                                </select>

                                <!-- EBook Specific Fields -->
                                <div id="ebookFields" style="display: none;">
                                    <div class="row g-2">
                                        <div class="col-md-6">
                                            <label for="fileSizeMB" class="form-label small fw-semibold">File Size (MB)</label>
                                            <input type="number" step="0.1" class="form-control form-control-sm" id="fileSizeMB" name="fileSizeMB" value="12.5">
                                        </div>
                                        <div class="col-md-6">
                                            <label for="downloadFormat" class="form-label small fw-semibold">Download Format</label>
                                            <select class="form-select form-select-sm" id="downloadFormat" name="downloadFormat">
                                                <option value="PDF">PDF</option>
                                                <option value="EPUB">EPUB</option>
                                                <option value="MOBI">MOBI</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <!-- PrintedBook Specific Fields -->
                                <div id="printedFields">
                                    <div class="row g-2">
                                        <div class="col-md-6">
                                            <label for="weightKg" class="form-label small fw-semibold">Weight (kg)</label>
                                            <input type="number" step="0.01" class="form-control form-control-sm" id="weightKg" name="weightKg" value="0.65">
                                        </div>
                                        <div class="col-md-6">
                                            <label for="coverType" class="form-label small fw-semibold">Cover Type</label>
                                            <select class="form-select form-select-sm" id="coverType" name="coverType">
                                                <option value="Paperback">Paperback</option>
                                                <option value="Hardcover">Hardcover</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12">
                                <label for="description" class="form-label fw-semibold">Book Description</label>
                                <textarea class="form-control" id="description" name="description" rows="3" placeholder="Overview of the book content..."></textarea>
                            </div>

                            <div class="col-12 d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                                <a href="${pageContext.request.contextPath}/books/manage" class="btn btn-outline-secondary rounded-pill px-4">Cancel</a>
                                <button type="submit" class="btn btn-primary rounded-pill px-4 fw-semibold">
                                    <i class="bi bi-check2-circle me-1"></i> Save to Books.txt
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
