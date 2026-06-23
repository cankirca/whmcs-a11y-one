{* WS-G oauth/login-twofactorauth.tpl
   Base: templates/twenty-one/oauth/login-twofactorauth.tpl
   Parent: twenty-one (NOT six)
   Rendered inside oauth/layout.tpl (standalone); no site footer; a11y-one.js absent.
   scripts.min.js (jQuery) loads from layout.
   A11y fixes:
   - h2 → h1 (standalone layout; no outer h1 from layout).
   - Backup code input: explicit <label> (was missing in parent — unlabelled input).
   - "Use backup code" link <a href="#" onclick=...> → <button type="button">.
   - Panel toggle: JS delegated listener (no inline onclick on the button itself).
   - Both cancel buttons retained (btnCancel, btnCancel2) for OAuth flow.
   - autocomplete="one-time-code" on backup code input (helps password managers). *}

<div class="content-container">

    <br />

    <h1 class="text-center h2">{lang key='twofactorauth'}</h1>

    <form method="post" action="{routePath('login-two-factor-challenge-verify')}" role="form" aria-label="{lang key='twofactorauth'}">

        <div id="loginWithBackupCode"{if !$backupcode} class="w-hidden"{/if}>
            <div class="content-padded">
                {include file="$template/includes/alert.tpl" type="warning" msg="{lang key='twofabackupcodelogin'}" textcenter=true}
                <label for="backupCodeInput" class="sr-only">{lang key='a11yBackupCodeLabel'}</label>
                <input type="text" id="backupCodeInput" name="code" class="form-control" autocomplete="one-time-code">
                <br />
                <button type="submit" name="backupcode" value="1" class="btn btn-primary btn-block" id="btnLogin">
                    {lang key='login'} &raquo;
                </button>
            </div>
            <div class="action-buttons">
                <button type="button" class="btn btn-default" id="btnCancel" onclick="jQuery('#frmCancelLogin').submit()">
                    {lang key='cancel'}
                </button>
            </div>
        </div>

        <div id="loginWithSecondFactor"{if $backupcode} class="w-hidden"{/if}>
            <div class="content-padded">
                {if $incorrect}
                    {include file="$template/includes/alert.tpl" type="error" msg="{lang key='twofa2ndfactorincorrect'}" textcenter=true}
                {elseif $error}
                    {include file="$template/includes/alert.tpl" type="error" msg=$error textcenter=true}
                {else}
                    {include file="$template/includes/alert.tpl" type="warning" msg="{lang key='twofa2ndfactorreq'}" textcenter=true}
                {/if}
                {$challenge}
            </div>
            <div class="action-buttons">
                <div class="float-left text-left small">
                    {lang key='twofacantaccess2ndfactor'}<br />
                    <button type="button" class="btn btn-link btn-sm" id="btnUseBackupCode">
                        {lang key='twofaloginusingbackupcode'}
                    </button>
                </div>
                <button type="button" class="btn btn-default" id="btnCancel2" onclick="jQuery('#frmCancelLogin').submit()">
                    {lang key='cancel'}
                </button>
            </div>
        </div>

    </form>

</div>

<form method="post" action="{$issuerurl}oauth/authorize.php" id="frmCancelLogin">
    <input type="hidden" name="login_declined" value="yes"/>
    <input type="hidden" name="request_hash" value="{$request_hash|escape:'html'}"/>
</form>

<script>
    (function () {
        var btnBackup = document.getElementById('btnUseBackupCode');
        if (btnBackup) {
            btnBackup.addEventListener('click', function () {
                var sf = document.getElementById('loginWithSecondFactor');
                var bc = document.getElementById('loginWithBackupCode');
                if (sf) { sf.classList.add('w-hidden'); }
                if (bc) { bc.classList.remove('w-hidden'); }
                var codeInput = document.getElementById('backupCodeInput');
                if (codeInput) { codeInput.focus(); }
            });
        }
    }());
</script>
