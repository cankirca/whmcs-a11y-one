{* WS-G clientareahome.tpl
   Base: templates/twenty-one/clientareahome.tpl
   Parent: twenty-one (NOT six)
   A11y fixes applied to a fresh copy of the twenty-one parent:
   - Stat tiles: each <a> link gets aria-label="<title>: <count>" so the link has
     an accessible name combining label + count. The icon, stat div, and title div
     are aria-hidden (all three are purely decorative once aria-label is present).
     The colour highlight bar conveys category visually — but the accessible name
     conveys the same information in text, so colour is NOT the only information cue.
   - captchaError alert: role="alert" added.
   - Hook-injected panels: h3 heading gets a stable id derived from item name;
     panel div gets aria-labelledby pointing at it.
   - Panel btn-icon and child-item icons: aria-hidden (decorative).
   - All other markup is a 1:1 copy of the twenty-one parent — no methods are
     added or removed. *}

{include file="$template/includes/flashmessage.tpl"}

{* Clear page heading so the dashboard has a real <h1> as its first heading. *}
<h1 class="h3 mb-4">{lang key='a11yDashboard'}</h1>

<div class="tiles mb-4">
    <div class="row no-gutters">
        <div class="col-6 col-xl-3">
            <a href="clientarea.php?action=services" class="tile" aria-label="{lang key='navservices'}: {$clientsstats.productsnumactive|escape}">
                <i class="fas fa-cube" aria-hidden="true"></i>
                <div class="stat" aria-hidden="true">{$clientsstats.productsnumactive}</div>
                <div class="title" aria-hidden="true">{lang key='navservices'}</div>
                <div class="highlight bg-color-blue"></div>
            </a>
        </div>
        {if $clientsstats.numdomains || $registerdomainenabled || $transferdomainenabled}
            <div class="col-6 col-xl-3">
                <a href="clientarea.php?action=domains" class="tile" aria-label="{lang key='navdomains'}: {$clientsstats.numactivedomains|escape}">
                    <i class="fas fa-globe" aria-hidden="true"></i>
                    <div class="stat" aria-hidden="true">{$clientsstats.numactivedomains}</div>
                    <div class="title" aria-hidden="true">{lang key='navdomains'}</div>
                    <div class="highlight bg-color-green"></div>
                </a>
            </div>
        {elseif $condlinks.affiliates && $clientsstats.isAffiliate}
            <div class="col-6 col-xl-3">
                <a href="affiliates.php" class="tile" aria-label="{lang key='affiliatessignups'}: {$clientsstats.numaffiliatesignups|escape}">
                    <i class="fas fa-shopping-cart" aria-hidden="true"></i>
                    <div class="stat" aria-hidden="true">{$clientsstats.numaffiliatesignups}</div>
                    <div class="title" aria-hidden="true">{lang key='affiliatessignups'}</div>
                    <div class="highlight bg-color-green"></div>
                </a>
            </div>
        {else}
            <div class="col-6 col-xl-3">
                <a href="clientarea.php?action=quotes" class="tile" aria-label="{lang key='quotes'}: {$clientsstats.numquotes|escape}">
                    <i class="far fa-file-alt" aria-hidden="true"></i>
                    <div class="stat" aria-hidden="true">{$clientsstats.numquotes}</div>
                    <div class="title" aria-hidden="true">{lang key='quotes'}</div>
                    <div class="highlight bg-color-green"></div>
                </a>
            </div>
        {/if}
        <div class="col-6 col-xl-3">
            <a href="supporttickets.php" class="tile" aria-label="{lang key='navtickets'}: {$clientsstats.numactivetickets|escape}">
                <i class="fas fa-comments" aria-hidden="true"></i>
                <div class="stat" aria-hidden="true">{$clientsstats.numactivetickets}</div>
                <div class="title" aria-hidden="true">{lang key='navtickets'}</div>
                <div class="highlight bg-color-red"></div>
            </a>
        </div>
        <div class="col-6 col-xl-3">
            <a href="clientarea.php?action=invoices" class="tile" aria-label="{lang key='navinvoices'}: {$clientsstats.numunpaidinvoices|escape}">
                <i class="fas fa-credit-card" aria-hidden="true"></i>
                <div class="stat" aria-hidden="true">{$clientsstats.numunpaidinvoices}</div>
                <div class="title" aria-hidden="true">{lang key='navinvoices'}</div>
                <div class="highlight bg-color-gold"></div>
            </a>
        </div>
    </div>
</div>

{foreach $addons_html as $addon_html}
    <div>
        {$addon_html}
    </div>
{/foreach}

{if $captchaError}
    <div class="alert alert-danger" role="alert">
        {$captchaError}
    </div>
{/if}

<div class="client-home-cards">
    <div class="row">
        <div class="col-12">
            {function name=outputHomePanels}
                {assign var="panelHeadId" value="panel-hd-"|cat:$item->getName()|regex_replace:'/[^a-z0-9]/i':'-'}
                <div menuItemName="{$item->getName()}" class="card card-accent-{$item->getExtra('color')}{if $item->getClass()} {$item->getClass()}{/if}" aria-labelledby="{$panelHeadId}"{if $item->getAttribute('id')} id="{$item->getAttribute('id')}"{/if}>
                    <div class="card-header">
                        <h3 class="card-title m-0" id="{$panelHeadId}">
                            {if $item->getExtra('btn-link') && $item->getExtra('btn-text')}
                                <div class="float-right">
                                    <a href="{$item->getExtra('btn-link')}" class="btn btn-default bg-color-{$item->getExtra('color')} btn-xs">
                                        {if $item->getExtra('btn-icon')}<i class="{$item->getExtra('btn-icon')}" aria-hidden="true"></i>{/if}
                                        {$item->getExtra('btn-text')}
                                    </a>
                                </div>
                            {/if}
                            {if $item->hasIcon()}<i class="{$item->getIcon()}" aria-hidden="true"></i>&nbsp;{/if}
                            {$item->getLabel()}
                            {if $item->hasBadge()}&nbsp;<span class="badge">{$item->getBadge()}</span>{/if}
                        </h3>
                    </div>
                    {if $item->hasBodyHtml()}
                        <div class="card-body">
                            {$item->getBodyHtml()}
                        </div>
                    {/if}
                    {if $item->hasChildren()}
                        <div class="list-group{if $item->getChildrenAttribute('class')} {$item->getChildrenAttribute('class')}{/if}">
                            {foreach $item->getChildren() as $childItem}
                                {if $childItem->getUri()}
                                    <a menuItemName="{$childItem->getName()}" href="{$childItem->getUri()}" class="list-group-item list-group-item-action{if $childItem->getClass()} {$childItem->getClass()}{/if}{if $childItem->isCurrent()} active{/if}"{if $childItem->getAttribute('dataToggleTab')} data-toggle="tab"{/if}{if $childItem->getAttribute('target')} target="{$childItem->getAttribute('target')}"{/if} id="{$childItem->getId()}">
                                        {if $childItem->hasIcon()}<i class="{$childItem->getIcon()}" aria-hidden="true"></i>&nbsp;{/if}
                                        {$childItem->getLabel()}
                                        {if $childItem->hasBadge()}&nbsp;<span class="badge">{$childItem->getBadge()}</span>{/if}
                                    </a>
                                {else}
                                    <div menuItemName="{$childItem->getName()}" class="list-group-item list-group-item-action{if $childItem->getClass()} {$childItem->getClass()}{/if}" id="{$childItem->getId()}">
                                        {if $childItem->hasIcon()}<i class="{$childItem->getIcon()}" aria-hidden="true"></i>&nbsp;{/if}
                                        {$childItem->getLabel()}
                                        {if $childItem->hasBadge()}&nbsp;<span class="badge">{$childItem->getBadge()}</span>{/if}
                                    </div>
                                {/if}
                            {/foreach}
                        </div>
                    {/if}
                    <div class="card-footer">
                        {if $item->hasFooterHtml()}
                            {$item->getFooterHtml()}
                        {/if}
                    </div>
                </div>
            {/function}

            {foreach $panels as $item}
                {if $item->getExtra('colspan')}
                    {outputHomePanels}
                    {assign "panels" $panels->removeChild($item->getName())}
                {/if}
            {/foreach}

        </div>
        <div class="col-md-6 col-lg-12 col-xl-6">

            {foreach $panels as $item}
                {if $item@iteration is odd}
                    {outputHomePanels}
                {/if}
            {/foreach}

        </div>
        <div class="col-md-6 col-lg-12 col-xl-6">

            {foreach $panels as $item}
                {if $item@iteration is even}
                    {outputHomePanels}
                {/if}
            {/foreach}

        </div>
    </div>
</div>
