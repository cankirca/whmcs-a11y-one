{* WS-G viewemail.tpl
   Base: templates/twenty-one/viewemail.tpl
   Parent: twenty-one (NOT six)
   STANDALONE page (own <!DOCTYPE>, no site chrome, no footer/a11y-one.js).
   a11y-one.js does NOT load on this page — all fixes are self-sufficient markup.
   A11y fixes:
   - html lang: locale-aware ({if $language=='turkish'}tr{else}en{/if}).
   - skip link to main content.
   - <main> landmark wraps card body.
   - h1 instead of h2 for the email subject (only heading on page).
   - Envelope icon inside h1: aria-hidden.
   - Attachment paperclip icons: aria-hidden.
   - iframe: title attribute describing content.
   - custom.css loads for contrast (via assetExists).
   - No a11y-one.js needed: page has no interactive widgets requiring JS helpers. *}

<!DOCTYPE html>
<html lang="{if $language=='turkish'}tr{else}en{/if}">
<head>
    <meta charset="utf-8">
    <title>{lang key='clientareaemails'} - {$companyname}</title>

    {include file="$template/includes/head.tpl"}

</head>
<body id="popup-backdrop">
    <a class="sr-only sr-only-focusable" href="#main-body">{lang key='a11ySkipToContent'}</a>
    <main id="main-body">
        <div class="card bg-default">
            <div class="card-header">
                <h1 class="h2 popup-header-padding">
                    <i class="far fa-envelope" aria-hidden="true"></i>
                    {$subject}
                </h1>
                {if is_array($attachments) && count($attachments) > 0}
                    <div class="popup-header-padding">
                        {foreach $attachments as $attachedFile}
                            <i class="fal fa-paperclip" aria-hidden="true"></i> {$attachedFile}{if !$attachedFile@last}<br>{/if}
                        {/foreach}
                    </div>
                {/if}
            </div>
            <div class="card-body">
                <iframe width="100%" height="380" frameborder="0" srcdoc="{$message|escape}" title="{$subject|escape}"></iframe>
            </div>
            <div class="card-footer text-center">
                <button type="button" class="btn btn-primary" onclick="window.close()">
                    {lang key='closewindow'}
                </button>
            </div>
        </div>
    </main>
</body>
</html>
