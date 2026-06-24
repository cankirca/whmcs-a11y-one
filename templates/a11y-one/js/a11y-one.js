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

    /* Interactive elements that may legally carry aria-label. */
    var _interactiveTags = { BUTTON: 1, A: 1, INPUT: 1, SELECT: 1, TEXTAREA: 1 };

    function fixCardMinimiseButtons() {
        document.querySelectorAll('.card-minimise').forEach(function (btn) {
            /* If the element is a non-interactive tag (e.g. <i>) and has no
               explicit role, promote it to role=button so aria-label is
               permitted and it is keyboard-reachable. */
            var tag = btn.tagName;
            if (!_interactiveTags[tag] && !btn.getAttribute('role')) {
                btn.setAttribute('role', 'button');
                if (!btn.getAttribute('tabindex')) {
                    btn.setAttribute('tabindex', '0');
                }
            }
            /* Hide any nested icon from AT (the button name carries the label). */
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
                var titleEl = header.querySelector('.card-title, .panel-title');
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
            /* Relocate this dev-only banner out of the content reading order to
               the end of the page (just before the footer), so it no longer
               interrupts navigation between the menu and the page heading.
               (It only appears on unlicensed/dev installs, never for end users.) */
            var footer = document.getElementById('footer');
            if (footer && footer.parentNode) {
                footer.parentNode.insertBefore(div, footer);
            }
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', labelDevLicenseNotice);
    } else {
        labelDevLicenseNotice();
    }

    /* ================================================================== */
    /* WS-F: Support ticket submit flow                                    */
    /* ================================================================== */

    /* ------------------------------------------------------------------ */
    /* Markdown editor (bootstrap-markdown widget)                         */
    /*                                                                      */
    /* The parent twenty-one theme enhances every <textarea.markdown-editor> */
    /* with the bootstrap-markdown plugin (jQuery.fn.markdown). It builds:  */
    /*   .md-editor                                                          */
    /*     .md-header.btn-toolbar                                            */
    /*       .btn-group > <button type=button data-handler="...-cmdXxx">    */
    /*                       <span class="fa..."></span></button>           */
    /*       .md-controls > a.md-control-fullscreen                          */
    /*     textarea.md-input                                                 */
    /*     .md-footer (custom status footer #...-footer)                     */
    /*                                                                      */
    /* The library sets only an English `title` on each button (and the     */
    /* visible text is a stray space), so the buttons have an empty/poor     */
    /* accessible name and the inner icon <span> is exposed. We patch the    */
    /* widget AFTER it builds (without forking the plugin):                  */
    /*   - localised aria-label + title per button (mapped by cmd handler)   */
    /*   - inner icon span aria-hidden                                       */
    /*   - the preview toggle gets aria-pressed reflecting its state         */
    /*   - the textarea (.md-input) gets a localised aria-label              */
    /*   - the status footer (.md-footer) becomes aria-live="polite"         */
    /* We use a MutationObserver because the widget builds asynchronously    */
    /* after the parent's document-ready runs.                              */
    /* ------------------------------------------------------------------ */

    /* Map the cmd* handler suffix → i18n carrier key + English fallback. */
    var _mdeButtonMap = {
        cmdBold:    ['mdebold', 'Bold'],
        cmdItalic:  ['mdeitalic', 'Italic'],
        cmdHeading: ['mdeheading', 'Heading'],
        cmdUrl:     ['mdeurl', 'Insert link'],
        cmdImage:   ['mdeimage', 'Insert image'],
        cmdList:    ['mdelist', 'Bulleted list'],
        cmdListO:   ['mdelisto', 'Numbered list'],
        cmdCode:    ['mdecode', 'Code'],
        cmdQuote:   ['mdequote', 'Quote'],
        cmdPreview: ['mdepreview', 'Toggle preview'],
        cmdHelp:    ['mdehelp', 'Markdown formatting help']
    };

    function _mdeHandlerSuffix(btn) {
        var h = btn.getAttribute('data-handler') || '';
        var m = h.match(/(cmd[A-Za-z]+)$/);
        return m ? m[1] : null;
    }

    function enhanceMarkdownEditor(editor) {
        if (!editor || editor.__a11yMdeDone) { return; }
        editor.__a11yMdeDone = true;

        /* Toolbar buttons */
        var buttons = editor.querySelectorAll('.md-header button[data-handler]');
        Array.prototype.forEach.call(buttons, function (btn) {
            var suffix = _mdeHandlerSuffix(btn);
            var entry = suffix && _mdeButtonMap[suffix];
            if (entry) {
                var label = _i18n(entry[0], entry[1]);
                btn.setAttribute('aria-label', label);
                btn.setAttribute('title', label);
            }
            /* The library puts a leading icon span inside the button. */
            btn.querySelectorAll('i, span, svg').forEach(function (icon) {
                if (!icon.hasAttribute('aria-hidden')) {
                    icon.setAttribute('aria-hidden', 'true');
                }
            });
            /* Preview toggle exposes pressed state. */
            if (suffix === 'cmdPreview') {
                if (!btn.hasAttribute('aria-pressed')) {
                    btn.setAttribute('aria-pressed', 'false');
                }
                btn.addEventListener('click', function () {
                    /* The library toggles the .md-preview block on click; read
                       its presence on the next tick to reflect the new state. */
                    setTimeout(function () {
                        var isPreview = editor.querySelector('.md-preview') !== null;
                        btn.setAttribute('aria-pressed', isPreview ? 'true' : 'false');
                    }, 0);
                });
            }
        });

        /* Fullscreen control (an <a>, not a <button>). */
        var fs = editor.querySelector('.md-control-fullscreen');
        if (fs) {
            fs.setAttribute('aria-label', _i18n('mdefullscreen', 'Toggle full screen'));
            fs.setAttribute('title', _i18n('mdefullscreen', 'Toggle full screen'));
            fs.querySelectorAll('i, span, svg').forEach(function (icon) {
                icon.setAttribute('aria-hidden', 'true');
            });
        }

        /* Toolbar container gets a group label. */
        var toolbar = editor.querySelector('.md-header');
        if (toolbar && !toolbar.hasAttribute('role')) {
            toolbar.setAttribute('role', 'toolbar');
            toolbar.setAttribute('aria-label', _i18n('mdetoolbar', 'Text formatting'));
        }

        /* The editing textarea gets an accessible name. Prefer a label
           supplied by the source textarea (data-a11y-mde-label) so the
           string is localised by the template; else use the carrier. */
        var ta = editor.querySelector('textarea.md-input');
        if (ta && !ta.getAttribute('aria-label')) {
            var srcLabel = null;
            /* bootstrap-markdown keeps the original id on the .md-input. */
            if (ta.id) {
                var src = document.getElementById(ta.id);
                if (src) { srcLabel = src.getAttribute('data-a11y-mde-label'); }
            }
            ta.setAttribute('aria-label', srcLabel || _i18n('mdeeditor', 'Message (Markdown editor)'));
        }

        /* Status footer becomes a polite live region. */
        var footer = editor.querySelector('.md-footer, .markdown-editor-status');
        if (footer && !footer.hasAttribute('aria-live')) {
            footer.setAttribute('aria-live', 'polite');
            footer.setAttribute('role', 'status');
        }
    }

    function enhanceAllMarkdownEditors() {
        document.querySelectorAll('.md-editor').forEach(enhanceMarkdownEditor);
    }

    /* The widget builds after the parent's ready handler; observe for it. */
    function watchMarkdownEditors() {
        if (!document.querySelector('.markdown-editor, .md-editor, #fileUploadsContainer')) {
            return; /* not a ticket/markdown page — skip the observer */
        }
        enhanceAllMarkdownEditors();
        if (typeof MutationObserver === 'undefined') { return; }
        var obs = new MutationObserver(function (mutations) {
            var found = false;
            mutations.forEach(function (m) {
                Array.prototype.forEach.call(m.addedNodes, function (n) {
                    if (n.nodeType !== 1) { return; }
                    if (n.classList && n.classList.contains('md-editor')) { found = true; }
                    else if (n.querySelector && n.querySelector('.md-editor')) { found = true; }
                });
            });
            if (found) { enhanceAllMarkdownEditors(); }
        });
        obs.observe(document.body, { childList: true, subtree: true });
        /* Stop observing after a short window — the editor builds on load. */
        setTimeout(function () { obs.disconnect(); enhanceAllMarkdownEditors(); }, 4000);
    }

    /* ------------------------------------------------------------------ */
    /* File upload — accessible "add more" cloning                          */
    /*                                                                      */
    /* The parent binds #btnTicketAttachmentsAdd to append the markup from   */
    /* .file-upload into #fileUploadsContainer. That cloned markup has a     */
    /* <label> with NO `for` and an <input type=file> with NO id, so cloned  */
    /* inputs are unlabelled. We fix this AFTER each add by minting a unique  */
    /* id + matching label `for`, wiring aria-describedby to the accepted-   */
    /* types help text, and announcing the new field via a polite region.    */
    /* We delegate on the button (capturing AFTER the parent's handler ran   */
    /* via a microtask) and also observe the container as a safety net.      */
    /* ------------------------------------------------------------------ */

    var _attachmentSeq = 1; /* #1 is the static first input */

    function _fileAnnounceRegion() {
        var r = document.getElementById('a11yFileUploadStatus');
        if (!r) {
            r = document.createElement('div');
            r.id = 'a11yFileUploadStatus';
            r.className = 'sr-only';
            r.setAttribute('aria-live', 'polite');
            r.setAttribute('role', 'status');
            document.body.appendChild(r);
        }
        return r;
    }

    function fixFileUploadInputs(announce) {
        var container = document.getElementById('fileUploadsContainer');
        if (!container) { return; }
        var fixedAny = false;
        container.querySelectorAll('input[type="file"].custom-file-input').forEach(function (input) {
            if (input.__a11yFileFixed) { return; }
            input.__a11yFileFixed = true;
            _attachmentSeq += 1;
            var id = 'inputAttachment' + _attachmentSeq;
            /* Guard against an id collision. */
            while (document.getElementById(id)) {
                _attachmentSeq += 1;
                id = 'inputAttachment' + _attachmentSeq;
            }
            input.id = id;
            input.setAttribute('aria-describedby', 'attachmentTypesHelp');
            var label = input.parentNode ? input.parentNode.querySelector('.custom-file-label') : null;
            if (label) {
                label.setAttribute('for', id);
                if (!label.textContent.trim()) {
                    label.textContent = _i18n('fileattachment', 'Attachment') + ' ' + _attachmentSeq;
                }
            }
            fixedAny = true;
        });
        if (fixedAny && announce) {
            _fileAnnounceRegion().textContent = _i18n('fileattachmentadded', 'Attachment field added');
        }
    }

    function initFileUploadA11y() {
        var btn = document.getElementById('btnTicketAttachmentsAdd');
        var container = document.getElementById('fileUploadsContainer');
        if (!btn || !container) { return; }

        /* After the parent's click handler appends a new field, fix it. */
        btn.addEventListener('click', function () {
            /* Defer so the parent's delegated jQuery handler runs first. */
            setTimeout(function () { fixFileUploadInputs(true); }, 0);
        });

        /* Safety net: observe the container for appended fields.
           Disconnects after 4 s (consistent with the markdown observer) to
           avoid an unbounded observer living for the page lifetime. The click
           handler above already covers all user-initiated additions. */
        if (typeof MutationObserver !== 'undefined') {
            var obs = new MutationObserver(function () { fixFileUploadInputs(true); });
            obs.observe(container, { childList: true });
            setTimeout(function () { obs.disconnect(); }, 4000);
        }
    }

    /* ------------------------------------------------------------------ */
    /* Custom fields — wire aria-describedby to descriptions                */
    /* The override template renders descriptions with id                   */
    /* customfield{id}_desc; link them to the matching core-generated        */
    /* control by its known id customfield{id} (no fork of $customfield.input). */
    /* ------------------------------------------------------------------ */
    function wireCustomFieldDescriptions() {
        var container = document.getElementById('customFieldsContainer');
        if (!container) { return; }
        container.querySelectorAll('[id$="_desc"]').forEach(function (desc) {
            var baseId = desc.id.replace(/_desc$/, '');
            var control = document.getElementById(baseId);
            if (control && !control.getAttribute('aria-describedby')) {
                control.setAttribute('aria-describedby', desc.id);
            }
        });
    }

    /* ------------------------------------------------------------------ */
    /* KB suggestions polling trigger (moved out of inline <script>)        */
    /* When the compose template renders #a11yKbSuggestTrigger, start the    */
    /* parent's getTicketSuggestions() loop. The #autoAnswerSuggestions      */
    /* container is already a named aria-live region in the template, so the */
    /* AJAX-injected suggestions are announced.                             */
    /* ------------------------------------------------------------------ */
    function initKbSuggestions() {
        if (!document.getElementById('a11yKbSuggestTrigger')) { return; }
        if (typeof window.getTicketSuggestions === 'function') {
            window.getTicketSuggestions();
        }
    }

    /* ------------------------------------------------------------------ */
    /* Ticket star rating — accessible radio group submit                   */
    /*                                                                      */
    /* viewticket.tpl rebuilds the parent's clickable <span rate="N">       */
    /* widget as a <fieldset.rating-fieldset> of native radios. The parent  */
    /* submitted a rating by navigating to                                  */
    /*   viewticket.php?tid={tid}&c={c}&rating=rate{replyid}_{N}            */
    /* (see twenty-one/js/whmcs.js "Ticket Rating Click Handler"). We       */
    /* reproduce that EXACT submit on radio `change`, reading the ticket    */
    /* identifiers carried as data-* on the fieldset. Keyboard users pick a */
    /* star with the arrow keys (native radio behaviour) and the rating     */
    /* posts identically to the original mouse-click flow.                  */
    /* ------------------------------------------------------------------ */
    function initTicketRatingA11y() {
        var groups = document.querySelectorAll('.rating-fieldset[data-ticketreplyid]');
        Array.prototype.forEach.call(groups, function (fs) {
            if (fs.__a11yRatingDone) { return; }
            fs.__a11yRatingDone = true;
            fs.addEventListener('change', function (e) {
                var input = e.target;
                if (!input || input.type !== 'radio' || !input.value) { return; }
                var tid = fs.getAttribute('data-ticketid');
                var key = fs.getAttribute('data-ticketkey');
                var replyId = fs.getAttribute('data-ticketreplyid');
                if (!tid || !key || !replyId) { return; }
                window.location = 'viewticket.php?tid=' + encodeURIComponent(tid)
                    + '&c=' + encodeURIComponent(key)
                    + '&rating=rate' + encodeURIComponent(replyId)
                    + '_' + encodeURIComponent(input.value);
            });
        });
    }

    /* ------------------------------------------------------------------ */
    /* Reply focus management                                               */
    /*                                                                      */
    /* The parent only smooth-scrolls to the reply composer (and, after a   */
    /* post, the browser lands on the reply thread). Scrolling alone moves  */
    /* nothing for keyboard / screen-reader users. We move focus to the     */
    /* target region's heading after the scroll so the next Tab continues   */
    /* from there and AT announces the destination. Targets carry           */
    /* tabindex="-1" in the template so they are programmatically focusable */
    /* without becoming a tab stop.                                         */
    /* ------------------------------------------------------------------ */
    function _focusRegion(target) {
        if (!target) { return; }
        var heading = target.querySelector('h1, h2, h3, .card-title, .reply-heading');
        var focusEl = heading || target;
        if (focusEl !== target && !focusEl.hasAttribute('tabindex')) {
            focusEl.setAttribute('tabindex', '-1');
        }
        /* Defer until the smooth-scroll animation settles. */
        setTimeout(function () {
            try { focusEl.focus({ preventScroll: true }); }
            catch (e) { focusEl.focus(); }
        }, 550);
    }

    function initReplyFocusA11y() {
        /* Buttons that scroll to a region (the "Reply" jump) also focus it. */
        document.querySelectorAll('[data-a11y-scroll-focus]').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var sel = btn.getAttribute('data-a11y-scroll-focus');
                _focusRegion(sel ? document.querySelector(sel) : null);
            });
        });

        /* After a reply is posted, WHMCS reloads the thread; move focus to
           the most recent reply so the new content is announced. Only do
           this when arriving from a reply submit (postreply / a reply hash)
           to avoid stealing focus on a normal page view. */
        var fromReply = /[?&]postreply=/.test(window.location.search)
            || /^#ticketReply\d+$/.test(window.location.hash);
        if (fromReply) {
            var target = null;
            if (window.location.hash && /^#ticketReply\d+$/.test(window.location.hash)) {
                target = document.querySelector(window.location.hash);
            }
            if (!target) {
                var replies = document.querySelectorAll('.ticket-reply-card');
                target = replies.length ? replies[replies.length - 1] : null;
            }
            _focusRegion(target);
        }
    }

    function initTicketSubmitA11y() {
        watchMarkdownEditors();
        initFileUploadA11y();
        wireCustomFieldDescriptions();
        initKbSuggestions();
        initTicketRatingA11y();
        initReplyFocusA11y();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initTicketSubmitA11y);
    } else {
        initTicketSubmitA11y();
    }

    /* ------------------------------------------------------------------ */
    /* KB article — print button progressive enhancement                    */
    /*                                                                      */
    /* knowledgebasearticle.tpl renders a <button class="btn-print-article">*/
    /* with no onclick. We wire window.print() here so no inline script is  */
    /* needed in the template.                                              */
    /* ------------------------------------------------------------------ */
    function initKbPrintButton() {
        var btns = document.querySelectorAll('.btn-print-article');
        Array.prototype.forEach.call(btns, function (btn) {
            if (btn.__a11yPrintWired) { return; }
            btn.__a11yPrintWired = true;
            btn.addEventListener('click', function () {
                window.print();
            });
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initKbPrintButton);
    } else {
        initKbPrintButton();
    }

    /* ------------------------------------------------------------------ */
    /* WS-B: Bootstrap-switch accessibility shim                           */
    /* ------------------------------------------------------------------ */

    /**
     * bootstrapSwitch accessibility shim.
     *
     * bootstrapSwitch visually replaces a native checkbox with a
     * custom widget that has no accessible name or state by default.
     * This function:
     *   1. Ensures the native <input> remains in the a11y tree.
     *   2. Gives the rendered switch wrapper role="switch",
     *      aria-checked, and aria-labelledby from the associated label.
     *   3. Keeps aria-checked in sync on change.
     *
     * @param {Element|Document} [root]
     */
    function initBootstrapSwitchA11y(root) {
        root = root || document;
        root.querySelectorAll('input.toggle-switch-success, input[class*="bootstrap-switch"]').forEach(function (input) {
            input.removeAttribute('aria-hidden');
            if (input.tabIndex < 0) {
                input.tabIndex = 0;
            }

            var wrapper = input.closest('.bootstrap-switch');
            if (!wrapper) {
                /* bootstrapSwitch not yet initialised — annotate raw input */
                if (!input.id) {
                    input.id = 'a11y-switch-' + Math.random().toString(36).slice(2);
                }
                if (!document.querySelector('label[for="' + input.id + '"]')) {
                    var lbl = input.getAttribute('data-label') || input.getAttribute('aria-label') ||
                        (input.nextSibling && input.nextSibling.textContent
                            ? input.nextSibling.textContent.trim() : '');
                    if (lbl) { input.setAttribute('aria-label', lbl); }
                }
                return;
            }

            if (!wrapper.getAttribute('role')) {
                wrapper.setAttribute('role', 'switch');
            }
            wrapper.setAttribute('aria-checked', input.checked ? 'true' : 'false');

            /* Accessible name: explicit label first, then nearest heading */
            if (!wrapper.getAttribute('aria-labelledby') && !wrapper.getAttribute('aria-label')) {
                var labelText = '';
                if (input.id) {
                    var labelEl = document.querySelector('label[for="' + input.id + '"]');
                    if (labelEl) { labelText = labelEl.textContent.trim(); }
                }
                if (!labelText) {
                    var cardBody = input.closest('.card-body');
                    var heading = cardBody && cardBody.querySelector('.card-title');
                    if (heading) { labelText = heading.textContent.trim(); }
                }
                if (labelText) {
                    var labelId = 'a11y-sw-lbl-' + (input.id || Math.random().toString(36).slice(2));
                    if (!document.getElementById(labelId)) {
                        var span = document.createElement('span');
                        span.id = labelId;
                        span.className = 'sr-only';
                        span.textContent = labelText;
                        wrapper.parentNode.insertBefore(span, wrapper);
                    }
                    wrapper.setAttribute('aria-labelledby', labelId);
                }
            }

            if (!wrapper.dataset.a11yBound) {
                wrapper.dataset.a11yBound = '1';
                input.addEventListener('switchChange.bootstrapSwitch', function () {
                    wrapper.setAttribute('aria-checked', input.checked ? 'true' : 'false');
                });
                input.addEventListener('change', function () {
                    wrapper.setAttribute('aria-checked', input.checked ? 'true' : 'false');
                });
                wrapper.addEventListener('keydown', function (e) {
                    if (e.key === ' ' || e.key === 'Enter') {
                        e.preventDefault();
                        input.click();
                    }
                });
                if (!wrapper.hasAttribute('tabindex')) {
                    wrapper.tabIndex = 0;
                }
            }
        });
    }

    /* ------------------------------------------------------------------ */
    /* WS-B: 2FA AJAX modal focus management                               */
    /* ------------------------------------------------------------------ */

    /**
     * When the AJAX-loaded 2FA modal (#modalAjax with .twofa-setup class)
     * opens, move focus to the first interactive element inside it.
     * Return focus to the trigger link when the modal closes.
     */
    function initTwofaModalFocus() {
        var modal = document.getElementById('modalAjax');
        if (!modal) { return; }

        modal.addEventListener('shown.bs.modal', function () {
            if (!modal.classList.contains('twofa-setup')) { return; }
            var focusable = modal.querySelector(
                'input:not([disabled]):not([type=hidden]), button:not([disabled]), select:not([disabled]), textarea:not([disabled]), a[href]'
            );
            if (focusable) {
                focusable.focus();
            } else {
                var dialog = modal.querySelector('.modal-dialog');
                if (dialog) {
                    dialog.setAttribute('tabindex', '-1');
                    dialog.focus();
                }
            }
        });

        var lastFocus = null;
        document.querySelectorAll('.twofa-config-link').forEach(function (link) {
            link.addEventListener('click', function () { lastFocus = link; });
        });
        modal.addEventListener('hidden.bs.modal', function () {
            if (lastFocus) { lastFocus.focus(); lastFocus = null; }
        });
    }

    /* ------------------------------------------------------------------ */
    /* WS-B: Linked-accounts live region                                   */
    /* ------------------------------------------------------------------ */

    /**
     * Wraps #providerLinkingMessages in an aria-live region so
     * screen-reader users hear status updates after OAuth linking.
     */
    function initLinkedAccountsLiveRegion() {
        var msgBox = document.getElementById('providerLinkingMessages');
        if (!msgBox) { return; }
        if (!msgBox.getAttribute('aria-live')) {
            msgBox.setAttribute('role', 'status');
            msgBox.setAttribute('aria-live', 'polite');
            msgBox.setAttribute('aria-atomic', 'true');
        }
    }

    /* ------------------------------------------------------------------ */
    /* WS-B: Bootstrap modal aria-labelledby fix                           */
    /* ------------------------------------------------------------------ */

    /**
     * Ensures every Bootstrap modal that contains a .modal-title
     * gets aria-labelledby pointing to that title element.
     */
    function initModalAria(root) {
        root = root || document;
        root.querySelectorAll('.modal[role="dialog"]').forEach(function (modal) {
            var title = modal.querySelector('.modal-title');
            if (!title) { return; }
            if (!title.id) {
                title.id = 'modal-title-' + (modal.id || Math.random().toString(36).slice(2));
            }
            if (!modal.getAttribute('aria-labelledby')) {
                modal.setAttribute('aria-labelledby', title.id);
            }
        });
    }

    /* ------------------------------------------------------------------ */
    /* WS-B: Disabled links — aria-disabled upgrade                        */
    /* ------------------------------------------------------------------ */

    /**
     * Links with class .disabled lack aria-disabled="true" in the
     * parent theme. Add it so AT announces them as unavailable.
     */
    function initAriaDisabledLinks(root) {
        root = root || document;
        root.querySelectorAll('a.disabled, a[disabled]').forEach(function (link) {
            link.setAttribute('aria-disabled', 'true');
            if (!link.dataset.a11yBound) {
                link.dataset.a11yBound = '1';
                link.addEventListener('click', function (e) { e.preventDefault(); });
                link.addEventListener('keydown', function (e) {
                    if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); }
                });
            }
        });
    }

    /* ------------------------------------------------------------------ */
    /* WS-B: StatesDropdown.js accessibility patch                        */
    /* ------------------------------------------------------------------ */

    /**
     * WHMCS core StatesDropdown.js replaces #inputState with #stateselect
     * (country has states) or #stateinput (stateNotRequired=true). The new
     * element loses the label association from <label for="inputState">.
     * Copy the label text into aria-label on the dynamic element.
     *
     * StatesDropdown.js triggers 'state:rendered' on the country select each
     * time it rebuilds the state field — bind there so we always run after.
     */
    function initStatesDropdownA11y() {
        var label = document.querySelector('label[for="inputState"]');
        if (!label) { return; }
        var labelText = label.textContent.trim();

        function labelStateEl() {
            ['stateselect', 'stateinput'].forEach(function (id) {
                var el = document.getElementById(id);
                if (el && !el.getAttribute('aria-label')) {
                    el.setAttribute('aria-label', labelText);
                }
            });
        }

        var countrySelect = document.querySelector('select[name="country"]');
        if (countrySelect) {
            /* Re-label whenever StatesDropdown rebuilds (fires on initial load too) */
            jQuery(countrySelect).on('state:rendered', labelStateEl);
            /* Fallback: label whatever is already in the DOM right now */
            setTimeout(labelStateEl, 0);
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function () {
            initBootstrapSwitchA11y(document);
            initTwofaModalFocus();
            initLinkedAccountsLiveRegion();
            initModalAria(document);
            initAriaDisabledLinks(document);
            initStatesDropdownA11y();
        });
    } else {
        initBootstrapSwitchA11y(document);
        initTwofaModalFocus();
        initLinkedAccountsLiveRegion();
        initModalAria(document);
        initAriaDisabledLinks(document);
        initStatesDropdownA11y();
    }

    /* Expose for re-use after AJAX / dynamic content */
    var _A = window.A11yOne = window.A11yOne || {};
    _A.initBootstrapSwitchA11y = initBootstrapSwitchA11y;
    _A.initTwofaModalFocus = initTwofaModalFocus;
    _A.initLinkedAccountsLiveRegion = initLinkedAccountsLiveRegion;
    _A.initModalAria = initModalAria;
    _A.initAriaDisabledLinks = initAriaDisabledLinks;
    _A.initStatesDropdownA11y = initStatesDropdownA11y;

    /* === WS-E Domains ===
     * Fix SSL-state images that WHMCS core JS injects dynamically without alt.
     * These images carry a class of "ssl-state" and use title/data-* for tooltip
     * content. We copy the title as alt text (or use empty alt for decorative).
     * Run on DOMContentLoaded + observe dynamic injection via MutationObserver.
     */
    function fixSslStateImageAlts() {
        document.querySelectorAll('img.ssl-state:not([alt])').forEach(function (img) {
            var title = img.getAttribute('title') || img.getAttribute('data-original-title') || '';
            img.setAttribute('alt', title); /* empty string if no title = decorative */
        });
    }

    function initSslStateAlts() {
        fixSslStateImageAlts();
        /* ssl-info.js populates each image's title/state via AJAX after load.
           Only the SSL pages (managessl, SSL widgets) carry img.ssl-state, so
           scope the observer to those images. This avoids a site-wide subtree
           observer that would fire on every unrelated class/DOM change. */
        var imgs = document.querySelectorAll('img.ssl-state');
        if (!imgs.length || typeof MutationObserver === 'undefined') { return; }
        var obs = new MutationObserver(fixSslStateImageAlts);
        imgs.forEach(function (img) {
            obs.observe(img, {
                attributes: true,
                attributeFilter: ['src', 'title', 'data-original-title']
            });
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initSslStateAlts);
    } else {
        initSslStateAlts();
    }

    /* === Axe-sweep fix: label hook-injected domain search inputs ===
     * WHMCS core injects a "Register a New Domain" panel on the clientarea
     * dashboard with a bare <input type="text" name="domain"> that has no
     * label element (axe rule: label, CRITICAL — WCAG 1.3.1 / 4.1.2).
     *
     * The input comes from a hook-generated panel body; no theme template
     * controls that markup.  Supply an aria-label via JS on DOMContentLoaded.
     * Label text from the i18n carrier (data-domainsearchlabel).
     */
    function labelDomainSearchInputs() {
        var inputs = document.querySelectorAll(
            'form[action="domainchecker.php"] input[name="domain"]:not([aria-label]):not([aria-labelledby])'
        );
        if (!inputs.length) { return; }
        var label = _i18n('domainsearchlabel', 'Search for a domain');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].setAttribute('aria-label', label);
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', labelDomainSearchInputs);
    } else {
        labelDomainSearchInputs();
    }

}());

/* === WS-G verify-email live region ===
 * WHMCS core scripts.min.js handles the btn-resend-verify-email AJAX call and
 * updates the button text on success/error.  This small IIFE additionally
 * copies the result text into the #verifyEmailStatus live region so that
 * screen readers announce the outcome without a page reload.
 */
(function () {
    function initVerifyEmailLiveRegion() {
        var btn = document.querySelector('.btn-resend-verify-email');
        if (!btn) { return; }
        var targetSel = btn.getAttribute('data-status-target');
        if (!targetSel) { return; }
        var statusEl = document.querySelector(targetSel);
        if (!statusEl) { return; }

        /* Use MutationObserver to watch for the button text change that core
           scripts.min.js performs on success/error — relay it to the live region. */
        var observer = new MutationObserver(function () {
            statusEl.textContent = btn.textContent.trim();
        });
        observer.observe(btn, { childList: true, subtree: true, characterData: true });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initVerifyEmailLiveRegion);
    } else {
        initVerifyEmailLiveRegion();
    }
}());

/* === Accessible navigation menus (WAI-ARIA menu-button pattern) ===
 * WHMCS/Bootstrap nav dropdowns announce aria-expanded but expose their items
 * as plain links with no menu semantics, so a screen reader stays in browse
 * mode and arrow keys never reach the dropdown — the user hears "expanded" but
 * cannot navigate the items. Upgrade each navbar dropdown to a real menu:
 *   - role=menu on the list, role=menuitem + tabindex=-1 on each link
 *   - Down/Up move focus between items (wrapping), Home/End jump to ends
 *   - Enter/Space/Down on the toggle opens the menu and focuses the first item
 *   - Esc (or Tab) closes; Esc returns focus to the toggle
 * We handle the keys explicitly (stopPropagation) so behaviour is identical
 * across screen readers rather than relying on Bootstrap's own key handling,
 * while still using Bootstrap's show/hide via its jQuery API.
 */
(function () {
    var $ = window.jQuery;

    function enhance(toggle) {
        var dd = toggle.closest('.dropdown');
        if (!dd || toggle.__a11yNavMenu) { return; }
        var menu = dd.querySelector('.dropdown-menu');
        if (!menu) { return; }
        toggle.__a11yNavMenu = true;

        toggle.setAttribute('aria-haspopup', 'true');
        menu.setAttribute('role', 'menu');
        if (!menu.getAttribute('aria-label')) {
            var name = (toggle.textContent || '').replace(/\s+/g, ' ').trim();
            if (name) { menu.setAttribute('aria-label', name); }
        }
        Array.prototype.forEach.call(menu.querySelectorAll('a'), function (a) {
            a.setAttribute('role', 'menuitem');
            a.setAttribute('tabindex', '-1');
            /* The wrapping <li> must be role=none so the menuitem's required
               parent is the role=menu list (ARIA required-parent). */
            if (a.parentElement && a.parentElement.tagName === 'LI') {
                a.parentElement.setAttribute('role', 'none');
            }
        });
        /* Dividers between groups → separators. */
        Array.prototype.forEach.call(menu.querySelectorAll('.dropdown-divider'), function (d) {
            d.setAttribute('role', 'separator');
        });

        function items() {
            return Array.prototype.filter.call(
                menu.querySelectorAll('a[role="menuitem"]'),
                function (a) { return !a.classList.contains('disabled') && a.offsetParent !== null; }
            );
        }
        function focusAt(i) {
            var list = items();
            if (!list.length) { return; }
            i = (i + list.length) % list.length;
            list[i].focus();
        }
        function indexOfActive() {
            return items().indexOf(document.activeElement);
        }
        function isOpen() { return dd.classList.contains('show'); }
        function open(cb) {
            if (!isOpen() && $) { $(toggle).dropdown('toggle'); }
            setTimeout(cb, 0);
        }
        function close(focusToggle) {
            if (isOpen() && $) { $(toggle).dropdown('toggle'); }
            if (focusToggle) { toggle.focus(); }
        }

        toggle.addEventListener('keydown', function (e) {
            if (e.key === 'ArrowDown' || e.key === 'Down') {
                e.preventDefault(); e.stopPropagation();
                open(function () { focusAt(0); });
            } else if (e.key === 'ArrowUp' || e.key === 'Up') {
                e.preventDefault(); e.stopPropagation();
                open(function () { focusAt(-1); });
            }
        });

        menu.addEventListener('keydown', function (e) {
            var i = indexOfActive();
            switch (e.key) {
                case 'ArrowDown': case 'Down':
                    e.preventDefault(); e.stopPropagation(); focusAt(i + 1); break;
                case 'ArrowUp': case 'Up':
                    e.preventDefault(); e.stopPropagation(); focusAt(i - 1); break;
                case 'Home':
                    e.preventDefault(); e.stopPropagation(); focusAt(0); break;
                case 'End':
                    e.preventDefault(); e.stopPropagation(); focusAt(-1); break;
                case 'Escape': case 'Esc':
                    e.preventDefault(); e.stopPropagation(); close(true); break;
                case 'Tab':
                    close(false); break;
                default: break;
            }
        });

        /* If Bootstrap opens the menu by click, still move focus to the first item. */
        if ($) {
            $(dd).on('shown.bs.dropdown', function () {
                setTimeout(function () { focusAt(0); }, 0);
            });
        }
    }

    function run() {
        var toggles = document.querySelectorAll('.navbar .dropdown > [data-toggle="dropdown"], .main-navbar-wrapper .dropdown > [data-toggle="dropdown"]');
        Array.prototype.forEach.call(toggles, enhance);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', run);
    } else {
        run();
    }
}());

/* === List-page filters: collapsed "Filters" disclosure below the heading ===
 * WHMCS renders list-page status filters ("View": Active/Pending/…) as a panel
 * in the secondary sidebar, which clutters navigation and pushes the list down.
 * Relocate that panel into a single collapsed "Filters" button placed right
 * under the page heading, so the list leads and filters are one predictable,
 * keyboard-operable control. Progressive enhancement: with no JS the filters
 * stay in the sidebar and still work.
 */
(function () {
    function filtersLabel() {
        var c = document.getElementById('a11yOneI18n');
        return (c && c.getAttribute('data-filters')) || 'Filters';
    }
    function initListFilters() {
        var card = document.querySelector('.view-filter-btns');
        if (!card) { return; }
        var group = card.querySelector('.list-group');
        var h1 = document.querySelector('.primary-content h1') || document.querySelector('#main-body h1');
        if (!group || !h1) { return; }
        var label = filtersLabel();

        var wrap = document.createElement('div');
        wrap.className = 'a11y-filters mb-4';

        var btn = document.createElement('button');
        btn.type = 'button';
        btn.id = 'a11yFiltersToggle';
        btn.className = 'btn btn-outline-secondary a11y-filters-toggle';
        btn.setAttribute('aria-expanded', 'false');
        btn.setAttribute('aria-controls', 'a11yFiltersRegion');
        var icon = document.createElement('i');
        icon.className = 'fas fa-filter mr-1';
        icon.setAttribute('aria-hidden', 'true');
        var lbl = document.createElement('span');
        lbl.textContent = label;
        btn.appendChild(icon);
        btn.appendChild(lbl);

        var region = document.createElement('div');
        region.id = 'a11yFiltersRegion';
        region.className = 'a11y-filters-region mt-2';
        region.setAttribute('role', 'group');
        region.setAttribute('aria-label', label);
        region.hidden = true;
        region.appendChild(group);

        wrap.appendChild(btn);
        wrap.appendChild(region);
        h1.insertAdjacentElement('afterend', wrap);

        if (card.parentNode) { card.parentNode.removeChild(card); }

        btn.addEventListener('click', function () {
            var open = btn.getAttribute('aria-expanded') === 'true';
            btn.setAttribute('aria-expanded', open ? 'false' : 'true');
            region.hidden = open;
        });
    }
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initListFilters);
    } else {
        initListFilters();
    }
}());

