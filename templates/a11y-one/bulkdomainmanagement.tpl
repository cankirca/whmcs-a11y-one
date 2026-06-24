{*
 * A11y One — bulkdomainmanagement.tpl
 * Bulk NS/contact editor: NS-choice radios in fieldset/legend; NS inputs
 * labelled; affected-domains list aria-labelledby; alerts role=alert;
 * contact tabs with full ARIA; contact field labels added.
 * Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca
 *}
{* Clear page heading. *}
<h1 class="h3 mb-4">{lang key='domainbulkmanagement'}</h1>
<div class="card">
    <div class="card-body">

        <form method="post" action="{$smarty.server.PHP_SELF}?action=bulkdomain">
            <input type="hidden" name="update" value="{$update}">
            <input type="hidden" name="save" value="1">
            {foreach $domainids as $domainid}
                <input type="hidden" name="domids[]" value="{$domainid}" />
            {/foreach}

            {if $update eq "nameservers"}
                <h3 class="card-title">{lang key='changenameservers'}</h3>

                {if $save}
                    {if $errors}
                    <div class="alert alert-error" role="alert">
                        <p class="bold">
                            {lang key='clientareaerrors'}
                        </p>
                        <ul>
                        {foreach $errors as $error}
                            <li>{$error}</li>
                        {/foreach}
                        </ul>
                    </div>
                    {else}
                    <div class="alert alert-success" role="status">
                        <p>
                            {lang key='changessavedsuccessfully'}
                        </p>
                    </div>
                    {/if}
                {/if}

                <p id="bulkAffectNs">
                    {lang key='domainbulkmanagementchangesaffect'}
                </p>

                <ul class="list-group mb-3" aria-labelledby="bulkAffectNs">
                    {foreach $domains as $domain}
                        <li class="list-group-item">{$domain}</li>
                    {/foreach}
                </ul>

                <fieldset>
                    <legend class="sr-only">{lang key='domainnameservers'}</legend>
                    <div class="form-check form-check-inline">
                        <input id="nsChoiceDefault" type="radio" class="form-check-input" name="nschoice" value="default" onclick="disableFields('domnsinputs',true)" checked />
                        <label for="nsChoiceDefault" class="form-check-label">
                            {lang key='nschoicedefault'}
                        </label>
                    </div>

                    <div class="form-check form-check-inline">
                        <input id="nsChoiceCustom" type="radio" class="form-check-input" name="nschoice" value="custom" onclick="disableFields('domnsinputs', '')" />
                        <label for="nsChoiceCustom" class="form-check-label">
                            {lang key='nschoicecustom'}
                        </label>
                    </div>
                </fieldset>

                {for $num=1 to 5}
                    <div class="form-group row">
                        <label for="inputNs{$num}" class="col-sm-4 col-form-label">{lang key='clientareanameserver'} {$num}</label>
                        <div class="col-sm-7">
                            <input type="text" name="ns{$num}" class="form-control domnsinputs" id="inputNs{$num}" />
                        </div>
                    </div>
                {/for}

                <div class="row">
                    <div class="col-sm-8 offset-sm-4">
                        <button type="submit" class="btn btn-primary btn-lg">
                            {lang key='changenameservers'}
                        </button>
                    </div>
                </div>

            {elseif $update eq "autorenew"}

                <h3 class="card-title">{lang key='domainautorenewstatus'}</h3>

                {if $save}
                    <div class="alert alert-success" role="status">
                        <p>
                            {lang key='changessavedsuccessfully'}
                        </p>
                    </div>
                {/if}

                <p>{lang key='domainautorenewinfo'}</p>
                <p>{lang key='domainautorenewrecommend'}</p>
                <p id="bulkAffectAutorenew">{lang key='domainbulkmanagementchangeaffect'}</p>

                <ul class="list-group mb-3" aria-labelledby="bulkAffectAutorenew">
                    {foreach $domains as $domain}
                        <li class="list-group-item">{$domain}</li>
                    {/foreach}
                </ul>

                <button type="submit" name="enable" class="btn btn-success btn-lg">
                    {lang key='domainsautorenewenable'}
                </button>
                <button type="submit" name="disable" class="btn btn-danger btn-lg">
                    {lang key='domainsautorenewdisable'}
                </button>

            {elseif $update eq "reglock"}

                <h3 class="card-title">{lang key='domainreglockstatus'}</h3>

                {if $save}
                    {if $errors}
                    <div class="alert alert-error" role="alert">
                        <p class="bold">
                            {lang key='clientareaerrors'}
                        </p>
                        <ul>
                        {foreach $errors as $error}
                            <li>{$error}</li>
                        {/foreach}
                        </ul>
                    </div>
                    {else}
                    <div class="alert alert-success" role="status">
                        <p>
                            {lang key='changessavedsuccessfully'}
                        </p>
                    </div>
                    {/if}
                {/if}

                <p>{lang key='domainreglockinfo'}</p>
                <p>{lang key='domainreglockrecommend'}</p>
                <p id="bulkAffectReglock">{lang key='domainbulkmanagementchangeaffect'}</p>

                <ul class="list-group mb-3" aria-labelledby="bulkAffectReglock">
                    {foreach $domains as $domain}
                        <li class="list-group-item">{$domain}</li>
                    {/foreach}
                </ul>

                <button type="submit" name="enable" class="btn btn-success btn-lg">
                    {lang key='domainreglockenable'}
                </button>
                <button type="submit" name="disable" class="btn btn-danger btn-lg">
                    {lang key='domainreglockdisable'}
                </button>

            {elseif $update eq "contactinfo"}

                <h3 class="card-title">{lang key='domaincontactinfoedit'}</h3>

                {if $save}
                    {if $errors}
                        <div class="alert alert-error" role="alert">
                            <p class="bold">
                                {lang key='clientareaerrors'}
                            </p>
                            <ul>
                                {foreach $errors as $error}
                                <li>{$error}</li>
                            {/foreach}
                            </ul>
                        </div>
                    {else}
                        <div class="alert alert-success" role="status">
                            <p>
                                {lang key='changessavedsuccessfully'}
                            </p>
                        </div>
                    {/if}
                {/if}

                <p id="bulkAffectContact">{lang key='domainbulkmanagementchangesaffect'}</p>

                <ul class="list-group mb-3" aria-labelledby="bulkAffectContact">
                    {foreach $domains as $domain}
                        <li class="list-group-item">{$domain}</li>
                    {/foreach}
                </ul>

                <ul class="nav nav-tabs responsive-tabs-sm" role="tablist" aria-label="{lang key='domaincontactinfoedit'}">
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
                                           class="form-control {$contactdetail}customwhois" />
                                </div>
                            {/foreach}
                        </div>
                    {/foreach}
                </div>

                <div class="row">
                    <div class="col-sm-8 offset-sm-4">
                        <button type="submit" class="btn btn-primary btn-lg">
                            {lang key='clientareasavechanges'}
                        </button>
                    </div>
                </div>

            {/if}

        </form>

    </div>
</div>
