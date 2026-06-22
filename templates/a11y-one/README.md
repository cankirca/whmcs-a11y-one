# A11y One

An accessible (WCAG 2.2 AA) child theme of the WHMCS Twenty-One theme, with a
fast, minimal login/registration experience. Fully localised in English and Turkish.

- **Author:** Can Kirca <cankirca@gmail.com> — https://github.com/cankirca
- **License:** MIT
- **Parent theme:** twenty-one
- **WHMCS:** 9.x

## Install

1. Copy the `a11y-one` folder into `templates/` in your WHMCS installation.
2. **Copy the language override files** into your WHMCS root `lang/overrides/`
   directory (create it if it does not exist):

   ```
   cp templates/a11y-one/lang/overrides/english.php  lang/overrides/english.php
   cp templates/a11y-one/lang/overrides/turkish.php  lang/overrides/turkish.php
   ```

   > **Why?** WHMCS does not auto-load `lang/overrides/` from inside a theme
   > folder. The custom strings this theme uses (`skipToMainContent`,
   > `userLogin.showPassword`, `warning`) must live in the site-level
   > `lang/overrides/` directory to resolve correctly. Without this step the
   > skip link, the password-reveal button and the alert heading will show their
   > raw key names instead of translated text.
   >
   > If you already have a `lang/overrides/english.php` (or `turkish.php`),
   > **merge** the keys from the theme copies into your existing files rather
   > than overwriting them.

   The copies shipped under `templates/a11y-one/lang/overrides/` are provided
   for reference only — they are not loaded automatically.

3. In the Admin Area, **Configuration > General Settings > General**, set
   **Template** to "A11y One", or preview first with `?systpl=a11y-one` on any
   client-area URL.

## What it does

- A dedicated minimal layout for login, registration, password-reset and 2FA
  pages (no navbar/footer chrome) for faster, simpler sign-in.
- Site-wide accessibility: skip link, landmarks, visible focus, corrected
  contrast, labelled fields, accessible alerts/modals, keyboard-operable
  navigation — targeting WCAG 2.2 AA.

## Accessibility & languages

Conformance target: WCAG 2.2 AA. Localised in English and Turkish; all strings
come from WHMCS language files.
