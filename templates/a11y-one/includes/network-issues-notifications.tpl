{if $openNetworkIssueCounts.open > 0}
    <div class="alert alert-warning network-issue-alert m-0" role="alert">
        <div class="container">
            <i class="fas fa-exclamation-triangle fa-fw" aria-hidden="true"></i>
            <span class="sr-only">{lang key='warning'}: </span>
            {lang key='networkIssuesAware'}
            <a href="{$WEB_ROOT}/serverstatus.php" class="alert-link float-lg-right">
                {lang key='learnmore'}
                <span class="sr-only"> — {lang key='networkIssuesAware'}</span>
                <i class="far fa-arrow-right" aria-hidden="true"></i>
            </a>
        </div>
    </div>
{elseif $openNetworkIssueCounts.scheduled > 0}
    <div class="alert alert-info network-issue-alert m-0" role="status" aria-live="polite">
        <div class="container">
            <i class="fas fa-info-circle fa-fw" aria-hidden="true"></i>
            <span class="sr-only">{lang key='information'}: </span>
            {lang key='networkIssuesScheduled'}
            <a href="{$WEB_ROOT}/serverstatus.php" class="alert-link float-lg-right">
                {lang key='learnmore'}
                <span class="sr-only"> — {lang key='networkIssuesScheduled'}</span>
                <i class="far fa-arrow-right" aria-hidden="true"></i>
            </a>
        </div>
    </div>
{/if}
