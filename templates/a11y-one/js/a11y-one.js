/**
 * a11y-one.js — theme JavaScript for the A11y One WHMCS theme
 * Author: Can Kirca
 *
 * Loaded once via footer.tpl for all pages. Assumes jQuery is available
 * (loaded earlier by the parent template's scripts.min.js).
 */
(function () {
    'use strict';

    /* Sidebar: keep aria-expanded in sync with the custom card-minimise toggle */
    var minimiseBtns = document.querySelectorAll('.card-minimise');
    document.addEventListener('click', function (e) {
        var btn = e.target.closest('.card-minimise');
        if (!btn) { return; }
        var expanded = btn.getAttribute('aria-expanded') === 'true';
        btn.setAttribute('aria-expanded', expanded ? 'false' : 'true');
    });
}());
