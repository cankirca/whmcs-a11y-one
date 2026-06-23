# A11y One

An accessible WHMCS client-area theme targeting WCAG 2.2 Level AA. Built as a child theme of the bundled `twenty-one` theme, with a matching accessible order-form template (`a11y-cart`) for the shopping-cart funnel.

**Author:** Can Kirca &lt;cankirca@gmail.com&gt; — https://github.com/cankirca  
**Version:** 1.0.0  
**WHMCS compatibility:** 9.0.5 (9.x)  
**Parent theme:** `twenty-one` (bundled with WHMCS)  
**Parent order form:** `standard_cart` (bundled with WHMCS)

---

## What A11y One Is

A11y One overrides only the templates that require accessibility work — everything else inherits from the parent theme. It ships with:

- A shared JavaScript engine (`js/a11y-one.js`, ~2 300 lines) that auto-initialises on every client-area page and provides accessible versions of commonly-used widgets.
- Template overrides for all major client-area page types.
- A companion order-form child template (`a11y-cart`) for the purchase funnel.
- Site-level language keys (English and Turkish) for all new user-facing strings.
- A `custom.css` that fixes contrast issues and adds focus-indicator improvements.

---

## Accessibility Features

### Shared Engine (`js/a11y-one.js`)

The engine runs on `DOMContentLoaded` and applies the following across all client-area pages:

- **Skip link** — a visible-on-focus "Skip to main content" link targeting `#main-body` appears at the top of every page.
- **Main landmark** — `<main id="main-body">` wraps the primary content area consistently.
- **iCheck shim** — replaces iCheck radio/checkbox widgets with native labelled inputs that are operable by keyboard and screen reader.
- **DataTables accessibility** — table `<caption>`, column `scope`, result-count live region, and sort-state announcements.
- **Tab widget** — Bootstrap nav-tabs gain `role=tablist/tab/tabpanel`, `aria-selected`, and arrow-key navigation.
- **Copy-to-clipboard** — copy buttons get a descriptive `aria-label` and announce completion via a live region.
- **Password reveal** — show/hide buttons for password fields are labelled and toggle `type` and `aria-pressed` correctly; strength meters report their level via sr-only text.
- **Status badges** — `.badge`, `.label`, and `[class*=status-]` elements have sr-only text labels so status is not communicated by colour alone.
- **Decorative icon hiding** — FontAwesome icons inside links and buttons are `aria-hidden="true"` automatically.
- **Notifications popover** — accessible labelling and dismiss behaviour.
- **Markdown editor** — bootstrap-markdown toolbar buttons are labelled; fullscreen toggle is exposed as a button.
- **File upload** — cloned file-input labels are renumbered correctly (Attachment 1, Attachment 2, …).
- **Modal ARIA** — dynamically-opened Bootstrap modals receive `aria-modal="true"`, `aria-labelledby`, and focus management.
- **Live regions** — flash alerts, network-status notices, and verification messages are announced to screen readers.
- **SSL state images** — `<img class="ssl-state">` elements receive computed `alt` text reflecting the current SSL status.
- **Bootstrap Switch** — toggle switches are given labelled fallback behaviour.

### Page-Level Overrides

Every major page type is overridden with targeted fixes:

- **Authentication** — login, register, password reset, 2FA: single `<h1>`, all fields labelled, `aria-required`, password reveal, error `role="alert"`.
- **Account / Profile** — profile edit, security, 2FA management, contacts, user management, user permissions: labelled fields, `<fieldset>`/`<legend>` groups, `aria-required`, error summaries.
- **Billing** — invoices list and detail, quotes, payment partials, add funds, mass pay: table captions, scoped headers, labelled payment-method radio groups, CC-field `autocomplete` tokens, iframe titles.
- **Services / Products** — product list, product details (tabs/credentials/usage), cancel, upgrade flow, SSL management and configuration, subscription management: corrected heading hierarchy, tab ARIA, copy-to-clipboard for credentials, contrast fixes for status badges.
- **Domains** — domain list, domain details, DNS management, nameservers, domain contacts, EPP key, forwarding, add-ons, bulk management, domain pricing: DataTables accessibility, labelled inputs throughout, live-region search feedback.
- **Support / KB** — ticket list, ticket submit flow, view ticket (with accessible star rating — native radio group), ticket feedback, knowledge base (article/category/search with live region), downloads, announcements, contact form, server status: accessible star-rating fieldset, markdown editor, file upload labels, live region for KB suggestions.
- **Dashboard / Misc** — dashboard (client home), email history, error pages (404/403/suspended/maintenance), OAuth flows (login, 2FA, authorize, error), 3DS / forward interstitials, account switcher, verify email: landmark and heading structure, live region for redirect pages, labelled account-switcher items.

### Accessible Cart (`a11y-cart`)

- Price/total live regions (`aria-live="polite"`) on configure, view cart, and checkout summaries.
- All configurable-option groups (radio, checkbox, server config, domain add-ons, payment methods, CC block) wrapped in `<fieldset>`/`<legend>`.
- Domain search results as `role="status" aria-live="polite"`; add-to-cart buttons include the domain name in their accessible label.
- Real labels on checkout personal-detail, registrant, payment, and CC fields (icon-only label pattern removed); `autocomplete` CC tokens throughout.
- Accessible modals (remove item, empty cart, recommendations) with `aria-modal`, `aria-labelledby`, and focus management.
- Quantity inputs labelled; ionRangeSlider native number-input fallback labelled and operable.
- Bootstrap-multiselect TLD picker given `aria-label`; native `<select>` is the operable fallback.
- Decorative icons `aria-hidden`; disabled checkout anchor has `aria-disabled="true"`; account-type show/hide toggles expose `aria-expanded`/`aria-controls`.

---

## Requirements

- WHMCS 9.x (tested on 9.0.5)
- Parent theme `twenty-one` (bundled with WHMCS; must remain installed)
- Parent order form `standard_cart` (bundled with WHMCS; must remain installed)
- PHP 8.x
- Bootstrap 4.5.3 (supplied by WHMCS / twenty-one)

---

## Installation

### Step 1 — Copy the theme templates

Copy the `templates/a11y-one/` directory into your WHMCS installation's `templates/` folder:

```
templates/a11y-one/          → <whmcs_root>/templates/a11y-one/
```

Copy the order-form templates into `templates/orderforms/`:

```
templates/orderforms/a11y-cart/   → <whmcs_root>/templates/orderforms/a11y-cart/
```

### Step 2 — Merge the language override keys (REQUIRED)

**This step is mandatory.** WHMCS does not load `lang/overrides/` files from inside a theme directory — only from the site-level `lang/overrides/` directory. A11y One's new user-facing strings (skip link, password reveal, status labels, sort announcements, etc.) are defined in:

```
lang/overrides/english.php
lang/overrides/turkish.php
```

**If your site does not yet have these files,** copy them directly:

```bash
cp <release>/lang/overrides/english.php  <whmcs_root>/lang/overrides/english.php
cp <release>/lang/overrides/turkish.php  <whmcs_root>/lang/overrides/turkish.php
```

**If your site already has `lang/overrides/english.php` and/or `lang/overrides/turkish.php`,** do NOT overwrite — merge the keys instead. Open both files side by side and copy the blocks labelled `/* === WS-A === */` through `/* === WS-H Cart === */` (and any flat `a11y`-prefixed keys) from the release files into your existing override files.

Every key defined in `english.php` must also be defined in `turkish.php` (and vice versa) to avoid missing-string fallback behaviour. The release ships with full English/Turkish parity.

Without this step, the theme renders but accessible labels (skip link text, password-reveal button labels, status badge sr-only text, sort announcements, etc.) will fall back to the key name rather than a human-readable string.

### Step 3 — Activate the client theme

In the WHMCS admin panel: **Configuration → System Settings → General Settings → Template** → select **a11y-one** → Save.

To preview without activating site-wide, append `?systpl=a11y-one` to any client-area URL (this sets a session cookie).

### Step 4 — Activate the order-form template (optional)

The accessible cart template is a separate template family and is independent of the client theme. To activate:

**Site-wide:** In **Configuration → System Settings → General Settings → Order** → set the order-form template to **a11y-cart** → Save.

**Per-URL preview:** Append `?carttpl=a11y-cart` to any `cart.php` URL (this sets a session cookie for the browser context).

### Step 5 — Clear the Smarty template cache

After installing or updating any `.tpl` files:

```bash
rm -f <whmcs_root>/templates_c/*
```

---

## Browser Support

| Browser | Status |
|---------|--------|
| Chromium / Chrome | Tested — full automated suite passes |
| Firefox | Tested — smoke tests pass |
| WebKit / Safari | Not CI-verified (see note below) |

**WebKit note:** Playwright WebKit could not be exercised on the CI host (aarch64/Raspberry Pi; missing system libraries). The theme uses standard HTML5 semantics and Bootstrap 4.5.3 with no WebKit-specific APIs. Operators serving significant Safari traffic are encouraged to test on a WebKit-capable machine before deploying.

---

## Languages

English and Turkish are fully supported. All user-facing strings are defined via WHMCS language keys (no hardcoded strings in templates). See Step 2 above for the language override merge requirement.

---

## Known Limitations

See `docs/a11y-one/CONFORMANCE.md` for the full list. The most significant operational limits are:

- **Domain details sidebar tabs** — panes are keyboard-reachable but do not expose full `role=tablist/tab/tabpanel` ARIA semantics (WHMCS non-standard markup prevents generic wiring).
- **Cart TLD picker** — bootstrap-multiselect widget; native `<select>` fallback is labelled and operable.
- **Cart quantity slider** — ionRangeSlider; native number-input fallback is labelled and operable.
- **Payment gateway iframes** — content injected by gateway modules is outside template control; wrapping iframes are titled.
- **Duplicate IDs in sidebar** — originate in parent `twenty-one`; not a WCAG 2.2 failure (SC 4.1.1 was removed in WCAG 2.2).

---

## Security Notes

### Exclude test fixtures from production

The `tests/` directory contains a database seed script (`seed.php`) and teardown script (`teardown.php`). These files must not be web-accessible on a production server. The release archive is built with `.gitattributes export-ignore` rules that exclude `tests/`, `docs/`, `.superpowers/`, and `.claude/` from `git archive` output. If you deploy from a full git checkout rather than a release archive, restrict access at the web server level.

**Nginx example:**

```nginx
location ~* ^/tests/ {
    deny all;
    return 403;
}
```

### Other security properties

- All dynamic values output in ARIA attributes (`aria-label`, `alt`, `title`, `data-*`) introduced by A11y One are escaped with Smarty's `|escape` filter.
- CSRF tokens (`{$token}`) are preserved unchanged in all form overrides.
- No secrets, API keys, or credentials appear in any template or JavaScript file.
- JavaScript in `js/a11y-one.js` and `js/a11y-cart.js` uses no `innerHTML` assignment on untrusted content and no `eval`.
- External links opened in a new tab (`target="_blank"`) carry `rel="noopener noreferrer"`.

---

## License

© 2026 Can Kirca. Released under the MIT License (see `LICENSE`). The author's choice of license governs; nothing in this distribution assigns copyright to any other party.

---

## Conformance

See `docs/a11y-one/CONFORMANCE.md` for the full WCAG 2.2 Level AA Accessibility Conformance Report.
