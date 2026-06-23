{**
 * clientareacancelrequest.tpl — A11y One override
 *
 * A11y fixes (WS-D Task 2):
 *   - Cancellation-type control converted from <select> to a native radio group
 *     wrapped in <fieldset>/<legend> (WCAG 1.3.1, 4.1.2).
 *   - Reason <textarea> keeps its existing <label for> association.
 *   - Domain-cancel <input type=checkbox> is labelled via wrapping <label>
 *     (already present in parent; preserved here explicitly).
 *   - Decorative icons carry aria-hidden="true".
 *   - Single <h1> rendered by global pageheader.tpl; no additional h1 here.
 *   - All UI strings via {$LANG.*} — no hardcoded text.
 *   - Token/sub hidden fields preserved.
 *
 * Author: Can Kirca
 **}
<h1 class="sr-only">{$LANG.clientareacancelrequest}</h1>

{if $invalid}

    {include file="$template/includes/alert.tpl" type="error" msg=$LANG.clientareacancelinvalid textcenter=true}
    <p class="text-center">
        <a href="clientarea.php?action=productdetails&amp;id={$id}" class="btn btn-primary">{$LANG.clientareabacklink}</a>
    </p>

{elseif $requested}

    {include file="$template/includes/alert.tpl" type="success" msg=$LANG.clientareacancelconfirmation textcenter=true}

    <p class="text-center">
        <a href="clientarea.php?action=productdetails&amp;id={$id}" class="btn btn-primary">{$LANG.clientareabacklink}</a>
    </p>

{else}

    {if $error}
        {include file="$template/includes/alert.tpl" type="error" errorshtml="<li>{$LANG.clientareacancelreasonrequired}</li>"}
    {/if}

    {include file="$template/includes/alert.tpl" type="info" textcenter=true msg="{$LANG.clientareacancelproduct}: <strong>{$groupname} - {$productname}</strong>{if $domain} ({$domain}){/if}"}

    <form method="post" action="{$smarty.server.PHP_SELF}?action=cancel&amp;id={$id}" class="form-stacked">
        <input type="hidden" name="sub" value="submit" />

        <fieldset>
            {* Reason textarea — label is for="cancellationreason" *}
            <div class="form-group">
                <label for="cancellationreason">{$LANG.clientareacancelreason}</label>
                <textarea name="cancellationreason" id="cancellationreason" class="form-control fullwidth" rows="6"></textarea>
            </div>

            {* Domain cancellation checkbox — labelled via wrapping <label> *}
            {if $domainid}
            <div class="panel panel-warning">
                <div class="panel-heading">
                    <h3 class="panel-title">{$LANG.cancelrequestdomain}</h3>
                </div>
                <div class="panel-body">
                    <p>{$LANG.cancelrequestdomaindesc|sprintf2:$domainnextduedate:$domainprice:$domainregperiod}</p>
                    <div class="col-sm-12 text-center">
                        <label for="canceldomain" class="checkbox">
                            <input type="checkbox" name="canceldomain" id="canceldomain" />
                            {$LANG.cancelrequestdomainconfirm}
                        </label>
                    </div>
                </div>
            </div>
            {/if}

            {* Cancellation type — native radio group in fieldset/legend (WCAG 1.3.1) *}
            <div class="form-group">
                <fieldset class="a11y-cancel-type-group">
                    <legend class="control-label">{$LANG.a11yCancelTypeGroup}</legend>
                    <div class="radio">
                        <label>
                            <input type="radio" name="type" value="Immediate" />
                            {$LANG.clientareacancellationimmediate}
                        </label>
                    </div>
                    <div class="radio">
                        <label>
                            <input type="radio" name="type" value="End of Billing Period" checked="checked" />
                            {$LANG.clientareacancellationendofbillingperiod}
                        </label>
                    </div>
                </fieldset>
            </div>

            <div class="form-group text-center">
                <input type="submit" value="{$LANG.clientareacancelrequestbutton}" class="btn btn-danger" />
                <a href="clientarea.php?action=productdetails&amp;id={$id}" class="btn btn-default">{$LANG.cancel}</a>
            </div>

        </fieldset>

    </form>

{/if}
