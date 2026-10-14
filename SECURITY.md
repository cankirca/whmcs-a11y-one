# Security Policy

## Supported versions

| Version | Supported |
| --- | --- |
| 1.0.x | ✅ |

## Reporting a vulnerability

Please report security issues **privately** rather than opening a public issue, using a
[private security advisory](https://github.com/cankirca/whmcs-a11y-one/security/advisories/new).

Include the WHMCS version, the A11y One version, and enough detail to reproduce.

**Response targets:** acknowledgement within 72 hours, an assessment within 7 days, and a fix
or a documented reason for closing within 30 days for confirmed issues. You will be credited in
the advisory and the changelog unless you would rather not be. Please do not disclose publicly
until a fix is available.

## Scope

A11y One is a WHMCS client-area theme made of Smarty templates, one JavaScript file, CSS and
language files. It adds no routes, endpoints or database access of its own. Issues of interest
include script injection through template output, unsafe handling of values passed to the
JavaScript, and anything that weakens an existing WHMCS protection.
