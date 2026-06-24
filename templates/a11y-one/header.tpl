{assign var="isAuthPage" value=in_array($templatefile, ['login','clientregister','password-reset-container','user-password'])}
<!doctype html>
<html lang="{if $language == 'turkish'}tr{else}en{/if}">
<head>
    <meta charset="{$charset}" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    {* Build a meaningful, page-specific <title>. WHMCS leaves $pagetitle as a
       generic "Client Area" on most client-area actions; the breadcrumb leaf is
       the actual page (e.g. "Product Details", "My Invoices"), so lead with it. *}
    {assign var="a11yTitleLeaf" value=""}
    {if $breadcrumb}{foreach $breadcrumb as $a11yBc}{if $a11yBc@last}{assign var="a11yTitleLeaf" value=$a11yBc.label|strip_tags|trim}{/if}{/foreach}{/if}
    <title>{if $kbarticle.title}{$kbarticle.title}{elseif $a11yTitleLeaf && $a11yTitleLeaf != $pagetitle}{$a11yTitleLeaf}{else}{$pagetitle}{/if} - {$companyname}</title>
    {include file="$template/includes/head.tpl"}
    {$headoutput}
</head>
<body class="{if $isAuthPage}auth-page{else}primary-bg-color{/if}" data-phone-cc-input="{$phoneNumberInputStyle}">
    <a class="skip-link" href="#main-body">{lang key='skipToMainContent'}</a>
    {if $captcha}{$captcha->getMarkup()}{/if}
    {$headeroutput}

    {if !$isAuthPage}
    <header id="header" class="header">
        {if $loggedin}
            <div class="topbar">
                <div class="container">
                    <div class="d-flex">
                        <div class="mr-auto">
                            <button type="button" class="btn" data-toggle="popover" id="accountNotifications" data-placement="bottom" aria-haspopup="dialog" aria-expanded="false" aria-controls="accountNotificationsContent" aria-label="{lang key='notifications'} ({count($clientAlerts)})">
                                <i class="far fa-flag" aria-hidden="true"></i>
                                {if count($clientAlerts) > 0}
                                    {count($clientAlerts)}
                                    <span class="d-none d-sm-inline">{lang key='notifications'}</span>
                                {else}
                                    <span class="d-sm-none">0</span>
                                    <span class="d-none d-sm-inline">{lang key='nonotifications'}</span>
                                {/if}
                            </button>
                            <div id="accountNotificationsContent" class="w-hidden" tabindex="-1">
                                <ul class="client-alerts">
                                {foreach $clientAlerts as $alert}
                                    <li>
                                        <a href="{$alert->getLink()}">
                                            <i class="fas fa-fw fa-{if $alert->getSeverity() == 'danger'}exclamation-circle{elseif $alert->getSeverity() == 'warning'}exclamation-triangle{elseif $alert->getSeverity() == 'info'}info-circle{else}check-circle{/if}" aria-hidden="true"></i>
                                            <div class="message">{$alert->getMessage()}</div>
                                        </a>
                                    </li>
                                {foreachelse}
                                    <li class="none">
                                        {lang key='notificationsnone'}
                                    </li>
                                {/foreach}
                                </ul>
                            </div>
                        </div>

                        <div class="ml-auto">
                            <div class="input-group active-client" role="group">
                                <div class="input-group-prepend d-none d-md-inline">
                                    <span class="input-group-text">{lang key='loggedInAs'}:</span>
                                </div>
                                <div class="btn-group">
                                    <a href="{$WEB_ROOT}/clientarea.php?action=details" class="btn btn-active-client">
                                        <span>
                                            {if $client.companyname}
                                                {$client.companyname}
                                            {else}
                                                {$client.fullName}
                                            {/if}
                                        </span>
                                    </a>
                                    <a href="{routePath('user-accounts')}" class="btn" data-toggle="tooltip" data-placement="bottom" title="{lang key='a11ySwitchAccount'}" aria-label="{lang key='a11ySwitchAccount'}">
                                        <i class="fad fa-random" aria-hidden="true"></i>
                                    </a>
                                    {if $adminMasqueradingAsClient || $adminLoggedIn}
                                        <a href="{$WEB_ROOT}/logout.php?returntoadmin=1" class="btn btn-return-to-admin" data-toggle="tooltip" data-placement="bottom" aria-label="{lang key='admin.returnToAdmin'}" title="{if $adminMasqueradingAsClient}{lang key='adminmasqueradingasclient'} {lang key='logoutandreturntoadminarea'}{else}{lang key='adminloggedin'} {lang key='returntoadminarea'}{/if}">
                                            <i class="fas fa-redo-alt" aria-hidden="true"></i>
                                            <span class="d-none d-md-inline-block">{lang key="admin.returnToAdmin"}</span>
                                        </a>
                                    {/if}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        {/if}

        <div class="navbar navbar-light">
            <div class="container">
                <a class="navbar-brand mr-3" href="{$WEB_ROOT}/index.php">
                    {if $assetLogoPath}
                        <img src="{$assetLogoPath}" alt="{$companyname}" class="logo-img">
                    {else}
                        {$companyname}
                    {/if}
                </a>

                <form method="post" action="{routePath('knowledgebase-search')}" class="form-inline ml-auto">
                    <div class="input-group search d-none d-xl-flex">
                        <div class="input-group-prepend">
                            <button class="btn btn-default" type="submit">
                                <i class="fas fa-search" aria-hidden="true"></i>
                                <span class="sr-only">{lang key="searchOurKnowledgebase"}</span>
                            </button>
                        </div>
                        <input class="form-control appended-form-control font-weight-light" type="text" name="search" placeholder="{lang key="searchOurKnowledgebase"}...">
                    </div>
                </form>

                <ul class="navbar-nav toolbar">
                    <li class="nav-item ml-3">
                        <a class="btn nav-link cart-btn" href="{$WEB_ROOT}/cart.php?a=view" aria-label="{lang key='carttitle'} ({$cartitemcount} {lang key='a11yItemsInCart'})">
                            <i class="far fa-shopping-cart fa-fw" aria-hidden="true"></i>
                            <span id="cartItemCount" class="badge badge-info" aria-hidden="true">{$cartitemcount}</span>
                        </a>
                    </li>
                    <li class="nav-item ml-3 d-xl-none">
                        <button class="btn nav-link" type="button" data-toggle="collapse" data-target="#mainNavbar" aria-controls="mainNavbar" aria-expanded="false" aria-label="{lang key='a11yMenu'}">
                            <span class="fas fa-bars fa-fw" aria-hidden="true"></span>
                        </button>
                    </li>
                </ul>
            </div>
        </div>
        <div class="navbar navbar-expand-xl main-navbar-wrapper">
            <div class="container">
                <div class="collapse navbar-collapse" id="mainNavbar">
                    <form method="post" action="{routePath('knowledgebase-search')}" class="d-xl-none">
                        <div class="input-group search w-100 mb-2">
                            <div class="input-group-prepend">
                                <button class="btn btn-default" type="submit">
                                    <i class="fas fa-search" aria-hidden="true"></i>
                                    <span class="sr-only">{lang key="searchOurKnowledgebase"}</span>
                                </button>
                            </div>
                            <input class="form-control prepended-form-control" type="text" name="search" placeholder="{lang key="searchOurKnowledgebase"}...">
                        </div>
                    </form>
                    <ul id="nav" class="navbar-nav mr-auto">
                        {include file="$template/includes/navbar.tpl" navbar=$primaryNavbar}
                    </ul>
                    <ul class="navbar-nav ml-auto">
                        {include file="$template/includes/navbar.tpl" navbar=$secondaryNavbar rightDrop=true}
                    </ul>
                </div>
            </div>
        </div>
    </header>

    {include file="$template/includes/network-issues-notifications.tpl"}

    <nav class="master-breadcrumb" aria-label="breadcrumb">
        <div class="container">
            {include file="$template/includes/breadcrumb.tpl"}
        </div>
    </nav>

    {include file="$template/includes/validateuser.tpl"}
    {include file="$template/includes/verifyemail.tpl"}

    {if $templatefile == 'homepage'}
        {if $registerdomainenabled || $transferdomainenabled}
            {include file="$template/includes/domain-search.tpl"}
        {/if}
    {/if}

    {/if}

    {if $isAuthPage}
    <main id="main-body" class="auth-main" tabindex="-1">
        <div class="auth-wrapper">
            <a class="auth-logo" href="{$WEB_ROOT}/index.php">
                {if $assetLogoPath}<img src="{$assetLogoPath}" alt="{$companyname}">{else}{$companyname}{/if}
            </a>
    {else}
    <section id="main-body" role="main" tabindex="-1">
        <div class="{if !$skipMainBodyContainer}container{/if}">
            <div class="{if !$inShoppingCart && ($primarySidebar->hasChildren() || $secondarySidebar->hasChildren())}row{/if}">

            {if !$inShoppingCart && ($primarySidebar->hasChildren() || $secondarySidebar->hasChildren())}
                <nav class="col-lg-4 col-xl-3" aria-label="{lang key='a11ySidebarNav'}">
                    <div class="sidebar">
                        {include file="$template/includes/sidebar.tpl" sidebar=$primarySidebar}
                    </div>
                    {if !$inShoppingCart && $secondarySidebar->hasChildren()}
                        <div class="d-none d-lg-block sidebar">
                            {include file="$template/includes/sidebar.tpl" sidebar=$secondarySidebar}
                        </div>
                    {/if}
                </nav>
            {/if}
            <div class="{if !$inShoppingCart && ($primarySidebar->hasChildren() || $secondarySidebar->hasChildren())}col-lg-8 col-xl-9{/if} primary-content">
    {/if}
