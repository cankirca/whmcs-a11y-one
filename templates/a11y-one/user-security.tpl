{* A11y One — user-security.tpl
   Parent: templates/twenty-one/user-security.tpl
   WS-B: Security question form gets aria-labelledby; 2FA status paragraphs get
         aria-live="polite" so AT announces state changes; 2FA modal links already
         have data-modal-class="twofa-setup" in parent — initTwofaModalFocus() in
         a11y-one.js manages focus on open/close; linked-accounts live region
         handled by initLinkedAccountsLiveRegion().
*}
{include file="$template/includes/flashmessage.tpl"}

<p>{lang key='userManagement.settings'}</p>

{if $linkableProviders}
    <div class="card">
        <div class="card-body">
            <h3 class="card-title">{lang key='remoteAuthn.titleLinkedAccounts'}</h3>

            {* WS-B: initLinkedAccountsLiveRegion() in a11y-one.js adds
               aria-live="polite" to #providerLinkingMessages inside this include *}
            {include file="$template/includes/linkedaccounts.tpl" linkContext="clientsecurity"}

            <br />

            {include file="$template/includes/linkedaccounts.tpl" linkContext="linktable"}

            <br />
        </div>
    </div>
{/if}

{if $securityQuestions->count() > 0}
    <div class="card">
        <div class="card-body">
            <h3 class="card-title" id="securityQHeading">{lang key='clientareanavsecurityquestions'}</h3>

            <form method="post"
                  action="{routePath('user-security-question')}"
                  aria-labelledby="securityQHeading">
                {if $user->hasSecurityQuestion()}
                    <div class="form-group">
                        <label for="inputCurrentAns" class="col-form-label">{$user->getSecurityQuestion()}</label>
                        <input type="password" name="currentsecurityqans" id="inputCurrentAns" class="form-control" autocomplete="off" />
                    </div>
                {/if}

                <div class="form-group">
                    <label for="inputSecurityQid" class="col-form-label">{lang key='clientareasecurityquestion'}</label>
                    <select name="securityqid" id="inputSecurityQid" class="form-control custom-select">
                        {foreach $securityQuestions as $question}
                            <option value="{$question->id}">
                                {$question->question}
                            </option>
                        {/foreach}
                    </select>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="inputSecurityAns1" class="col-form-label">{lang key='clientareasecurityanswer'}</label>
                            <input type="password" name="securityqans" id="inputSecurityAns1" class="form-control" autocomplete="new-password" />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="inputSecurityAns2" class="col-form-label">{lang key='clientareasecurityconfanswer'}</label>
                            <input type="password" name="securityqans2" id="inputSecurityAns2" class="form-control" autocomplete="new-password" />
                        </div>
                    </div>
                </div>

                <p>
                    <input class="btn btn-primary" type="submit" name="submit" value="{lang key='clientareasavechanges'}" />
                    <input class="btn btn-default" type="reset" value="{lang key='cancel'}" />
                </p>
            </form>
        </div>
    </div>
{/if}

{if $twoFactorAuthAvailable}
    <div class="card">
        <div class="card-body">
            <h3 class="card-title">{lang key='twofactorauth'}</h3>

            {* WS-B: aria-live="polite" so AT announces 2FA state changes *}
            <p class="twofa-config-link disable{if !$twoFactorAuthEnabled} w-hidden{/if}"
               aria-live="polite" aria-atomic="true">
                {lang key='twofacurrently'} <strong>{lang key='enabled'|strtolower}</strong>
            </p>
            <p class="twofa-config-link enable{if $twoFactorAuthEnabled} w-hidden{/if}"
               aria-live="polite" aria-atomic="true">
                {lang key='twofacurrently'} <strong>{lang key='disabled'|strtolower}</strong>
            </p>

            {if $twoFactorAuthRequired}
                {include file="$template/includes/alert.tpl" type="warning" msg="{lang key="clientAreaSecurityTwoFactorAuthRequired"}"}
            {else}
                {include file="$template/includes/alert.tpl" type="warning" msg="{lang key="clientAreaSecurityTwoFactorAuthRecommendation"}"}
            {/if}

            {* WS-B: data-modal-class="twofa-setup" hooks initTwofaModalFocus()
               to manage focus in/out of the AJAX-loaded 2FA modal *}
            <a href="{routePath('account-security-two-factor-disable')}"
               class="btn btn-danger open-modal twofa-config-link disable{if !$twoFactorAuthEnabled} w-hidden{/if}"
               data-modal-title="{lang key='twofadisable'}"
               data-modal-class="twofa-setup"
               data-btn-submit-label="{lang key='twofadisable'}"
               data-btn-submit-color="danger"
               data-btn-submit-id="btnDisable2FA">
                {lang key='twofadisableclickhere'}
            </a>
            <a href="{routePath('account-security-two-factor-enable')}"
               class="btn btn-success open-modal twofa-config-link enable{if $twoFactorAuthEnabled} w-hidden{/if}"
               data-modal-title="{lang key='twofaenable'}"
               data-modal-class="twofa-setup"
               data-btn-submit-id="btnEnable2FA">
                {lang key='twofaenableclickhere'}
            </a>
        </div>
    </div>
{/if}
