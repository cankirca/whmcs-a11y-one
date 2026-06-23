{* WS-G user-verify-email.tpl
   Base: templates/twenty-one/user-verify-email.tpl
   Parent: twenty-one (NOT six)
   Rendered inside site chrome; a11y-one.js loads via footer.
   A11y fixes:
   - Status icons (check/clock/times): aria-hidden (decorative; meaning in text).
   - Arrow icon in CTA link: aria-hidden.
   - Resend button: aria-live region (#verifyEmailStatus) announces AJAX result.
     The existing btn-resend-verify-email class is wired in WHMCS core JS to
     update the data-email-sent / data-error-msg targets.
     We add a data-status-target pointing at the live region so a small WS-G
     JS helper (appended to a11y-one.js) can relay the outcome.
   - h2 headings for state messages are correct (page is inside client-area chrome
     which has h1 via the page title); preserved from parent.
   Note: the resend AJAX is handled by WHMCS core scripts.min.js; we only need
   to announce the result. See initVerifyEmailLiveRegion() in a11y-one.js. *}

<div class="card mw-540 mb-md-4 mt-md-4">
    <div class="card-body px-sm-5 py-5 text-center">
        {if $success}
            <h2>
                <i class="fas fa-check fa-2x text-success" aria-hidden="true"></i><br>
                {lang key="emailVerification.success"}
            </h2>
        {elseif $expired}
            <h2>
                <i class="far fa-clock fa-2x text-warning" aria-hidden="true"></i><br>
                {lang key="emailVerification.expired"}
            </h2>

            {if $loggedin}
                <div id="verifyEmailStatus" role="status" aria-live="polite" aria-atomic="true" class="sr-only"></div>
                <button class="btn btn-default btn-lg btn-resend-verify-email"
                    data-email-sent="{lang key='emailSent'}"
                    data-error-msg="{lang key='error'}"
                    data-status-target="#verifyEmailStatus"
                    data-uri="{routePath('user-email-verification-resend')}">
                    {lang key='resendEmail'}
                </button>
            {else}
                <p>{lang key="emailVerification.loginToRequest"}</p>
            {/if}
        {else}
            <h2>
                <i class="fas fa-times fa-2x text-danger" aria-hidden="true"></i><br>
                {lang key="emailVerification.notFound"}
            </h2>

            {if !$loggedin}
                <p>{lang key="emailVerification.loginToRequest"}</p>
            {/if}
        {/if}

        <a href="{routePath('login-index')}" class="btn btn-primary btn-lg mt-4">
            {lang key="orderForm.continueToClientArea"}
            &nbsp;
            <i class="fa fa-arrow-right" aria-hidden="true"></i>
        </a>

    </div>
</div>
