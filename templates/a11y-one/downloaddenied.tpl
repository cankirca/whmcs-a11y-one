{* WS-G downloaddenied.tpl
   Base: templates/twenty-one/downloaddenied.tpl
   Parent: twenty-one (NOT six)
   Rendered inside site chrome; a11y-one.js loads via footer.
   A11y fixes:
   - Submit buttons (renew / order now): already have text content from parent;
     preserved. The &raquo; is supplemental — kept as-is (visually decorative).
   - Error alert at top: already uses includes/alert.tpl which renders role-aware.
   - Info alert: same.
   - No heading in parent; page is accessed after an error so the flash/alert
     at top provides the error context. No h1 required here as this fragment
     renders inside the client-area chrome's main content area which has a
     page-level h1 from the breadcrumb/page-title region in header.tpl. *}

{if $reason eq "supportandupdates"}

    {include file="$template/includes/alert.tpl" type="error" msg="{lang key='supportAndUpdatesExpiredLicense'}{if $licensekey}: {$licensekey}{else}.{/if}" textcenter=true}

{/if}

<div class="card">
    <div class="card-body">
        {if $reason eq "supportandupdates"}

            <p>{lang key='supportAndUpdatesRenewalRequired'}</p>

            <form action="{$systemsslurl}cart.php?a=add" method="post">
                <input type="hidden" name="productid" value="{$serviceid}" />
                <input type="hidden" name="aid" value="{$addonid}" />
                <div class="text-center">
                    <button type="submit" class="btn btn-default">
                        {lang key='supportAndUpdatesClickHereToRenew'} &raquo;
                    </button>
                </div>
            </form>

        {else}

            <p>{lang key='downloadproductrequired'}</p>

            {if $prodname}
                {include file="$template/includes/alert.tpl" type="info" msg=$prodname textcenter=true}
            {else}
                {include file="$template/includes/alert.tpl" type="info" msg=$addonname textcenter=true}
            {/if}

            {if $pid || $aid}
                <form action="{$systemsslurl}cart.php" method="post">
                    {if $pid}
                        <input type="hidden" name="a" value="add" />
                        <input type="hidden" name="pid" value="{$pid}" />
                    {elseif $aid}
                        <input type="hidden" name="gid" value="addons" />
                    {/if}
                    <div class="text-center">
                        <button type="submit" class="btn btn-default">
                            {lang key='ordernowbutton'} &raquo;
                        </button>
                    </div>
                </form>
            {/if}

        {/if}
    </div>
</div>
