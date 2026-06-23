{* A11y One — clientareasecurity.tpl
   Parent: templates/twenty-one/clientareasecurity.tpl
   WS-B: SSO toggle gets explicit sr-only label and aria-labelledby; status text
         spans wrapped in aria-live region; initBootstrapSwitchA11y() in
         a11y-one.js adds role=switch + aria-checked to .bootstrap-switch wrapper.
*}
{if $showSsoSetting}
    <div class="card">
        <div class="card-body">
            <h3 class="card-title" id="ssoHeading">{lang key='sso.title'}</h3>

            {include file="$template/includes/alert.tpl" type="success" msg="{lang key='sso.summary'}"}

            <form id="frmSingleSignOn">
                <input type="hidden" name="token" value="{$token}" />
                <input type="hidden" name="action" value="security" />
                <input type="hidden" name="toggle_sso" value="1" />
                <div class="p-2">
                    {* WS-B: sr-only label gives the bootstrapSwitch an accessible name *}
                    <label for="inputAllowSso" class="sr-only">{lang key='wsb.ssoToggleLabel'}</label>
                    <input type="checkbox"
                           name="allow_sso"
                           class="toggle-switch-success"
                           id="inputAllowSso"
                           aria-labelledby="ssoHeading"
                           {if $isSsoEnabled}checked{/if}>
                    &nbsp;
                    {* WS-B: aria-live region so AT announces SSO state changes *}
                    <span aria-live="polite" aria-atomic="true">
                        <span id="ssoStatusTextEnabled"{if !$isSsoEnabled} style="display: none;"{/if}>
                            {lang key='sso.enabled'}
                        </span>
                        <span id="ssoStatusTextDisabled"{if $isSsoEnabled} style="display: none;"{/if}>
                            {lang key='sso.disabled'}
                        </span>
                    </span>
                </div>
            </form>

            <p>{lang key='sso.disablenotice'}</p>
        </div>
    </div>
{/if}
