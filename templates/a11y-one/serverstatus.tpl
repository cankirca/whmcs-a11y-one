{*
 * A11y One – serverstatus.tpl override
 * Author: Can Kirca <cankirca@gmail.com>
 * Fixes:
 *   - Status indicators (port check spinner/icon) are not icon/colour-only:
 *     JS writes an aria-live region with text status; initial spinner has
 *     sr-only "Checking…" text.
 *   - <table> gets a <caption> for screen-reader context.
 *   - <th> elements get scope="col".
 *   - All decorative icons get aria-hidden="true".
 *   - phpinfo target=_blank link gets rel="noopener noreferrer" + sr-only note.
 *}

{if $opencount == 0}
    <div class="alert alert-success">
        <i class="fas fa-check fa-fw" aria-hidden="true"></i>
        {"{lang key='networkstatusnone'}"|sprintf:"{lang key='networkissuesstatusopen'}"}
    </div>
{/if}

{if $scheduledcount > 0}
    <div class="alert alert-info">
        <i class="fas fa-exclamation-triangle fa-fw" aria-hidden="true"></i>
        {lang key='networkIssues.scheduled' count=$scheduledcount}
        <a href="serverstatus.php?view=scheduled" class="alert-link">{lang key='learnmore'}...</a>
    </div>
{/if}

{if $servers}
    <div class="card">
        <div class="card-body">
            <h2>{lang key='serverstatustitle'}</h2>

            <p>{lang key='serverstatusheadingtext'}</p>

            <div class="table-responsive">
                <table class="table table-striped" aria-label="{lang key='serverstatustitle'}">
                    <caption class="sr-only">{lang key='serverstatustitle'}</caption>
                    <thead>
                        <tr>
                            <th scope="col">{lang key='servername'}</th>
                            <th scope="col" class="text-center">{lang key='networkIssues.http'}</th>
                            <th scope="col" class="text-center">{lang key='networkIssues.ftp'}</th>
                            <th scope="col" class="text-center">{lang key='networkIssues.pop3'}</th>
                            <th scope="col" class="text-center">{lang key='serverstatusphpinfo'}</th>
                            <th scope="col" class="text-center">{lang key='serverstatusserverload'}</th>
                            <th scope="col" class="text-center">{lang key='serverstatusuptime'}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $servers as $num => $server}
                            <tr>
                                <td>{$server.name}</td>
                                <td class="text-center" id="port80_{$num}">
                                    <span class="fas fa-spinner fa-spin" aria-hidden="true"></span>
                                    <span class="sr-only status-text">{lang key='serverstatusChecking'}</span>
                                </td>
                                <td class="text-center" id="port21_{$num}">
                                    <span class="fas fa-spinner fa-spin" aria-hidden="true"></span>
                                    <span class="sr-only status-text">{lang key='serverstatusChecking'}</span>
                                </td>
                                <td class="text-center" id="port110_{$num}">
                                    <span class="fas fa-spinner fa-spin" aria-hidden="true"></span>
                                    <span class="sr-only status-text">{lang key='serverstatusChecking'}</span>
                                </td>
                                <td class="text-center">
                                    <a href="{$server.phpinfourl}"
                                       target="_blank"
                                       rel="noopener noreferrer">
                                        {lang key='serverstatusphpinfo'}
                                        <span class="sr-only">{lang key='announcementNewWindow'}</span>
                                    </a>
                                </td>
                                <td class="text-center" id="load{$num}">
                                    <span class="fas fa-spinner fa-spin" aria-hidden="true"></span>
                                    <span class="sr-only status-text">{lang key='serverstatusChecking'}</span>
                                </td>
                                <td class="text-center" id="uptime{$num}">
                                    <span class="fas fa-spinner fa-spin" aria-hidden="true"></span>
                                    <span class="sr-only status-text">{lang key='serverstatusChecking'}</span>
                                    <script>
                                    jQuery(document).ready(function() {
                                        checkPort({$num}, 80);
                                        checkPort({$num}, 21);
                                        checkPort({$num}, 110);
                                        getStats({$num});
                                    });
                                    </script>
                                </td>
                            </tr>
                        {foreachelse}
                            <tr>
                                <td colspan="7">{lang key='serverstatusnoservers'}</td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
{/if}

{foreach $issues as $issue}
    <div class="card">
        <div class="card-header">
            {$issue.title}
            ({$issue.status})
            <span id="issuePriorityLabel" class="badge badge-{if $issue.rawPriority == 'Critical'}danger{elseif $issue.rawPriority == 'High'}warning{elseif $issue.rawPriority == 'Low'}success{else}info{/if} float-md-right">{$issue.priority}</span>
        </div>
        <div class="card-body">
            {if $issue.server || $issue.affecting}
                <p class="h5">
                    <strong>{lang key='networkissuesaffecting'} {$issue.type}</strong>
                    -
                    {if $issue.type eq "{lang key='networkissuestypeserver'}"}
                        {$issue.server}
                    {else}
                        {$issue.affecting}
                    {/if}
                </p>
            {/if}
            <ul class="list-inline">
                <li class="list-inline-item pr-3">
                    <i class="far fa-calendar-alt fa-fw" aria-hidden="true"></i>
                    {$issue.startdate}
                    {if $issue.enddate} - {$issue.enddate}{/if}
                </li>
                <li class="list-inline-item pr-3">
                    <i class="far fa-clock fa-fw" aria-hidden="true"></i>
                    <strong>{lang key='networkissueslastupdated'}</strong> {$issue.lastupdate}
                </li>
            </ul>
            {if $issue.clientaffected}
                <div class="alert alert-warning p-1 text-center">
                    {lang key='networkIssues.affectingYou'}
                </div>
            {/if}
            <p>
                {$issue.description}
            </p>
        </div>
    </div>
{foreachelse}
    <p>{$noissuesmsg}</p>
{/foreach}

<nav aria-label="{lang key='networkIssuesNavLabel'}">
    <ul class="pagination">
        <li class="page-item{if !$prevpage} disabled{/if}">
            <a class="page-link" href="?{if $view}view={$view}&amp;{/if}page={$prevpage}">{lang key='previouspage'}</a>
        </li>
        <li class="page-item{if !$nextpage} disabled{/if}">
            <a class="page-link" href="?{if $view}view={$view}&amp;{/if}page={$nextpage}">{lang key='nextpage'}</a>
        </li>
    </ul>
</nav>
