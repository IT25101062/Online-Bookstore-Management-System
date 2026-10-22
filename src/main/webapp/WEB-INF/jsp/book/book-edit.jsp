<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
                            <i class="bi bi-pencil-square me-2" style="color:#dfb990;"></i>Edit Book & Stock
                        </h4>
                        <small style="color:rgba(255,255,255,0.7);">Update details for Book ID: <code>${book.bookId}</code></small>
                    </div>
                </div>

                <div class="card-body p-4 p-md-5">
                    <form action="${pageContext.request.contextPath}/books/edit" method="post">
                        <input type="hidden" name="bookId" value="${book.bookId}">

                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label fw-semibold" style="color:#240e18;">Book ID (Read-only)</label>
                                <input type="text" class="form-control bg-light" value="${book.bookId}" style="border-color:#ede3da;" readonly>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold" style="color:#240e18;">Format Type (Read-only)</label>
                                <input type="text" class="form-control bg-light" value="${book.bookType}" style="border-color:#ede3da;" readonly>
                            </div>
                            <div class="col-md-4">
                                <label for="isbn" class="form-label fw-semibold" style="color:#240e18;">
                                    ISBN Number <span style="color:#c49a6c;">*</span>
                                    <span id="isbnBadge" class="badge bg-secondary ms-1 small" style="font-size: 0.72rem;">10 or 13 digits</span>
                                </label>
                                <input type="text" class="form-control" id="isbn" name="isbn" 
                                       value="${book.isbn}" 
                                       maxlength="17" minlength="10"
                                       autocomplete="off"
                                       style="border-color:#ede3da;" required>
                                <div class="form-text small" style="color: #786670; font-size: 0.75rem;">
                                    <i class="bi bi-shield-check me-1" style="color:#c49a6c;"></i>Limit: 10 or 13 digits only (Max 13 digits).
                                </div>
                            </div>

                            <div class="col-md-8">
                                <label for="title" class="form-label fw-semibold" style="color:#240e18;">Book Title <span style="color:#c49a6c;">*</span></label>
                                <input type="text" class="form-control" id="title" name="title" value="${book.title}" style="border-color:#ede3da;" required>
                            </div>

                            <div class="col-md-4">
                                <label for="author" class="form-label fw-semibold" style="color:#240e18;">Author Name <span style="color:#c49a6c;">*</span></label>
                                <input type="text" class="form-control" id="author" name="author" value="${book.author}" style="border-color:#ede3da;" required>
                            </div>

                            <div class="col-md-4">
                                <label for="category" class="form-label fw-semibold" style="color:#240e18;">Category <span style="color:#c49a6c;">*</span></label>
                                <select class="form-select" id="category" name="category" style="border-color:#ede3da;" required>
                                    <c:forEach items="${categories}" var="cat">
                                        <option value="${cat}" ${book.category == cat ? 'selected' : ''}>${cat}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label for="basePrice" class="form-label fw-semibold" style="color:#240e18;">Base Price (Rs.) <span style="color:#c49a6c;">*</span></label>
                                <input type="number" step="0.01" min="0" class="form-control" id="basePrice" name="basePrice" value="${book.basePrice}" style="border-color:#ede3da;" required>
                            </div>

                            <div class="col-md-4">
                                <label for="stockQuantity" class="form-label fw-semibold" style="color:#240e18;">Stock Quantity <span style="color:#c49a6c;">*</span></label>
                                <input type="number" min="0" class="form-control" id="stockQuantity" name="stockQuantity" value="${book.stockQuantity}" style="border-color:#ede3da;" required>
                            </div>

                            <!-- Type Specific Attributes -->
                            <c:choose>
                                <c:when test="${book.bookType == 'EBOOK'}">
                                    <div class="col-md-6">
                                        <label for="fileSizeMB" class="form-label fw-semibold" style="color:#240e18;">File Size (MB)</label>
                                        <input type="number" step="0.1" class="form-control" id="fileSizeMB" name="fileSizeMB" value="${book.fileSizeMB}" style="border-color:#ede3da;">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="downloadFormat" class="form-label fw-semibold" style="color:#240e18;">Download Format</label>
                                        <select class="form-select" id="downloadFormat" name="downloadFormat" style="border-color:#ede3da;">
                                            <option value="PDF" ${book.downloadFormat == 'PDF' ? 'selected' : ''}>PDF</option>
                                            <option value="EPUB" ${book.downloadFormat == 'EPUB' ? 'selected' : ''}>EPUB</option>
                                            <option value="MOBI" ${book.downloadFormat == 'MOBI' ? 'selected' : ''}>MOBI</option>
                                        </select>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="col-md-6">
                                        <label for="weightKg" class="form-label fw-semibold" style="color:#240e18;">Weight (kg)</label>
                                        <input type="number" step="0.01" class="form-control" id="weightKg" name="weightKg" value="${book.weightKg}" style="border-color:#ede3da;">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="coverType" class="form-label fw-semibold" style="color:#240e18;">Cover Type</label>
                                        <select class="form-select" id="coverType" name="coverType" style="border-color:#ede3da;">
                                            <option value="Paperback" ${book.coverType == 'Paperback' ? 'selected' : ''}>Paperback</option>
                                            <option value="Hardcover" ${book.coverType == 'Hardcover' ? 'selected' : ''}>Hardcover</option>
                                        </select>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <!-- Book Cover Image URL (Google Images / Web URL) -->
                            <div class="col-12 p-3 rounded-3" style="background:#fcf9f5; border:1px solid #ede3da;">
                                <div class="row align-items-center g-3">
                                    <div class="col-md-8">
                                        <label for="imageUrl" class="form-label fw-bold mb-1" style="color:#240e18;">
                                            <i class="bi bi-image me-1" style="color:#c49a6c;"></i> Cover Image URL (Google Images / Web Link)
                                        </label>
                                        <p class="small text-muted mb-2">
                                            Paste an image link from Google Images or any web address:
                                        </p>
                                        <div class="input-group">
                                            <span class="input-group-text bg-white" style="border-color:#ede3da;"><i class="bi bi-link-45deg" style="color:#c49a6c;"></i></span>
                                            <input type="url" class="form-control" id="imageUrl" name="imageUrl"
                                                   value="${book.imageUrl}"
                                                   placeholder="https://example.com/cover.jpg or Google Image URL"
                                                   style="border-color:#ede3da;"
                                                   oninput="updateImagePreview(this.value, 'coverImagePreview', 'coverFallbackIcon')">
                                        </div>
                                    </div>
                                    <!-- Live Thumbnail Preview Box -->
                                    <div class="col-md-4 text-center">
                                        <label class="form-label small fw-semibold text-muted d-block mb-1">Current / Live Preview</label>
                                        <div id="coverPreviewContainer" class="d-flex align-items-center justify-content-center mx-auto rounded-3 overflow-hidden shadow-sm position-relative"
                                             style="width: 100px; height: 130px; background: linear-gradient(135deg, #240e18 0%, #361724 100%); border: 1.5px dashed #c49a6c;">
                                            <img id="coverImagePreview" src="${book.imageUrl}" alt="Cover Preview"
                                                 style="width: 100%; height: 100%; object-fit: cover; display: ${not empty book.imageUrl ? 'block' : 'none'};"
                                                 onerror="this.style.display='none'; document.getElementById('coverFallbackIcon').style.display='flex';">
                                            <div id="coverFallbackIcon" class="d-flex flex-column align-items-center justify-content-center text-center p-2"
                                                 style="color:#dfb990; display: ${empty book.imageUrl ? 'flex' : 'none'};">
                                                <i class="bi bi-image fs-3 mb-1"></i>
                                                <span style="font-size: 0.65rem; line-height: 1.1;">No Image Added</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12">
                                <label for="description" class="form-label fw-semibold" style="color:#240e18;">Book Description</label>
                                <textarea class="form-control" id="description" name="description" rows="3" style="border-color:#ede3da;">${book.description}</textarea>
                            </div>

                            <div class="col-12 d-flex justify-content-end gap-2 mt-4 pt-3" style="border-top:1px solid #f0e8e0;">
                                <a href="${pageContext.request.contextPath}/books/manage" class="btn btn-outline-plum px-4">Cancel</a>
                                <button type="submit" class="btn btn-plum px-4 fw-semibold">
                                    <i class="bi bi-check2-circle me-1"></i> Save Changes
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
