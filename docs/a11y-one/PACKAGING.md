# A11y One — Release Packaging Guide

This document describes how to build the shippable release archive for the A11y One theme.

---

## 1. Shippable Paths

The release archive contains exactly the following paths from the repository root:

### Theme templates

```
templates/a11y-one/
```

All files under this directory are included: `.tpl` files, `js/a11y-one.js`, `css/custom.css`, `theme.yaml`, `LICENSE`, `README.md`, and the `includes/`, `lang/`, and `payment/` subdirectories.

### Order-form templates

```
templates/orderforms/a11y-cart/
```

All files under this directory are included: `.tpl` files, `js/a11y-cart.js`, `css/custom.css`, and `theme.yaml`.

### Language override keys — merge, do not copy wholesale

```
lang/overrides/english.php
lang/overrides/turkish.php
```

**Important:** These files are site-level WHMCS override files that may also contain keys added by other themes or customisations. They are included in the release so installers can see which keys to add, but they must **not** be dropped wholesale onto a site that already has its own `lang/overrides/` files. Installers should merge the A11y One key blocks (marked `/* === WS-A === */` through `/* === WS-H Cart === */`, plus flat `a11y`-prefixed keys) into their existing files.

See `docs/a11y-one/README.md §Installation Step 2` for the merge procedure.

---

## 2. Excluded Paths

The following paths are **excluded** from the release archive via `.gitattributes export-ignore` and must never appear in a distributed package:

| Path | Reason |
|------|--------|
| `tests/` | Development test suite and database seed/teardown scripts. The seed (`tests/a11y-one/seed.php`) and teardown scripts write to the database and must not be web-accessible. |
| `docs/` | Developer and internal documentation (including this file). End users receive only the theme files. |
| `.superpowers/` | Build ledger and internal planning files. |
| `.claude/` | AI-assistant session memory. |
| `.git/` | Git internals (automatically excluded by `git archive`). |

Verify the exclusion rules are in place before building:

```bash
grep 'export-ignore' /var/www/whmcs/.gitattributes
```

Expected output:

```
tests/ export-ignore
docs/ export-ignore
.superpowers/ export-ignore
.claude/ export-ignore
```

---

## 3. Building the Release Archive

Use `git archive` to produce a clean archive that honours the `.gitattributes export-ignore` rules:

```bash
# From the WHMCS repository root, on the release branch:
git archive --format=zip --prefix=a11y-one-1.0.0/ HEAD \
    templates/a11y-one \
    templates/orderforms/a11y-cart \
    lang/overrides/english.php \
    lang/overrides/turkish.php \
    -o /tmp/a11y-one-1.0.0.zip
```

Or as a tarball:

```bash
git archive --format=tar.gz --prefix=a11y-one-1.0.0/ HEAD \
    templates/a11y-one \
    templates/orderforms/a11y-cart \
    lang/overrides/english.php \
    lang/overrides/turkish.php \
    | gzip > /tmp/a11y-one-1.0.0.tar.gz
```

**Note on path selection:** Specifying explicit paths (`templates/a11y-one ...`) in the `git archive` call is the safest approach — it ensures that nothing else in the repository root (WHMCS core files, other themes, configuration) is accidentally bundled. The `.gitattributes export-ignore` rules are an additional safety net that silently strips the listed paths even if they match a broader path spec.

### Verify the archive contents

```bash
# List the archive to confirm only theme files are present:
unzip -l /tmp/a11y-one-1.0.0.zip | head -60

# Confirm excluded paths are absent:
unzip -l /tmp/a11y-one-1.0.0.zip | grep -E 'tests/|docs/|\.superpowers/|\.claude/'
# Expected: no output (zero matches)
```

---

## 4. Post-Install Checklist

Run through this checklist after deploying A11y One to a site:

### Templates

- [ ] `<whmcs_root>/templates/a11y-one/` directory exists and contains `theme.yaml`, `header.tpl`, `footer.tpl`, `js/a11y-one.js`, `css/custom.css`.
- [ ] `<whmcs_root>/templates/orderforms/a11y-cart/` directory exists and contains `theme.yaml`, `common.tpl`, `js/a11y-cart.js`.
- [ ] Parent theme `twenty-one` is present at `<whmcs_root>/templates/twenty-one/`.
- [ ] Parent order form `standard_cart` is present at `<whmcs_root>/templates/orderforms/standard_cart/`.

### Language overrides

- [ ] `<whmcs_root>/lang/overrides/english.php` contains the A11y One key blocks (`/* === WS-A === */` through `/* === WS-H Cart === */`).
- [ ] `<whmcs_root>/lang/overrides/turkish.php` contains matching Turkish keys.
- [ ] Both files are readable by the web server user.

### Template cache

- [ ] Smarty template cache cleared: `rm -f <whmcs_root>/templates_c/*`
- [ ] PHP opcode cache cleared if applicable (e.g. `php -r "opcache_reset();"` or web server reload).

### Activation

- [ ] A11y One is set as the active client theme in WHMCS admin (Configuration → General Settings → Template).
- [ ] (Optional) Order form template set to `a11y-cart` in WHMCS admin (Configuration → General Settings → Order).

### Security

- [ ] The `tests/` directory is either absent on the production server (preferred — deploy from the release archive, not a git checkout) or blocked at the web server level.

  **Nginx:**
  ```nginx
  location ~* ^/tests/ {
      deny all;
      return 403;
  }
  ```

  **Apache:**
  ```apache
  <Directory "<whmcs_root>/tests">
      Require all denied
  </Directory>
  ```

- [ ] Confirm `seed.php` and `teardown.php` return 403 (or are absent) from a browser.

### Smoke tests

- [ ] Load the client-area login page (`/index.php?rp=/login`) — the skip link is visible on first Tab press.
- [ ] Load a client-area page while logged in — the `#main-body` landmark is present (inspect with browser devtools or a screen reader).
- [ ] Run an axe-core browser extension check on the login and dashboard pages — confirm zero critical/serious violations.
- [ ] (Optional) Preview the cart: `<whmcs_root>/cart.php?carttpl=a11y-cart` — confirm the cart renders and add-to-cart buttons have descriptive accessible names.

---

## 5. File Counts (Reference)

For sanity-checking the archive, approximate file counts for v1.0.0:

| Path | Approx. files |
|------|--------------|
| `templates/a11y-one/` (all subdirs) | ~70 files |
| `templates/orderforms/a11y-cart/` | ~15 files |
| `lang/overrides/english.php` | 1 file |
| `lang/overrides/turkish.php` | 1 file |

Exact counts will vary if WHMCS adds or renames parent templates between minor releases.
