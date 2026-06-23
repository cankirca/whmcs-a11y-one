{*
 * A11y One — domain-pricing.tpl
 * Category filters rebuilt as toggle <button> controls with aria-pressed;
 * currency selector labelled; pricing table gets caption + scope headers.
 * The filter script is inherited parent behaviour improved for keyboard access —
 * no canonical a11y-one.js helper covers this specific filter-to-DataTables wire.
 * Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca
 *}
<div class="domain-pricing">

    {if $featuredTlds}
        <div class="featured-tlds-container">
            <div class="row">
                {foreach $featuredTlds as $num => $tldinfo}
                    <div class="col-md-3 col-sm-4 col-6">
                        <div class="featured-tld">
                            <div class="img-container">
                                <img src="{$BASE_PATH_IMG}/tld_logos/{$tldinfo.tldNoDots}.png" alt="{$tldinfo.tld}">
                            </div>
                            <div class="price {$tldinfo.tldNoDots}">
                                {if is_object($tldinfo.register)}
                                    {$tldinfo.register->toPrefixed()}{if $tldinfo.period > 1}{lang key="orderForm.shortPerYears" years={$tldinfo.period}}{else}{lang key="orderForm.shortPerYear" years=''}{/if}
                                {else}
                                    {lang key="domainregnotavailable"}
                                {/if}
                            </div>
                        </div>
                    </div>
                {/foreach}
            </div>
        </div>
    {/if}

    {if !$loggedin && $currencies}
        <form method="post" action="" class="float-right">
            <label for="currencySelector" class="sr-only">{lang key='currency'}</label>
            <select id="currencySelector" name="currency" class="form-control currency-selector" onchange="submit()">
                <option>
                    {lang key="changeCurrency"} ({$activeCurrency.prefix} {$activeCurrency.code})
                </option>
                {foreach $currencies as $currency}
                    <option value="{$currency['id']}">
                        {$currency['prefix']} {$currency['code']}
                    </option>
                {/foreach}
            </select>
        </form>
    {/if}

    <h4>{lang key='pricing.browseExtByCategory'}</h4>

    <div class="tld-filters">
        {foreach $tldCategories as $category => $count}
            <button type="button"
                    class="btn badge badge-secondary tld-filter-btn"
                    data-category="{$category}"
                    aria-pressed="false">{lang key="domainTldCategory.$category" defaultValue=$category} ({$count})</button>
        {/foreach}
    </div>

    {include file="$template/includes/tablelist.tpl" tableName="DomainPricing" noOrdering=true}
    <script>
        jQuery(document).ready(function() {
            var table = jQuery('#tableDomainPricing').show().DataTable();

            {if $orderby == 'date'}
                table.order(0, '{$sort}');
            {elseif $orderby == 'subject'}
                table.order(1, '{$sort}');
            {/if}
            table.draw();
            jQuery('#tableLoading').hide();

            jQuery('.tld-filter-btn').off('click').on('click', function(e) {
                e.preventDefault();
                var $btn = jQuery(this);
                var $search = jQuery('#tableDomainPricing_wrapper input[type="search"]');
                if ($btn.attr('aria-pressed') === 'true') {
                    $search.val('').trigger('keyup');
                    jQuery('.tld-filter-btn').attr('aria-pressed', 'false').removeClass('badge-success').addClass('badge-secondary');
                } else {
                    $search.val($btn.data('category')).trigger('keyup');
                    jQuery('.tld-filter-btn').attr('aria-pressed', 'false').removeClass('badge-success').addClass('badge-secondary');
                    $btn.attr('aria-pressed', 'true').removeClass('badge-secondary').addClass('badge-success');
                }
            });
        });
    </script>

    <div class="table-container clearfix overflow-auto">
        <table class="table table-list hidden" id="tableDomainPricing">
            <caption class="sr-only">{lang key='a11yDomainPricingCaption'}</caption>
            <thead>
            <tr>
                <th scope="col">{lang key='domaintld'}</th>
                <th scope="col">{lang key='category'}</th>
                <th scope="col">{lang key='pricing.register'}</th>
                <th scope="col">{lang key='pricing.transfer'}</th>
                <th scope="col">{lang key='pricing.renewal'}</th>
                <th scope="col">{lang key='gracePeriod'}</th>
                <th scope="col">{lang key='redemptionPeriod'}</th>
            </tr>
            </thead>
            <tbody>
            {foreach $pricing as $extension => $data}
                <tr>
                    <td>
                        {$extension}
                        {if $data.group}
                            <span class="tld-sale-group tld-sale-group-{$data.group}">
                                {$data.group}!
                            </span>
                        {/if}
                    </td>
                    <td>
                        {$data.categories[0]}
                        <span class="w-hidden">
                            {foreach $data.categories as $category}
                                {$category}
                            {/foreach}
                        </span>
                    </td>
                    {foreach $data.register as $years => $price}
                        <td>
                            {if $price >= 0}
                                {$price}<br>
                                <small>{$years} {if $years > 1}{lang key="orderForm.years"}{else}{lang key="orderForm.year"}{/if}</small>
                            {else}
                                <small>{lang key="domainregnotavailable"}</small>
                            {/if}
                        </td>
                        {break}
                    {foreachelse}
                        <td>-</td>
                    {/foreach}
                    {foreach $data.transfer as $years => $price}
                        <td>
                            {if $price >= 0}
                                {$price}<br>
                                <small>{$years} {if $years > 1}{lang key="orderForm.years"}{else}{lang key="orderForm.year"}{/if}</small>
                            {else}
                                <small>{lang key="domainregnotavailable"}</small>
                            {/if}
                        </td>
                        {break}
                    {foreachelse}
                        <td>-</td>
                    {/foreach}
                    {foreach $data.renew as $years => $price}
                        <td>
                            {if $price >= 0}
                                {$price}<br>
                                <small>{$years} {if $years > 1}{lang key="orderForm.years"}{else}{lang key="orderForm.year"}{/if}</small>
                            {else}
                                <small>{lang key="domainregnotavailable"}</small>
                            {/if}
                        </td>
                        {break}
                    {foreachelse}
                        <td>-</td>
                    {/foreach}
                    <td>
                        {if is_null($data.grace_period)}
                            -
                        {else}
                            {$data.grace_period.days} {lang key='domainrenewalsdays'}<br>
                            <small>({$data.grace_period.price})</small>
                        {/if}
                    </td>
                    <td>
                        {if is_null($data.redemption_period)}
                            -
                        {else}
                            {$data.redemption_period.days} {lang key='domainrenewalsdays'}<br>
                            <small>({$data.redemption_period.price})</small>
                        {/if}
                    </td>
                </tr>
            {foreachelse}
                <tr>
                    <td colspan="7">{lang key="pricing.noExtensionsDefined"}</td>
                </tr>
            {/foreach}
            </tbody>
        </table>
        <div class="text-center" id="tableLoading">
            <p><i class="fas fa-spinner fa-spin" aria-hidden="true"></i> {lang key='loading'}</p>
        </div>
    </div>

</div>
