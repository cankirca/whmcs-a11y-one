# A11y One — Accessible WHMCS Client Theme

**A11y One** is an accessibility‑first client area theme for [WHMCS](https://www.whmcs.com/) 9.x.
It is a child theme of the stock **Twenty‑One** theme that keeps Twenty‑One's familiar look while
making every client‑facing page genuinely usable for people who rely on a screen reader or the
keyboard. It targets **WCAG 2.2 Level AA** across the whole client area and ships with a matching
accessible order form.

- **Standard:** WCAG 2.2 AA — verified with automated (axe‑core) and manual testing
- **Parent theme:** `twenty-one` (so it inherits future Twenty‑One updates)
- **Order form:** `a11y-cart` (accessible child of `standard_cart`)
- **Languages:** English and Turkish (extendable)
- **License:** MIT · © 2026 Can Kirca

---

## Why A11y One?

Most themes pass an automated scan but still feel broken with a screen reader: pages share one
generic title, headings announce the wrong thing, menus say “expanded” but can’t be navigated, and
controls have no names. A11y One was built and tested the other way around — from the lived
keyboard/screen‑reader experience inward:

- **Every page has a clear, unique heading and browser title.** No more “Client Area” on every tab.
- **Real menus.** Top‑navigation dropdowns are WAI‑ARIA menu buttons — arrow keys move between items,
  `Esc` closes and returns focus.
- **Landmarks and skip link.** A skip‑to‑content link, a single `main` landmark, and a labelled
  sidebar `nav` so screen‑reader users can jump straight to the content.
- **Accessible widgets.** Native, operable form controls (the inaccessible iCheck overlay is
  replaced), keyboard‑operable data tables with announced sorting/paging, an accessible ticket star
  rating, labelled markdown editor and file uploads, copy‑to‑clipboard buttons with live
  announcements, and accessible modals with focus management.
- **Visible focus everywhere**, AA‑contrast colors, and status conveyed by text — never color alone.
- **List filters** tucked into a single, keyboard‑operable “Filters” disclosure under the heading.
- **Internationalised:** all interface and assistive‑technology strings come from language files.

A full, criterion‑by‑criterion conformance report is in
[`docs/a11y-one/CONFORMANCE.md`](docs/a11y-one/CONFORMANCE.md).

---

## Requirements

| | |
|---|---|
| WHMCS | 9.x |
| Parent theme | `twenty-one` (ships with WHMCS) |
| PHP | 8.1+ (WHMCS 9 requirement) |
| Browsers | Current Chromium, Firefox, Safari/WebKit, and Edge |

---

## Installation

> A11y One is a child theme. You install its files alongside your existing WHMCS theme files —
> nothing in WHMCS core or in `twenty-one` is modified.

### 1. Copy the theme files

Copy these folders from this repository into your WHMCS installation, preserving the paths:

```
templates/a11y-one/                  →  <whmcs>/templates/a11y-one/
templates/orderforms/a11y-cart/      →  <whmcs>/templates/orderforms/a11y-cart/
```

### 2. Merge the language keys  ⚠️ required

A11y One adds interface/screen‑reader strings that **must live in your site‑level language
overrides** — WHMCS does **not** auto‑load theme‑level `lang/overrides`. Merge the keys from this
repo’s reference files into your site files (create them if they don’t exist):

```
lang/overrides/english.php   →  merge into  <whmcs>/lang/overrides/english.php
lang/overrides/turkish.php   →  merge into  <whmcs>/lang/overrides/turkish.php
```

The same keys are also bundled at `templates/a11y-one/lang/overrides/` as a reference copy.
If a page shows a raw key name (e.g. `a11yDashboard`) instead of text, this step was missed.

### 3. Activate the theme

- **Client theme:** *Configuration → System Settings → General → Ordering* (or *Themes*) →
  set the **Client Area Template** to **A11y One**.
- **Order form:** set the **Default Order Form Template** to **A11y Cart**. (You can also preview
  per request by appending `&carttpl=a11y-cart` to a cart URL.)

### 4. Clear the template cache

```
rm -f <whmcs>/templates_c/*
```

A post‑install checklist lives in [`docs/a11y-one/PACKAGING.md`](docs/a11y-one/PACKAGING.md).

---

## Language support

Built‑in: **English** and **Turkish**, with full key parity. To add a language, translate the keys
in `lang/overrides/english.php` into your site‑level `lang/overrides/<language>.php`.

---

## Accessibility & conformance

- **Target:** WCAG 2.2 Level AA.
- **Testing:** an automated [axe‑core](https://github.com/dequelabs/axe-core) sweep across 30+ page
  types (zero serious/critical violations), per‑page Playwright checks, and manual screen‑reader and
  keyboard testing.
- **Report:** [`docs/a11y-one/CONFORMANCE.md`](docs/a11y-one/CONFORMANCE.md) (VPAT‑style) lists every
  relevant success criterion, the testing method, and the small set of documented limitations
  (e.g. third‑party widgets such as the TLD multiselect and quantity slider, which always provide a
  labelled native fallback).

Found an accessibility problem? Please open an issue — real‑world AT feedback is the most valuable
kind.

---

## Development & testing

The accessibility test suite (not shipped in the release package) lives under `tests/a11y-one/` and
uses Python [Playwright](https://playwright.dev/python/) + `axe-playwright-python`.

```bash
pip install playwright axe-playwright-python pytest
playwright install chromium firefox
# point the suite at your dev install and run:
cd tests/a11y-one && pytest -q
```

See `tests/a11y-one/fixtures/` for the idempotent, CLI‑only seed/teardown helpers used to create
test data.

---

## Project layout

```
templates/a11y-one/          The theme (child of twenty-one)
  js/a11y-one.js             The accessibility engine (loaded site-wide)
  css/custom.css             Contrast, focus, and layout overrides
  includes/, error/, oauth/  Overridden partials and standalone pages
  lang/overrides/            Reference copy of the language keys (to merge)
templates/orderforms/a11y-cart/   Accessible order form (child of standard_cart)
lang/overrides/              The language keys to merge into your site
docs/a11y-one/               README, CONFORMANCE, CHANGELOG, PACKAGING
tests/a11y-one/              Playwright + axe accessibility test suite
```

---

## Contributing

Issues and pull requests are welcome — especially screen‑reader/keyboard findings and translations.
Please keep the project’s conventions: all user‑facing strings via language files, output escaped,
WCAG 2.2 AA maintained, and no change that breaks Twenty‑One’s visual identity.

---

## License

[MIT](LICENSE) © 2026 **Can Kirca** · <cankirca@gmail.com> · [github.com/cankirca](https://github.com/cankirca)
