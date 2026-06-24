{*
 * A11y One — affiliatessignup.tpl
 * Accessible override of twenty-one/affiliatessignup.tpl (WCAG 2.2 AA).
 *
 * Changes over parent:
 *  - Submit button already carries visible text via {lang key='affiliatesactivate'}; no change
 *    needed for accessible name — confirmed present in parent.
 *  - Hidden activate field and any CSRF token preserved.
 *  - Heading order: the page leads with a single <h1>; section card headings
 *    use <h3> matching parent convention.
 *
 * Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca
 *}
{* Clear page heading. *}
<h1 class="h3 mb-4">{lang key='affiliatesignuptitle'}</h1>
{if $affiliatesystemenabled}

    <div class="card">
        <div class="card-body extra-padding">

            <h3>{lang key='affiliatesignuptitle'}</h3>
            <p class="lead">{lang key='affiliatesignupintro'}</p>

            <ul class="py-4">
                <li>{lang key='affiliatesignupinfo1'}</li>
                <li>{lang key='affiliatesignupinfo2'}</li>
                <li>{lang key='affiliatesignupinfo3'}</li>
            </ul>

            <br />

            <form method="post" action="affiliates.php">
                <input type="hidden" name="activate" value="true" />
                {if isset($token)}<input type="hidden" name="token" value="{$token|escape}" />{/if}
                <p class="text-center">
                    <button id="activateAffiliate" type="submit" class="btn btn-success btn-lg px-5 py-2">
                        {lang key='affiliatesactivate'}
                    </button>
                </p>
            </form>
        </div>
    </div>

{else}
    {include file="$template/includes/alert.tpl" type="warning" msg="{lang key='affiliatesdisabled'}" textcenter=true}
{/if}
