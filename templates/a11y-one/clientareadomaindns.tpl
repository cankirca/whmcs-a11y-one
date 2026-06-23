{*
 * A11y One — clientareadomaindns.tpl
 * Inline-edit DNS table: caption added; th elements get scope+id; each cell
 * input gets headers + aria-label for AT; new-record row labelled sr-only.
 * Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca
 *}
<div class="card">
    <div class="card-body">
        <h3 class="card-title">{lang key='domaindnsmanagement'}</h3>

        {include file="$template/includes/alert.tpl" type="info" msg="{lang key='domaindnsmanagementdesc'}"}

        {if $error}
            {include file="$template/includes/alert.tpl" type="error" msg=$error}
        {/if}

        {if $external}
            <div class="text-center px-4">
                {$code}
            </div>
        {else}

            <form method="post" action="{$smarty.server.PHP_SELF}?action=domaindns">
                <input type="hidden" name="sub" value="save" />
                <input type="hidden" name="domainid" value="{$domainid}" />

                <table class="table table-striped">
                    <caption class="sr-only">{lang key='domaindnsmanagement'}</caption>
                    <thead>
                        <tr>
                            <th scope="col" id="dnsHostHead">{lang key='domaindnshostname'}</th>
                            <th scope="col" id="dnsTypeHead">{lang key='domaindnsrecordtype'}</th>
                            <th scope="col" id="dnsAddrHead">{lang key='domaindnsaddress'}</th>
                            <th scope="col" id="dnsPrioHead">{lang key='domaindnspriority'}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $dnsrecords as $dnsrecord}
                            <tr>
                                <td headers="dnsHostHead">
                                    <input type="hidden" name="dnsrecid[]" value="{$dnsrecord.recid}" />
                                    <input type="text" name="dnsrecordhost[]" value="{$dnsrecord.hostname}" size="10" class="form-control" aria-label="{lang key='domaindnshostname'}" />
                                </td>
                                <td headers="dnsTypeHead">
                                    <select name="dnsrecordtype[]" class="form-control" aria-label="{lang key='domaindnsrecordtype'}">
                                        <option value="A"{if $dnsrecord.type eq "A"} selected="selected"{/if}>{lang key="domainDns.a"}</option>
                                        <option value="AAAA"{if $dnsrecord.type eq "AAAA"} selected="selected"{/if}>{lang key="domainDns.aaaa"}</option>
                                        <option value="MXE"{if $dnsrecord.type eq "MXE"} selected="selected"{/if}>{lang key="domainDns.mxe"}</option>
                                        <option value="MX"{if $dnsrecord.type eq "MX"} selected="selected"{/if}>{lang key="domainDns.mx"}</option>
                                        <option value="CNAME"{if $dnsrecord.type eq "CNAME"} selected="selected"{/if}>{lang key="domainDns.cname"}</option>
                                        <option value="TXT"{if $dnsrecord.type eq "TXT"} selected="selected"{/if}>{lang key="domainDns.txt"}</option>
                                        <option value="URL"{if $dnsrecord.type eq "URL"} selected="selected"{/if}>{lang key="domainDns.url"}</option>
                                        <option value="FRAME"{if $dnsrecord.type eq "FRAME"} selected="selected"{/if}>{lang key="domainDns.frame"}</option>
                                    </select>
                                </td>
                                <td headers="dnsAddrHead">
                                    <input type="text" name="dnsrecordaddress[]" value="{$dnsrecord.address}" size="40" class="form-control" aria-label="{lang key='domaindnsaddress'}" />
                                </td>
                                <td headers="dnsPrioHead">
                                    {if $dnsrecord.type eq "MX"}<input type="text" name="dnsrecordpriority[]" value="{$dnsrecord.priority}" size="2" class="form-control" aria-label="{lang key='domaindnspriority'}" />{else}<input type="hidden" name="dnsrecordpriority[]" value="N/A" />{lang key='domainregnotavailable'}{/if}
                                </td>
                            </tr>
                        {/foreach}
                        <tr>
                            <td headers="dnsHostHead">
                                <span class="sr-only">{lang key='a11yDomainAddNewRecord'}</span>
                                <input type="text" name="dnsrecordhost[]" size="10" class="form-control" aria-label="{lang key='domaindnshostname'}" />
                            </td>
                            <td headers="dnsTypeHead">
                                <select name="dnsrecordtype[]" class="form-control" aria-label="{lang key='domaindnsrecordtype'}">
                                    <option value="A">{lang key="domainDns.a"}</option>
                                    <option value="AAAA">{lang key="domainDns.aaaa"}</option>
                                    <option value="MXE">{lang key="domainDns.mxe"}</option>
                                    <option value="MX">{lang key="domainDns.mx"}</option>
                                    <option value="CNAME">{lang key="domainDns.cname"}</option>
                                    <option value="TXT">{lang key="domainDns.txt"}</option>
                                    <option value="URL">{lang key="domainDns.url"}</option>
                                    <option value="FRAME">{lang key="domainDns.frame"}</option>
                                </select>
                            </td>
                            <td headers="dnsAddrHead">
                                <input type="text" name="dnsrecordaddress[]" size="40" class="form-control" aria-label="{lang key='domaindnsaddress'}" />
                            </td>
                            <td headers="dnsPrioHead">
                                <input type="text" name="dnsrecordpriority[]" size="2" class="form-control" aria-label="{lang key='domaindnspriority'}" />
                            </td>
                        </tr>
                    </tbody>
                </table>

                <p class="text-right text-muted">
                    <small>* {lang key='domaindnsmxonly'}</small>
                </p>

                <div class="text-center">
                    <button type="submit" class="btn btn-primary">
                        {lang key='clientareasavechanges'}
                    </button>
                    <button type="reset" class="btn btn-default">
                        {lang key='clientareacancel'}
                    </button>
                </div>

            </form>

        {/if}

    </div>
</div>
