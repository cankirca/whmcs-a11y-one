{*
 * A11y One — clientareadomaincontactinfo.tpl
 * Per-contact tabs: full tablist/tab/tabpanel ARIA; radio groups in
 * fieldset/legend; contact fields get explicit label/for pairs;
 * IRTP modal gets aria-modal + focus management via canonical initModalAria.
 * Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca
 *}
{if $successful}
    {include file="$template/includes/alert.tpl" type="success" msg="{lang key='changessavedsuccessfully'}" textcenter=true}
{/if}

{if $pending}
    {include file="$template/includes/alert.tpl" type="info" msg=$pendingMessage textcenter=true}
{/if}

{if $domainInformation && !$pending && $domainInformation->getIsIrtpEnabled() && $domainInformation->isContactChangePending()}
    {if $domainInformation->getPendingSuspension()}
        {include file="$template/includes/alert.tpl" type="warning" msg="<strong>{lang key='domains.verificationRequired'}</strong><br>{lang key='domains.newRegistration'}" textcenter=true}
    {else}
        {include file="$template/includes/alert.tpl" type="info" msg="<strong>{lang key='domains.contactChangePending'}</strong><br>{lang key='domains.contactsChanged'}" textcenter=true}
    {/if}
{/if}

{if $error}
    {include file="$template/includes/alert.tpl" type="error" msg=$error textcenter=true}
{/if}

<div class="card">
    <div class="card-body">
        <h3 class="card-title">{lang key='domaincontactinfo'}</h3>

        <p>{lang key='whoisContactWarning'}</p>

        <form method="post" action="{$smarty.server.PHP_SELF}?action=domaincontacts" id="frmDomainContactModification">

            <input type="hidden" name="sub" value="save" />
            <input type="hidden" name="domainid" value="{$domainid}" />

            <ul class="nav nav-tabs responsive-tabs-sm" role="tablist" aria-label="{lang key='domaincontactinfo'}">
                {foreach $contactdetails as $contactdetail => $values}
                    <li class="nav-item" role="presentation">
                        <a class="nav-link{if $values@first} active{/if}"
                           id="tabSelector{$contactdetail}"
                           data-toggle="tab"
                           href="#tab{$contactdetail}"
                           role="tab"
                           aria-controls="tab{$contactdetail}"
                           aria-selected="{if $values@first}true{else}false{/if}">{$contactdetail}</a>
                    </li>
                {/foreach}
            </ul>
            <div class="responsive-tabs-sm-connector"><div class="channel"></div><div class="bottom-border"></div></div>
            <div class="tab-content p-4">
                {foreach $contactdetails as $contactdetail => $values}
                    <div class="tab-pane fade{if $values@first} show active{/if}"
                         id="tab{$contactdetail}"
                         role="tabpanel"
                         tabindex="0"
                         aria-labelledby="tabSelector{$contactdetail}">

                        <fieldset>
                            <legend class="sr-only">{lang key='domaincontactinfo'} — {$contactdetail}</legend>

                            <div class="form-check">
                                <input type="radio" class="form-check-input" name="wc[{$contactdetail}]" id="{$contactdetail}1" value="contact" onclick="useDefaultWhois(this.id)" />
                                <label class="form-check-label" for="{$contactdetail}1">{lang key='domaincontactusexisting'}</label>
                            </div>

                            <div class="row">
                                <div class="offset-1 col-10">
                                    <div class="form-group">
                                        <label for="{$contactdetail}3">{lang key='domaincontactchoose'}</label>
                                        <input type="hidden" name="sel[{$contactdetail}]" value="">
                                        <select id="{$contactdetail}3" class="form-control custom-select {$contactdetail}defaultwhois" name="sel[{$contactdetail}]" disabled>
                                            <option value="u{$clientsdetails.userid}">{lang key='domaincontactprimary'}</option>
                                            {foreach $contacts as $contact}
                                                <option value="c{$contact.id}">{$contact.name}</option>
                                            {/foreach}
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="form-check">
                                <input type="radio" class="form-check-input" name="wc[{$contactdetail}]" id="{$contactdetail}2" value="custom" onclick="useCustomWhois(this.id)" checked />
                                <label class="form-check-label" for="{$contactdetail}2">{lang key='domaincontactusecustom'}</label>
                            </div>

                        </fieldset>

                        {foreach $values as $name => $value}
                            <div class="form-group">
                                <label for="contact_{$contactdetail}_{$name}">{$contactdetailstranslations[$name]}</label>
                                <input type="text"
                                       id="contact_{$contactdetail}_{$name}"
                                       name="contactdetails[{$contactdetail}][{$name}]"
                                       value="{$value}"
                                       data-original-value="{$value}"
                                       class="form-control {$contactdetail}customwhois{if array_key_exists($contactdetail, $irtpFields) && in_array($name, $irtpFields[$contactdetail])} irtp-field{/if}" />
                            </div>
                        {/foreach}
                    </div>
                {/foreach}
            </div>

            <p class="text-center">
                {if $domainInformation && $irtpFields}
                    <input id="irtpOptOut" type="hidden" name="irtpOptOut" value="0">
                    <input id="irtpOptOutReason" type="hidden" name="irtpOptOutReason" value="">
                {/if}
                <button type="submit" class="btn btn-primary">
                    {lang key='clientareasavechanges'}
                </button>
                <button type="reset" class="btn btn-default">
                    {lang key='clientareacancel'}
                </button>
            </p>

        </form>

    </div>
</div>

{if $domainInformation && $irtpFields}
    <div class="modal fade" id="modalIRTPConfirmation" role="dialog" aria-modal="true" aria-labelledby="IRTPConfirmationLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content card">
                <div id="modalIRTPConfirmationHeading" class="modal-header card-header bg-primary text-light">
                    <h4 class="modal-title" id="IRTPConfirmationLabel">{lang key='domains.importantReminder'}</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="{lang key='orderForm.close'}">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div id="modalIRTPConfirmationBody" class="modal-body card-body text-center">
                    <div class="row">
                        <div class="col-sm-10 offset-sm-1">
                            {lang key='domains.irtpNotice'}
                        </div>
                        <div class="col-sm-12">
                            <div class="checkbox-inline">
                                <label for="modalIrtpOptOut">
                                    <input id="modalIrtpOptOut" class="form-check-input" type="checkbox" value="1">
                                    {lang key='domains.optOut'}
                                </label>
                            </div>
                        </div>
                        <div class="col-sm-12">
                            <div class="row">
                                <div class="col-sm-12 text-left">
                                    <label for="modalReason">{lang key='domains.optOutReason'}</label>:
                                </div>
                                <div class="col-sm-12">
                                    <input id="modalReason" type="text" class="form-control input-600" autocomplete="off">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="modalIRTPConfirmationFooter" class="modal-footer card-footer">
                    <button type="button" id="IRTPConfirmation-Submit" class="btn btn-primary" onclick="irtpSubmit();return false;">
                        {lang key='supportticketsticketsubmit'}
                    </button>
                    <button type="button" id="IRTPConfirmation-Cancel" class="btn btn-default" data-dismiss="modal">
                        {lang key='cancel'}
                    </button>
                </div>
            </div>
        </div>
    </div>
{/if}
