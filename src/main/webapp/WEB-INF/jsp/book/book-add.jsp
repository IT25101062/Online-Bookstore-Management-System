<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<jsp:include page="../common/alerts.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 rounded-4 overflow-hidden bg-white" style="box-shadow:0 10px 40px rgba(44,18,30,0.1); border:1px solid #ede3da !important;">
                <div class="p-4 text-white d-flex justify-content-between align-items-center"
                     style="background: linear-gradient(135deg, #240e18 0%, #361724 55%, #502538 100%); border-bottom: 1px solid rgba(196,154,108,0.25);">
                    <div>
                        <h4 class="fw-bold mb-1" style="font-family:'Playfair Display',serif; color:#fff;">
                            <i class="bi bi-plus-circle me-2" style="color:#dfb990;"></i>Add New Book
                        </h4>
                        <small style="color:rgba(255,255,255,0.7);">Create a new book entry in the Chapter One Catalog</small>
                    </div>
                </div>

                <div class="card-body p-4 p-md-5">
                    <form action="${pageContext.request.contextPath}/books/add" method="post">
                        <div class="row g-3">
                            <div class="col-md-8">
                                <label for="title" class="form-label fw-semibold" style="color:#240e18;">Book Title <span style="color:#c49a6c;">*</span></label>
                                <input type="text" class="form-control" id="title" name="title" placeholder="e.g. Clean Architecture" style="border-color:#ede3da;" required>
                            </div>
                            <div class="col-md-4">
                                <label for="isbn" class="form-label fw-semibold" style="color:#240e18;">
                                    ISBN Number <span style="color:#c49a6c;">*</span>
                                    <span id="isbnBadge" class="badge bg-secondary ms-1 small" style="font-size: 0.72rem;">0 / 13 digits</span>
                                </label>
                                <input type="text" class="form-control" id="isbn" name="isbn" 
                                       placeholder="e.g. 978-0134494166" 
                                       maxlength="17" minlength="10"
                                       autocomplete="off"
                                       style="border-color:#ede3da;" required>
                                <div class="form-text small" style="color: #786670; font-size: 0.75rem;">
                                    <i class="bi bi-shield-check me-1" style="color:#c49a6c;"></i>Limit: 10 or 13 digits only (Max 13 digits).
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="author" class="form-label fw-semibold" style="color:#240e18;">Author Name <span style="color:#c49a6c;">*</span></label>
                                <input type="text" class="form-control" id="author" name="author" placeholder="e.g. Robert C. Martin" style="border-color:#ede3da;" required>
                            </div>

                            <div class="col-md-6">
                                <label for="category" class="form-label fw-semibold" style="color:#240e18;">Category <span style="color:#c49a6c;">*</span></label>
                                <select class="form-select" id="category" name="category" style="border-color:#ede3da;" required>
                                    <c:forEach items="${categories}" var="cat">
                                        <option value="${cat}">${cat}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label for="basePrice" class="form-label fw-semibold" style="color:#240e18;">Base Price (Rs.) <span style="color:#c49a6c;">*</span></label>
                                <input type="number" step="0.01" min="0" class="form-control" id="basePrice" name="basePrice" placeholder="29.99" style="border-color:#ede3da;" required>
                            </div>

                            <div class="col-md-6">
                                <label for="stockQuantity" class="form-label fw-semibold" style="color:#240e18;">Stock Quantity <span style="color:#c49a6c;">*</span></label>
                                <input type="number" min="0" class="form-control" id="stockQuantity" name="stockQuantity" value="20" style="border-color:#ede3da;" required>
                            </div>

                            <!-- Book Format Selection -->
                            <div class="col-12 p-3 rounded-3" style="background:#fbf8f3; border: 1px solid #ede3da;">
                                <label for="bookType" class="form-label fw-bold" style="color:#240e18;">
                                    <i class="bi bi-journal-bookmark-fill me-1" style="color:#c49a6c;"></i> Book Format
                                </label>
                                <select class="form-select mb-3" id="bookType" name="bookType" onchange="toggleBookTypeFields()" style="border-color:#ede3da;" required>
                                    <option value="PRINTED" selected>Printed Book (Physical Hardcover/Paperback)</option>
                                    <option value="EBOOK">E-Book (Digital Instant Download)</option>
                                </select>

                                <!-- EBook Specific Fields -->
                                <div id="ebookFields" style="display: none;">
                                    <div class="row g-2">
                                        <div class="col-md-6">
                                            <label for="fileSizeMB" class="form-label small fw-semibold" style="color:#786670;">File Size (MB)</label>
                                            <input type="number" step="0.1" class="form-control form-control-sm" id="fileSizeMB" name="fileSizeMB" value="12.5" style="border-color:#ede3da;">
                                        </div>
                                        <div class="col-md-6">
                                            <label for="downloadFormat" class="form-label small fw-semibold" style="color:#786670;">Download Format</label>
                                            <select class="form-select form-select-sm" id="downloadFormat" name="downloadFormat" style="border-color:#ede3da;">
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
                                            <label for="weightKg" class="form-label small fw-semibold" style="color:#786670;">Weight (kg)</label>
                                            <input type="number" step="0.01" class="form-control form-control-sm" id="weightKg" name="weightKg" value="0.65" style="border-color:#ede3da;">
                                        </div>
                                        <div class="col-md-6">
                                            <label for="coverType" class="form-label small fw-semibold" style="color:#786670;">Cover Type</label>
                                            <select class="form-select form-select-sm" id="coverType" name="coverType" style="border-color:#ede3da;">
                                                <option value="Paperback">Paperback</option>
                                                <option value="Hardcover">Hardcover</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Book Cover Image URL (Google Images / Web URL) -->
                            <div class="col-12 p-3 rounded-3" style="background:#fcf9f5; border:1px solid #ede3da;">
                                <div class="row align-items-center g-3">
                                    <div class="col-md-8">
                                        <label for="imageUrl" class="form-label fw-bold mb-1" style="color:#240e18;">
                                            <i class="bi bi-image me-1" style="color:#c49a6c;"></i> Cover Image URL (Google Images / Web Link)
                                        </label>
                                        <p class="small text-muted mb-2">
                                            Search on Google Images &rarr; right-click image &rarr; select <strong>"Copy image address"</strong> &rarr; paste below:
                                        </p>
                                        <div class="input-group">
                                            <span class="input-group-text bg-white" style="border-color:#ede3da;"><i class="bi bi-link-45deg" style="color:#c49a6c;"></i></span>
                                            <input type="url" class="form-control" id="imageUrl" name="imageUrl"
                                                   placeholder="https://example.com/cover.jpg or Google Image URL"
                                                   style="border-color:#ede3da;"
                                                   oninput="updateImagePreview(this.value, 'coverImagePreview', 'coverFallbackIcon')">
                                        </div>
                                    </div>
                                    <!-- Live Thumbnail Preview Box -->
                                    <div class="col-md-4 text-center">
                                        <label class="form-label small fw-semibold text-muted d-block mb-1">Live Image Preview</label>
                                        <div id="coverPreviewContainer" class="d-flex align-items-center justify-content-center mx-auto rounded-3 overflow-hidden shadow-sm position-relative"
                                             style="width: 100px; height: 130px; background: linear-gradient(135deg, #240e18 0%, #361724 100%); border: 1.5px dashed #c49a6c;">
                                            <img id="coverImagePreview" src="" alt="Cover Preview"
                                                 style="width: 100%; height: 100%; object-fit: cover; display: none;">
                                            <div id="coverFallbackIcon" class="d-flex flex-column align-items-center justify-content-center text-center p-2" style="color:#dfb990;">
                                                <i class="bi bi-image fs-3 mb-1"></i>
                                                <span style="font-size: 0.65rem; line-height: 1.1;">No Image Added</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12">
                                <label for="description" class="form-label fw-semibold" style="color:#240e18;">Book Description</label>
                                <textarea class="form-control" id="description" name="description" rows="3" placeholder="Overview of the book content..." style="border-color:#ede3da;"></textarea>
                            </div>

                            <div class="col-12 d-flex justify-content-end gap-2 mt-4 pt-3" style="border-top:1px solid #f0e8e0;">
                                <a href="${pageContext.request.contextPath}/books/manage" class="btn btn-outline-plum px-4">Cancel</a>
                                <button type="submit" class="btn btn-plum px-4 fw-semibold">
                                    <i class="bi bi-plus-circle me-1"></i> Add Book to Catalog
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
