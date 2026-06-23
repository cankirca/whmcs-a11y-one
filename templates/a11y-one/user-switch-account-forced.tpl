{* WS-G user-switch-account-forced.tpl
   Base: templates/twenty-one/user-switch-account-forced.tpl
   Parent: twenty-one (NOT six)
   Rendered inside site chrome; a11y-one.js loads via footer.
   A11y fixes:
   - Arrow icon inside submit button: aria-hidden (decorative).
   - d-flex/justify-content-center wrapper: preserved from parent but simplified
     so the form acts as block (button + link in normal flow).
   - Cancel link is a real <a> href (correct in parent) — preserved. *}

<div class="card mw-540">
    <div class="card-body">
        <p>{lang key="switchAccount.forcedSwitchRequest"}</p>
        <div class="d-flex justify-content-center py-3">
            <p>
                <strong>
                    {$requiredClient->fullName}
                    {if $requiredClient->companyName}
                        ({$requiredClient->companyName})
                    {/if}
                </strong>
                <br>
                {$requiredClient->email}
            </p>
        </div>
        <form method="post" action="{routePath('user-accounts')}">
            <div class="d-flex justify-content-center">
                <input type="hidden" name="id" value="{$requiredClient->id}" >
                <button type="submit" class="btn btn-primary mr-3">
                    {lang key="continue"}
                    <i class="fas fa-arrow-right" aria-hidden="true"></i>
                </button>
                <a href="{routePath('clientarea-home')}" class="btn btn-default">
                    {lang key="switchAccount.cancelAndReturn"}
                </a>
            </div>
        </form>
    </div>
</div>
