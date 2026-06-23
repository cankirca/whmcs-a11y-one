{* WS-G user-switch-account.tpl
   Base: templates/twenty-one/user-switch-account.tpl
   Parent: twenty-one (NOT six)
   Rendered inside site chrome (header/footer); a11y-one.js loads via footer.
   initAriaDisabledLinks() from shared layer covers disabled links — but here
   we replace <a href="#"> with real <button> elements which is cleaner.
   A11y fixes:
   - Account chooser: <a href="#"> onclick → <button type="button"> with data-id.
     Each button has visible text (displayName) — SR reads the name directly.
   - Closed/disabled accounts: <button disabled aria-disabled="true"> instead of
     a styled <a class="disabled"> which was not reachable by keyboard.
   - Labels and badges inside buttons remain readable by AT.
   - Form submit is triggered from JS on button click (delegated; no inline onclick). *}

<div class="card mw-540">
    <div class="card-body">
        {include file="$template/includes/flashmessage.tpl"}

        {if $accounts->count() == 0}
            <p>{lang key="switchAccount.noneFound"}</p>
            <p>{lang key="switchAccount.createInstructions"}</p>
            <p>
                <a href="{routePath('cart-index')}" class="btn btn-default">
                    {lang key="shopNow"}
                </a>
            </p>
            <br><br>
        {else}
            <p>{lang key="switchAccount.choose"}</p>

            <div class="select-account">
                {foreach $accounts as $account}
                    {if $account->status == 'Closed'}
                        <button type="button"
                            class="btn btn-default w-100 text-left mb-1"
                            data-id="{$account->id}"
                            disabled
                            aria-disabled="true">
                            {$account->displayName}
                            {if $account->authedUserIsOwner()}
                                <span class="label label-info">{lang key="clientOwner"}</span>
                            {/if}
                            <span class="label label-default">{$account->status}</span>
                        </button>
                    {else}
                        <button type="button"
                            class="btn btn-default w-100 text-left mb-1"
                            data-id="{$account->id}">
                            {$account->displayName}
                            {if $account->authedUserIsOwner()}
                                <span class="label label-info">{lang key="clientOwner"}</span>
                            {/if}
                        </button>
                    {/if}
                {/foreach}
            </div>
        {/if}
    </div>
</div>

<form method="post" action="{routePath('user-accounts')}">
    <input type="hidden" name="id" value="" id="inputSwitchAcctId">
</form>

<script>
    (function () {
        document.querySelectorAll('.select-account button[data-id]').forEach(function (btn) {
            if (btn.disabled) { return; }
            btn.addEventListener('click', function () {
                document.getElementById('inputSwitchAcctId').value = this.getAttribute('data-id');
                this.closest('.card').nextElementSibling.submit();
            });
        });
    }());
</script>
