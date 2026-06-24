{*
 * A11y One — affiliates.tpl
 * Accessible override of twenty-one/affiliates.tpl (WCAG 2.2 AA).
 *
 * Changes over parent:
 *  - Referral link <input> has an id + visible/sr-only <label> + copy-to-clipboard button
 *    (data-clipboard-target; handled by canonical initAllCopyButtons in a11y-one.js).
 *  - Commission summary table: <caption> (sr-only) + row header cells use <th scope="row">.
 *  - Referrals DataTable (#tableAffiliatesList): <caption> (sr-only) + <th scope="col"> on
 *    all header cells. fixAllDataTables (canonical JS) enhances it further.
 *  - Withdraw-request form: icon is aria-hidden; {$token} CSRF field preserved.
 *  - All decorative FA icons aria-hidden.
 *
 * Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca
 *}
{* Clear page heading. *}
<h1 class="h3 mb-4">{lang key='affiliatestitle'}</h1>
{if $inactive}

    {include file="$template/includes/alert.tpl" type="danger" msg="{lang key='affiliatesdisabled'}" textcenter=true}

{else}
    {include file="$template/includes/flashmessage.tpl"}
    {if $withdrawrequestsent}
        <div class="alert alert-success">
            <i class="fas fa-check fa-fw" aria-hidden="true"></i>
            {lang key='affiliateswithdrawalrequestsuccessful'}
        </div>
    {/if}

    <div class="row">

        <div class="col-md-4">
            <div class="affiliate-stat affiliate-stat-green alert-warning mb-2">
                <i class="fas fa-users" aria-hidden="true"></i>
                <span>{$visitors}</span>
                {lang key='affiliatesclicks'}
            </div>
        </div>

        <div class="col-md-4">
            <div class="affiliate-stat affiliate-stat-green alert-info mb-2">
                <i class="fas fa-shopping-cart" aria-hidden="true"></i>
                <span>{$signups}</span>
                {lang key='affiliatessignups'}
            </div>
        </div>

        <div class="col-md-4">
            <div class="affiliate-stat affiliate-stat-green alert-success mb-2">
                <i class="far fa-chart-bar" aria-hidden="true"></i>
                <span>{$conversionrate}%</span>
                {lang key='affiliatesconversionrate'}
            </div>
        </div>

    </div>

    <div class="card my-3">
        <div class="card-body">

            <p class="h3">{lang key='affiliatesreferallink'}</p>
            <label for="affiliatesReferalLink" class="sr-only">{lang key='affiliatesreferallink'}</label>
            <div class="d-flex align-items-center">
                <input type="text"
                       id="affiliatesReferalLink"
                       class="form-control"
                       readonly="readonly"
                       value="{$referrallink|escape}">
                <button type="button"
                        class="btn btn-sm btn-outline-secondary ml-2 copy-to-clipboard"
                        data-clipboard-target="#affiliatesReferalLink"
                        aria-label="{lang key='a11yCopyToClipboard'}">
                    <i class="fal fa-copy" aria-hidden="true"></i>
                </button>
            </div>

        </div>
    </div>

    <div class="row">
        <div class="col-md-8 offset-md-2">
            <table class="table table-bordered table-striped table-rounded">
                <caption class="sr-only">{lang key='a11yAffiliatesCommissionSummary'}</caption>
                <tbody>
                    <tr>
                        <th scope="row" class="text-right">{lang key='affiliatescommissionspending'}:</th>
                        <td><strong>{$pendingcommissions}</strong></td>
                    </tr>
                    <tr>
                        <th scope="row" class="text-right">{lang key='affiliatescommissionsavailable'}:</th>
                        <td><strong>{$balance}</strong></td>
                    </tr>
                    <tr>
                        <th scope="row" class="text-right">{lang key='affiliateswithdrawn'}:</th>
                        <td><strong>{$withdrawn}</strong></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    {if !$withdrawrequestsent}
        <div class="text-center">
            <form method="POST" action="{$smarty.server.PHP_SELF}">
                <input type="hidden" name="action" value="withdrawrequest" />
                {if isset($token)}<input type="hidden" name="token" value="{$token|escape}" />{/if}
                <button type="submit" class="btn btn-lg btn-danger{if !$withdrawlevel} disabled" disabled="disabled{/if}">
                    <i class="fas fa-university" aria-hidden="true"></i> {lang key='affiliatesrequestwithdrawal'}
                </button>
            </form>
        </div>
        {if !$withdrawlevel}
            <p class="text-muted text-center">{lang key="affiliateWithdrawalSummary" amountForWithdrawal=$affiliatePayoutMinimum}</p>
        {/if}
    {/if}

    <h2>{lang key='affiliatesreferals'}</h2>

    {include file="$template/includes/tablelist.tpl" tableName="AffiliatesList"}
    <script>
        jQuery(document).ready(function() {
            var table = jQuery('#tableAffiliatesList').show().DataTable();

            {if $orderby == 'regdate'}
                table.order(0, '{$sort}');
            {elseif $orderby == 'product'}
                table.order(1, '{$sort}');
            {elseif $orderby == 'amount'}
                table.order(2, '{$sort}');
            {elseif $orderby == 'status'}
                table.order(4, '{$sort}');
            {/if}
            table.draw();
            jQuery('#tableLoading').hide();
        });
    </script>
    <div class="table-container clearfix">
        <table id="tableAffiliatesList" class="table table-list w-hidden">
            <caption class="sr-only">{lang key='a11yAffiliatesReferralsList'}</caption>
            <thead>
                <tr>
                    <th scope="col">{lang key='affiliatessignupdate'}</th>
                    <th scope="col">{lang key='orderproduct'}</th>
                    <th scope="col">{lang key='affiliatesamount'}</th>
                    <th scope="col">{lang key='affiliatescommission'}</th>
                    <th scope="col">{lang key='affiliatesstatus'}</th>
                </tr>
            </thead>
            <tbody>
            {foreach $referrals as $referral}
                <tr class="text-center">
                    <td><span class="w-hidden">{$referral.datets}</span>{$referral.date}</td>
                    <td>{$referral.service}</td>
                    <td data-order="{$referral.amountnum}">{$referral.amountdesc}</td>
                    <td data-order="{$referral.commissionnum}">{$referral.commission}</td>
                    <td><span class='label status status-{$referral.rawstatus|strtolower}'>{$referral.status}</span></td>
                </tr>
            {/foreach}
            </tbody>
        </table>
        <div class="text-center" id="tableLoading">
            <p><i class="fas fa-spinner fa-spin" aria-hidden="true"></i> {lang key='loading'}</p>
        </div>
    </div>

    {if $affiliatelinkscode}
        <h2>{lang key='affiliateslinktous'}</h2>
        <div class="margin-bottom text-center">
            {$affiliatelinkscode}
        </div>
    {/if}

{/if}
