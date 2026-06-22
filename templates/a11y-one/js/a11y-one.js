/**
 * a11y-one.js — theme JavaScript for the A11y One WHMCS theme
 * Author: Can Kirca
 *
 * Loaded once via footer.tpl for all pages. Assumes jQuery is available
 * (loaded earlier by the parent template's scripts.min.js).
 */
(function () {
    'use strict';

    /* ------------------------------------------------------------------ */
    /* i18n: read localised strings from the carrier element rendered by   */
    /* tablelist.tpl. Fall back to English only when the element is absent. */
    /* ------------------------------------------------------------------ */
    var _i18nEl = null;

    function _i18n(key, fallback) {
        if (!_i18nEl) {
            _i18nEl = document.getElementById('a11yOneI18n');
        }
        if (_i18nEl) {
            var val = _i18nEl.getAttribute('data-' + key);
            if (val !== null && val !== '') { return val; }
        }
        return fallback;
    }

    /* ------------------------------------------------------------------ */
    /* Sidebar: keep aria-expanded in sync with the custom card-minimise   */
    /* toggle; also ensure every card-minimise button has an accessible    */
    /* name (the icon inside is aria-hidden).                              */
    /* ------------------------------------------------------------------ */
    function fixCardMinimiseButtons() {
        document.querySelectorAll('.card-minimise').forEach(function (btn) {
            if (!btn.getAttribute('aria-label')) {
                /* Derive a name from the controlled panel's heading text.   */
                /* The button is nested inside the .card-title / .card-header */
                /* so we must collect text nodes that are NOT inside the btn. */
                var heading = null;
                var header = btn.closest('.card-header');
                if (header) {
                    var titleEl = header.querySelector('.card-title');
                    if (titleEl) {
                        /* Clone and remove the button to get clean heading text */
                        var clone = titleEl.cloneNode(true);
                        var cloneBtn = clone.querySelector('.card-minimise');
                        if (cloneBtn) { cloneBtn.parentNode.removeChild(cloneBtn); }
                        heading = clone.textContent.replace(/\s+/g, ' ').trim();
                    }
                }
                var isExpanded = btn.getAttribute('aria-expanded') !== 'false';
                var action = isExpanded ? _i18n('collapse', 'Collapse') : _i18n('expand', 'Expand');
                var label = heading
                    ? action + ' ' + heading
                    : action + ' ' + _i18n('panel', 'panel');
                btn.setAttribute('aria-label', label);
            }
        });
    }

    /* Run on DOMContentLoaded and on any click (state may change) */
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', fixCardMinimiseButtons);
    } else {
        fixCardMinimiseButtons();
    }

    document.addEventListener('click', function (e) {
        var btn = e.target.closest('.card-minimise');
        if (!btn) { return; }
        var expanded = btn.getAttribute('aria-expanded') === 'true';
        btn.setAttribute('aria-expanded', expanded ? 'false' : 'true');
        /* Update label to reflect collapsed/expanded state */
        var isNowExpanded = !expanded;
        var collapse = _i18n('collapse', 'Collapse');
        var expand   = _i18n('expand',   'Expand');
        var current  = btn.getAttribute('aria-label') || '';
        var replaceRe = new RegExp('^(' + collapse + '|' + expand + ') ');
        btn.setAttribute('aria-label', current.replace(replaceRe, (isNowExpanded ? collapse + ' ' : expand + ' ')));
    });

    /* ------------------------------------------------------------------ */
    /* DataTables a11y post-processing                                      */
    /*                                                                      */
    /* Runs on every draw.dt event (initial + sort/filter/page changes)    */
    /* and also on DOMContentLoaded to catch any table already initialised. */
    /* All fixes are idempotent.                                            */
    /* ------------------------------------------------------------------ */

    /**
     * Fix a single DataTables wrapper element.
     * @param {Element} wrapper  — the .dataTables_wrapper element
     */
    function fixDataTable(wrapper) {
        var table = wrapper.querySelector('table');
        if (!table) { return; }

        /* 1. Accessible table name -------------------------------------- */
        /* Look for the nearest preceding h1-h4 in the same card/panel    */
        if (!table.getAttribute('aria-label') && !table.querySelector('caption')) {
            var heading = null;
            /* Strategy A: .card ancestor → .card-header .card-title */
            var card = wrapper.closest('.card');
            if (card) {
                var cardHeader = card.querySelector('.card-header .card-title');
                if (cardHeader) {
                    heading = cardHeader.textContent.trim();
                }
            }
            /* Strategy B: walk up ancestors, check all prev siblings     */
            /* (and their descendants) for any h1-h4 text                 */
            if (!heading) {
                var el = wrapper;
                outer: for (var depth = 0; depth < 8; depth++) {
                    if (!el.parentElement) { break; }
                    el = el.parentElement;
                    var sib = el.previousElementSibling;
                    while (sib) {
                        /* Direct heading tag */
                        if (/^H[1-4]$/.test(sib.tagName)) {
                            heading = sib.textContent.trim();
                            break outer;
                        }
                        /* Heading nested inside a sibling */
                        var nested = sib.querySelector('h1,h2,h3,h4');
                        if (nested) {
                            heading = nested.textContent.trim();
                            break outer;
                        }
                        sib = sib.previousElementSibling;
                    }
                }
            }
            if (heading) {
                /* Strip icon text / whitespace collapse */
                heading = heading.replace(/\s+/g, ' ').trim();
                table.setAttribute('aria-label', heading);
            }
        }

        /* 2. <th scope="col"> on all header cells ----------------------- */
        var ths = table.querySelectorAll('thead th');
        ths.forEach(function (th) {
            if (!th.getAttribute('scope')) {
                th.setAttribute('scope', 'col');
            }
            /* 3. aria-sort: DataTables 1.10.x sets aria-sort on the       */
            /* sorted column's th. Verify and add "none" on unsorted cols. */
            if (!th.getAttribute('aria-sort')) {
                th.setAttribute('aria-sort', 'none');
            }
        });

        /* 4. Pagination: aria-label + aria-current ---------------------- */
        var paginate = wrapper.querySelector('.dataTables_paginate');
        if (paginate) {
            var pageItems = paginate.querySelectorAll('.paginate_button');
            pageItems.forEach(function (item) {
                /* .paginate_button may be an <li> containing an <a>,
                   or in some DataTables builds the <a> directly. */
                var a = (item.tagName === 'A') ? item : item.querySelector('a');
                var li = (item.tagName === 'LI') ? item : item.closest('li');
                if (!a) { return; }

                var dtIdx = a.getAttribute('data-dt-idx');
                var isActive = (li || item).classList.contains('active');
                var isDisabled = (li || item).classList.contains('disabled');

                /* Previous / Next buttons */
                if (dtIdx === 'previous' || (item.id && item.id.indexOf('_previous') !== -1)) {
                    a.setAttribute('aria-label', _i18n('prevpage', 'Previous page'));
                    if (isDisabled) { a.setAttribute('aria-disabled', 'true'); }
                    else { a.removeAttribute('aria-disabled'); }
                    a.removeAttribute('aria-current');
                } else if (dtIdx === 'next' || (item.id && item.id.indexOf('_next') !== -1)) {
                    a.setAttribute('aria-label', _i18n('nextpage', 'Next page'));
                    if (isDisabled) { a.setAttribute('aria-disabled', 'true'); }
                    else { a.removeAttribute('aria-disabled'); }
                    a.removeAttribute('aria-current');
                } else if (dtIdx === 'first') {
                    a.setAttribute('aria-label', _i18n('firstpage', 'First page'));
                    a.removeAttribute('aria-current');
                } else if (dtIdx === 'last') {
                    a.setAttribute('aria-label', _i18n('lastpage', 'Last page'));
                    a.removeAttribute('aria-current');
                } else {
                    /* Numeric page button */
                    var pageNum = a.textContent.trim();
                    if (pageNum && !isNaN(Number(pageNum))) {
                        a.setAttribute('aria-label', _i18n('page', 'Page') + ' ' + pageNum);
                        if (isActive) {
                            a.setAttribute('aria-current', 'page');
                        } else {
                            a.removeAttribute('aria-current');
                        }
                    }
                }
            });

            /* Wrap pagination in a <nav> with a label if not already done */
            if (paginate.tagName !== 'NAV' && !paginate.closest('nav')) {
                if (!paginate.getAttribute('role')) {
                    paginate.setAttribute('role', 'navigation');
                    paginate.setAttribute('aria-label', _i18n('tablepagination', 'Table pagination'));
                }
            }
        }

        /* 5. Search input: ensure accessible name ----------------------- */
        var filterDiv = wrapper.querySelector('.dataTables_filter');
        if (filterDiv) {
            var searchInput = filterDiv.querySelector('input[type="search"]');
            if (searchInput && !searchInput.getAttribute('aria-label')) {
                /* DataTables wraps the input in a <label>; if it has visible  */
                /* text that label is sufficient. If sSearch was blank the      */
                /* label contains no text — add aria-label directly.            */
                var lbl = filterDiv.querySelector('label');
                var lblText = lbl ? lbl.textContent.trim() : '';
                if (!lblText) {
                    searchInput.setAttribute('aria-label', _i18n('search', 'Search'));
                } else {
                    /* Label has text — give input an id and wire <label for> */
                    var tableId = table.getAttribute('id') || ('dt-' + Math.random().toString(36).slice(2));
                    var inputId = tableId + '-search';
                    if (!searchInput.getAttribute('id')) {
                        searchInput.setAttribute('id', inputId);
                    }
                    if (lbl && !lbl.getAttribute('for')) {
                        lbl.setAttribute('for', searchInput.getAttribute('id'));
                    }
                }
            }
        }

        /* 6. Length <select>: ensure accessible name -------------------- */
        var lengthDiv = wrapper.querySelector('.dataTables_length');
        if (lengthDiv) {
            var lengthSelect = lengthDiv.querySelector('select');
            if (lengthSelect && !lengthSelect.getAttribute('aria-label')) {
                var lenLbl = lengthDiv.querySelector('label');
                var lenText = lenLbl ? lenLbl.textContent.trim() : '';
                if (!lenText) {
                    lengthSelect.setAttribute('aria-label', _i18n('rowsperpage', 'Rows per page'));
                } else {
                    /* Label wraps select — give select an id and wire label */
                    var tableId2 = table.getAttribute('id') || ('dt-' + Math.random().toString(36).slice(2));
                    var selectId = tableId2 + '-length';
                    if (!lengthSelect.getAttribute('id')) {
                        lengthSelect.setAttribute('id', selectId);
                    }
                    if (lenLbl && !lenLbl.getAttribute('for')) {
                        lenLbl.setAttribute('for', lengthSelect.getAttribute('id'));
                    }
                }
            }
        }
    }

    /**
     * Fix view-filter toggle buttons: add aria-pressed reflecting .active.
     * These live outside the dataTables_wrapper so we scan at document level.
     */
    function fixViewFilterButtons() {
        var filterBtns = document.querySelectorAll('.view-filter-btns .list-group-item');
        filterBtns.forEach(function (btn) {
            var pressed = btn.classList.contains('active') ? 'true' : 'false';
            btn.setAttribute('aria-pressed', pressed);
            /* Ensure role=button if it's an <a> element */
            if (btn.tagName === 'A') {
                btn.setAttribute('role', 'button');
            }
        });
    }

    /**
     * Fix responsive child-row expanders: add aria-expanded.
     * DataTables responsive adds .dtr-control on the first td of a collapsed row.
     */
    function fixResponsiveExpanders() {
        /* Collapsed rows: tr.child-no has td.dtr-control */
        document.querySelectorAll('tr.odd, tr.even').forEach(function (tr) {
            var ctrl = tr.querySelector('td.dtr-control');
            if (!ctrl) { return; }
            var isExpanded = tr.nextElementSibling && tr.nextElementSibling.classList.contains('child');
            ctrl.setAttribute('aria-expanded', isExpanded ? 'true' : 'false');
            if (!ctrl.getAttribute('role')) {
                ctrl.setAttribute('role', 'button');
            }
            if (!ctrl.getAttribute('tabindex')) {
                ctrl.setAttribute('tabindex', '0');
            }
        });
    }

    /**
     * Run all DataTables a11y fixes on every wrapper found in the document.
     */
    function fixAllDataTables() {
        document.querySelectorAll('.dataTables_wrapper').forEach(fixDataTable);
        fixViewFilterButtons();
        fixResponsiveExpanders();
    }

    /* Hook into DataTables draw.dt event (fires after every draw) */
    if (typeof jQuery !== 'undefined') {
        jQuery(document).on('draw.dt', function () {
            fixAllDataTables();
        });
        /* Also run after DataTables init completes on each table */
        jQuery(document).on('init.dt', function () {
            fixAllDataTables();
        });
    }

    /* Also run on DOMContentLoaded as a fallback (catches non-DT tables) */
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', fixAllDataTables);
    } else {
        /* Already loaded — run async to let DataTables finish its own init */
        setTimeout(fixAllDataTables, 0);
    }
}());
