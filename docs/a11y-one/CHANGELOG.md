# Changelog

All notable changes to A11y One are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versions follow [Semantic Versioning](https://semver.org/).

---

## [1.0.0] — 2026-06-24

Initial public release. Full WCAG 2.2 Level AA accessible client-area theme for WHMCS 9.x, delivered across eight workstreams.

### Added

**Shared accessibility engine — WS-A**

- `js/a11y-one.js`: site-wide accessibility engine (~2 300 lines) loaded on every client-area page. Provides: iCheck-to-native-input shim; DataTables caption/scope/sort-state/result-count live regions; Bootstrap nav-tab `role=tablist/tab/tabpanel` + arrow-key navigation; copy-to-clipboard buttons with live confirmation; password reveal/hide with `aria-pressed`; password strength meter sr-only label; status-badge sr-only text labels; decorative FontAwesome icon `aria-hidden`; card-minimise button ARIA; notifications-popover accessible labelling; bootstrap-markdown editor toolbar labels; file-upload label cloning (Attachment N); Bootstrap modal `aria-modal`/`aria-labelledby`/focus management; flash/verify/network-status live regions; SSL state image `alt` text; bootstrap-switch labelled fallback.
- `header.tpl`: visible-on-focus skip link to `#main-body`; auth-page minimal chrome (no navbar on login/register/reset pages); ARIA landmark consistency.
- `footer.tpl`: `<main id="main-body">` closes here; `#a11yOneI18n` data carrier for JS i18n strings; auth-page minimal footer.
- Skip link targeting `#main-body` (`<main>` landmark) present on all pages.
- Site-level language keys (`lang/overrides/english.php`, `lang/overrides/turkish.php`) for all accessibility strings, with full English/Turkish parity throughout.

**Account / Profile / Security — WS-B**

- `clientareadetails.tpl`: all fields labelled; required fields `aria-required`; grouped fieldsets; custom fields labelled; error summary `role="alert"`.
- `clientareasecurity.tpl`, `user-security.tpl`: 2FA enable/disable modal ARIA; backup-code display with copy button; labelled totp input.
- `user-profile.tpl`: profile edit with labelled fields and grouped fieldsets.
- `user-password.tpl`: password change with reveal buttons and strength meter.
- `account-contacts-manage.tpl`, `account-contacts-new.tpl`: contact form labelling; required-field indicators.
- `account-user-management.tpl`, `account-user-permissions.tpl`: user table caption/scope; permission checkboxes labelled; invitation form accessible.
- `account-paymentmethods.tpl`, `account-paymentmethods-manage.tpl`, `account-paymentmethods-billing-contacts.tpl`: payment-method selection fieldset; CC-field `autocomplete` tokens; iframe title.
- `clientregister.tpl`: registration form labelling; T&C checkbox labelled; password reveal and strength meter.
- Password-reset flow (`password-reset-container.tpl`, `*-email-prompt.tpl`, `*-change-prompt.tpl`, `*-security-prompt.tpl`): single `<h1>`; all fields labelled; error `role="alert"`.

**Billing — WS-C**

- `clientareainvoices.tpl`: invoice list table caption/scope/result-count.
- `viewinvoice.tpl`: invoice detail table labelled; payment section fieldset; status badge sr-only text.
- `clientareaquotes.tpl`: quotes table caption/scope.
- `viewquote.tpl`: quote detail heading structure; `bg-warning` contrast fixed (10.9:1).
- `invoice-payment.tpl`: payment-method radio group fieldset.
- `payment/` partials: CC-field labels and `autocomplete` tokens; iframe title; 3DS status live region.
- `clientareaaddfunds.tpl`: amount fieldset; labelled radio options.
- `masspay.tpl`: table caption; checkbox group labelled.
- `viewbillingnote.tpl`: heading structure.

**Services / Products — WS-D**

- `clientareaproducts.tpl`: products table caption/scope/result-count.
- `clientareaproductdetails.tpl`: tab widget ARIA (tabs/panels/arrow keys); copy-to-clipboard for credentials; heading order; product status badge contrast fixed.
- `clientareaproductusagebilling.tpl`, `usagebillingpricing.tpl`: usage table labelling; heading structure.
- `clientareacancelrequest.tpl`: fieldset/legend for cancel reason; labelled radio group.
- `upgrade.tpl`, `upgrade-configure.tpl`, `upgradesummary.tpl`: upgrade-option radio group fieldset; summary table caption.
- `managessl.tpl`, `configuressl-stepone.tpl`, `configuressl-steptwo.tpl`, `configuressl-complete.tpl`: SSL status images with computed `alt` text; step-indicator heading; form labelling; DV badge contrast fixed.
- `subscription-manage.tpl`: subscription table caption; action button labels.

**Domains — WS-E**

- `clientareadomains.tpl`: domain list DataTables accessibility; filter/status controls labelled.
- `clientareadomaindetails.tpl`: domain-details tab panes keyboard-reachable (`tabindex="0"`, `aria-label`); see known limitations.
- DNS management, nameservers, domain contacts, EPP key, forwarding, add-ons, bulk management, domain pricing: all form inputs labelled; DataTables accessibility; live-region search feedback.
- `domain-pricing.tpl`: pricing table caption/scope; TLD filter labelled.
- `fixSslStateImageAlts` scoped to `img.ssl-state` elements with MutationObserver, gated on element presence.

**Support / Knowledge Base — WS-F**

- `supportticketslist.tpl`: ticket list table; real `<a>` rows; sr-only unread-count label.
- `supportticketsubmit-stepone.tpl`, `*-steptwo.tpl`, `*-customfields.tpl`, `*-confirm.tpl`, `*-kbsuggestions.tpl`: submit flow labelling; KB-suggestions live region; file-upload clone labels.
- `viewticket.tpl`: accessible star rating (native radio group styled in CSS; submits `?rating=rate{replyid}_{N}`); close-ticket form button; reply-box focus management.
- `ticketfeedback.tpl`: per-staff fieldset/legend; 1–10 rating radios with "N out of 10" accessible names; labelled textareas.
- `knowledgebase.tpl`, `knowledgebasecat.tpl`, `knowledgebasearticle.tpl`: article list labelling; search results live region.
- `downloads.tpl`, `downloadscat.tpl`: downloads table caption/scope.
- `announcements.tpl`, `viewannouncement.tpl`: heading structure; list labelling.
- `contact.tpl`: form fieldset/legend; all fields labelled.
- `serverstatus.tpl`: status-indicator text labels (not colour-only).
- `markdown-guide.tpl`: heading structure.

**Dashboard / Miscellaneous / OAuth — WS-G**

- `clientareahome.tpl`: single `<h1>`; dashboard tile `aria-label` (numeric stats); tile title contrast fixed (specificity).
- `homepage.tpl`: landing-page landmark and heading structure; CTA links named.
- `clientareaemails.tpl`: email history table caption/scope; actions column header.
- `viewemail.tpl`: single `<h1>`; accessible email body container.
- Error pages (`error/forbidden.tpl`, `error/maintenance.tpl`, `error/notfound.tpl`, `error/suspended.tpl`): single `<h1>`; descriptive message; link back to home; decorative icons `aria-hidden`.
- OAuth flow (`oauth/layout.tpl`, `oauth/login.tpl`, `oauth/login-twofactorauth.tpl`, `oauth/authorize.tpl`, `oauth/error.tpl`): shared OAuth landmark/skip; login fields labelled; 2FA backup-code input labelled; consent button names; scopes list readable; error single `<h1>`.
- `3dsecure.tpl`: iframe titled; "please wait" live region; no-JS fallback submit.
- `forwardpage.tpl`: meaningful `<title>`; redirect live region; no-JS fallback.
- `user-switch-account.tpl`, `user-switch-account-forced.tpl`: account-chooser list items named (not icon-only).
- `banned.tpl`: heading structure; reason text accessible.

**Accessible Order Form — WS-H**

- `templates/orderforms/a11y-cart/`: new order-form child of `standard_cart` covering `common.tpl`, `products.tpl`, `configureproduct.tpl`, `configuredomains.tpl`, `domainregister.tpl`, `viewcart.tpl`, `checkout.tpl`, `complete.tpl`, `addons.tpl`, `recommendations-modal.tpl`, and supporting partials.
- `js/a11y-cart.js`: cart-specific JS engine (account-type toggle `aria-expanded`, quantity-fallback label, dynamic accessible names for add-to-cart buttons).
- Price live regions, configurable-option fieldsets, domain search status region, real checkout field labels, CC `autocomplete` tokens, modal focus management, ionRangeSlider fallback, TLD-picker `aria-label`, decorative icon hiding, `aria-disabled` on disabled checkout link.

**Test suite**

- `tests/a11y-one/`: Python Playwright + axe-playwright-python test suite covering all workstreams. Excluded from release archive via `.gitattributes export-ignore`.

**Packaging**

- `.gitattributes`: export-ignore rules for `tests/`, `docs/`, `.superpowers/`, `.claude/`.
- `templates/a11y-one/theme.yaml`: declares parent `twenty-one`, author Can Kirca, MIT license.
- `templates/orderforms/a11y-cart/theme.yaml`: declares parent `standard_cart`, author Can Kirca, MIT license.

### Security

- All dynamic values introduced in ARIA attributes are escaped with Smarty `|escape`.
- CSRF tokens preserved in all form overrides.
- Test seed/teardown scripts (`seed.php`, `teardown.php`) are CLI-only (403 on web request) and excluded from release archive.
- External `target="_blank"` links carry `rel="noopener noreferrer"`.

---

[1.0.0]: https://github.com/cankirca/whmcs-a11y-one/releases/tag/v1.0.0
