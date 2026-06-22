{assign var="isAuthPage" value=in_array($templatefile, ['login','clientregister','password-reset-container','user-password'])}
        {if $isAuthPage}
            </div>{* .auth-wrapper *}
        </main>
    {else}
                    </div>

                    </div>
                    {if !$inShoppingCart && $secondarySidebar->hasChildren()}
                        <div class="d-lg-none sidebar sidebar-secondary">
                            {include file="$template/includes/sidebar.tpl" sidebar=$secondarySidebar}
                        </div>
                    {/if}
                <div class="clearfix"></div>
            </div>
        </div>
    </section>
    {/if}

    {if !$isAuthPage}
    <footer id="footer" class="footer">
        <div class="container">
            <ul class="list-inline mb-7 text-center float-lg-right">
                {include file="$template/includes/social-accounts.tpl"}

                {if $languagechangeenabled && count($locales) > 1 || $currencies}
                    <li class="list-inline-item">
                        <button type="button" class="btn" data-toggle="modal" data-target="#modalChooseLanguage">
                            <div class="d-inline-block align-middle">
                                <div class="iti-flag {if $activeLocale.countryCode === '001'}us{else}{$activeLocale.countryCode|lower}{/if}"></div>
                            </div>
                            {$activeLocale.localisedName}
                            /
                            {$activeCurrency.prefix}
                            {$activeCurrency.code}
                        </button>
                    </li>
                {/if}
            </ul>

            <ul class="nav justify-content-center justify-content-lg-start mb-7">
                <li class="nav-item">
                    <a class="nav-link" href="{$WEB_ROOT}/contact.php">
                        {lang key='contactus'}
                    </a>
                </li>
                {if $acceptTOS}
                    <li class="nav-item">
                        <a class="nav-link" href="{$tosURL}" target="_blank">{lang key='ordertos'}</a>
                    </li>
                {/if}
            </ul>

            <p class="copyright mb-0">
                {lang key="copyrightFooterNotice" year=$date_year company=$companyname}
            </p>
        </div>
    </footer>

    <div id="fullpage-overlay" class="w-hidden">
        <div class="outer-wrapper">
            <div class="inner-wrapper">
                <img src="{$WEB_ROOT}/assets/img/overlay-spinner.svg" alt="">
                <br>
                <span class="msg"></span>
            </div>
        </div>
    </div>

    <div class="modal system-modal fade" id="modalAjax" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"></h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                        <span class="sr-only">{lang key='close'}</span>
                    </button>
                </div>
                <div class="modal-body">
                    {lang key='loading'}
                </div>
                <div class="modal-footer">
                    <div class="float-left loader">
                        <i class="fas fa-circle-notch fa-spin"></i>
                        {lang key='loading'}
                    </div>
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        {lang key='close'}
                    </button>
                    <button type="button" class="btn btn-primary modal-submit">
                        {lang key='submit'}
                    </button>
                </div>
            </div>
        </div>
    </div>

    <form method="get" action="{$currentpagelinkback}">
        <div class="modal modal-localisation" id="modalChooseLanguage" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-body">
                        <button type="button" class="close text-light" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>

                        {if $languagechangeenabled && count($locales) > 1}
                            <h5 class="h5 pt-5 pb-3">{lang key='chooselanguage'}</h5>
                            <div class="row item-selector">
                                <input type="hidden" name="language" data-current="{$language}" value="{$language}" />
                                {foreach $locales as $locale}
                                    <div class="col-4">
                                        <a href="#" class="item{if $language == $locale.language} active{/if}" data-value="{$locale.language}">
                                            {$locale.localisedName}
                                        </a>
                                    </div>
                                {/foreach}
                            </div>
                        {/if}
                        {if !$loggedin && $currencies}
                            <p class="h5 pt-5 pb-3">{lang key='choosecurrency'}</p>
                            <div class="row item-selector">
                                <input type="hidden" name="currency" data-current="{$activeCurrency.id}" value="">
                                {foreach $currencies as $selectCurrency}
                                    <div class="col-4">
                                        <a href="#" class="item{if $activeCurrency.id == $selectCurrency.id} active{/if}" data-value="{$selectCurrency.id}">
                                            {$selectCurrency.prefix} {$selectCurrency.code}
                                        </a>
                                    </div>
                                {/foreach}
                            </div>
                        {/if}
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-default">{lang key='apply'}</button>
                    </div>
                </div>
            </div>
        </div>
    </form>

    {if !$loggedin && $adminLoggedIn}
        <a href="{$WEB_ROOT}/logout.php?returntoadmin=1" class="btn btn-return-to-admin" data-toggle="tooltip" data-placement="bottom" title="{if $adminMasqueradingAsClient}{lang key='adminmasqueradingasclient'} {lang key='logoutandreturntoadminarea'}{else}{lang key='adminloggedin'} {lang key='returntoadminarea'}{/if}">
            <i class="fas fa-redo-alt"></i>
            <span class="d-none d-md-inline-block">{lang key="admin.returnToAdmin"}</span>
        </a>
    {/if}
    {else}{* end !$isAuthPage; auth-page footer below *}
    <footer class="auth-footer">
        <div class="container text-center">
            <p class="copyright mb-0">{lang key="copyrightFooterNotice" year=$date_year company=$companyname}</p>
        </div>
    </footer>
    {/if}

    {include file="$template/includes/generate-password.tpl"}

    {* i18n carrier: a11y-one.js reads these data-attributes for localised ARIA strings.
       Present on every page (moved here from tablelist.tpl) so auth pages also get
       localised labels (password reveal, strength meter). Hidden from layout and AT. *}
    <span id="a11yOneI18n" hidden
        data-collapse="{lang key='a11yCollapse'}"
        data-expand="{lang key='a11yExpand'}"
        data-panel="{lang key='a11yPanel'}"
        data-rowsperpage="{lang key='a11yRowsPerPage'}"
        data-tablepagination="{lang key='a11yTablePagination'}"
        data-prevpage="{lang key='a11yPrevPage'}"
        data-nextpage="{lang key='a11yNextPage'}"
        data-firstpage="{lang key='a11yFirstPage'}"
        data-lastpage="{lang key='a11yLastPage'}"
        data-page="{lang key='a11yPage'}"
        data-search="{lang key='a11ySearch'}"
        data-showpassword="{lang key='userLogin.showPassword'}"
        data-hidepassword="{lang key='userLogin.hidePassword'}"
        data-pwweak="{lang key='a11yPwWeak'}"
        data-pwfair="{lang key='a11yPwFair'}"
        data-pwstrong="{lang key='a11yPwStrong'}"
        data-copytoclipboard="{lang key='a11yCopyToClipboard'}"
        data-copied="{lang key='a11yCopied'}"
        data-sortable="{lang key='a11ySortable'}"
        data-sortedasc="{lang key='a11ySortedAsc'}"
        data-sorteddesc="{lang key='a11ySortedDesc'}"
        data-notsorted="{lang key='a11yNotSorted'}"
        data-devlicensenotice="{lang key='a11yDevLicenseNotice'}"
        data-mdeeditor="{lang key='a11yMdeEditor'}"
        data-mdetoolbar="{lang key='a11yMdeToolbar'}"
        data-mdebold="{lang key='a11yMdeBold'}"
        data-mdeitalic="{lang key='a11yMdeItalic'}"
        data-mdeheading="{lang key='a11yMdeHeading'}"
        data-mdeurl="{lang key='a11yMdeUrl'}"
        data-mdeimage="{lang key='a11yMdeImage'}"
        data-mdelist="{lang key='a11yMdeList'}"
        data-mdelisto="{lang key='a11yMdeListO'}"
        data-mdecode="{lang key='a11yMdeCode'}"
        data-mdequote="{lang key='a11yMdeQuote'}"
        data-mdepreview="{lang key='a11yMdePreview'}"
        data-mdehelp="{lang key='a11yMdeHelp'}"
        data-mdefullscreen="{lang key='a11yMdeFullscreen'}"
        data-fileattachment="{lang key='a11yFileAttachment'}"
        data-fileattachmentadded="{lang key='a11yFileAttachmentAdded'}"
    ></span>
    <script src="{$WEB_ROOT}/templates/{$template}/js/a11y-one.js"></script>
    {$footeroutput}

</body>
</html>
