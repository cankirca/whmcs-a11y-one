{*
 * A11y One — clientareadomainemailforwarding.tpl
 * Inline-edit forwarding table: caption; th elements get scope+id; each cell
 * input gets headers + aria-label; new-forwarder row labelled sr-only.
 * Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca
 *}
{* Clear page heading. *}
<h1 class="h3 mb-4">{lang key='domainemailforwarding'}</h1>
<div class="card">
    <div class="card-body">
        <h3 class="card-title">{lang key='domainemailforwarding'}</h3>

        {include file="$template/includes/alert.tpl" type="info" msg="{lang key='domainemailforwardingdesc'}"}

        {if $error}
            {include file="$template/includes/alert.tpl" type="error" msg=$error}
        {/if}

        {if $external}
            <div class="text-center px-4">
                {$code}
            </div>
        {else}

            <form method="post" action="{$smarty.server.PHP_SELF}?action=domainemailforwarding">
                <input type="hidden" name="sub" value="save" />
                <input type="hidden" name="domainid" value="{$domainid}" />

                <table class="table table-striped">
                    <caption class="sr-only">{lang key='domainemailforwarding'}</caption>
                    <thead>
                        <tr>
                            <th scope="col" id="fwdPrefixHead">{lang key='domainemailforwardingprefix'}</th>
                            <th scope="col" id="fwdAtHead"><span class="sr-only">{lang key='a11yDomainForwardingAt'}</span></th>
                            <th scope="col" id="fwdToHead">{lang key='domainemailforwardingforwardto'}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $emailforwarders as $num => $emailforwarder}
                        <tr>
                            <td headers="fwdPrefixHead">
                                <input type="text" name="emailforwarderprefix[{$num}]" value="{$emailforwarder.prefix}" class="form-control" aria-label="{lang key='domainemailforwardingprefix'}" />
                            </td>
                            <td class="text-center" headers="fwdAtHead">@{$domain} =&gt; </td>
                            <td headers="fwdToHead">
                                <input type="text" name="emailforwarderforwardto[{$num}]" value="{$emailforwarder.forwardto}" class="form-control" aria-label="{lang key='domainemailforwardingforwardto'}" />
                            </td>
                        </tr>
                        {/foreach}
                        <tr>
                            <td headers="fwdPrefixHead">
                                <span class="sr-only">{lang key='a11yDomainAddNewForwarder'}</span>
                                <input type="text" name="emailforwarderprefixnew" class="form-control" aria-label="{lang key='domainemailforwardingprefix'}" />
                            </td>
                            <td class="text-center" headers="fwdAtHead">@{$domain} =&gt; </td>
                            <td headers="fwdToHead">
                                <input type="text" name="emailforwarderforwardtonew" class="form-control" aria-label="{lang key='domainemailforwardingforwardto'}" />
                            </td>
                        </tr>
                    </tbody>
                </table>

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
