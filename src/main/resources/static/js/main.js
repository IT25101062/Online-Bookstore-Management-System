/**
 * ReadVerse Online Bookstore - Main JavaScript
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
