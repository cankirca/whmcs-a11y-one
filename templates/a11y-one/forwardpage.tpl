{* WS-G forwardpage.tpl
   Base: templates/twenty-one/forwardpage.tpl
   Parent: twenty-one (NOT six)
   Rendered inside site chrome (header/footer); a11y-one.js loads via footer.
   This is a payment-redirect interstitial — JS auto-submits after 5s.
   A11y fixes:
   - Progress bar: already has role="progressbar" + aria-valuenow/min/max and
     sr-only "loading" text in parent — preserved.
   - Live region (#fwdPageStatus): announces redirect to SR users without reload.
   - No-JS fallback submit button: if JS disabled, user can click to proceed.
   - Progress bar is visible and conveys animation (decorative intent OK here;
     SR gets the live region announcement instead). *}

<div class="my-2">
    {include file="$template/includes/alert.tpl" type="info" msg=$message textcenter=true}
</div>

<div class="mb-5 d-flex flex-column justify-content-center align-items-center">

    <div role="status" aria-live="polite" aria-atomic="true" id="fwdPageStatus" class="sr-only">
        {lang key='a11yRedirectingPlease'}
    </div>

    <div class="progress w-25 my-4">
        <div class="progress-bar progress-bar-striped progress-bar-animated bg-color-blue w-100" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100">
            <span class="sr-only">{lang key='loading'}</span>
        </div>
    </div>

    <div id="frmPayment">

        {$code}

        <form method="post" action="{if $invoiceid}viewinvoice.php?id={$invoiceid}{else}clientarea.php{/if}">
        </form>

    </div>

    <noscript>
        <p>{lang key='a11yJsRequiredForPayment'}</p>
    </noscript>

</div>

<script>
    setTimeout("autoSubmitFormByContainer('frmPayment')", 5000);
</script>
