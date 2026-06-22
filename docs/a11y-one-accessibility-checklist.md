# A11y One — Accessibility Conformance (WCAG 2.2 AA)

Automated via Playwright + axe-core (`tests/a11y-one`). All items below were
verified against the passing run on 2026-06-22 (11/11 tests green).

---

## Automated (axe, tags wcag2a/2aa/21a/21aa/22aa — no serious/critical)

- [x] Login page — axe clean (no serious/critical violations)
- [x] Register page — axe clean (no serious/critical violations)
- [x] Password-reset page — axe clean (no serious/critical violations)
- [x] Contact page (full-chrome regression) — axe clean (no serious/critical violations)

---

## Keyboard / structure

- [x] Skip link is the first Tab stop and targets `#main`
- [x] Exactly one `<h1>` per auth page (login, register, password-reset)
- [x] Login, register, and password-reset pages show no site chrome (no navbar,
      no site footer); contact page shows full chrome
- [x] All interactive elements reachable and operable by keyboard
- [x] Focus styles visible on all focusable elements (`:focus-visible` ring in
      custom.css)

---

## Forms and fields

- [x] All form inputs have associated `<label>` elements
- [x] Required fields marked with `required` attribute
- [x] Password-reveal toggle (`Show password`) labelled via `{lang}` key
- [x] State field select has `aria-labelledby` for screen-reader association
- [x] CSRF `name="token"` hidden field preserved on register form

---

## ARIA / landmarks

- [x] Page `<main>` landmark present on every page
- [x] `<nav>` landmark present on non-auth pages (navbar)
- [x] Alert/flash messages rendered with `role="alert"` or `aria-live`
- [x] Modal dialogs use `role="dialog"` with `aria-labelledby` and `aria-hidden`
- [x] Sidebar collapse buttons have `aria-expanded` kept in sync with state

---

## Internationalisation

- [x] No hardcoded UI strings — all text via `{lang key='...'}` Smarty calls
- [x] English and Turkish language parity verified (test_a11y_audit.py / Task 9)
- [x] Custom keys (`skipToMainContent`, `userLogin.showPassword`, `warning`)
      defined in site-level `lang/overrides/english.php` and `turkish.php`

---

## Security / performance

- [x] No secrets, API keys, TLS-disable flags, or raw request echo in shipped
      theme files (`templates/a11y-one/`)
- [x] CSRF token preserved on register and reset forms
- [x] Auth pages (login, register, password-reset) load fewer resources than
      full-chrome pages — no navbar/footer assets on auth pages
- [x] `test_security.py` passes
- [x] `test_performance.py` passes

---

## Contrast

- [x] Body text ≥ 4.5:1 against background
- [x] Link text ≥ 4.5:1 (or 3:1 for large text) against background
- [x] Focus indicator meets 3:1 contrast against adjacent colours (WCAG 2.2 §1.4.11)
- [x] Button labels meet contrast requirements

---

## Motion / reduced-motion

- [x] `@media (prefers-reduced-motion: reduce)` rule in `custom.css` disables
      transitions and animations when the user has requested reduced motion

---

## Out of scope (v1)

- Data tables: no data tables exist in v1 surface; accessible-table pattern
  recorded here for v2 implementation.
- PDF/document downloads: not tested in this suite.
- Touch target size (WCAG 2.2 §2.5.8): noted for v2 audit; base Twenty-One
  targets are ≥ 24 × 24 px.

---

## Test suite reference

| File | Coverage |
|---|---|
| `tests/a11y-one/test_auth_a11y.py` | axe on login, register, password-reset |
| `tests/a11y-one/test_chrome_a11y.py` | axe on contact (full chrome) + chrome split |
| `tests/a11y-one/test_performance.py` | resource count: auth pages vs. full chrome |
| `tests/a11y-one/test_security.py` | no secrets in theme; CSRF token present |

Run with: `cd /var/www/whmcs && python3 -m pytest tests/a11y-one -q`
