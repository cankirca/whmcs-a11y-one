{*
 * A11y One — clientareadomains.tpl
 * Accessible domains list: select-all checkbox labelled, keyboard-reachable
 * rows, bulk-action group aria-label, status badges with sr-only text,
 * decorative icons aria-hidden.
 * Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca
 *}
{* Clear page heading. *}
<h1 class="h3 mb-4">{lang key='clientareanavdomains'}</h1>
{if $warnings}
    {include file="$template/includes/alert.tpl" type="warning" msg=$warnings textcenter=true}
{/if}
<div class="tab-content">
    <div class="tab-pane fade show active" id="tabOverview">
        {include file="$template/includes/tablelist.tpl" tableName="DomainsList" noSortColumns="0, 1" startOrderCol="2" filterColumn="5"}
        <script>
            jQuery(document).ready(function () {
                var table = jQuery('#tableDomainsList').show().DataTable();

                {if $orderby == 'domain'}
                    table.order(2, '{$sort}');
                {elseif $orderby == 'regdate' || $orderby == 'registrationdate'}
                    table.order(3, '{$sort}');
                {elseif $orderby == 'nextduedate'}
                    table.order(4, '{$sort}');
                {elseif $orderby == 'autorenew'}
                    table.order(5, '{$sort}');
                {elseif $orderby == 'status'}
                    table.order(6, '{$sort}');
                {/if}
                table.draw();
                jQuery('#tableLoading').hide();
            });
        </script>
        <form id="domainForm" method="post" action="clientarea.php?action=bulkdomain">
            <input id="bulkaction" name="update" type="hidden" />

            <div class="btn-group btn-group-sm mb-3" role="group" aria-label="{lang key='a11yDomainBulkActions'}">
                <button type="button" class="btn btn-default setBulkAction" id="nameservers">
                    <i class="fal fa-globe fa-fw" aria-hidden="true"></i>
                    {lang key='domainmanagens'}
                </button>
                <button type="button" class="btn btn-default setBulkAction" id="contactinfo">
                    <i class="fal fa-user" aria-hidden="true"></i>
                    {lang key='domaincontactinfoedit'}
                </button>
                {if $allowrenew}
                    <button type="button" class="btn btn-default setBulkAction" id="renewDomains">
                        <i class="fal fa-sync" aria-hidden="true"></i>
                        {lang key='domainmassrenew'}
                    </button>
                {/if}
                <div class="btn-group btn-group-sm" role="group">
                    <button id="btnGroupDrop1" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                      {lang key="more"}...
                    </button>
                    <div class="dropdown-menu" aria-labelledby="btnGroupDrop1">
                      <a class="dropdown-item setBulkAction" href="#" id="autorenew"><i class="fal fa-sync" aria-hidden="true"></i>
                    {lang key='domainautorenewstatus'}</a>
                      <a class="dropdown-item setBulkAction" href="#" id="reglock"><i class="fal fa-lock" aria-hidden="true"></i>
                    {lang key='domainreglockstatus'}</a>
                    </div>
                  </div>
            </div>

            <div class="table-container clearfix">
                <table id="tableDomainsList" class="table table-list w-hidden">
                    <caption class="sr-only">{lang key='a11yDomainTableCaption'}</caption>
                    <thead>
                        <tr>
                            <th class="width-fixed-20" scope="col">
                                <input type="checkbox" id="domainsSelectAll" aria-label="{lang key='a11yDomainSelectAll'}" />
                            </th>
                            <th scope="col"><span class="sr-only">{lang key='sslState.sslStatus'}</span></th>
                            <th scope="col">{lang key='orderdomain'}</th>
                            <th scope="col">{lang key='clientareahostingregdate'}</th>
                            <th scope="col">{lang key='clientareahostingnextduedate'}</th>
                            <th scope="col">{lang key='domainstatus'}</th>
                        </tr>
                    </thead>
                    <tbody>
                    {foreach $domains as $domain}
                        <tr onclick="clickableSafeRedirect(event, 'clientarea.php?action=domaindetails&amp;id={$domain.id}', false)">
                            <td>
                                <input type="checkbox" name="domids[]" class="domids stopEventBubble" value="{$domain.id}" aria-label="{lang key='a11yDomainSelectRow'}: {$domain.domain|escape}" />
                            </td>
                            <td class="text-center ssl-info" data-element-id="{$domain.id}" data-type="domain" data-domain="{$domain.domain}">
                                {if $domain.sslStatus}
                                    <img src="{$domain.sslStatus->getImagePath()}" width="25" data-toggle="tooltip" title="{$domain.sslStatus->getTooltipContent()}" alt="{$domain.sslStatus->getTooltipContent()}" class="{$domain.sslStatus->getClass()}">
                                {elseif !$domain.isActive}
                                    <img src="{$BASE_PATH_IMG}/ssl/ssl-inactive-domain.png" width="25" data-toggle="tooltip" title="{lang key='sslState.sslInactiveDomain'}" alt="{lang key='sslState.sslInactiveDomain'}">
                                {/if}
                            </td>
                            <td>
                                <a href="clientarea.php?action=domaindetails&amp;id={$domain.id}" class="stopEventBubble">{$domain.domain}</a>
                                <a href="http://{$domain.domain}" target="_blank" rel="noopener noreferrer" class="stopEventBubble ml-1" aria-label="{lang key='a11yDomainVisitSite'}: {$domain.domain|escape} ({lang key='a11yOpensInNewWindow'})">
                                    <i class="fas fa-external-link-alt fa-xs" aria-hidden="true"></i>
                                </a>
                                <br>
                                <small>
                                    {if $domain.autorenew}
                                        <i class="fas fa-fw fa-check text-success" aria-hidden="true"></i>
                                        {lang key='domainsautorenew'}
                                    {else}
                                        <i class="fas fa-fw fa-times text-danger" aria-hidden="true"></i>
                                        {lang key='domainsautorenew'}
                                    {/if}
                                </small>
                            </td>
                            <td><span class="w-hidden">{$domain.normalisedRegistrationDate}</span>{$domain.registrationdate}</td>
                            <td><span class="w-hidden">{$domain.normalisedNextDueDate}</span>{$domain.nextduedate}</td>
                            <td>
                                <span class="label status status-{$domain.statusClass}">{$domain.statustext}</span>
                                <span class="w-hidden">
                                    {if $domain.expiringSoon}<span>{lang key="domainsExpiringSoon"}</span>{/if}
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
        </form>
        <div aria-live="polite" role="status" id="domainSelectedCount" class="sr-only"></div>
    </div>
</div>
