{* WS-G error/unknown-routepath.tpl
   Base: templates/twenty-one/error/unknown-routepath.tpl
   Parent: twenty-one (NOT six)
   Rendered inside site chrome; a11y-one.js loads via footer.
   Parent includes page-not-found.tpl then adds an alert-info block.
   A11y fixes:
   - This template itself only adds the "invalid link" notice; the 404 fixes
     live in error/page-not-found.tpl (overridden separately).
   - The alert-info div: add role="alert" so SR announces it immediately.
   - Referrer link: already uses real href (the $referrer var) — preserved.
     Escape applied on both href and text (same as parent). *}

{include file="$template/error/page-not-found.tpl"}

<div class="alert alert-info text-center mb-5" role="alert">
    Sorry, but the previous page (<a href="{$referrer|escape}">{$referrer|escape}</a>) provided an invalid page link.
</div>
