{* WS-G oauth/authorize.tpl
   Base: templates/twenty-one/oauth/authorize.tpl
   Parent: twenty-one (NOT six)
   Rendered inside oauth/layout.tpl (standalone); no site footer; a11y-one.js absent.
   A11y fixes:
   - App logo img: alt text set to app name (was empty in parent).
   - h2 → h1 (standalone layout; no outer h1 from layout).
   - Permissions list: aria-labelledby ties it to the intro paragraph for context.
   - Form aria-label: names the consent form.
   - Consent buttons already have text content — preserved.
   - form action="#": WHMCS submits via JS; harmless. *}

<div class="content-container">

    {if $appLogo}
        <div class="app-logo">
            <img src="{$appLogo}" alt="{$appName|escape}" />
        </div>
    {/if}

    <h1 class="text-center h2">{lang key='oauth.authoriseAppToAccess' appName=$appName}</h1>

    <div class="content-padded">
        <div class="permission-grants">
            <p id="permissionsIntro">{lang key='oauth.willBeAbleTo'}:</p>
            <ul aria-labelledby="permissionsIntro">
                {foreach $requestedPermissions as $permission}
                    <li>{$permission}</li>
                {/foreach}
            </ul>
        </div>
    </div>

    <form method="post" action="#" role="form" aria-label="{lang key='oauth.authoriseAppToAccess' appName=$appName}">
        <input type="hidden" name="token" value="{$token}" />
        <input type="hidden" name="request_hash" value="{$request_hash}" />
        <input type="hidden" name="oauth_token" value="{$oauthToken}" />
        {foreach $requestedAuthorizations as $auth}
            <input type="hidden" name="authz[]" value="{$auth}" />
        {/foreach}
        <div class="action-buttons">
            <button name="userAuthorization" id="userAuthorizationAccepted" value="yes" type="submit" class="btn btn-primary">
                {lang key='oauth.authorise'}
            </button>
            <button name="userAuthorization" id="userAuthorizationDeclined" value="no" type="submit" class="btn btn-default">
                {lang key='cancel'}
            </button>
        </div>
    </form>

</div>
