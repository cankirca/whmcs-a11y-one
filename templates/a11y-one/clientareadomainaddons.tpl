{*
 * A11y One — clientareadomainaddons.tpl
 * Buy/disable addon: sr-only addon-name context added to price-only buttons;
 * hardcoded "Domain:" replaced with lang key.
 * Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca
 *}
<div class="card">
    <div class="card-body">

        <form method="post" action="{$smarty.server.PHP_SELF}?action=domainaddons">
            <input type="hidden" name="{$action}" value="{$addon}">
            <input type="hidden" name="id" value="{$domainid}">
            <input type="hidden" name="confirm" value="1">
            <input type="hidden" name="token" value="{$token}">

            {if $action eq "buy"}
                <input type="hidden" name="buy" value="{$addon}">

                {if $addon eq "dnsmanagement"}

                    <h3 class="card-title">{lang key='domainaddonsdnsmanagement'}</h3>

                    {include file="$template/includes/alert.tpl" type="info" msg="{lang key='clientareahostingdomain'}: <strong>{$domain}</strong>" textcenter=true}

                    <p>{lang key='domainaddonsdnsmanagementinfo'}</p>

                    <p class="text-center">
                        <button type="submit" name="enable" class="btn btn-success btn-lg">
                            {lang key='domainaddonsbuynow'} {$addonspricing.dnsmanagement}{lang key='domainaddonsperyear'}
                            <span class="sr-only"> — {lang key='domainaddonsdnsmanagement'}</span>
                        </button>
                    </p>

                {elseif $addon eq "emailfwd"}

                    <h3 class="card-title">{lang key='domainemailforwarding'}</h3>

                    {include file="$template/includes/alert.tpl" type="info" msg="{lang key='clientareahostingdomain'}: <strong>{$domain}</strong>" textcenter=true}

                    <p>{lang key='domainaddonsemailforwardinginfo'}</p>

                    <p class="text-center">
                        <button type="submit" name="enable" class="btn btn-success btn-lg">
                            {lang key='domainaddonsbuynow'} {$addonspricing.emailforwarding}{lang key='domainaddonsperyear'}
                            <span class="sr-only"> — {lang key='domainemailforwarding'}</span>
                        </button>
                    </p>

                {elseif $addon eq "idprotect"}

                    <h3 class="card-title">{lang key='domainidprotection'}</h3>

                    {include file="$template/includes/alert.tpl" type="info" msg="{lang key='clientareahostingdomain'}: <strong>{$domain}</strong>" textcenter=true}

                    <p>{lang key='domainaddonsidprotectioninfo'}</p>

                    <p class="text-center">
                        <button type="submit" name="enable" class="btn btn-success btn-lg">
                            {lang key='domainaddonsbuynow'} {$addonspricing.idprotection}{lang key='domainaddonsperyear'}
                            <span class="sr-only"> — {lang key='domainidprotection'}</span>
                        </button>
                    </p>
                {/if}
            {elseif $action eq "disable"}
                <input type="hidden" name="disable" value="{$addon}">
                <h3 class="card-title">
                    {if $addon eq "dnsmanagement"}
                        {lang key='domainaddonsdnsmanagement'}
                    {elseif $addon eq "emailfwd"}
                        {lang key='domainemailforwarding'}
                    {elseif $addon eq "idprotect"}
                        {lang key='domainidprotection'}
                    {/if}
                </h3>

                {include file="$template/includes/alert.tpl" type="info" msg="{lang key='clientareahostingdomain'}: <strong>{$domain}</strong>" textcenter=true}

                {if $success}
                    {include file="$template/includes/alert.tpl" type="success" msg="{lang key='domainaddonscancelsuccess'}" textcenter=true}
                {elseif $error}
                    {include file="$template/includes/alert.tpl" type="error" msg="{lang key='domainaddonscancelfailed'}" textcenter=true}
                {else}
                    <p>{lang key='domainaddonscancelwarning'}</p>

                    <p class="text-center">
                        <button type="submit" name="disable" class="btn btn-danger btn-lg">
                            {lang key='domainaddonscancelconfirm'}
                            <span class="sr-only"> —
                                {if $addon eq "dnsmanagement"}
                                    {lang key='domainaddonsdnsmanagement'}
                                {elseif $addon eq "emailfwd"}
                                    {lang key='domainemailforwarding'}
                                {elseif $addon eq "idprotect"}
                                    {lang key='domainidprotection'}
                                {/if}
                            </span>
                        </button>
                        <a href="{$smarty.server.PHP_SELF}?action=domaindetails&domainid={$domainid}" class="btn btn-default btn-lg">
                            {lang key='clientareabacklink'}
                        </a>
                    </p>
                {/if}
            {/if}

        </form>

    </div>
</div>
