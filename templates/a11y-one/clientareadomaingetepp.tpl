{*
 * A11y One — clientareadomaingetepp.tpl
 * EPP code: exposed as copyable <code> element; canonical initAllCopyButtons
 * handles the data-a11y-copy button — no inline script needed.
 * Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca
 *}
<div class="card">
    <div class="card-body">
        <h3 class="card-title">{lang key='domaingeteppcode'}</h3>

        <p>{lang key='domaingeteppcodeexplanation'}</p>

        {if $error}
            {include file="$template/includes/alert.tpl" type="error" msg="<i class='fas fa-exclamation-triangle fa-fw' aria-hidden='true'></i> {lang key='domaingeteppcodefailure'}"|cat:" $error"}
        {elseif $eppcode}
            <div class="alert alert-info text-center" role="status">
                <p>
                    <i class="fas fa-info-circle fa-fw" aria-hidden="true"></i>
                    {lang key='domaingeteppcodeis'}
                </p>
                <p>
                    <code id="eppCodeValue">{$eppcode}</code>
                    <button type="button"
                            class="btn btn-sm btn-outline-secondary ml-2"
                            data-a11y-copy="#eppCodeValue"
                            aria-label="{lang key='a11yDomainCopyEpp'}">
                        <i class="fal fa-copy" aria-hidden="true"></i>
                    </button>
                </p>
            </div>
        {else}
            {include file="$template/includes/alert.tpl" type="success" msg="<i class='fas fa-check fa-fw' aria-hidden='true'></i> {lang key='domaingeteppcodeemailconfirmation'}"}
        {/if}

    </div>
</div>
