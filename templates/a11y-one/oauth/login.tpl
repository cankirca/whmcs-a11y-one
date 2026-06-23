{* WS-G oauth/login.tpl
   Base: templates/twenty-one/oauth/login.tpl
   Parent: twenty-one (NOT six)
   Rendered inside oauth/layout.tpl (standalone); no site footer; a11y-one.js absent.
   Fixes are self-sufficient markup; scripts.min.js (jQuery) loads from layout.
   A11y fixes:
   - App logo img: alt text set to app name.
   - h2 heading → h1 (layout has no outer h1; login heading is the page h1).
   - Form: aria-label names the form.
   - autocomplete: password field uses "current-password" (was omitted in parent).
   - Labels already present for email + password fields in parent — verified, preserved.
   - Remember-me checkbox: label wraps input (parent already correct) — preserved.
   - Cancel button: onclick retained (needed for OAuth cancel flow).
   - btnCancel: form submit retained as-is (jQuery already available). *}

<div class="content-container">

    {if $appLogo}
        <div class="app-logo">
            <img src="{$appLogo}" alt="{$appName|escape}" />
        </div>
    {/if}

    <h1 class="text-center h2">{lang key='oauth.loginToGrantApp' appName=$appName}</h1>

    <form method="post" action="{$issuerurl}dologin.php" role="form" aria-label="{lang key='oauth.loginToGrantApp' appName=$appName}">
        <div class="content-padded">

            {if $incorrect}
                {include file="$template/includes/alert.tpl" type="error" msg="{lang key='loginincorrect'}" textcenter=true}
            {/if}

            <div class="form-group">
                <label for="inputEmail">{lang key='clientareaemail'}</label>
                <input type="email" name="username" class="form-control" id="inputEmail" placeholder="{lang key='enteremail'}" autocomplete="email" autofocus>
            </div>

            <div class="form-group">
                <label for="inputPassword">{lang key='clientareapassword'}</label>
                <input type="password" name="password" class="form-control" id="inputPassword" placeholder="{lang key='clientareapassword'}" autocomplete="current-password">
            </div>

        </div>

        <div class="action-buttons">
            <div class="float-left">
                <div class="form-check">
                    <label>
                        <input type="checkbox" class="form-check-input" name="rememberme" /> {lang key='loginrememberme'}
                    </label>
                    &bull;
                    <a href="{routePath('password-reset-begin')}">{lang key='forgotpw'}</a>
                </div>
            </div>
            <button type="submit" class="btn btn-primary" id="btnLogin">
                {lang key='login'}
            </button>
            <button type="button" class="btn btn-default" id="btnCancel" onclick="jQuery('#frmCancelLogin').submit()">
                {lang key='cancel'}
            </button>
        </div>

    </form>

</div>

<form method="post" action="{$issuerurl}oauth/authorize.php" id="frmCancelLogin">
    <input type="hidden" name="login_declined" value="yes"/>
    <input type="hidden" name="request_hash" value="{$request_hash|escape:'html'}"/>
</form>
