{* WS-D Task 3: subscription-manage — a11y-one override.
   Changes vs. parent (twenty-one/subscription-manage.tpl):
   - Card body has role="status" + aria-live="polite" so outcome alerts are
     announced by screen readers on load.
   - Home anchor: <i> icon gets aria-hidden="true" (decorative — visible text present)
     and the link carries aria-label for an unambiguous accessible name.
   Author: Can Kirca
*}
{* Clear page heading. *}
<h1 class="h3 mb-4">{lang key='manageSubscription'}</h1>
<div class="card mw-540">
    <div class="card-body" role="status" aria-live="polite">

        {if $errorMessage}

            {include file="$template/includes/alert.tpl" type="danger" msg=$errorMessage textcenter=true}

        {elseif $infoMessage}

            {include file="$template/includes/alert.tpl" type="info" msg=$infoMessage textcenter=true}

        {elseif $action == 'optin'}

            {include file="$template/includes/alert.tpl" type="success" msg="{lang key='thankYou'}" textcenter=true}
            <p class="text-center">{lang key='newslettersubscribed'}</p>

        {elseif $action == 'optout'}

            {include file="$template/includes/alert.tpl" type="success" msg="{lang key='thankYou'}" textcenter=true}
            <p>{lang key='newsletterremoved'}</p>
            <p>{"{lang key='newsletterresubscribe'}"|sprintf2:'<a href="clientarea.php?action=details">':'</a>'}</p>

        {/if}

        <br>

        <p class="text-center">
            <a href="{$WEB_ROOT}/index.php" class="btn btn-default"
               aria-label="{lang key='returnhome'}">
                <i class="fas fa-home" aria-hidden="true"></i>
                {lang key='returnhome'}
            </a>
        </p>

    </div>
</div>

<br /><br />
