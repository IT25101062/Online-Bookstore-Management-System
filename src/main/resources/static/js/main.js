/**
 * Chapter One – Online Bookstore - Main JavaScript
 * Handles confirmations, form validation, dynamic price calculation, and notifications
 */

document.addEventListener('DOMContentLoaded', function () {
    // Enable Bootstrap tooltips if any
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Auto-dismiss alerts after 5 seconds
    setTimeout(function() {
        var alerts = document.querySelectorAll('.alert-dismissible');
        alerts.forEach(function(alert) {
            var bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        });
    }, 5000);

    // Initialize ISBN digit limiter if present
    setupIsbnInput('isbn', 'isbnBadge');
});

// Confirm deletion dialog
function confirmDelete(itemDescription) {
    return confirm("Are you sure you want to permanently delete " + (itemDescription || "this record") + "? This operation cannot be undone.");
}

// Dynamic toggle for Book Type (EBook vs Printed Book)
function toggleBookTypeFields() {
    var typeSelect = document.getElementById('bookType');
    if (!typeSelect) return;

    var selectedType = typeSelect.value;
    var ebookFields = document.getElementById('ebookFields');
    var printedFields = document.getElementById('printedFields');

    if (selectedType === 'EBOOK') {
        if (ebookFields) ebookFields.style.display = 'block';
        if (printedFields) printedFields.style.display = 'none';
    } else {
        if (ebookFields) ebookFields.style.display = 'none';
        if (printedFields) printedFields.style.display = 'block';
    }
}

// Dynamic toggle for Payment Method
function togglePaymentFields() {
    var paymentSelect = document.getElementById('paymentMethod');
    if (!paymentSelect) return;

    var selected = paymentSelect.value;
    var cardFields = document.getElementById('cardPaymentFields');
    var cashFields = document.getElementById('cashPaymentFields');

    if (selected === 'CARD') {
        if (cardFields) cardFields.style.display = 'block';
        if (cashFields) cashFields.style.display = 'none';
    } else {
        if (cardFields) cardFields.style.display = 'none';
        if (cashFields) cashFields.style.display = 'block';
    }
}

// Live Image Preview for Book Cover URL (Google Images / Web URLs)
function updateImagePreview(url, previewImgId, fallbackIconId) {
    var img = document.getElementById(previewImgId || 'coverImagePreview');
    var fallback = document.getElementById(fallbackIconId || 'coverFallbackIcon');
    if (!img) return;

    var trimmed = url ? url.trim() : '';
    if (trimmed.length > 8 && (trimmed.startsWith('http://') || trimmed.startsWith('https://') || trimmed.startsWith('data:image/'))) {
        img.src = trimmed;
        img.onload = function() {
            img.style.display = 'block';
            if (fallback) fallback.style.display = 'none';
        };
        img.onerror = function() {
            img.style.display = 'none';
            if (fallback) fallback.style.display = 'flex';
        };
    } else {
        img.style.display = 'none';
        img.src = '';
        if (fallback) fallback.style.display = 'flex';
    }
}

// ISBN Number Limiter & Live Digit Validator (Strict limit: 10 or 13 digits, max 13 digits)
function setupIsbnInput(inputId, badgeId) {
    var input = document.getElementById(inputId || 'isbn');
    var badge = document.getElementById(badgeId || 'isbnBadge');
    if (!input) return;

    function formatAndLimit() {
        // Strip any character not a digit, hyphen, or X/x
        var raw = input.value;
        var filtered = '';
        var digitCount = 0;

        for (var i = 0; i < raw.length; i++) {
            var ch = raw[i];
            if (/[0-9Xx]/.test(ch)) {
                // Limit strictly to a maximum of 13 digits
                if (digitCount < 13) {
                    filtered += ch.toUpperCase();
                    digitCount++;
                }
            } else if (ch === '-') {
                filtered += ch;
            }
        }

        // Limit total formatted string length to 17
        if (filtered.length > 17) {
            filtered = filtered.substring(0, 17);
            digitCount = (filtered.match(/[0-9Xx]/g) || []).length;
        }

        if (input.value !== filtered) {
            input.value = filtered;
        }

        if (badge) {
            if (digitCount === 10) {
                badge.className = 'badge bg-success ms-1 small';
                badge.innerHTML = '<i class="bi bi-check-circle me-1"></i>10 digits (ISBN-10)';
                input.setCustomValidity('');
            } else if (digitCount === 13) {
                badge.className = 'badge bg-success ms-1 small';
                badge.innerHTML = '<i class="bi bi-check-circle me-1"></i>13 digits (ISBN-13)';
                input.setCustomValidity('');
            } else if (digitCount === 0) {
                badge.className = 'badge bg-secondary ms-1 small';
                badge.textContent = '0 / 13 digits (Limit: 10 or 13)';
                input.setCustomValidity('Please enter a valid 10 or 13 digit ISBN.');
            } else {
                badge.className = 'badge bg-warning text-dark ms-1 small';
                badge.textContent = digitCount + ' / 13 digits (Must be 10 or 13)';
                input.setCustomValidity('ISBN must contain exactly 10 or 13 digits. Current: ' + digitCount);
            }
        }
    }

    input.addEventListener('input', formatAndLimit);
    input.addEventListener('paste', function() {
        setTimeout(formatAndLimit, 50);
    });

    // Run initial formatting for edit forms
    formatAndLimit();
}

// =========================================================================
// Category Management Modal & Dynamic Dropdown Handling
// =========================================================================

var _categoryModalInstance = null;
var _lastSelectedCategory = 'Technology';

function openAddCategoryModal() {
    var modalEl = document.getElementById('addCategoryModal');
    if (!modalEl) return;
    var nameInput = document.getElementById('newCategoryName');
    var descInput = document.getElementById('newCategoryDesc');
    var alertEl = document.getElementById('categoryModalAlert');
    if (nameInput) nameInput.value = '';
    if (descInput) descInput.value = '';
    if (alertEl) {
        alertEl.className = 'alert d-none mb-3 py-2 small';
        alertEl.textContent = '';
    }
    _categoryModalInstance = bootstrap.Modal.getOrCreateInstance(modalEl);
    _categoryModalInstance.show();
    setTimeout(function() {
        if (nameInput) nameInput.focus();
    }, 400);
}

function handleCategoryChange(selectEl) {
    if (selectEl.value === '__ADD_NEW__') {
        openAddCategoryModal();
        // Reset select back to previous until added
        selectEl.value = _lastSelectedCategory;
    } else {
        _lastSelectedCategory = selectEl.value;
    }
}

function submitNewCategory(contextPath) {
    var nameInput = document.getElementById('newCategoryName');
    var descInput = document.getElementById('newCategoryDesc');
    var iconSelect = document.getElementById('newCategoryIcon');
    var alertEl = document.getElementById('categoryModalAlert');
    var saveBtn = document.getElementById('btnSaveCategory');

    if (!nameInput) return;
    var name = nameInput.value.trim();
    if (!name || name.length < 2) {
        if (alertEl) {
            alertEl.className = 'alert alert-danger mb-3 py-2 small';
            alertEl.textContent = 'Please enter a valid category name (minimum 2 characters).';
        }
        nameInput.focus();
        return;
    }

    var formData = new URLSearchParams();
    formData.append('categoryName', name);
    formData.append('description', descInput ? descInput.value.trim() : '');
    formData.append('iconName', iconSelect ? iconSelect.value : 'bi-journal-bookmark');

    if (saveBtn) {
        saveBtn.disabled = true;
        saveBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-1" role="status" aria-hidden="true"></span>Saving...';
    }

    var url = (contextPath || '') + '/categories/add';
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: formData.toString()
    })
    .then(function(res) {
        return res.json().then(function(data) {
            return { ok: res.ok, data: data };
        });
    })
    .then(function(result) {
        if (saveBtn) {
            saveBtn.disabled = false;
            saveBtn.innerHTML = '<i class="bi bi-check2-circle me-1"></i> Save Category';
        }

        if (result.ok && result.data && result.data.success) {
            var catName = result.data.categoryName || name;
            var select = document.getElementById('category');
            if (select) {
                // Check if option already exists
                var exists = false;
                for (var i = 0; i < select.options.length; i++) {
                    if (select.options[i].value.toLowerCase() === catName.toLowerCase()) {
                        exists = true;
                        select.selectedIndex = i;
                        break;
                    }
                }
                if (!exists) {
                    var newOpt = document.createElement('option');
                    newOpt.value = catName;
                    newOpt.textContent = catName;
                    newOpt.selected = true;

                    // Insert before the __ADD_NEW__ option
                    var addNewOpt = select.querySelector('option[value="__ADD_NEW__"]');
                    if (addNewOpt) {
                        select.insertBefore(newOpt, addNewOpt);
                    } else {
                        select.appendChild(newOpt);
                    }
                    select.value = catName;
                }
                _lastSelectedCategory = catName;
            }

            if (_categoryModalInstance) {
                _categoryModalInstance.hide();
            }

            // Show temporary alert/toast
            var pageAlert = document.createElement('div');
            pageAlert.className = 'alert alert-success alert-dismissible fade show shadow-sm mt-3';
            pageAlert.setAttribute('role', 'alert');
            pageAlert.innerHTML = '<i class="bi bi-check-circle-fill me-2"></i> Category <strong>' + catName + '</strong> added and selected! <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>';
            var container = document.querySelector('.card-body') || document.querySelector('main .container');
            if (container) {
                container.insertBefore(pageAlert, container.firstChild);
                setTimeout(function() {
                    try {
                        var bsAlert = new bootstrap.Alert(pageAlert);
                        bsAlert.close();
                    } catch (e) {}
                }, 4000);
            }
        } else {
            if (alertEl) {
                alertEl.className = 'alert alert-danger mb-3 py-2 small';
                alertEl.textContent = (result.data && result.data.message) ? result.data.message : 'Failed to add category.';
            }
        }
    })
    .catch(function(err) {
        if (saveBtn) {
            saveBtn.disabled = false;
            saveBtn.innerHTML = '<i class="bi bi-check2-circle me-1"></i> Save Category';
        }
        if (alertEl) {
            alertEl.className = 'alert alert-danger mb-3 py-2 small';
            alertEl.textContent = 'Error: ' + err.message;
        }
    });
}
