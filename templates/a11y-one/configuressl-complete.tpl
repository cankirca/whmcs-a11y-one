{* WS-D Task 3: configuressl-complete — a11y-one override.
   Changes vs. parent (twenty-one/configuressl-complete.tpl):
   - Promotes the page success to h1 (parent used alert + h4; this template is the
     full page content, so a single h1 is appropriate; "Next Steps" becomes h2).
   - Copy-to-clipboard buttons: aria-label carries copy target field label for
     unambiguous button names on the DNS/file panels.
   - Clippy <img>: aria-hidden="true" since the button's aria-label is the accessible name.
   - Back-to-client-area button: aria-label clarifies destination.
   Author: Can Kirca
*}
{if $errormessage}

    {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage textcenter=true}

{else}

    <div class="card py-3">
        <div class="card-body">
            {* Success heading — single h1 for the page body *}
            <h1 class="h4 text-center text-success" id="sslCompleteHeading">
                {lang key='sslconfigcomplete'}
            </h1>

            <h2 class="h5 text-center mt-3">{lang key='ssl.nextSteps'}</h2>

            {if is_null($authData) || (!is_null($authData) && $authData->methodNameConstant() == 'emailauth')}
                {include file="$template/includes/alert.tpl" type="info" msg="{lang key='ssl.emailSteps'}"}
                {if !is_null($authData)}
                    <div class="pb-3 text-center">{lang key='ssl.emailInformation'}</div>
                    <div class="form-group row">
                        <label for="emailApprover" class="control-label col-md-4 col-form-label text-md-right">{lang key='email'}</label>
                        <div class="col-md-8">
                            <input type="text" class="form-control" id="emailApprover" value="{$authData->email}" readonly
                                   aria-describedby="sslCompleteHeading"/>
                        </div>
                    </div>
                {/if}
            {elseif !is_null($authData) && $authData->methodNameConstant() == 'dnsauth'}
                {include file="$template/includes/alert.tpl" type="info" msg="{lang key='ssl.dnsSteps'}"}
                <div class="pb-3 text-center">{lang key='ssl.dnsRecordInformation'}</div>
                <div class="form-group row">
                    <label for="recordType" class="control-label col-md-4 col-form-label text-md-right">{lang key='ssl.type'}</label>
                    <div class="col-md-8">
                        <input type="text" class="form-control" id="recordType" value="{$authData->type}" readonly/>
                    </div>
                </div>
                <div class="form-group row">
                    <label for="host" class="control-label col-md-4 col-form-label text-md-right">{lang key='ssl.host'}</label>
                    <div class="col-md-8">
                        <div class="input-group">
                            <input type="text" class="form-control" id="host" value="{$authData->host}" readonly/>
                            <div class="input-group-append">
                                <button type="button" class="btn btn-default btn-sm copy-to-clipboard"
                                        data-clipboard-target="#host"
                                        aria-label="{lang key='a11yCopyToClipboard'}: {lang key='ssl.host'}">
                                    <img src="{$WEB_ROOT}/assets/img/clippy.svg" aria-hidden="true" alt="" width="15">
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="form-group row">
                    <label for="dnsContents" class="control-label col-md-4 col-form-label text-md-right">{lang key='ssl.value'}</label>
                    <div class="col-md-8">
                        <div class="input-group">
                            <input type="text" class="form-control" id="dnsContents" value="{$authData->value}" readonly/>
                            <div class="input-group-append">
                                <button type="button" class="btn btn-default btn-sm copy-to-clipboard"
                                        data-clipboard-target="#dnsContents"
                                        aria-label="{lang key='a11yCopyToClipboard'}: {lang key='ssl.value'}">
                                    <img src="{$WEB_ROOT}/assets/img/clippy.svg" aria-hidden="true" alt="" width="15">
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            {elseif !empty($authData) && $authData->methodNameConstant() == 'fileauth'}
                {include file="$template/includes/alert.tpl" type="info" msg="{lang key='ssl.fileSteps'}"}
                <div class="pb-3 text-center">{lang key='ssl.fileInformation'}</div>
                <div class="form-group row">
                    <label for="fileName" class="control-label col-md-4 col-form-label text-md-right">{lang key='ssl.url'}</label>
                    <div class="col-md-8">
                        <input type="text" class="form-control" id="fileName"
                               value="http://{$domain}/{$authData->filePath()}" readonly/>
                    </div>
                </div>
                <div class="form-group row">
                    <label for="fileContents" class="control-label col-md-4 col-form-label text-md-right">{lang key='ssl.value'}</label>
                    <div class="col-md-8">
                        <div class="input-group">
                            <input type="text" class="form-control" id="fileContents" value="{$authData->contents}" readonly/>
                            <div class="input-group-append">
                                <button type="button" class="btn btn-default btn-sm copy-to-clipboard"
                                        data-clipboard-target="#fileContents"
                                        aria-label="{lang key='a11yCopyToClipboard'}: {lang key='ssl.value'}">
                                    <img src="{$WEB_ROOT}/assets/img/clippy.svg" aria-hidden="true" alt="" width="15">
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            {/if}

            <form method="post" action="clientarea.php?action=productdetails">
                <input type="hidden" name="id" value="{$serviceid}" />
                <p class="text-center mt-3">
                    <button type="submit" class="btn btn-default"
                            aria-label="{lang key='invoicesbacktoclientarea'}">
                        {lang key='invoicesbacktoclientarea'}
                    </button>
                </p>
            </form>
        </div>
    </div>
{/if}
