{* WS-D Task 3: configuressl-steptwo — a11y-one override.
   Changes vs. parent (twenty-one/configuressl-steptwo.tpl):
   - Validation-method radio group wrapped in <fieldset>+<legend> (WCAG 1.3.1 / 4.1.2).
   - Each radio: class="form-check-input icheck-button" — WS-A iCheck shim makes native
     inputs operble; real <label> wraps each radio+text pair.
   - Each radio carries aria-controls pointing to its panel container.
   - Panel containers: role="region" + aria-label for announced method name.
   - Approver-email sub-group: nested <fieldset>+<legend class="sr-only">.
   - Submit button: explicit aria-label.
   Author: Can Kirca
*}
{if empty($approvalMethods)}
    {assign var="approvalMethods" value=[]}
{/if}
<div class="card">
    <div class="card-body">
        {if $errormessage}
            {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage}
        {/if}
        <form method="post" action="{$smarty.server.PHP_SELF}?cert={$cert}&step=3">

            {* Validation-method radio group: fieldset+legend (WCAG 1.3.1 / 4.1.2) *}
            <fieldset>
                <legend><h2 class="card-title mb-0">{lang key='ssl.selectValidation'}</h2></legend>

                {if empty($approvalMethods) || (!empty($approvalMethods) && in_array('email', $approvalMethods))}
                    <label class="form-check form-check-inline">
                        <input type="radio" class="form-check-input icheck-button" name="approval_method" value="email" checked
                               aria-controls="containerApprovalMethodEmail">
                        <strong class="name">{lang key='ssl.emailMethod'}</strong>
                    </label>
                {/if}
                {if in_array('dns-txt-token', $approvalMethods)}
                    <label class="form-check form-check-inline">
                        <input type="radio" class="form-check-input icheck-button" name="approval_method" value="dns-txt-token"
                               aria-controls="containerApprovalMethodDns">
                        <strong class="name">{lang key='ssl.dnsMethod'}</strong>
                    </label>
                {/if}
                {if in_array('file', $approvalMethods)}
                    <label class="form-check form-check-inline">
                        <input type="radio" class="form-check-input icheck-button" name="approval_method" value="file"
                               aria-controls="containerApprovalMethodFile">
                        <strong class="name">{lang key='ssl.fileMethod'}</strong>
                    </label>
                {/if}
            </fieldset>

            <div class="tab-content pt-3">
                {* Email method panel *}
                <div id="containerApprovalMethodEmail" role="region"
                     aria-label="{lang key='ssl.emailMethod'}">
                    {include file="$template/includes/alert.tpl" type="secondary" msg={lang key='ssl.emailMethodDescription'}}
                    <p>{lang key='ssl.selectEmail'}</p>
                    <div class="row pt-2">
                        <div class="col-sm-10 offset-sm-1">
                            {* Approver-email sub-radios: nested fieldset+legend *}
                            <fieldset>
                                <legend class="sr-only">{lang key='a11ySslApproverEmailGroup'}</legend>
                                <div class="list-group">
                                    {foreach $approveremails as $num => $approveremail}
                                        <div class="list-group-item">
                                            <label class="mb-0">
                                                <input type="radio" class="form-check-input" name="approveremail"
                                                       value="{$approveremail}"{if $num eq 0} checked{/if}>
                                                {$approveremail}
                                            </label>
                                        </div>
                                    {/foreach}
                                </div>
                            </fieldset>
                        </div>
                    </div>
                </div>

                {* DNS method panel *}
                <div id="containerApprovalMethodDns" class="w-hidden" role="region"
                     aria-label="{lang key='ssl.dnsMethod'}">
                    {include file="$template/includes/alert.tpl" type="secondary" msg={lang key='ssl.dnsMethodDescription'}}
                </div>

                {* File method panel *}
                <div id="containerApprovalMethodFile" class="w-hidden" role="region"
                     aria-label="{lang key='ssl.fileMethod'}">
                    {include file="$template/includes/alert.tpl" type="secondary" msg={lang key='ssl.fileMethodDescription'}}
                </div>
            </div>

            <div class="text-center pt-3">
                <button type="submit" class="btn btn-primary" id="btnOrderContinue"
                        aria-label="{lang key='ordercontinuebutton'}">
                    {lang key='ordercontinuebutton'}
                </button>
            </div>

        </form>
    </div>
</div>
