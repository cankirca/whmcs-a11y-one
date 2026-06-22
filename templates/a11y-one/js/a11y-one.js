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
    /* Sidebar collapse: clean disclosure pattern (SR round 2, fix C)      */
    /*                                                                     */
    /* sidebar.tpl now renders the toggle as a full-width <button> that    */
    /* WRAPS the section title text + chevron, with aria-expanded /        */
    /* aria-controls. The button's accessible name therefore comes         */
    /* naturally from its title text (the chevron <i> is aria-hidden), so  */
    /* a screen reader announces "{section title}, button, expanded/       */
    /* collapsed" — the standard disclosure phrasing the SR user asked for.*/
    /*                                                                     */
    /* We DO NOT add a verb-prefixed aria-label here: that would override  */
    /* the section-title name and bury the section under "Collapse …". We  */
    /* only supply an aria-label as a FALLBACK when a button has no visible */
    /* text of its own (defensive — e.g. an icon-only legacy card).        */
    /* aria-expanded is kept in sync on click; the visible state lives in  */
    /* aria-expanded, not in the name.                                     */
    /* ------------------------------------------------------------------ */
    function _cardMinimiseAccessibleText(btn) {
        /* Visible text of the button minus aria-hidden icons. */
        var clone = btn.cloneNode(true);
        clone.querySelectorAll('i, svg, [aria-hidden="true"]').forEach(function (el) {
            if (el.parentNode) { el.parentNode.removeChild(el); }
        });
        return (clone.textContent || '').replace(/\s+/g, ' ').trim();
    }

    function fixCardMinimiseButtons() {
        document.querySelectorAll('.card-minimise').forEach(function (btn) {
            /* Hide the chevron from AT (decorative). */
            btn.querySelectorAll('i, svg').forEach(function (icon) {
                icon.setAttribute('aria-hidden', 'true');
            });
            /* If the button has its own visible text, that IS the name —   */
            /* leave it alone (clean disclosure). Only fall back to a        */
            /* derived label when the button would otherwise be nameless.    */
            if (_cardMinimiseAccessibleText(btn)) { return; }
            if (btn.getAttribute('aria-label')) { return; }
            var heading = null;
            var header = btn.closest('.card-header');
            if (header) {
                var titleEl = header.querySelector('.card-title');
                if (titleEl) {
                    var tClone = titleEl.cloneNode(true);
                    var cloneBtn = tClone.querySelector('.card-minimise');
                    if (cloneBtn) { cloneBtn.parentNode.removeChild(cloneBtn); }
                    heading = tClone.textContent.replace(/\s+/g, ' ').trim();
                }
            }
            btn.setAttribute('aria-label', heading || _i18n('panel', 'panel'));
        });
    }

    /* Run on DOMContentLoaded and on any click (state may change) */
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', fixCardMinimiseButtons);
    } else {
        fixCardMinimiseButtons();
    }

    /* Keep aria-expanded in sync with the parent theme's slide toggle. */
    document.addEventListener('click', function (e) {
        var btn = e.target.closest('.card-minimise');
        if (!btn) { return; }
        var expanded = btn.getAttribute('aria-expanded') === 'true';
        btn.setAttribute('aria-expanded', expanded ? 'false' : 'true');
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

        /* 2. <th scope="col"> + sort state on all header cells ---------- */
        var ths = table.querySelectorAll('thead th');
        ths.forEach(function (th) {
            if (!th.getAttribute('scope')) {
                th.setAttribute('scope', 'col');
            }

            /* 3. aria-sort + accessible sort-state name -------------------*/
            /* DataTables marks the active column with .sorting_asc /       */
            /* .sorting_desc and others with .sorting. It also stamps its    */
            /* own aria-sort, but inconsistently (it leaves "none" on the    */
            /* freshly-sorted column until the next interaction). Derive     */
            /* aria-sort authoritatively from the class so it is always      */
            /* correct after every draw, and make the header's accessible    */
            /* name convey that it is a sort control and its current state.  */
            var isSortable = th.classList.contains('sorting') ||
                             th.classList.contains('sorting_asc') ||
                             th.classList.contains('sorting_desc') ||
                             th.classList.contains('sorting_asc_disabled') ||
                             th.classList.contains('sorting_desc_disabled');

            if (!isSortable) {
                /* Non-sortable column — leave it without sort semantics.   */
                if (!th.getAttribute('aria-sort')) {
                    /* nothing to do — a plain column header */
                }
                return;
            }

            var sortState; /* 'ascending' | 'descending' | 'none' */
            if (th.classList.contains('sorting_asc')) {
                sortState = 'ascending';
            } else if (th.classList.contains('sorting_desc')) {
                sortState = 'descending';
            } else {
                sortState = 'none';
            }
            th.setAttribute('aria-sort', sortState);

            /* Column name: the th's own text minus any helper/sr nodes.    */
            /* Cache it once so re-sorting (which leaves text intact) keeps  */
            /* the same column name even if DataTables adds spans later.     */
            var colName = th.getAttribute('data-a11y-col');
            if (!colName) {
                var thClone = th.cloneNode(true);
                thClone.querySelectorAll('.sr-only, i, svg').forEach(function (el) {
                    if (el.parentNode) { el.parentNode.removeChild(el); }
                });
                colName = (thClone.textContent || '').replace(/\s+/g, ' ').trim();
                if (colName) { th.setAttribute('data-a11y-col', colName); }
            }

            /* Build "{column}, sortable, sorted ascending/descending/not   */
            /* sorted" via the i18n carrier. This overrides DataTables'      */
            /* own static aria-label ("activate to sort column ascending")  */
            /* which never reflects the CURRENT state. We do NOT touch the   */
            /* click handler — DataTables still sorts on click.             */
            var stateWord;
            if (sortState === 'ascending') {
                stateWord = _i18n('sortedasc', 'sorted ascending');
            } else if (sortState === 'descending') {
                stateWord = _i18n('sorteddesc', 'sorted descending');
            } else {
                stateWord = _i18n('notsorted', 'not sorted');
            }
            var sortableWord = _i18n('sortable', 'sortable');
            var name = (colName ? colName + ', ' : '') + sortableWord + ', ' + stateWord;
            th.setAttribute('aria-label', name);
            /* Mirror to title so mouse users get the same hint and we      */
            /* shadow DataTables' default title text.                        */
            th.setAttribute('title', name);
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

        /* 7. Result-count live region ----------------------------------- */
        /* After every draw (sort / search / page) announce the new result  */
        /* count to SR users. DataTables already renders the human string   */
        /* in .dataTables_info ("Showing X to Y of Z entries", localised by  */
        /* DataTables). We mirror that text into a per-wrapper visually-     */
        /* hidden aria-live="polite" region so the announcement fires on     */
        /* every redraw. The visible .dataTables_info itself is NOT a live   */
        /* region (and toggling it would be noisy), so we keep a dedicated   */
        /* mirror. Idempotent: created once, text updated each draw.         */
        announceTableInfo(wrapper, table);
    }

    /**
     * Maintain a visually-hidden polite live region per DataTables wrapper
     * that mirrors the .dataTables_info text, so SR users hear the updated
     * result count after each sort / search / page.
     * @param {Element} wrapper
     * @param {Element} table
     */
    function announceTableInfo(wrapper, table) {
        var infoEl = wrapper.querySelector('.dataTables_info');
        if (!infoEl) { return; }
        var text = (infoEl.textContent || '').replace(/\s+/g, ' ').trim();
        if (!text) { return; }

        /* The visible info element duplicates this text; mark it aria-hidden */
        /* so AT hears the announcement only once (from our live region).     */
        infoEl.setAttribute('aria-hidden', 'true');

        var region = wrapper.__a11yInfoLive;
        if (!region || !region.isConnected) {
            region = document.createElement('div');
            region.className = 'sr-only';
            region.setAttribute('aria-live', 'polite');
            region.setAttribute('aria-atomic', 'true');
            /* Inline sr-only so it works even without the theme stylesheet. */
            region.style.cssText = [
                'position:absolute', 'width:1px', 'height:1px', 'padding:0',
                'margin:-1px', 'overflow:hidden', 'clip:rect(0,0,0,0)',
                'white-space:nowrap', 'border:0'
            ].join(';');
            wrapper.appendChild(region);
            wrapper.__a11yInfoLive = region;
        }

        /* Only update (and thus re-announce) when the text actually changed */
        /* so the initial draw doesn't double-announce on the DOMContentLoaded */
        /* fallback pass. */
        if (region.__a11yLastText !== text) {
            region.__a11yLastText = text;
            region.textContent = text;
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

    /* ------------------------------------------------------------------ */
    /* Password reveal buttons (site-wide generalisation)                 */
    /*                                                                    */
    /* Selects .btn-reveal-pw and .pw-reveal buttons across all pages.    */
    /* Ensures each button has:                                           */
    /*   - type="button"                                                  */
    /*   - aria-controls → the sibling password input id (adds id if     */
    /*     missing)                                                       */
    /*   - aria-pressed reflecting current show/hide state                */
    /*   - aria-label toggling between "Show password" / "Hide password"  */
    /*     via the i18n carrier (data-showpassword / data-hidepassword)   */
    /* On click: toggles input type between "password" and "text" and    */
    /* updates aria-pressed + aria-label. All icons inside get           */
    /* aria-hidden. Idempotent — safe on pages with inline attributes     */
    /* (login, user-password, reset pages).                               */
    /* ------------------------------------------------------------------ */

    var _revealSel = '.btn-reveal-pw, .pw-reveal';

    /**
     * Read the show/hide label for a reveal button, honouring the
     * translation the template already baked in via {lang}.
     *
     * Strategy: each button stores both labels as data attributes so toggling
     * is locale-aware without the i18n carrier element.  The attributes are
     * written by initRevealButton on first visit by deriving them from:
     *   1. aria-label already on the button (the "show" label, from the
     *      template's {lang} output — already correctly translated)
     *   2. data-label-show / data-label-hide set externally, if present
     *   3. The i18n carrier element (present on pages with tablelist.tpl)
     *   4. English fallback
     */
    function _getShowLabel(btn) {
        return btn.getAttribute('data-label-show') ||
               _i18n('showpassword', 'Show password');
    }
    function _getHideLabel(btn) {
        return btn.getAttribute('data-label-hide') ||
               _i18n('hidepassword', 'Hide password');
    }
    function _revealLabel(btn, isVisible) {
        return isVisible ? _getHideLabel(btn) : _getShowLabel(btn);
    }

    /**
     * Initialise one reveal button. Idempotent: only sets attributes that
     * are missing or need correction relative to the input's current state.
     */
    function initRevealButton(btn) {
        /* Ensure type=button so it does not submit forms */
        if (btn.getAttribute('type') !== 'button') {
            btn.setAttribute('type', 'button');
        }

        /* Hide inner icons from AT */
        btn.querySelectorAll('i, svg').forEach(function (icon) {
            icon.setAttribute('aria-hidden', 'true');
        });

        /* Find the controlled password input.
           Priority: aria-controls attr → .pw-input sibling → any
           type=password sibling in the same input-group or form-group. */
        var inputId = btn.getAttribute('aria-controls');
        var input = inputId ? document.getElementById(inputId) : null;
        if (!input) {
            var container = btn.closest('.input-group') ||
                            btn.closest('.form-group') ||
                            btn.parentElement;
            if (container) {
                input = container.querySelector('.pw-input') ||
                        container.querySelector('input[type="password"]') ||
                        container.querySelector('input[type="text"].pw-input');
            }
        }
        if (!input) { return; } /* no target — skip */

        /* Ensure the input has an id so aria-controls can reference it */
        if (!input.getAttribute('id')) {
            input.setAttribute('id', 'a11y-pw-' + Math.random().toString(36).slice(2));
        }
        if (!btn.getAttribute('aria-controls')) {
            btn.setAttribute('aria-controls', input.getAttribute('id'));
        }

        /* Capture the show-label from the existing aria-label (set by the
           template via {lang} in the correct locale) before we ever change it.
           Store both labels on the button so toggle stays locale-correct. */
        if (!btn.getAttribute('data-label-show')) {
            /* If the button has an aria-label already, treat it as the show
               label (all templates start hidden / aria-pressed=false). */
            var existingLabel = btn.getAttribute('aria-label');
            if (existingLabel) {
                btn.setAttribute('data-label-show', existingLabel);
            } else {
                btn.setAttribute('data-label-show', _i18n('showpassword', 'Show password'));
            }
        }
        if (!btn.getAttribute('data-label-hide')) {
            btn.setAttribute('data-label-hide', _i18n('hidepassword', 'Hide password'));
        }

        /* Derive current visibility from input type */
        var isVisible = input.getAttribute('type') === 'text';

        /* aria-pressed: set only if wrong or missing */
        var wantedPressed = isVisible ? 'true' : 'false';
        if (btn.getAttribute('aria-pressed') !== wantedPressed) {
            btn.setAttribute('aria-pressed', wantedPressed);
        }

        /* aria-label: set the correct label for the current state.
           If the button was already showing the right label (e.g. set by
           the template), this is a no-op. */
        var wantedLabel = _revealLabel(btn, isVisible);
        if (!btn.getAttribute('aria-label') || btn.getAttribute('aria-label') !== wantedLabel) {
            btn.setAttribute('aria-label', wantedLabel);
        }
    }

    /** Initialise all reveal buttons currently in the DOM. */
    function initAllRevealButtons() {
        document.querySelectorAll(_revealSel).forEach(initRevealButton);
    }

    /* Reveal button click handling.
     *
     * The parent theme's whmcs.js also has a jQuery delegated handler for
     * .btn-reveal-pw that toggles the input type. jQuery's delegated handlers
     * on document fire BEFORE native document.addEventListener handlers when
     * jQuery is loaded before our script.
     *
     * Strategy:
     *  1. Use a capturing listener (capture:true) to record the PRE-click type
     *     before ANY handler (jQuery or native) runs. Capturing fires during
     *     the down-propagation phase, before bubbling handlers on document.
     *  2. Use a bubbling listener (our main handler) to schedule a setTimeout(0)
     *     that runs after all synchronous handlers. In the timeout we check if
     *     the type changed; if not (no parent handler on this page) we toggle
     *     it ourselves. Then sync ARIA either way.
     */

    /* Storing per-button pre-click types using the button element as key */
    var _revealPreTypes = typeof WeakMap !== 'undefined' ? new WeakMap() : null;

    /* Capturing phase: record type BEFORE any handler changes it */
    document.addEventListener('click', function (e) {
        var btn = e.target.closest ? e.target.closest(_revealSel) : null;
        if (!btn) { return; }

        var inputId = btn.getAttribute('aria-controls');
        var input = inputId ? document.getElementById(inputId) : null;
        if (!input) {
            var c = btn.closest('.input-group') || btn.closest('.form-group') || btn.parentElement;
            if (c) {
                input = c.querySelector('.pw-input') ||
                        c.querySelector('input[type="password"]') ||
                        c.querySelector('input[type="text"].pw-input');
            }
        }
        if (!input) { return; }

        /* Store pre-click type */
        if (_revealPreTypes) {
            _revealPreTypes.set(btn, input.getAttribute('type'));
        } else {
            btn.__a11yRevealPreType = input.getAttribute('type');
        }
    }, true); /* ← capture: true — fires before any bubbling handler */

    /* Bubbling phase: sync ARIA after all handlers (jQuery etc.) have run */
    document.addEventListener('click', function (e) {
        var btn = e.target.closest ? e.target.closest(_revealSel) : null;
        if (!btn) { return; }

        var inputId = btn.getAttribute('aria-controls');
        var input = inputId ? document.getElementById(inputId) : null;
        if (!input) {
            var c2 = btn.closest('.input-group') || btn.closest('.form-group') || btn.parentElement;
            if (c2) {
                input = c2.querySelector('.pw-input') ||
                        c2.querySelector('input[type="password"]') ||
                        c2.querySelector('input[type="text"].pw-input');
            }
        }
        if (!input) { return; }

        var capturedBtn   = btn;
        var capturedInput = input;
        var preType = _revealPreTypes
            ? (_revealPreTypes.get(btn) || capturedInput.getAttribute('type'))
            : (btn.__a11yRevealPreType || capturedInput.getAttribute('type'));

        /* After all synchronous handlers, sync ARIA */
        setTimeout(function () {
            var postType = capturedInput.getAttribute('type');

            /* If no other handler changed the type, toggle it ourselves */
            if (postType === preType) {
                postType = (preType === 'password') ? 'text' : 'password';
                capturedInput.setAttribute('type', postType);
            }

            /* Sync ARIA to final state */
            var nowVisible = postType === 'text';
            capturedBtn.setAttribute('aria-pressed', nowVisible ? 'true' : 'false');
            capturedBtn.setAttribute('aria-label', _revealLabel(capturedBtn, nowVisible));
        }, 0);
    }); /* bubbling — fires after jQuery's delegated handlers */

    /* Run init on DOMContentLoaded (or immediately if DOM is already ready) */
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initAllRevealButtons);
    } else {
        initAllRevealButtons();
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

    /* ------------------------------------------------------------------ */
    /* Bootstrap Tabs a11y helper                                          */
    /*                                                                     */
    /* Bootstrap 4 sets role="tablist/tab/tabpanel" inconsistently and    */
    /* does not reliably maintain aria-selected, aria-controls, or        */
    /* aria-labelledby. It also has no arrow-key navigation.              */
    /*                                                                     */
    /* This helper, run on DOMContentLoaded + Bootstrap shown.bs.tab:     */
    /*  - sets role="tablist" on each <ul class="nav-tabs">               */
    /*  - sets role="tab", aria-selected, aria-controls on each tab link  */
    /*  - sets role="tabpanel", aria-labelledby, tabindex="0" on panels   */
    /*  - adds Left/Right arrow-key navigation (ARIA tabs pattern)        */
    /* All fixes are idempotent; only sets what is missing or stale.      */
    /* ------------------------------------------------------------------ */

    /**
     * Wire up one .nav-tabs widget: roles, aria attributes, arrow-key nav.
     * @param {Element} tablist  The <ul class="nav-tabs"> element.
     */
    function initTabWidget(tablist) {
        /* Idempotency guard — mark once fully processed */
        if (tablist.__a11yTabsInited) { return; }
        tablist.__a11yTabsInited = true;

        /* role=tablist on the <ul> */
        if (!tablist.getAttribute('role')) {
            tablist.setAttribute('role', 'tablist');
        }

        /* Collect all tab links inside this widget */
        var links = Array.prototype.slice.call(
            tablist.querySelectorAll('.nav-link, .nav-item > a[data-toggle="tab"], a.tabControlLink[data-toggle="tab"]')
        );
        if (!links.length) { return; }

        links.forEach(function (link) {
            /* role=tab */
            if (!link.getAttribute('role')) {
                link.setAttribute('role', 'tab');
            }

            /* The Bootstrap 4 structure is: <ul role=tablist> <li class=nav-item>
               <a role=tab>. For the tablist → tab ownership constraint to be met,
               the <li> wrapper must be removed from the a11y tree with
               role=presentation (standard Bootstrap tabs pattern). */
            var li = link.parentElement;
            if (li && li.tagName === 'LI') {
                if (!li.getAttribute('role')) {
                    li.setAttribute('role', 'presentation');
                }
            }

            /* Resolve the panel target: href="#id" or data-target="#id" */
            var panelId = null;
            var href = link.getAttribute('href') || '';
            if (href.charAt(0) === '#') {
                panelId = href.slice(1);
            }
            if (!panelId) {
                var dt = link.getAttribute('data-target') || '';
                if (dt.charAt(0) === '#') { panelId = dt.slice(1); }
            }

            /* aria-controls → panel id */
            if (panelId && !link.getAttribute('aria-controls')) {
                link.setAttribute('aria-controls', panelId);
            }

            /* aria-selected: active class → true, else false */
            var isActive = link.classList.contains('active');
            link.setAttribute('aria-selected', isActive ? 'true' : 'false');

            /* tabindex: only the active tab is in the natural tab order;  */
            /* inactive tabs are reachable only via arrow keys.            */
            link.setAttribute('tabindex', isActive ? '0' : '-1');

            /* Find the controlled panel */
            if (panelId) {
                var panel = document.getElementById(panelId);
                if (panel) {
                    /* role=tabpanel */
                    if (!panel.getAttribute('role')) {
                        panel.setAttribute('role', 'tabpanel');
                    }

                    /* Ensure panel has an id so aria-labelledby can point back */
                    /* Give the link an id if it doesn't have one already */
                    if (!link.getAttribute('id')) {
                        link.setAttribute('id', 'a11y-tab-' + panelId);
                    }

                    /* aria-labelledby → the tab link */
                    if (!panel.getAttribute('aria-labelledby')) {
                        panel.setAttribute('aria-labelledby', link.getAttribute('id'));
                    }

                    /* tabindex=0 so keyboard users can tab into the panel */
                    if (!panel.getAttribute('tabindex')) {
                        panel.setAttribute('tabindex', '0');
                    }
                }
            }
        });

        /* Arrow-key navigation per ARIA Authoring Practices (roving tabindex) */
        tablist.addEventListener('keydown', function (e) {
            var key = e.key || e.keyCode;
            var isLeft  = (key === 'ArrowLeft'  || key === 37);
            var isRight = (key === 'ArrowRight' || key === 39);
            var isHome  = (key === 'Home'       || key === 36);
            var isEnd   = (key === 'End'        || key === 35);

            if (!isLeft && !isRight && !isHome && !isEnd) { return; }

            /* Re-query links at event time (DOM may have changed) */
            var allLinks = Array.prototype.slice.call(
                tablist.querySelectorAll('[role="tab"]:not([disabled])')
            );
            if (!allLinks.length) { return; }

            var focused = document.activeElement;
            var idx = allLinks.indexOf(focused);
            if (idx === -1) { return; }

            var nextIdx;
            if (isLeft)  { nextIdx = (idx - 1 + allLinks.length) % allLinks.length; }
            if (isRight) { nextIdx = (idx + 1) % allLinks.length; }
            if (isHome)  { nextIdx = 0; }
            if (isEnd)   { nextIdx = allLinks.length - 1; }

            e.preventDefault();

            var nextLink = allLinks[nextIdx];

            /* Move focus + activate (ARIA tabs pattern: arrow activates) */
            nextLink.focus();
            /* If Bootstrap 4 is loaded, trigger the tab show via jQuery/BS */
            /* so the panel actually switches, then sync ARIA.              */
            if (typeof jQuery !== 'undefined' && jQuery.fn.tab) {
                jQuery(nextLink).tab('show');
            } else {
                nextLink.click();
            }
        });
    }

    /**
     * Sync aria-selected and tabindex on all tab links after Bootstrap
     * activates a new tab (shown.bs.tab event).
     * @param {Element} tablist
     */
    function syncTabAriaSelected(tablist) {
        var links = Array.prototype.slice.call(
            tablist.querySelectorAll('[role="tab"]')
        );
        links.forEach(function (link) {
            var isActive = link.classList.contains('active');
            link.setAttribute('aria-selected', isActive ? 'true' : 'false');
            link.setAttribute('tabindex', isActive ? '0' : '-1');
        });
    }

    /**
     * Patch any pre-existing role="tabpanel" elements that the WHMCS template
     * already stamped in HTML but did not fully wire up (missing tabindex,
     * aria-labelledby). We scan all tab links across the whole page (not just
     * inside .nav-tabs) to find which link controls each panel.
     */
    function fixTemplateTabPanels() {
        document.querySelectorAll('[role="tabpanel"]').forEach(function (panel) {
            /* tabindex=0 */
            if (!panel.getAttribute('tabindex')) {
                panel.setAttribute('tabindex', '0');
            }

            /* aria-labelledby — find a link that points to this panel */
            if (!panel.getAttribute('aria-labelledby')) {
                var panelId = panel.getAttribute('id');
                if (!panelId) { return; }
                /* Look for a link with href="#<id>" or data-target="#<id>"
                   anywhere in the document */
                var link = document.querySelector(
                    '[href="#' + panelId + '"][data-toggle="tab"], ' +
                    '[data-target="#' + panelId + '"][data-toggle="tab"], ' +
                    '[href="#' + panelId + '"].nav-link, ' +
                    '[href="#' + panelId + '"].tabControlLink'
                );
                if (!link) { return; }

                /* Ensure the link has an id */
                if (!link.getAttribute('id')) {
                    link.setAttribute('id', 'a11y-tab-' + panelId);
                }
                panel.setAttribute('aria-labelledby', link.getAttribute('id'));

                /* Also ensure the link has role=tab */
                if (!link.getAttribute('role')) {
                    link.setAttribute('role', 'tab');
                }
            }
        });
    }

    /** Init or re-sync all .nav-tabs widgets in the document. */
    function initAllTabWidgets() {
        document.querySelectorAll('ul.nav-tabs, ol.nav-tabs').forEach(function (tablist) {
            initTabWidget(tablist);
            /* Re-sync selected state on each call (handles page where active */
            /* tab may vary by server-side condition)                         */
            syncTabAriaSelected(tablist);
        });
        /* Also patch any panels the template already marked with role=tabpanel */
        fixTemplateTabPanels();
    }

    /* Run on DOM ready */
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initAllTabWidgets);
    } else {
        initAllTabWidgets();
    }

    /* Sync aria-selected whenever Bootstrap activates a new tab */
    if (typeof jQuery !== 'undefined') {
        jQuery(document).on('shown.bs.tab', function (e) {
            var link = e.target; /* newly activated tab link */
            var tablist = link ? link.closest('ul.nav-tabs, ol.nav-tabs') : null;
            if (tablist) {
                syncTabAriaSelected(tablist);
            }
        });
    }

    /* ------------------------------------------------------------------ */
    /* Status badges a11y                                                  */
    /*                                                                     */
    /* WHMCS status badges use .label / .badge + modifier classes for     */
    /* colour coding. Most already carry visible text. This helper         */
    /* ensures any icon-only or genuinely empty badge is supplemented      */
    /* with a visually-hidden text label derived from its class name.     */
    /*                                                                     */
    /* Scope: defensive / global. Pages still needing per-page deep work: */
    /*   WS-D — productdetails: status badges for hosting account state   */
    /*           (Active/Suspended/Terminated) and SSL status badges       */
    /*   WS-E — domaindetails: registration status, WHOIS privacy         */
    /*   WS-E — clientareadomains list: bulk status colour coding          */
    /* Those pages use dynamic/AJAX-driven status text; per-page work      */
    /* is deferred to their respective workstreams.                        */
    /* ------------------------------------------------------------------ */

    /**
     * Map from badge modifier class → readable status text.
     * Covers the Bootstrap + WHMCS label-* / status-* vocabulary.
     */
    var _badgeClassMap = {
        'label-success':  'Active',
        'label-danger':   'Error',
        'label-warning':  'Warning',
        'label-info':     'Info',
        'label-default':  'Default',
        'label-primary':  'Primary',
        'badge-success':  'Active',
        'badge-danger':   'Error',
        'badge-warning':  'Warning',
        'badge-info':     'Info',
        'status-active':      'Active',
        'status-suspended':   'Suspended',
        'status-terminated':  'Terminated',
        'status-cancelled':   'Cancelled',
        'status-fraud':       'Fraud',
        'status-pending':     'Pending',
        'status-expired':     'Expired',
        'status-grace':       'Grace Period',
        'status-redemption':  'Redemption',
        'status-transferred': 'Transferred Away',
        'status-deleted':     'Deleted'
    };

    function fixStatusBadges() {
        var sel = '.label, .badge, [class*="status-"]';
        document.querySelectorAll(sel).forEach(function (badge) {
            /* Skip if already processed */
            if (badge.__a11yBadgeFixed) { return; }
            badge.__a11yBadgeFixed = true;

            /* If badge already has non-whitespace visible text, it's fine */
            /* Clone and strip sr-only elements to get true visible text */
            var clone = badge.cloneNode(true);
            clone.querySelectorAll('.sr-only').forEach(function (el) { el.parentNode.removeChild(el); });
            /* Also strip icon elements */
            clone.querySelectorAll('i, svg, img').forEach(function (el) { el.parentNode.removeChild(el); });
            var visibleText = clone.textContent.replace(/\s+/g, ' ').trim();

            if (visibleText) {
                /* Has visible text — ensure icons are aria-hidden */
                badge.querySelectorAll('i, svg').forEach(function (icon) {
                    icon.setAttribute('aria-hidden', 'true');
                });
                return;
            }

            /* Icon-only or empty badge: try to derive text from class */
            var classes = Array.prototype.slice.call(badge.classList);
            var derivedText = null;
            for (var c = 0; c < classes.length; c++) {
                if (_badgeClassMap[classes[c]]) {
                    derivedText = _badgeClassMap[classes[c]];
                    break;
                }
            }

            if (derivedText) {
                var srSpan = document.createElement('span');
                srSpan.className = 'sr-only';
                srSpan.textContent = derivedText;
                badge.appendChild(srSpan);
            }

            /* Always hide inner icons from AT */
            badge.querySelectorAll('i, svg').forEach(function (icon) {
                icon.setAttribute('aria-hidden', 'true');
            });
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', fixStatusBadges);
    } else {
        fixStatusBadges();
    }

    /* ------------------------------------------------------------------ */
    /* Copy-to-clipboard a11y                                              */
    /*                                                                     */
    /* WHMCS uses buttons with data-clipboard-target="<selector>" and     */
    /* class "copy-to-clipboard". The parent's WHMCS.ui.clipboard().copy  */
    /* handler fires on click. We:                                         */
    /*  1. Ensure each copy button has aria-label (from i18n carrier).    */
    /*  2. Ensure inner icons are aria-hidden.                             */
    /*  3. On click (after the copy succeeds), inject a visually-hidden   */
    /*     aria-live="polite" "Copied" announcement and return focus.      */
    /*  4. One shared live-region is lazily created in <body>.            */
    /* ------------------------------------------------------------------ */

    var _copyLiveRegion = null;

    function _getCopyLiveRegion() {
        if (!_copyLiveRegion) {
            _copyLiveRegion = document.createElement('div');
            _copyLiveRegion.setAttribute('aria-live', 'polite');
            _copyLiveRegion.setAttribute('aria-atomic', 'true');
            /* sr-only positioning */
            _copyLiveRegion.style.cssText = [
                'position:absolute',
                'width:1px',
                'height:1px',
                'padding:0',
                'margin:-1px',
                'overflow:hidden',
                'clip:rect(0,0,0,0)',
                'white-space:nowrap',
                'border:0'
            ].join(';');
            document.body.appendChild(_copyLiveRegion);
        }
        return _copyLiveRegion;
    }

    /** Selector covering all WHMCS copy-button patterns */
    var _copySel = '[data-clipboard-target], [data-clipboard-text], .copy-to-clipboard';

    function initCopyButton(btn) {
        if (btn.__a11yCopyInited) { return; }
        btn.__a11yCopyInited = true;

        /* Ensure type=button */
        if (btn.tagName === 'BUTTON' && !btn.getAttribute('type')) {
            btn.setAttribute('type', 'button');
        }

        /* aria-label — use carrier key, falling back to English */
        if (!btn.getAttribute('aria-label')) {
            btn.setAttribute('aria-label', _i18n('copytoclipboard', 'Copy to clipboard'));
        }

        /* aria-hidden on inner icons */
        btn.querySelectorAll('i, svg, img').forEach(function (icon) {
            icon.setAttribute('aria-hidden', 'true');
        });
    }

    function initAllCopyButtons() {
        document.querySelectorAll(_copySel).forEach(initCopyButton);
    }

    /* Announce on click — bubbling, after WHMCS handler has run */
    document.addEventListener('click', function (e) {
        var btn = e.target.closest ? e.target.closest(_copySel) : null;
        if (!btn) { return; }

        /* Defer so the native copy + WHMCS tooltip logic runs first */
        setTimeout(function () {
            var region = _getCopyLiveRegion();
            /* Clear then set (ensures re-announcement even for identical text) */
            region.textContent = '';
            /* Use rAF to ensure the DOM mutation is flushed before setting text */
            requestAnimationFrame(function () {
                region.textContent = _i18n('copied', 'Copied');
            });
            /* Return focus to the trigger */
            if (btn && typeof btn.focus === 'function') {
                btn.focus();
            }
        }, 100);
    });

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initAllCopyButtons);
    } else {
        initAllCopyButtons();
    }

    /* ------------------------------------------------------------------ */
    /* Spinner / loading aria-busy                                         */
    /*                                                                     */
    /* Buttons with .spinner-on-click or .disable-on-click receive        */
    /* aria-busy="true" when clicked, signalling that an async operation  */
    /* is in progress. This supplements the visual spinner shown by the   */
    /* parent theme.                                                       */
    /*                                                                     */
    /* For full-page-reload actions (form POST), aria-busy persists on    */
    /* the old page naturally (new page loads). For AJAX-only operations, */
    /* we clear aria-busy when the AJAX completes via ajaxComplete.       */
    /* ------------------------------------------------------------------ */

    var _spinnerSel = '.spinner-on-click, .disable-on-click';

    document.addEventListener('click', function (e) {
        var btn = e.target.closest ? e.target.closest(_spinnerSel) : null;
        if (!btn) { return; }
        /* Only set on buttons / submit inputs */
        if (btn.tagName !== 'BUTTON' && btn.tagName !== 'INPUT' && btn.getAttribute('role') !== 'button') {
            return;
        }
        /* Mark this button so we can clear aria-busy on ajaxComplete.
           Use data-a11y-busy flag to track elements we set aria-busy on. */
        btn.setAttribute('data-a11y-busy', 'true');
        /* Set aria-busy immediately (synchronously, before submit) */
        btn.setAttribute('aria-busy', 'true');
    }, true); /* capture: true to fire before default form submission */

    /* Clear aria-busy when AJAX operations complete, for buttons marked
       with data-a11y-busy (preventing stale aria-busy on AJAX-only actions).
       Only if jQuery is available (WHMCS uses jQuery for AJAX). */
    if (typeof jQuery !== 'undefined') {
        jQuery(document).on('ajaxComplete', function () {
            /* Find all elements currently carrying our flag and clear aria-busy */
            document.querySelectorAll('[data-a11y-busy="true"]').forEach(function (elem) {
                elem.removeAttribute('aria-busy');
                elem.removeAttribute('data-a11y-busy');
            });
        });
    }

    /* ------------------------------------------------------------------ */
    /* Global decorative-icon hiding                                       */
    /*                                                                     */
    /* FontAwesome glyphs are decorative by default. WHMCS templates emit  */
    /* many <i>/<span> FA icons WITHOUT aria-hidden, so screen readers     */
    /* announce the glyph ("?", PUA chars) before the link/button text     */
    /* ("1 ? services"). This pass sets aria-hidden="true" on every FA     */
    /* icon element that does not already have it.                         */
    /*                                                                     */
    /* SAFETY: An icon that is the SOLE accessible name of a control must  */
    /* NOT be hidden until that control carries its own label. All such    */
    /* header controls (switcher, cart, hamburger, notifications,          */
    /* return-to-admin) were given explicit aria-label in header.tpl, so   */
    /* hiding their icons here is safe. As an extra guard we skip an icon   */
    /* whose nearest control ancestor has no other accessible text AND no  */
    /* aria-label/aria-labelledby/title — leaving such an icon visible to  */
    /* AT rather than producing an unlabelled control.                     */
    /* Idempotent: only touches icons missing aria-hidden.                 */
    /* ------------------------------------------------------------------ */

    var _faIconSel = 'i[class*="fa-"], span[class*="fa-"], ' +
        'i.fa, i.fas, i.far, i.fad, i.fal, i.fab, ' +
        'span.fa, span.fas, span.far, span.fad, span.fal, span.fab';

    function _isFaIcon(el) {
        if (!el || !el.classList) { return false; }
        var cl = el.classList;
        if (cl.contains('fa') || cl.contains('fas') || cl.contains('far') ||
            cl.contains('fad') || cl.contains('fal') || cl.contains('fab')) {
            return true;
        }
        for (var i = 0; i < cl.length; i++) {
            if (cl[i].indexOf('fa-') === 0) { return true; }
        }
        return false;
    }

    /* Does the control have an accessible name independent of this icon? */
    function _controlHasOwnName(control, icon) {
        if (!control) { return true; } /* not inside a control — always safe */
        if (control.getAttribute('aria-label') ||
            control.getAttribute('aria-labelledby') ||
            control.getAttribute('title')) {
            return true;
        }
        /* Clone, drop the candidate icon (and any sibling icons) + sr-only-less
           check: does visible/sr-only text remain? */
        var clone = control.cloneNode(true);
        clone.querySelectorAll('i, svg').forEach(function (el) {
            el.parentNode.removeChild(el);
        });
        var txt = (clone.textContent || '').replace(/\s+/g, ' ').trim();
        return txt.length > 0;
    }

    function hideDecorativeIcons(root) {
        var scope = root || document;
        var icons = scope.querySelectorAll(_faIconSel);
        Array.prototype.forEach.call(icons, function (icon) {
            if (!_isFaIcon(icon)) { return; }
            if (icon.getAttribute('aria-hidden') === 'true') { return; }
            /* If the icon carries its own explicit accessible name, respect it. */
            if (icon.getAttribute('aria-label') ||
                icon.getAttribute('aria-labelledby') ||
                icon.getAttribute('role') === 'img') {
                return;
            }
            var control = icon.closest('a, button, [role="button"], label, summary');
            if (control && !_controlHasOwnName(control, icon)) {
                /* Icon is the only name source for an unlabelled control —
                   don't hide it, or the control becomes nameless. */
                return;
            }
            icon.setAttribute('aria-hidden', 'true');
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function () { hideDecorativeIcons(); });
    } else {
        hideDecorativeIcons();
    }
    /* Re-run after AJAX content swaps (sidebar refresh, alerts, etc.) */
    if (typeof jQuery !== 'undefined') {
        jQuery(document).on('ajaxComplete', function () { hideDecorativeIcons(); });
    }

    /* ------------------------------------------------------------------ */
    /* Account-notifications popover: aria-expanded sync + focus mgmt      */
    /*                                                                     */
    /* The button (#accountNotifications) opens a Bootstrap popover whose  */
    /* content is #accountNotificationsContent (role=dialog, tabindex=-1   */
    /* in header.tpl). We:                                                 */
    /*  - sync aria-expanded on the button with shown/hidden.bs.popover    */
    /*  - move focus into the popover on open (first link, else the        */
    /*    dialog container)                                                */
    /*  - Esc closes the popover and returns focus to the button          */
    /* ------------------------------------------------------------------ */

    function initNotificationsPopover() {
        var btn = document.getElementById('accountNotifications');
        if (!btn || btn.__a11yNotifBound) { return; }
        if (typeof jQuery === 'undefined') { return; }
        btn.__a11yNotifBound = true;

        var $btn = jQuery(btn);

        $btn.on('shown.bs.popover', function () {
            btn.setAttribute('aria-expanded', 'true');
            /* Bootstrap clones the content into the live popover. Focus the
               first focusable element inside it, else the popover container. */
            var tip = $btn.data('bs.popover');
            var tipEl = tip && tip.tip ? tip.tip : document.querySelector('.popover.show, .popover.in');
            if (!tipEl) { return; }
            tipEl.setAttribute('role', 'dialog');
            tipEl.setAttribute('aria-label', btn.getAttribute('aria-label') || '');
            var focusTarget = tipEl.querySelector('a[href], button, [tabindex]');
            if (!focusTarget) {
                tipEl.setAttribute('tabindex', '-1');
                focusTarget = tipEl;
            }
            if (focusTarget && typeof focusTarget.focus === 'function') {
                focusTarget.focus();
            }
        });

        $btn.on('hidden.bs.popover', function () {
            btn.setAttribute('aria-expanded', 'false');
        });

        /* Esc within the popover closes it and returns focus to the button. */
        document.addEventListener('keydown', function (e) {
            if (e.key !== 'Escape' && e.keyCode !== 27) { return; }
            if (btn.getAttribute('aria-expanded') !== 'true') { return; }
            var active = document.activeElement;
            var inPopover = active && active.closest && active.closest('.popover');
            if (inPopover || active === btn) {
                $btn.popover('hide');
                btn.focus();
            }
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initNotificationsPopover);
    } else {
        initNotificationsPopover();
    }

    /* ------------------------------------------------------------------ */
    /* Collapse toggles: aria-expanded sync (hamburger / mobile nav)       */
    /*                                                                     */
    /* Bootstrap 4's collapse plugin updates aria-expanded automatically   */
    /* only when the toggle's data-target/href resolves cleanly; the       */
    /* twenty-one hamburger uses data-target and starts with no            */
    /* aria-expanded. We keep every collapse toggle's aria-expanded in     */
    /* sync with the actual show/hide state via the bs.collapse events.    */
    /* ------------------------------------------------------------------ */

    function _togglesFor(collapseEl) {
        var id = collapseEl.id;
        var sel = [];
        if (id) {
            sel.push('[data-target="#' + id + '"]');
            sel.push('[href="#' + id + '"]');
            sel.push('[aria-controls="' + id + '"]');
        }
        if (!sel.length) { return []; }
        return Array.prototype.slice.call(document.querySelectorAll(sel.join(',')));
    }

    if (typeof jQuery !== 'undefined') {
        jQuery(document).on('shown.bs.collapse', function (e) {
            _togglesFor(e.target).forEach(function (t) {
                t.setAttribute('aria-expanded', 'true');
            });
        });
        jQuery(document).on('hidden.bs.collapse', function (e) {
            _togglesFor(e.target).forEach(function (t) {
                t.setAttribute('aria-expanded', 'false');
            });
        });
    }

    /* ------------------------------------------------------------------ */
    /* Development-license notice: give it a labelled region context.      */
    /*                                                                     */
    /* WHMCS core injects a yellow "Dev License" banner as the FIRST child */
    /* of .primary-content (no id/class — inline styles only), landing     */
    /* between the sidebar/nav and the page heading where a screen-reader  */
    /* user hears orphan license text mid-navigation. It is NOT in any     */
    /* template we override, so we cannot remove or relocate it cleanly;   */
    /* the least-invasive accessibility fix is to wrap it in a named       */
    /* region (role=region + aria-label) so AT announces it as a distinct, */
    /* skippable landmark rather than stray text. Idempotent.              */
    /* ------------------------------------------------------------------ */

    function labelDevLicenseNotice() {
        var candidates = document.querySelectorAll('.primary-content > div, #main-body > .container > div');
        Array.prototype.forEach.call(candidates, function (div) {
            if (div.__a11yLicenseWrapped) { return; }
            if (div.getAttribute('role') === 'region') { return; }
            var txt = (div.textContent || '');
            /* Match WHMCS' core dev-license wording (locale-independent token). */
            if (!/Development License|Dev License/i.test(txt)) { return; }
            /* Only treat the compact banner, not large content blocks. */
            if (txt.length > 400) { return; }
            div.__a11yLicenseWrapped = true;
            div.setAttribute('role', 'region');
            div.setAttribute('aria-label', _i18n('devlicensenotice', 'Development license notice'));
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', labelDevLicenseNotice);
    } else {
        labelDevLicenseNotice();
    }

}());
