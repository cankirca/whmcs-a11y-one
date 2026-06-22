{foreach $navbar as $item}
    <li menuItemName="{$item->getName()}" class="d-block{if $item@first} no-collapse{/if}{if $item->hasChildren()} dropdown no-collapse{/if}{if $item->getClass()} {$item->getClass()}{/if}" id="{$item->getId()}">
        <a class="{if !isset($rightDrop) || !$rightDrop}pr-4{/if}{if $item->hasChildren()} dropdown-toggle" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" aria-controls="{$item->getId()}-menu" href="#"{else}" href="{$item->getUri()}"{if $item->isCurrent()} aria-current="page"{/if}{/if}{if $item->getAttribute('target')} target="{$item->getAttribute('target')}"{/if}>
            {if $item->hasIcon()}<i class="{$item->getIcon()}" aria-hidden="true"></i>&nbsp;{/if}
            {$item->getLabel()}
            {if $item->hasBadge()}&nbsp;<span class="badge">{$item->getBadge()}</span>{/if}
        </a>
        {if $item->hasChildren()}
            <ul class="dropdown-menu{if isset($rightDrop) && $rightDrop} dropdown-menu-right{/if}" id="{$item->getId()}-menu">
            {foreach $item->getChildren() as $childItem}
                {if $childItem->getClass() && in_array($childItem->getClass(), ['dropdown-divider', 'nav-divider'])}
                    <div class="dropdown-divider"></div>
                {else}
                    <li menuItemName="{$childItem->getName()}" class="dropdown-item{if $childItem->getClass()} {$childItem->getClass()}{/if}" id="{$childItem->getId()}">
                        <a href="{$childItem->getUri()}" class="dropdown-item px-2 py-0"{if $childItem->isCurrent()} aria-current="page"{/if}{if $childItem->getAttribute('target')} target="{$childItem->getAttribute('target')}"{/if}>
                            {if $childItem->hasIcon()}<i class="{$childItem->getIcon()}" aria-hidden="true"></i>&nbsp;{/if}
                            {$childItem->getLabel()}
                            {if $childItem->hasBadge()}&nbsp;<span class="badge">{$childItem->getBadge()}</span>{/if}
                        </a>
                    </li>
                {/if}
            {/foreach}
            </ul>
        {/if}
    </li>
{/foreach}
{if !isset($rightDrop) || !$rightDrop}
    <li class="d-none dropdown collapsable-dropdown">
        <a class="dropdown-toggle" href="#" id="navbarDropdownMenu" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" aria-controls="navbarDropdownMenuList">
            {lang key='more'}
        </a>
        <ul class="collapsable-dropdown-menu dropdown-menu" id="navbarDropdownMenuList" aria-labelledby="navbarDropdownMenu">
        </ul>
    </li>
{/if}
