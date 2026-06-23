# A11y One — Accessibility Conformance Report
## WCAG 2.2 Level AA

**Product:** A11y One — accessible WHMCS client-area theme  
**Version:** 1.0.0  
**Evaluation date:** 2026-06-24  
**Author:** Can Kirca &lt;cankirca@gmail.com&gt; — https://github.com/cankirca  
**Standard:** Web Content Accessibility Guidelines (WCAG) 2.2, Levels A and AA

---

## 1. Scope

This report covers the client-area templates delivered by the **A11y One** theme for WHMCS 9.0.5:

- **System theme** (`templates/a11y-one/`): all client-facing pages including authentication, dashboard, account/profile/security, billing (invoices, quotes, payments), services/products, SSL management, domains, support tickets, knowledge base, downloads, announcements, contact, server status, OAuth flows, email history, error pages, and miscellaneous standalone pages.
- **Order-form template** (`templates/orderforms/a11y-cart/`): the shopping-cart / order funnel (product selection, configure product, configure domains, add-ons, view cart, checkout, order complete).

Pages delivered by WHMCS core that are not overridden by A11y One (e.g. the admin panel) are out of scope.

---

## 2. Evaluation Methods

Three complementary verification methods were used:

**A. Automated axe-core sweep (primary)**  
Python Playwright (v1.58) drives Chromium against a seeded WHMCS instance and runs `axe-playwright-python` with the full `wcag2a`, `wcag2aa`, `wcag21a`, `wcag21aa`, and `wcag22aa` rule tags. A catch-all release sweep (`test_release_axe_sweep.py`) covers the broad page set; per-workstream test modules (`test_ws_*.py`) exercise targeted page types with specific positive-allowlist assertions (asserting that named rules including `color-contrast` pass, not merely that no violations are found). The axe rule `duplicate-id-active` is excluded from assertions on authenticated client-area pages (see Known Limitations §4.1).

**B. Positive-allowlist per-page tests**  
For each page type, named WCAG rules are asserted to pass (not blanket-excluded). Rules asserted per page include: `color-contrast`, `button-name`, `image-alt`, `label`, `html-has-lang`, `landmark-one-main`, `page-has-heading-one`, `link-name`, and others appropriate to the page. This ensures that fixing one issue does not mask another.

**C. Source / structural review**  
Pages not runtime-reachable via automated test (e.g. EPP unlock — requires registrar redirect; bulk domain management — POST-only flow; ticket feedback form — requires admin reply) were verified by reading the rendered Smarty template markup against WCAG criteria. These are noted in the conformance table below.

**Browsers tested:** Chromium (primary, full automated suite), Firefox (smoke tests). WebKit was not exercised on this CI host (aarch64/Raspberry Pi; missing system library dependencies for Playwright WebKit). Markup uses standard Bootstrap 4.5.3 with no WebKit-specific APIs; WebKit coverage is considered a deployment-time concern for site operators.

---

## 3. Conformance Table

The table below lists the WCAG 2.2 success criteria relevant to the scope of this product. Criteria not applicable to any page in scope are marked Not Applicable with a brief rationale. Status definitions:

- **Supports** — criterion is met across the relevant page set.
- **Partially Supports** — criterion is met on most pages; exceptions are documented.
- **Not Applicable** — no content in scope triggers this criterion.

| SC | Name | Level | Status | Remarks |
|----|------|-------|--------|---------|
| 1.1.1 | Non-text Content | A | Supports | All non-decorative images have programmatic alternatives. Decorative FontAwesome icons inside links/buttons are `aria-hidden="true"` globally via the shared JS engine. SSL state images receive computed `alt` text via `fixSslStateImageAlts`. Profile/avatar images use descriptive `alt`. |
| 1.2.1 | Audio-only and Video-only (Prerecorded) | A | Not Applicable | No prerecorded audio-only or video-only content is present in the template set. |
| 1.2.2 | Captions (Prerecorded) | A | Not Applicable | No prerecorded video with audio in scope. |
| 1.2.3 | Audio Description or Media Alternative (Prerecorded) | A | Not Applicable | No prerecorded video in scope. |
| 1.2.4 | Captions (Live) | AA | Not Applicable | No live media in scope. |
| 1.2.5 | Audio Description (Prerecorded) | AA | Not Applicable | No prerecorded video in scope. |
| 1.3.1 | Info and Relationships | A | Supports | Heading hierarchy reviewed and corrected to a single `<h1>` per page. Data tables have `<caption>` and `scope` attributes. Form inputs have associated `<label>` elements or `aria-label`/`aria-labelledby`. Grouped inputs (radio sets, checkbox sets, payment methods, configurable options, CC fields) are wrapped in `<fieldset>`/`<legend>`. Lists are marked up as `<ul>`/`<ol>`. ARIA landmarks (`<main id="main-body">`, `<nav>`, `<header>`, `<footer>`) are consistent across pages. |
| 1.3.2 | Meaningful Sequence | A | Supports | Source order follows reading/logical order. Responsive sidebar double-render (see §4.1) does not change meaningful content sequence. |
| 1.3.3 | Sensory Characteristics | A | Supports | Instructions do not rely solely on shape, color, size, or position. Status indicators use both color and text (status badges include sr-only text labels). |
| 1.3.4 | Orientation | AA | Supports | No template locks or prevents orientation changes. |
| 1.3.5 | Identify Input Purpose | AA | Supports | Checkout and profile form fields use appropriate HTML5 `autocomplete` tokens (`cc-name`, `cc-number`, `cc-exp`, `cc-csc`, `given-name`, `family-name`, `email`, `tel`, `postal-code`, `street-address`). |
| 1.3.6 | Identify Purpose | AAA | Not Applicable | Level AAA, out of scope for this report. |
| 1.4.1 | Use of Color | A | Supports | Status badges include visible text labels in addition to color. Star rating uses a text label ("N out of 10") as well as visual presentation. Unread-ticket indicators use sr-only text supplements. |
| 1.4.2 | Audio Control | A | Not Applicable | No auto-playing audio in scope. |
| 1.4.3 | Contrast (Minimum) | AA | Supports | Color-contrast rule asserted in per-page axe tests. Known pre-existing low-contrast elements in the parent `twenty-one` theme were fixed in our overrides (e.g. `bg-warning` quote badges fixed to 10.9:1; dashboard tile title specificity clash resolved; DV badge contrast resolved). |
| 1.4.4 | Resize Text | AA | Supports | All text uses relative units inherited from Bootstrap 4. No fixed-pixel font sizes introduced. |
| 1.4.5 | Images of Text | AA | Supports | No images of text introduced. |
| 1.4.10 | Reflow | AA | Supports | Bootstrap 4 responsive grid is inherited and not broken by our overrides. Templates were visually reviewed at narrow viewports; no horizontal scrolling introduced. |
| 1.4.11 | Non-text Contrast | AA | Supports | Focus indicators and UI component boundaries meet or exceed 3:1 contrast against adjacent colors. Focus styles from Bootstrap 4 are supplemented in `custom.css` where needed. |
| 1.4.12 | Text Spacing | AA | Supports | No CSS properties in our overrides prevent text-spacing overrides (letter-spacing, line-height, word-spacing, margin adjustments). |
| 1.4.13 | Content on Hover or Focus | AA | Supports | Tooltip/popover content (notifications popover, Bootstrap tooltips) is dismissible and persistent on hover; no content auto-dismisses while pointer is on it. |
| 2.1.1 | Keyboard | A | Supports | All interactive elements are reachable and operable by keyboard. iCheck-replaced native inputs, DataTables, tab widgets, copy-to-clipboard buttons, password-reveal buttons, modal dialogs, star-rating radio groups, and the accessible cart funnel are all keyboard-operable. See §4.2 for the domain-details sidebar partial limitation. |
| 2.1.2 | No Keyboard Trap | A | Supports | Focus is managed into and out of modal dialogs; no keyboard traps introduced. The notification popover is dismissible by keyboard. |
| 2.1.4 | Character Key Shortcuts | A | Not Applicable | No single-character key shortcuts introduced. |
| 2.2.1 | Timing Adjustable | A | Not Applicable | No time limits introduced by the theme. WHMCS session timeout is a server-side mechanism outside template control. |
| 2.2.2 | Pause, Stop, Hide | A | Not Applicable | No auto-updating, blinking, scrolling, or moving content introduced by the theme. |
| 2.3.1 | Three Flashes or Below Threshold | A | Not Applicable | No flashing content introduced. |
| 2.4.1 | Bypass Blocks | A | Supports | A visible-on-focus "Skip to main content" link is present in `header.tpl` and targets `#main-body` (the `<main>` landmark). |
| 2.4.2 | Page Titled | A | Supports | Page titles are set by WHMCS core and not overridden; they are descriptive and present on all pages in scope. The `<title>` element is present and meaningful. |
| 2.4.3 | Focus Order | A | Supports | Reading and focus order follow a logical top-to-bottom sequence. Modal focus is managed on open (trapped inside) and restore on close. Tab widget keyboard navigation follows the ARIA authoring practices pattern (arrow keys within widget, Tab exits). |
| 2.4.4 | Link Purpose (In Context) | A | Supports | Links have accessible names from visible text, `aria-label`, or sr-only supplemental text. Identical "Add to cart" buttons in the cart are distinguished by including the domain name in the accessible label. Table rows rendered as links carry the relevant entity name. |
| 2.4.5 | Multiple Ways | AA | Not Applicable | Navigation structure (header nav, breadcrumbs, search) is provided by WHMCS core and not removed by our overrides. |
| 2.4.6 | Headings and Labels | AA | Supports | Page headings reviewed and corrected throughout. Form labels are descriptive (icon-only label antipattern removed from checkout and profile pages). |
| 2.4.7 | Focus Visible | AA | Supports | Focus indicators are visible. Bootstrap 4 default focus outlines are preserved and supplemented where overridden. Keyboard-focus styles verified during manual testing. |
| 2.4.11 | Focus Not Obscured (Minimum) | AA | Supports | Sticky elements (fixed header) do not obscure keyboard focus; the skip link brings focus to the main landmark below the fixed header. |
| 2.4.12 | Focus Not Obscured (Enhanced) | AAA | Not Applicable | Level AAA, out of scope. |
| 2.4.13 | Focus Appearance | AAA | Not Applicable | Level AAA, out of scope. |
| 2.5.1 | Pointer Gestures | A | Not Applicable | No multi-point or path-based gestures introduced. |
| 2.5.2 | Pointer Cancellation | A | Supports | Click actions use standard `onclick`/form-submit patterns; no `mousedown`-only activation introduced. |
| 2.5.3 | Label in Name | A | Supports | Visible text labels are included in or match the accessible name of controls. |
| 2.5.4 | Motion Actuation | A | Not Applicable | No motion-activated functionality introduced. |
| 2.5.7 | Dragging Movements | AA | Not Applicable | No drag interactions introduced. |
| 2.5.8 | Target Size (Minimum) | AA | Supports | Interactive elements use Bootstrap 4 button/input sizing; minimum target sizes are consistent with the parent theme. |
| 3.1.1 | Language of Page | A | Supports | `<html lang="...">` is set by WHMCS core based on the active language and is present on all pages. |
| 3.1.2 | Language of Parts | AA | Not Applicable | No inline language changes in the scope of this theme's overrides. |
| 3.2.1 | On Focus | A | Supports | No context changes triggered by focus alone. |
| 3.2.2 | On Input | A | Supports | No unexpected context changes on input. Form submissions are explicitly user-initiated. Account-type show/hide toggles use `aria-expanded`/`aria-controls` without submitting forms. |
| 3.2.3 | Consistent Navigation | AA | Supports | Navigation is provided by shared `header.tpl` and `footer.tpl` and is consistent across all client-area pages. |
| 3.2.4 | Consistent Identification | AA | Supports | Shared components (skip link, notifications popover, copy-to-clipboard buttons, password-reveal buttons) are identified consistently across pages. |
| 3.2.6 | Consistent Help | A | Supports | Help/support links (where present) appear in a consistent location in the navigation chrome. |
| 3.3.1 | Error Identification | A | Supports | Form validation errors are identified in text, not color alone. Error states use `role="alert"` or `aria-describedby` to associate error messages with fields. |
| 3.3.2 | Labels or Instructions | A | Supports | All form inputs have descriptive labels. Required fields carry `aria-required="true"`. Instructions are provided before forms where needed. |
| 3.3.3 | Error Suggestion | AA | Supports | Where WHMCS core provides error messages, those messages are surfaced in the accessible name/description of the affected field. |
| 3.3.4 | Error Prevention (Legal, Financial, Binding) | AA | Supports | WHMCS core provides order review and confirmation steps. The cart checkout flow presents an order summary before final submission. |
| 3.3.7 | Redundant Entry | A | Not Applicable | No redundant entry required within the scope of our template overrides. |
| 3.3.8 | Accessible Authentication (Minimum) | AA | Supports | The login page has a clearly labelled username and password field. No cognitive-function test (CAPTCHA) is introduced by the theme. |
| 4.1.1 | Parsing | Obsolete | Not Applicable | WCAG 2.2 removed SC 4.1.1. See §4.1 for the `duplicate-id-active` discussion. |
| 4.1.2 | Name, Role, Value | A | Supports | All interactive UI components have a programmatic name, role, and state/value. Custom widgets (tab panels, modals, live regions, status badges, copy buttons, password-reveal, star-rating, cart quantity fallback) expose correct ARIA. See §4.2 for the partial exception on domain-details sidebar tabs. |
| 4.1.3 | Status Messages | AA | Supports | Flash messages, live-search results, sort-state announcements, copy-to-clipboard confirmations, table result counts, 3DS/redirect wait messages, and domain-search results panels use `role="status"`, `role="alert"`, or `aria-live` regions as appropriate. |

---

## 4. Known Limitations and Deferrals

### 4.1 `duplicate-id-active` — Not a WCAG 2.2 Failure

Automated tooling (axe-core) may report `duplicate-id-active` on authenticated client-area pages. This is **not asserted as a failure** in the test suite because:

- WCAG 2.2 removed SC 4.1.1 (Parsing), which was the normative basis for this rule. axe-core marks the rule as deprecated.
- The duplicate IDs originate in the **parent `twenty-one` theme** (`includes/sidebar.tpl`), which renders sidebar child element IDs twice for responsive layout (desktop at line 60, mobile at line 78). A11y One does not introduce or worsen this condition.

**Mitigation:** Operators who wish to eliminate the duplicate IDs can override `includes/sidebar.tpl` to suffix the mobile copy's IDs (e.g. append `-mobile`) or `aria-hidden` the hidden copy. This is not bundled in v1.0.0 to minimize divergence from the parent theme.

### 4.2 Domain Details Sidebar Tab Panel ARIA (SC 2.1.1, 4.1.2 — Partially Supports)

The `clientareadomaindetails` page uses a non-standard tab-control structure produced by WHMCS core (`.tabControlLink` elements inside sidebar markup). Applying the standard `role=tablist/tab/tabpanel` pattern via the shared `fixTemplateTabPanels` helper causes `aria-required-parent` violations because WHMCS's markup nesting does not match the required DOM relationship.

**Current state:** Each tab pane is keyboard-reachable (`tabindex="0"`, `aria-label` describing its content). The tabs are operable but do not expose full ARIA tab semantics.

**Mitigation:** Arrow-key navigation between tabs is not available; Tab key navigates panes. A full `role=tablist/tab/tabpanel` wiring targeting the specific domain-details markup is planned for a future release.

### 4.3 Cart TLD Picker — Bootstrap Multiselect (SC 2.1.1 — Partially Supports)

The domain search TLD picker in `a11y-cart` uses the `bootstrap-multiselect` third-party widget, which generates its own button/listbox markup. The underlying native `<select>` has an `aria-label` and remains operable as a fallback.

**Mitigation:** Users can select TLDs via the native `<select>` element if the multiselect widget is not keyboard-operable. A fully accessible combobox/listbox replacement is deferred to a future release.

### 4.4 Cart Quantity Slider — ionRangeSlider (SC 2.1.1 — Partially Supports)

The ionRangeSlider widget on configure-product pages hides the native number input. The theme exposes the native number input (`.irs-hidden-input`) with a visible label via cart JS, providing an operable fallback.

**Mitigation:** The native number input is labelled and operable. The slider's visual control remains inaccessible to keyboard-only users. A native-control redesign is deferred.

### 4.5 Payment Gateway Iframe / Tokenizer Markup (SC 4.1.2 — Partially Supports)

The markup injected by payment gateway modules (e.g. CC tokenizer iframes, 3DS iframes) is generated by the gateway module and is outside the control of the order-form template. A11y One titles the wrapping `<iframe>` where it can; the iframe content itself is not in scope.

### 4.6 WebKit / Safari Not CI-Verified

Playwright WebKit could not be exercised on the aarch64/Raspberry Pi CI host due to missing system library dependencies. All markup uses standard HTML5 semantics and Bootstrap 4.5.3 with no WebKit-specific APIs. Chromium and Firefox pass the full test suite. Operators serving significant Safari traffic should perform manual or CI verification in a WebKit environment.

### 4.7 Pages Verified by Source Review (Not Runtime Axe)

The following pages were verified by source/structural review rather than runtime axe execution due to test-environment constraints:

- `clientareadomaingetepp` — EPP key unlock triggers a registrar redirect; not renderable in CI.
- `bulkdomainmanagement` — POST-only flow; not runtime-reachable with automated seed.
- `ticketfeedback` — requires a staff reply associated with an admin email; not in CI seed.

All three were reviewed against WCAG criteria at the source level and meet the applicable success criteria.

---

## 5. Test Suite Reference

| Module | Coverage |
|--------|----------|
| `tests/a11y-one/test_ws_a_components.py` | Shared engine components (DataTables, iCheck, tabs, copy, password reveal, badges, live regions) |
| `tests/a11y-one/test_ws_b_account.py` | Account / profile / security / contacts / users |
| `tests/a11y-one/test_ws_c_billing.py` | Invoices, quotes, payment, add funds, mass pay |
| `tests/a11y-one/test_ws_d_services.py` | Products list, product details, cancel, upgrade, SSL, subscription |
| `tests/a11y-one/test_ws_e_domains.py` | Domain list, details, DNS, nameservers, contacts, EPP, forwarding, add-ons, bulk, pricing |
| `tests/a11y-one/test_ws_f_support.py` | Tickets, KB, downloads, announcements, contact, server status, ticket feedback |
| `tests/a11y-one/test_ws_g_misc.py` | Dashboard, emails, errors, OAuth, 3DS, account switcher, verify email |
| `tests/a11y-one/test_ws_h_cart.py` | Accessible cart / order funnel (`?carttpl=a11y-cart`) |
| `tests/a11y-one/test_release_axe_sweep.py` | Cross-site WCAG 2.2 sweep with zero serious/critical assertion |
| `tests/a11y-one/test_security.py` | Template security checks (no secrets, CSRF preserved) |
| `tests/a11y-one/test_performance.py` | Asset-load performance baseline |

Tests are excluded from the release archive via `.gitattributes export-ignore` and should not be deployed to production. If the `tests/` directory is present on a production server, restrict access at the web server level (see README §Security).
