/**
 * A11y Cart — accessibility enhancements for the Standard Cart order form.
 *
 * Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca
 * License: MIT
 *
 * Progressive enhancement only: every fix degrades gracefully if a node is
 * absent on the current cart step. All user-facing text comes from data-*
 * attributes injected by the templates (which read WHMCS language strings),
 * so no copy is hardcoded here.
 */
(function () {
    'use strict';

    function ready(fn) {
        if (document.readyState !== 'loading') {
            fn();
        } else {
            document.addEventListener('DOMContentLoaded', fn);
        }
    }

    /**
     * Mark dynamically-updated price/total containers as polite live regions so
     * screen readers announce recalculated amounts on configure/cart/checkout.
     */
    function markPriceLiveRegions() {
        var ids = [
            'producttotal',        // configureproduct order summary body
            'orderSummary',        // configure / viewcart summary
            'totalCartPrice',      // checkout payment total
            'totalDueToday',       // checkout / viewcart due-today
            'subtotal', 'discount', 'taxTotal1', 'taxTotal2', 'recurring'
        ];
        ids.forEach(function (id) {
            var el = document.getElementById(id);
            if (el && !el.hasAttribute('aria-live')) {
                el.setAttribute('aria-live', 'polite');
                el.setAttribute('aria-atomic', 'true');
            }
        });
    }

    /**
     * Wire a w-hidden show/hide toggle button to its controlled container with
     * aria-expanded / aria-controls. WHMCS toggles `.w-hidden` (or `.hidden`)
     * via jQuery, so we observe class changes to keep aria-expanded in sync.
     */
    function wireToggle(btnId, targetId) {
        var btn = document.getElementById(btnId);
        var target = document.getElementById(targetId);
        if (!btn || !target) {
            return;
        }
        btn.setAttribute('aria-controls', targetId);

        function isHidden(node) {
            return node.classList.contains('w-hidden') || node.classList.contains('hidden');
        }
        function sync() {
            btn.setAttribute('aria-expanded', isHidden(target) ? 'false' : 'true');
        }
        sync();
        var observer = new MutationObserver(sync);
        observer.observe(target, { attributes: true, attributeFilter: ['class'] });
    }

    /**
     * Checkout: "Already registered / Create account" mode toggles and the
     * sign-in / sign-up containers behave as disclosure controls.
     */
    function wireCheckoutToggles() {
        wireToggle('btnAlreadyRegistered', 'containerExistingUserSignin');
        wireToggle('btnNewUserSignup', 'containerNewUserSignup');
    }

    /**
     * The checkout "Checkout" link in viewcart is an <a> styled as a button that
     * is disabled via the `disabled` class when the cart is empty. Expose that
     * state to AT.
     */
    function fixDisabledAnchorButtons() {
        var anchors = document.querySelectorAll('a.btn.disabled, a.btn-checkout.disabled');
        anchors.forEach(function (a) {
            a.setAttribute('aria-disabled', 'true');
            a.setAttribute('role', 'button');
        });
    }

    /**
     * Multi-state "Add to cart" domain buttons: announce the resolved state
     * (added / unavailable) on the button's accessible name. WHMCS toggles inner
     * spans (.to-add/.added/.unavailable) by class; we reflect the visible one
     * onto aria-label, scoped to the button's domain where known.
     */
    function refreshDomainButtonLabels(scope) {
        var root = scope || document;
        var addedTpl = root.getAttribute && root.getAttribute('data-lang-added');
        var buttons = (scope || document).querySelectorAll('.btn-add-to-cart');
        buttons.forEach(function (btn) {
            var domain = btn.getAttribute('data-domain') || '';
            var addLabel = btn.getAttribute('data-label-add');
            var addedLabel = btn.getAttribute('data-label-added');
            var unavailLabel = btn.getAttribute('data-label-unavailable');
            function visible(sel) {
                var s = btn.querySelector(sel);
                return s && s.offsetParent !== null;
            }
            var label = addLabel;
            if (visible('.unavailable') && unavailLabel) {
                label = unavailLabel;
            } else if (visible('.added') && addedLabel) {
                label = addedLabel;
            }
            if (label) {
                btn.setAttribute('aria-label', label);
            }
        });
    }

    /**
     * Make the domain search results panel a polite status region and keep the
     * add-to-cart button labels current as availability resolves.
     */
    function wireDomainResults() {
        var results = document.getElementById('DomainSearchResults');
        if (!results) {
            return;
        }
        if (!results.hasAttribute('role')) {
            results.setAttribute('role', 'status');
        }
        results.setAttribute('aria-live', 'polite');

        refreshDomainButtonLabels(results);
        var observer = new MutationObserver(function () {
            refreshDomainButtonLabels(results);
        });
        observer.observe(results, {
            subtree: true,
            attributes: true,
            attributeFilter: ['class', 'style']
        });
    }

    /**
     * Accessible modals: ensure aria-modal + labelledby and move focus to the
     * dialog on open, restoring it on close. Works with Bootstrap 3/4 events.
     */
    function wireModals() {
        if (typeof jQuery === 'undefined') {
            return;
        }
        jQuery('.modal').each(function () {
            var $modal = jQuery(this);
            var modal = this;
            // Derive a labelledby target from the modal title if present.
            var $title = $modal.find('.modal-title, .modal-header h4, .modal-header h3').first();
            if ($title.length) {
                if (!$title.attr('id')) {
                    $title.attr('id', modal.id + '-title');
                }
                $modal.attr('aria-labelledby', $title.attr('id'));
            }
            $modal.attr('aria-modal', 'true');

            var lastFocus = null;
            $modal.on('show.bs.modal', function () {
                lastFocus = document.activeElement;
            });
            $modal.on('shown.bs.modal', function () {
                var focusable = modal.querySelector(
                    '[autofocus], .btn-primary, button:not(.close), a[href], input, select, textarea'
                );
                if (focusable) {
                    focusable.focus();
                }
            });
            $modal.on('hidden.bs.modal', function () {
                if (lastFocus && typeof lastFocus.focus === 'function') {
                    lastFocus.focus();
                }
            });
        });
    }

    /**
     * The ionRangeSlider hides the native number input and replaces it with
     * non-focusable markup. Where a slider is built, expose the underlying input
     * to AT (visually hidden but reachable) so the value stays operable.
     */
    function fixRangeSliderFallback() {
        var sliders = document.querySelectorAll('.irs-hidden-input');
        sliders.forEach(function (input) {
            if (!input.getAttribute('aria-label')) {
                var labelText = input.getAttribute('data-a11y-label');
                if (labelText) {
                    input.setAttribute('aria-label', labelText);
                }
            }
            // ionRangeSlider sets the native input to display:none; expose a
            // screen-reader-operable copy is non-trivial, so we at least keep the
            // native input focusable and labelled as a documented fallback.
            input.classList.add('sr-only');
            input.removeAttribute('tabindex');
        });
    }

    ready(function () {
        markPriceLiveRegions();
        wireCheckoutToggles();
        fixDisabledAnchorButtons();
        wireDomainResults();
        wireModals();
        fixRangeSliderFallback();
    });
}());
