{* WS-D Task 3: managessl — a11y-one override.
   Changes vs. parent (twenty-one/managessl.tpl):
   - Table <th> elements get scope="col" (DataTables a11y inherited via tablelist.tpl).
   - <label> status badges replaced with <span> — label element is for form controls only.
   - Validation-type badge: sr-only prefix so type is not conveyed by colour alone.
   - Instant-issuance <i> icon: aria-hidden="true" + sr-only text sibling.
   - Resend-approver-email button: aria-label adds product name for disambiguation.
   - Upgrade button: aria-label carries SSL product name + aria-disabled mirrors disabled attr.
   - Live region on the AJAX status div.
   Author: Can Kirca
*}
{include file="$template/includes/tablelist.tpl" tableName="SslList" startOrderCol="3" filterColumn="0" noSortColumns="4"}

<div class="alert alert-table-ssl-manage w-hidden" role="status" aria-live="polite"></div>

<div class="table-container clearfix">
    <table id="tableSslList" class="table table-list" aria-label="{lang key='sslcertificates'}">
        <thead>
            <tr>
                <th scope="col">{lang key='ssldomain'}</th>
                <th scope="col">{lang key='sslproduct'}</th>
                <th scope="col">{lang key='sslorderdate'}</th>
                <th scope="col">{lang key='sslrenewaldate'}</th>
                <th scope="col">{lang key='actions'}</th>
            </tr>
        </thead>
        <tbody>
            {foreach $sslProducts as $sslProduct}
                <tr>
                    {if $sslProduct->addonId && $sslProduct->addonId > 0}
                        <td>
                            {if $sslProduct->status == $sslStatusAwaitingConfiguration}
                                <span class="label label-info">{lang key='sslawaitingconfig'}</span>
                            {else}
                                {if $sslProduct->addon->service->domain}{$sslProduct->addon->service->domain}{else}-{/if}
                                {if $sslProduct->addon->nextDueDateProperties['isPast']}
                                    <span class="label label-default">{lang key='clientareaexpired'}</span>
                                {elseif $sslProduct->addon->nextDueDateProperties['daysTillExpiry'] < 60}
                                    <span class="label label-danger">{lang key='expiringsoon'}</span>
                                {else}
                                    {if $sslProduct->wasInstantIssuanceAttempted() && $sslProduct->wasInstantIssuanceSuccessful()}
                                        &nbsp;<i class="fas fa-bolt" aria-hidden="true"></i><span class="sr-only">{lang key='sslinstantissuancebenefit'}</span>
                                    {/if}
                                {/if}
                            {/if}
                        </td>
                        <td>
                            {$sslProduct->addon->productAddon->name}
                            <span class="label label-{if $sslProduct->validationType == 'DV'}default{elseif $sslProduct->validationType == 'OV'}warning{elseif $sslProduct->validationType == 'EV'}success{/if}">
                                <span class="sr-only">{lang key='a11ySslValidationType'}: </span>{$sslProduct->validationType}
                            </span>
                        </td>
                        <td>
                            <span class="w-hidden">{$sslProduct->addon->registrationDate}</span>{$sslProduct->addon->registrationDateFormatted}
                        </td>
                        <td>
                            <span class="w-hidden">{$sslProduct->addon->nextDueDate}</span>{$sslProduct->addon->nextDueDateFormatted}
                        </td>
                        <td>
                            {if $sslProduct->status == $sslStatusAwaitingIssuance}
                                <button class="btn btn-default btn-sm btn-resend-approver-email"
                                        aria-label="{lang key='sslresendmail'} — {$sslProduct->addon->productAddon->name}"
                                        data-url="{routePath('clientarea-ssl-certificates-resend-approver-email')}"
                                        data-addonid="{$sslProduct->addonId}">{lang key='sslresendmail'}</button>
                            {/if}
                            {if $sslProduct->status == $sslStatusAwaitingConfiguration}
                                <a href="{$sslProduct->getConfigurationUrl()}" class="btn btn-default btn-sm">{lang key='sslconfigure'}</a>
                            {/if}
                            {if $sslProduct->addon->nextDueDateProperties['isFuture']}
                                <form action="{$sslProduct->getUpgradeUrl()}" method="post">
                                    <input type="hidden" name="id" value="{$sslProduct->id}">
                                    <button type="submit" class="btn btn-default btn-sm"
                                            aria-label="{lang key='upgrade'} — {$sslProduct->addon->productAddon->name}"{if $sslProduct->validationType == 'EV'} disabled="disabled" aria-disabled="true"{/if}>{lang key='upgrade'}</button>
                                </form>
                            {/if}
                        </td>
                    {else}
                        <td>
                            {if $sslProduct->status == $sslStatusAwaitingConfiguration}
                                <span class="label label-info">{lang key='sslawaitingconfig'}</span>
                            {else}
                                {if $sslProduct->service->domain}{$sslProduct->service->domain}{else}-{/if}
                                {if $sslProduct->service->nextDueDateProperties['isPast']}
                                    <span class="label label-default">{lang key='clientareaexpired'}</span>
                                {elseif $sslProduct->service->nextDueDateProperties['daysTillExpiry'] < 60}
                                    <span class="label label-danger">{lang key='expiringsoon'}</span>
                                {/if}
                            {/if}
                        </td>
                        <td>
                            {$sslProduct->service->product->name}
                            <span class="label label-{if $sslProduct->validationType == 'DV'}default{elseif $sslProduct->validationType == 'OV'}warning{elseif $sslProduct->validationType == 'EV'}success{/if}">
                                <span class="sr-only">{lang key='a11ySslValidationType'}: </span>{$sslProduct->validationType}
                            </span>
                        </td>
                        <td>
                            <span class="w-hidden">{$sslProduct->service->registrationDate}</span>{$sslProduct->service->registrationDateFormatted}
                        </td>
                        <td>
                            <span class="w-hidden">{$sslProduct->service->nextDueDate}</span>{$sslProduct->service->nextDueDateFormatted}
                        </td>
                        <td>
                            {if $sslProduct->status == $sslStatusAwaitingIssuance}
                                <button class="btn btn-default btn-sm btn-resend-approver-email"
                                        aria-label="{lang key='sslresendmail'} — {$sslProduct->service->product->name}"
                                        data-url="{routePath('clientarea-ssl-certificates-resend-approver-email')}"
                                        data-serviceid="{$sslProduct->serviceId}">{lang key='sslresendmail'}</button>
                            {/if}
                            {if $sslProduct->status == $sslStatusAwaitingConfiguration}
                                <a href="{$sslProduct->getConfigurationUrl()}" class="btn btn-default btn-sm">{lang key='sslconfigure'}</a>
                            {/if}
                        </td>
                    {/if}

                </tr>
            {/foreach}
        </tbody>
    </table>
</div>
