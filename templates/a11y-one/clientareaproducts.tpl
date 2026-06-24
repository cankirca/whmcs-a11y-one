{* A11y One — clientareaproducts.tpl (services list) override.
   Author: Can Kirca
   WS-D Task 1: keyboard-accessible rows (real <a> link, no onclick redirect),
   product logo img alt, status badge sr-only text, DataTables inherited. *}

{* Clear page heading — this list page had no <h1> of its own. *}
<h1 class="h3 mb-4">{lang key='a11yMyServices'}</h1>

{include file="$template/includes/tablelist.tpl" tableName="ServicesList" filterColumn="4" noSortColumns="0"}

<script>
    jQuery(document).ready(function() {
        var table = jQuery('#tableServicesList').show().DataTable();

        {if $orderby == 'product'}
            table.order([1, '{$sort}'], [4, 'asc']);
        {elseif $orderby == 'amount' || $orderby == 'billingcycle'}
            table.order(2, '{$sort}');
        {elseif $orderby == 'nextduedate'}
            table.order(3, '{$sort}');
        {elseif $orderby == 'domainstatus'}
            table.order(4, '{$sort}');
        {/if}
        table.draw();
        jQuery('#tableLoading').hide();
    });
</script>

<div class="table-container clearfix">
    <table id="tableServicesList" class="table table-list w-hidden">
        <thead>
            <tr>
                <th scope="col"></th>
                <th scope="col">{lang key='orderproduct'}</th>
                <th scope="col">{lang key='clientareaaddonpricing'}</th>
                <th scope="col">{lang key='clientareahostingnextduedate'}</th>
                <th scope="col">{lang key='clientareastatus'}</th>
            </tr>
        </thead>
        <tbody>
            {foreach $services as $service}
                {* No onclick redirect — row is navigable via the product-name <a> link below *}
                <tr>
                    <td class="py-0 text-center{if $service.sslStatus} ssl-info{/if}" data-element-id="{$service.id}" data-type="service"{if $service.domain} data-domain="{$service.domain}"{/if}>
                        {if $service.sslStatus}
                            {* SSL status icon: decorative — tooltip carries the info; alt="" *}
                            <img src="{$service.sslStatus->getImagePath()}" alt="" data-toggle="tooltip" title="{$service.sslStatus->getTooltipContent()}" class="{$service.sslStatus->getClass()}" width="25">
                        {elseif !$service.isActive}
                            {* Inactive service icon: decorative alongside status cell text *}
                            <img src="{$BASE_PATH_IMG}/ssl/ssl-inactive-domain.png" alt="" data-toggle="tooltip" title="{lang key='sslState.sslInactiveService'}" width="25">
                        {/if}
                    </td>
                    <td>
                        {* Real <a> link — provides keyboard navigation and accessible name *}
                        <strong><a href="clientarea.php?action=productdetails&amp;id={$service.id}">{$service.product}</a></strong>
                        {if $service.domain}<br /><a href="http://{$service.domain}" target="_blank" rel="noopener noreferrer">{$service.domain}</a>{else}<br />-{/if}
                    </td>
                    <td class="text-center" data-order="{$service.amountnum}">{$service.amount} <small class="text-muted">{$service.billingcycle}</small></td>
                    <td class="text-center"><span class="w-hidden">{$service.normalisedNextDueDate}</span>{$service.nextduedate}</td>
                    <td class="text-center">
                        <span class="label status status-{$service.status|strtolower}">
                            {$service.statustext}
                            {* sr-only text ensures status is not conveyed by colour alone *}
                            <span class="sr-only">{$service.statustext}</span>
                        </span>
                    </td>
                </tr>
            {/foreach}
        </tbody>
    </table>
    <div class="text-center" id="tableLoading">
        <p><i class="fas fa-spinner fa-spin" aria-hidden="true"></i> {lang key='loading'}</p>
    </div>
</div>
