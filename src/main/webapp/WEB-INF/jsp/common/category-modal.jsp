<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Add New Category Modal -->
<div class="modal fade" id="addCategoryModal" tabindex="-1" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 14px; border: 1px solid #ede3da; overflow: hidden; box-shadow: 0 16px 40px rgba(36, 14, 24, 0.22);">
            <div class="modal-header text-white" style="background: linear-gradient(135deg, #240e18 0%, #361724 100%); border-bottom: 2px solid #c49a6c;">
                <h5 class="modal-title fw-bold" id="addCategoryModalLabel">
                    <i class="bi bi-tags-fill me-2" style="color: #c49a6c;"></i>Add New Book Category
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4" style="background: #fbf8f3;">
                <div id="categoryModalAlert" class="alert d-none mb-3 py-2 small" role="alert"></div>

                <div class="mb-3">
                    <label for="newCategoryName" class="form-label fw-semibold" style="color:#240e18;">
                        Category Name <span style="color:#c49a6c;">*</span>
                    </label>
                    <input type="text" class="form-control" id="newCategoryName" 
                           placeholder="e.g. History, Children's, Poetry, Biography" 
                           maxlength="50" style="border-color:#ede3da;" required>
                    <div class="form-text small" style="color: #786670;">Between 2 and 50 characters. Must be unique.</div>
                </div>

                <div class="mb-3">
                    <label for="newCategoryDesc" class="form-label fw-semibold" style="color:#240e18;">
                        Description <span class="text-muted small fw-normal">(Optional)</span>
                    </label>
                    <textarea class="form-control" id="newCategoryDesc" rows="2" 
                              placeholder="Brief description of this literary category..." 
                              style="border-color:#ede3da;"></textarea>
                </div>

                <div class="mb-3">
                    <label for="newCategoryIcon" class="form-label fw-semibold" style="color:#240e18;">
                        Icon Theme <span class="text-muted small fw-normal">(Optional)</span>
                    </label>
                    <select class="form-select" id="newCategoryIcon" style="border-color:#ede3da;">
                        <option value="bi-journal-bookmark" selected>Book / Journal</option>
                        <option value="bi-book">Open Book</option>
                        <option value="bi-laptop">Technology / Laptop</option>
                        <option value="bi-briefcase">Business / Work</option>
                        <option value="bi-heart">Heart / Self-Help</option>
                        <option value="bi-lightbulb">Lightbulb / Science</option>
                        <option value="bi-globe">Globe / Geography</option>
                        <option value="bi-compass">Compass / Adventure</option>
                        <option value="bi-palette">Art / Design</option>
                        <option value="bi-music-note-beamed">Music & Arts</option>
                        <option value="bi-clock-history">History & Memoir</option>
                        <option value="bi-stars">Fantasy / Fiction</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer" style="background:#f4ece2; border-top: 1px solid #ede3da;">
                <button type="button" class="btn btn-outline-plum px-3" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-plum px-4 fw-semibold" id="btnSaveCategory" onclick="submitNewCategory('${pageContext.request.contextPath}')">
                    <i class="bi bi-check2-circle me-1"></i> Save Category
                </button>
            </div>
        </div>
    </div>
</div>
