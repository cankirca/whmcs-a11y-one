{* WS-G banned.tpl
   Base: templates/twenty-one/banned.tpl
   Parent: twenty-one (NOT six)
   Rendered inside site chrome; a11y-one.js loads via footer.
   A11y fixes:
   - Gavel icon: aria-hidden (decorative; meaning conveyed by alert text).
   - role="alert" added explicitly to the alert-danger div (Bootstrap adds
     class only; explicit role ensures SR announces immediately).
   - Single clear error message structure preserved from parent. *}

{* Clear page heading. *}
<h1 class="h3 mb-4">{lang key='bannedtitle'}</h1>
<div class="alert alert-danger" role="alert">
    <strong>
        <i class="fas fa-gavel" aria-hidden="true"></i>
        {lang key='bannedyourip'}
        {$ip}
        {lang key='bannedhasbeenbanned'}
    </strong>
    <ul>
        <li>
            {lang key='bannedbanreason'}:
            <strong>{$reason}</strong>
        </li>
        <li>
            {lang key='bannedbanexpires'}:
            {$expires}
        </li>
    </ul>
</div>
