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
    /* iCheck replacement                                                   */
    /*                                                                      */
    /* The parent twenty-one theme bundles iCheck 1.0.3 and runs            */
    /*   jQuery('.icheck-button').iCheck({ ... })                           */
    /* on document-ready (and again per-page on the billing-contacts        */
    /* container). iCheck wraps each native <input type=checkbox|radio> in  */
    /* a styled <div>/<ins> overlay and sets the real input to              */
    /* position:absolute; opacity:0 — removing it from the accessibility    */
    /* tree so screen-reader and keyboard users cannot perceive or operate  */
    /* it.                                                                  */
    /*                                                                      */
    /* We replace jQuery.fn.iCheck with a lightweight shim that leaves the  */
    /* NATIVE input fully visible, focusable and operable (it is styled to   */
    /* match twenty-one via custom.css), while still honouring the iCheck    */
    /* public API the parent relies on:                                     */
    /*   - the imperative methods  .iCheck('check' | 'uncheck' | 'toggle' |  */
    /*     'disable' | 'enable' | 'indeterminate' | 'determinate' |          */
    /*     'update' | 'destroy')                                             */
    /*   - the pseudo-events  ifClicked / ifChanged / ifChecked /            */
    /*     ifUnchecked / ifToggled / ifDisabled / ifEnabled /                */
    /*     ifIndeterminate / ifDeterminate                                   */
    /* which the parent binds via .on('ifChecked', …) on the payment-method  */
    /* (name="type"), billing-contact (name="billingcontact") and SSL        */
    /* approval (name="approval_method") inputs.                             */
    /*                                                                      */
    /* The input keeps its original name / value / form association, so      */
    /* form submission is byte-for-byte unchanged. This must run BEFORE the  */
    /* parent's document-ready iCheck() call — a11y-one.js is a synchronous  */
    /* <script> emitted before {$footeroutput} in footer.tpl, so installing  */
    /* the shim here wins over any later .iCheck() invocation.               */
    /* ------------------------------------------------------------------ */
    function installICheckShim($) {
        if (!$ || !$.fn) { return; }

        /* Mark our shim so we never double-install over the real plugin or  */
        /* over ourselves (idempotent across multiple loads).                */
        if ($.fn.iCheck && $.fn.iCheck.__a11yOneShim) { return; }

        var EVENTS = {
            check: 'ifChecked',
            uncheck: 'ifUnchecked',
            toggle: 'ifToggled',
            disable: 'ifDisabled',
            enable: 'ifEnabled',
            indeterminate: 'ifIndeterminate',
            determinate: 'ifDeterminate'
        };

        function fire($input, name) {
            /* Mirror iCheck: fire the namespaced pseudo-event so existing    */
            /* .on('ifChecked', …) handlers in the parent keep working.       */
            $input.trigger(name);
        }

        /* Bridge native interaction → iCheck pseudo-events. Bound once per   */
        /* input. Radios in a group all emit ifChanged when the group state   */
        /* changes (native 'change' only fires on the newly-checked radio, so */
        /* we additionally notify same-name siblings, matching iCheck).       */
        function bindBridge($input) {
            var node = $input[0];
            if (node.__a11yICheckBound) { return; }
            node.__a11yICheckBound = true;

            $input.on('click.a11yicheck', function () {
                fire($input, 'ifClicked');
            });

            $input.on('change.a11yicheck', function () {
                fire($input, 'ifChanged');
                fire($input, node.checked ? 'ifChecked' : 'ifUnchecked');
                fire($input, 'ifToggled');
                if (node.type === 'radio' && node.name) {
                    /* Notify de-selected siblings so any ifUnchecked/ifChanged */
                    /* listeners on them also run (iCheck parity).             */
                    var form = node.form || document;
                    var sel = 'input[type="radio"][name="' + cssEscape(node.name) + '"]';
                    $(form).find(sel).each(function () {
                        if (this !== node && this.__a11yICheckBound) {
                            var $sib = $(this);
                            fire($sib, 'ifChanged');
                            fire($sib, 'ifUnchecked');
                            fire($sib, 'ifToggled');
                        }
                    });
                }
            });
        }

        function cssEscape(value) {
            /* Minimal attribute-selector escaping for name values. */
            return String(value).replace(/["\\]/g, '\\$&');
        }

        /* Apply a string method to one input and fire the matching events.   */
        function applyMethod($input, method) {
            var node = $input[0];
            if (!node) { return; }

            if (method === 'destroy') {
                $input.off('.a11yicheck');
                node.__a11yICheckBound = false;
                $input.removeClass('a11y-native-check');
                return;
            }

            if (method === 'update') {
                /* No styled overlay to refresh — native input already        */
                /* reflects its own state. No-op (parity placeholder).        */
                return;
            }

            /* State-changing methods (check/uncheck/toggle): mutate the      */
            /* checked property and fire ONE native 'change'. The             */
            /* change.a11yicheck bridge below converts that into the iCheck   */
            /* pseudo-events (ifChanged / ifChecked|ifUnchecked / ifToggled)  */
            /* — including for de-selected radio siblings — so every event    */
            /* fires exactly once, just as the real iCheck does.              */
            if (method === 'check' || method === 'uncheck' || method === 'toggle') {
                var changed = false;
                if (method === 'check') {
                    if (!node.checked) { node.checked = true; changed = true; }
                } else if (method === 'uncheck') {
                    if (node.checked) { node.checked = false; changed = true; }
                } else { /* toggle */
                    node.checked = !node.checked; changed = true;
                }
                /* Fire a single native 'change' only when the state actually   */
                /* changed; the change.a11yicheck bridge then emits the iCheck   */
                /* pseudo-events. A no-op check/uncheck fires nothing — iCheck    */
                /* parity (its operate() guards on the current state).           */
                if (changed) { $input.trigger('change'); }
                return;
            }

            /* Non-state methods: mutate then fire the matching pseudo-event  */
            /* directly (these have no native 'change' to ride on).           */
            if (method === 'disable') {
                if (node.disabled) { return; }
                node.disabled = true;
            } else if (method === 'enable') {
                if (!node.disabled) { return; }
                node.disabled = false;
            } else if (method === 'indeterminate') {
                node.indeterminate = true;
            } else if (method === 'determinate') {
                node.indeterminate = false;
            }
            if (EVENTS[method]) {
                fire($input, EVENTS[method]);
            }
        }

        var shim = function (options) {
            /* String argument → imperative method on each matched input.     */
            if (typeof options === 'string') {
                var method = options;
                this.each(function () {
                    applyMethod($(this), method);
                });
                return this;
            }

            /* Object / no argument → "initialise": keep the native control,  */
            /* tag it for CSS styling and wire the event bridge.              */
            this.each(function () {
                var $input = $(this);
                if (this.type !== 'checkbox' && this.type !== 'radio') { return; }
                $input.addClass('a11y-native-check');
                bindBridge($input);
            });
            return this;
        };

        shim.__a11yOneShim = true;
        $.fn.iCheck = shim;

        /* Defensive: if the real iCheck somehow already ran before us (e.g.  */
        /* load-order change), unwrap any existing overlays so the native     */
        /* input is restored and re-bridge it.                               */
        function reclaimExisting() {
            var wrappers = document.querySelectorAll('.icheckbox_square-blue, .iradio_square-blue, .icheckbox, .iradio');
            wrappers.forEach(function (wrap) {
                var input = wrap.querySelector('input[type="checkbox"], input[type="radio"]');
                if (!input) { return; }
                /* Move the input out of the overlay, drop iCheck inline css. */
                wrap.parentNode.insertBefore(input, wrap);
                wrap.parentNode.removeChild(wrap);
                input.style.position = '';
                input.style.opacity = '';
                input.style.display = '';
                var $i = $(input);
                $i.addClass('a11y-native-check');
                bindBridge($i);
            });
        }
        $(reclaimExisting);
    }

    if (typeof jQuery !== 'undefined') {
        installICheckShim(jQuery);
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
