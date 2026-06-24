{**
 * upgradesummary.tpl — A11y One override
 *
 * A11y fixes (WS-D Task 2):
 *   - Summary table gets <caption> (WCAG 1.3.1) and <th scope="col"> on all
 *     column headers (WCAG 1.3.1).
 *   - Promo-code <input type="text"> receives an explicit <label for> (WCAG 1.3.1).
 *   - Payment-method <select> receives an explicit <label for> (WCAG 1.3.1, 4.1.2).
 *   - Submit button retains value= as its accessible name.
 *   - Single <h1> leads the page content; subheaders are h3.
 *   - All strings via {$LANG.*} — no hardcoded text.
 *
 * Author: Can Kirca
 **}
{* Clear page heading. *}
<h1 class="h3 mb-4">{lang key='a11yUpgradeSummary'}</h1>
{if $promoerror}
    {include file="$template/includes/alert.tpl" type="error" msg=$promoerror textcenter=true}
{/if}

{if $promorecurring}
    {include file="$template/includes/alert.tpl" type="info"
    msg=$LANG.recurringpromodesc|sprintf2:$promorecurring textcenter=true}
{/if}

<div class="alert alert-block alert-info text-center">
    {$LANG.upgradecurrentconfig}: <strong>{$groupname} - {$productname}</strong>{if $domain} ({$domain}){/if}
</div>

<table class="table table-striped">
    <caption class="sr-only">{$LANG.a11yUpgradeSummaryCaption}</caption>
    <thead>
        <tr>
            <th scope="col" width="60%">{$LANG.orderdesc}</th>
            <th scope="col" width="40%" class="text-center">{$LANG.orderprice}</th>
        </tr>
    </thead>
    <tbody>
        {foreach key=num item=upgrade from=$upgrades}
            {if $type eq "package"}
                <tr>
                    <td><input type="hidden" name="pid" value="{$upgrade.newproductid}" /><input type="hidden" name="billingcycle" value="{$upgrade.newproductbillingcycle}" />{$upgrade.oldproductname} =&gt; {$upgrade.newproductname}</td>
                    <td class="text-center">{$upgrade.price}</td>
                </tr>
            {elseif $type eq "configoptions"}
                <tr>
                    <td>{$upgrade.configname}: {$upgrade.originalvalue} =&gt; {$upgrade.newvalue}</td>
                    <td class="text-center">{$upgrade.price}</td>
                </tr>
            {/if}
        {/foreach}
        <tr class="masspay-total">
            <td class="text-right">{$LANG.ordersubtotal}:</td>
            <td class="text-center">{$subtotal}</td>
        </tr>
        {if $promodesc}
            <tr class="masspay-total">
                <td class="text-right">{$promodesc}:</td>
                <td class="text-center">{$discount}</td>
            </tr>
        {/if}
        {if $taxrate}
            <tr class="masspay-total">
                <td class="text-right">{$taxname} @ {$taxrate}%:</td>
                <td class="text-center">{$tax}</td>
            </tr>
        {/if}
        {if $taxrate2}
            <tr class="masspay-total">
                <td class="text-right">{$taxname2} @ {$taxrate2}%:</td>
                <td class="text-center">{$tax2}</td>
            </tr>
        {/if}
        <tr class="masspay-total">
            <td class="text-right">{$LANG.ordertotalduetoday}:</td>
            <td class="text-center">{$total}</td>
        </tr>
    </tbody>
</table>

{if $type eq "package"}
    {include file="$template/includes/alert.tpl" type="warning" msg=$LANG.upgradeproductlogic|cat:' ('|cat:$upgrade.daysuntilrenewal|cat:' '|cat:$LANG.days|cat:')' textcenter=true}
{/if}

<div class="row">
    <div class="col-sm-6">

        {* Promo-code form: input labelled via <label for> (WCAG 1.3.1) *}
        <form method="post" action="{$smarty.server.PHP_SELF}" role="form">
            <input type="hidden" name="step" value="2" />
            <input type="hidden" name="type" value="{$type}" />
            <input type="hidden" name="id" value="{$id}" />
            {if $type eq "package"}
                <input type="hidden" name="pid" value="{$upgrades.0.newproductid}" />
                <input type="hidden" name="billingcycle" value="{$upgrades.0.newproductbillingcycle}" />
            {/if}
            {include file="$template/includes/subheader.tpl" title=$LANG.orderpromotioncode}
            {foreach from=$configoptions key=cid item=value}
                <input type="hidden" name="configoption[{$cid}]" value="{$value}" />
            {/foreach}
            <div class="input-group">
                <label for="promocode" class="sr-only">{$LANG.a11yUpgradePromoLabel}</label>
                <input class="form-control"
                       type="text"
                       id="promocode"
                       name="promocode"
                       placeholder="{$LANG.orderpromotioncode}"
                       width="40"
                       {if $promocode}value="{$promocode} - {$promodesc}" disabled="disabled"{/if}>
                {if $promocode}
                    <span class="input-group-btn">
                        <input type="submit" name="removepromo" value="{$LANG.orderdontusepromo}"
                               class="btn btn-danger" />
                    </span>
                {else}
                    <span class="input-group-btn">
                        <input type="submit" value="{$LANG.orderpromovalidatebutton}" class="btn btn-success" />
                    </span>
                {/if}
            </div>
        </form>

    </div>
    <div class="col-sm-6">

        {* Payment + confirm form: payment select labelled via <label for> (WCAG 1.3.1) *}
        <form method="post" action="{$smarty.server.PHP_SELF}">
            <input type="hidden" name="step" value="3" />
            <input type="hidden" name="type" value="{$type}" />
            <input type="hidden" name="id" value="{$id}" />
            {if $type eq "package"}
                <input type="hidden" name="pid" value="{$upgrades.0.newproductid}" />
                <input type="hidden" name="billingcycle" value="{$upgrades.0.newproductbillingcycle}" />
            {/if}
            {foreach from=$configoptions key=cid item=value}
                <input type="hidden" name="configoption[{$cid}]" value="{$value}" />
            {/foreach}
            {if $promocode}<input type="hidden" name="promocode" value="{$promocode}">{/if}

            {include file="$template/includes/subheader.tpl" title=$LANG.orderpaymentmethod}
            <div class="form-group">
                <label for="inputPaymentMethod" class="sr-only">{$LANG.a11yUpgradePaymentLabel}</label>
                <select name="paymentmethod" id="inputPaymentMethod" class="form-control">
                    {if $allowgatewayselection}
                        <option value="none">{$LANG.paymentmethoddefault}</option>
                    {/if}
                    {foreach key=num item=gateway from=$gateways}
                        <option value="{$gateway.sysname}"{if $gateway.sysname eq $selectedgateway} selected="selected"{/if}>{$gateway.name}</option>
                    {/foreach}
                </select>
            </div>

    </div>
</div>

<div class="form-group text-center">
    <input type="submit"
           value="{$LANG.ordercontinuebutton}"
           class="btn btn-primary"
           id="btnOrderContinue" />
</div>

</form>
