{* WS-G oauth/layout.tpl
   Base: templates/twenty-one/oauth/layout.tpl
   Parent: twenty-one (NOT six)
   STANDALONE page (own <!DOCTYPE>). This layout wraps all OAuth pages.
   a11y-one.js does NOT load (no site footer). custom.css loads via assetExists.
   Fixes are self-sufficient — no external JS helpers needed.
   A11y fixes:
   - html lang: locale-aware (Smarty $language var available in OAuth context).
   - Logo img: alt text set to company name (was empty in parent).
   - App logo img alt: covered in child pages (authorize.tpl, login.tpl).
   - "Not you?" anchor <a href="#" onclick=...> → <button type="button">.
   - <section id="header"> → <header> landmark with aria-label.
   - <section id="content"> → <main id="main-body"> landmark.
   - <section id="footer"> → <footer> landmark.
   - Skip link to main content.
   - scripts.min.js preserved (OAuth JS requires jQuery). *}

<!DOCTYPE html>
<html lang="{if $language=='turkish'}tr{else}en{/if}">
  <head>
    <meta charset="{$charset}">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{$requestedAction} - {$companyname}</title>

    <link href="{assetPath file='all.min.css'}" rel="stylesheet">
    <link href="{assetPath file='theme.min.css'}?v={$versionHash}" rel="stylesheet">
    {assetExists file="custom.css"}
    <link href="{$__assetPath__}" rel="stylesheet">
    {/assetExists}
    <link href="{assetPath file='oauth.css'}" rel="stylesheet">

    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
    <a class="sr-only sr-only-focusable" href="#main-body">{if $language=='turkish'}Ana içeriğe geç{else}Skip to main content{/if}</a>

    <header id="header" aria-label="{$companyname|escape}">
        <div class="container clearfix">
            <img src="{$logo}" alt="{$companyname|escape}" />
            <div class="float-right text-right">
                {if $loggedin}
                    <form method="post" action="{$issuerurl}oauth/authorize.php" id="frmLogout">
                        <input type="hidden" name="logout" value="1"/>
                        <input type="hidden" name="request_hash" value="{$request_hash|escape:'html'}"/>
                        <p>
                            {lang key='oauth.currentlyLoggedInAs' firstName=$userInfo.firstName lastName=$userInfo.lastName}{if $userInfo.clientName} ({$userInfo.clientName}){/if}.
                            <button type="button" class="btn btn-link p-0" onclick="jQuery('#frmLogout').submit()">{lang key='oauth.notYou'}</button>
                        </p>
                    </form>
                {/if}
                <form method="post" action="{$issuerurl}oauth/authorize.php" id="frmCancelLogin">
                    <input type="hidden" name="return_to_app" value="1"/>
                    <input type="hidden" name="request_hash" value="{$request_hash|escape:'html'}"/>
                    <button type="submit" class="btn btn-default">
                        {lang key='oauth.returnToApp' appName=$appName}
                    </button>
                </form>
            </div>
        </div>
    </header>

    <main id="main-body">
        {$content}
    </main>

    <footer id="footer">
        {lang key='oauth.copyrightFooter' dateYear=$date_year companyName=$companyname}
    </footer>

    <script src="{assetPath file='scripts.min.js'}"></script>
  </body>
</html>
