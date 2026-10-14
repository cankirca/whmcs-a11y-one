# Contributing

Thanks for considering a contribution. A11y One exists because many people only find out a page
is unusable when they try to use it with a keyboard or a screen reader, so reports from real
assistive-technology use are as welcome as code.

## What this project is

An accessibility-first child theme of WHMCS's stock `twenty-one` theme, plus an accessible
order form (`a11y-cart`, a child of `standard_cart`). It targets WCAG 2.2 Level AA.

- Nothing in WHMCS core or in `twenty-one` is modified; everything lives in the child themes.
- Interface and assistive-technology strings come from `lang/overrides/` and must exist in both
  English and Turkish.
- Look and feel stays close to Twenty-One.

## Especially welcome

- Screen-reader and browser combinations not yet covered (NVDA, JAWS, VoiceOver, Orca, TalkBack).
- Client-area pages or WHMCS versions where something is announced wrongly or unreachable.
- Additional translations of the language overrides.

## Before opening a pull request

Please state in the pull request:

- which screen reader and browser you tested with, and on which OS,
- what you heard before and after,
- that keyboard operation works end to end,
- that there is no visual regression for sighted mouse users.

Explain **why** in comments, not what. Commit messages: a short imperative subject, then a body
explaining the reasoning.

## Reporting security issues

Please don't open a public issue. See [SECURITY.md](SECURITY.md).

## Licence

By contributing you agree that your contributions are licensed under the [MIT Licence](LICENSE).
