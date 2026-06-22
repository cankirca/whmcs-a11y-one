{*
    A11y One — accessible "view ticket" page.
    Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca

    Accessibility changes vs parent twenty-one:
      - Single <h1> for the page ("View Ticket #N"); the reply-composer card
        title and every individual reply become logically-ordered headings
        (each reply is an <h2> naming its author so the thread is navigable by
        heading and a screen-reader rotor lists each post).
      - Star rating: the parent's clickable <span rate="N"> widget (which only
        works with a mouse and exposes nothing to AT) is rebuilt as a real
        radio group — a <fieldset> with a <legend> prompt and five native
        <input type="radio" name="ticketrating"> controls, each with a <label>
        carrying sr-only "N star(s)" text. Gold stars are drawn purely in CSS
        over the native radios (custom.css), so the visual is unchanged but the
        control is keyboard-operable (Tab in, Arrow keys to choose) and named.
        The original submit is PRESERVED: the parent posts the rating by
        navigating to viewticket.php?tid=..&c=..&rating=rate{replyid}_{N};
        a11y-one.js reads the same ticketid/ticketkey/ticketreplyid carried on
        the fieldset and performs the identical navigation on radio change.
      - Close-ticket control: the parent's bare onclick=window.location button
        becomes a real <form> GET submit with the close params + token as hidden
        fields and a <button type="submit"> with a proper accessible name; the
        icon is aria-hidden. (The already-closed state stays a disabled button.)
      - Reply markdown editor + file upload reuse the shared WS-F helpers in
        a11y-one.js (markdown-editor class + data-a11y-mde-label; file inputs
        get aria-describedby to the accepted-types help; the "add more" clone is
        labelled + announced). No duplicated JS.
      - Attachment download links: the accessible name carries the filename and
        a download verb; links that open in a new window get an sr-only
        "(opens in new window)" note + rel="noopener".
      - Reply focus management: after the page is told to scroll to a reply
        (e.g. a freshly posted reply, or the "Reply" jump), a11y-one.js moves
        focus to the target heading/region instead of only smooth-scrolling.
*}
{if $invalidTicketId}
    {include file="$template/includes/alert.tpl" type="danger" title="{lang key='thereisaproblem'}" msg="{lang key='supportticketinvalid'}" textcenter=true}
{else}
    {if $closedticket}
        {include file="$template/includes/alert.tpl" type="warning" msg="{lang key='supportticketclosedmsg'}" textcenter=true}
    {/if}

    {if $errormessage}
        {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage}
    {/if}
{/if}

{if !$invalidTicketId}
    <div class="card view-ticket">
        <div class="card-body p-3">
            <h1 class="card-title h3">
                {lang key='supportticketsviewticket'} #{$tid}
                <div class="ticket-actions float-sm-right mt-3 mt-sm-0">
                    <button id="ticketReply" type="button" class="btn btn-default btn-sm" data-a11y-scroll-focus="#ticketReplyContainer" onclick="smoothScroll('#ticketReplyContainer')">
                        <i class="fas fa-pencil-alt fa-fw" aria-hidden="true"></i>
                        {lang key='supportticketsreply'}
                    </button>
                    {if $showCloseButton}
                        {if $closedticket}
                            <button id="closedTicket" type="button" class="btn btn-danger btn-sm" disabled="disabled">
                                <i class="fas fa-times fa-fw" aria-hidden="true"></i>
                                {lang key='supportticketsstatusclosed'}
                            </button>
                        {else}
                            {* Real form submit instead of an onclick=window.location redirect. *}
                            <form method="get" action="{$smarty.server.PHP_SELF}" class="d-inline ticket-close-form">
                                <input type="hidden" name="tid" value="{$tid}">
                                <input type="hidden" name="c" value="{$c}">
                                <input type="hidden" name="closeticket" value="true">
                                <input type="hidden" name="token" value="{$token}">
                                <button id="closeTicket" type="submit" class="btn btn-danger btn-sm">
                                    <i class="fas fa-times fa-fw" aria-hidden="true"></i>
                                    {lang key='supportticketsclose'}
                                </button>
                            </form>
                        {/if}
                    {/if}
                </div>
            </h1>

            <p>
                {lang key='supportticketssubject'}:
                <strong>{$subject}</strong>
            </p>
        </div>

        {foreach $descreplies as $reply}
            <div class="card-body ticket-reply-card" id="ticketReply{$reply.id|default:$reply@index}" tabindex="-1">
                <div class="ticket-reply markdown-content{if $reply.admin} staff{/if}">
                    <div class="posted-by">
                        {* Each post becomes a heading so the thread is navigable by heading.
                           The visible "posted by …" line is kept as the heading text. *}
                        <h2 class="reply-heading h6 m-0">
                            {lang key="support.postedBy" name="<span class=\"posted-by-name\">{$reply.requestor.name}</span>" date="<span class=\"posted-on\">{$reply.date}</span>" requestorType="<span class=\"label requestor-badge requestor-type-{$reply.requestor.type_normalised} float-md-right\">{lang key='support.requestor.'|cat:$reply.requestor.type_normalised}</span>"}
                        </h2>
                    </div>
                    <div class="message p-3">
                        {$reply.message}
                        {if $reply.ipaddress}
                            <hr>
                            {lang key='support.ipAddress'}: {$reply.ipaddress}
                        {/if}
                        {if $reply.id && $reply.admin && $ratingenabled}
                            <div class="clearfix">
                                {if $reply.rating}
                                    <div class="rating-done">
                                        {for $rating=1 to 5}
                                            <span class="star{if (5 - $reply.rating) < $rating} active{/if}" aria-hidden="true"></span>
                                        {/for}
                                        <div class="rated">{lang key='ticketreatinggiven'}</div>
                                    </div>
                                {else}
                                    {* Accessible rating control: a fieldset of native radios styled
                                       as gold stars via CSS. The ticket identifiers are carried as
                                       data-* so a11y-one.js can reproduce the parent's rating submit
                                       (navigate to ?tid=..&c=..&rating=rate{replyid}_{N}). *}
                                    <fieldset class="rating-fieldset rating"
                                              data-ticketid="{$tid}"
                                              data-ticketkey="{$c}"
                                              data-ticketreplyid="{$reply.id}">
                                        <legend class="rating-legend">{lang key='a11yRateThisReply'}</legend>
                                        {for $rating=5 to 1 step -1}
                                            <input type="radio"
                                                   class="rating-input sr-only"
                                                   name="ticketrating{$reply.id}"
                                                   id="rating{$reply.id}_{$rating}"
                                                   value="{$rating}">
                                            <label class="rating-star star" for="rating{$reply.id}_{$rating}">
                                                <span class="sr-only">{if $rating == 1}{lang key='a11yStarSingular' count=$rating}{else}{lang key='a11yStarPlural' count=$rating}{/if}</span>
                                            </label>
                                        {/for}
                                    </fieldset>
                                {/if}
                            </div>
                        {/if}
                    </div>
                    {if $reply.attachments}
                        <div class="attachments p-3">
                            <strong>
                                <i class="far fa-paperclip fa-fw" aria-hidden="true"></i>
                                {lang key='supportticketsticketattachments'} ({$reply.attachments|count})
                            </strong>
                            {if $reply.attachments_removed} - {lang key='support.attachmentsRemoved'}{/if}
                            <ul class="attachment-list">
                                {foreach $reply.attachments as $num => $attachment}
                                    <li>
                                        {if $reply.attachments_removed}
                                            <span>
                                                <figure>
                                                    <i class="far fa-file-minus" aria-hidden="true"></i>
                                                </figure>
                                                <div class="caption">
                                                    {$attachment}
                                                </div>
                                            </span>
                                        {else}
                                            <a href="dl.php?type={if $reply.id}ar&id={$reply.id}{else}a&id={$id}{/if}&i={$num}"
                                               target="_blank" rel="noopener"
                                               aria-label="{lang key='downloadbtn'} {$attachment} ({lang key='a11yOpensInNewWindow'})">
                                                <span>
                                                    <figure>
                                                        <i class="far fa-file" aria-hidden="true"></i>
                                                    </figure>
                                                    <div class="caption">
                                                        {$attachment}
                                                        <span class="sr-only">({lang key='a11yOpensInNewWindow'})</span>
                                                    </div>
                                                </span>
                                            </a>
                                        {/if}
                                    </li>
                                {/foreach}
                            </ul>
                        </div>
                    {/if}
                </div>
            </div>
        {/foreach}
    </div>

    <div class="card d-print-none" id="ticketReplyContainer" tabindex="-1">
        <div class="card-body">
            <h2 class="card-title h3">{lang key='supportticketsreply'}</h2>

            <form method="post" action="{$smarty.server.PHP_SELF}?tid={$tid}&amp;c={$c}&amp;postreply=true" enctype="multipart/form-data" role="form" id="frmReply">
                <div class="row">
                    <div class="form-group col-md-4">
                        <label for="inputName">{lang key='supportticketsclientname'}</label>
                        <input class="form-control" type="text" name="replyname" id="inputName" value="{$replyname}" autocomplete="name"{if $loggedin} disabled="disabled"{/if}>
                    </div>
                    <div class="form-group col-md-5">
                        <label for="inputEmail">{lang key='supportticketsclientemail'}</label>
                        <input class="form-control" type="email" name="replyemail" id="inputEmail" value="{$replyemail}" autocomplete="email"{if $loggedin} disabled="disabled"{/if}>
                    </div>
                </div>

                <div class="form-group">
                    <label for="inputMessage">{lang key='contactmessage'}</label>
                    <textarea name="replymessage" id="inputMessage" rows="12" class="form-control markdown-editor" data-auto-save-name="ctr{$tid}" data-a11y-mde-label="{lang key='contactmessage'}">{$replymessage}</textarea>
                </div>

                <div class="form-group">
                    <label for="inputAttachments">{lang key='supportticketsticketattachments'}</label>
                    <div class="input-group mb-1 attachment-group">
                        <div class="custom-file">
                            <label class="custom-file-label text-truncate" for="inputAttachment1" data-default="Choose file">
                                {lang key='chooseFile'}
                            </label>
                            <input type="file" class="custom-file-input" name="attachments[]" id="inputAttachment1" aria-describedby="attachmentTypesHelp">
                        </div>
                        <div class="input-group-append">
                            <button class="btn btn-default" type="button" id="btnTicketAttachmentsAdd">
                                <i class="fas fa-plus" aria-hidden="true"></i>
                                {lang key='addmore'}
                            </button>
                        </div>
                    </div>
                    <div class="file-upload w-hidden">
                        <div class="input-group mb-1 attachment-group">
                            <div class="custom-file">
                                <label class="custom-file-label text-truncate">
                                    {lang key='chooseFile'}
                                </label>
                                <input type="file" class="custom-file-input" name="attachments[]" aria-describedby="attachmentTypesHelp">
                            </div>
                        </div>
                    </div>
                    <div id="fileUploadsContainer"></div>
                    <div class="text-muted" id="attachmentTypesHelp">
                        <small>{lang key='supportticketsallowedextensions'}: {$allowedfiletypes} ({lang key="maxFileSize" fileSize="$uploadMaxFileSize"})</small>
                    </div>
                </div>

                <div class="form-group text-center">
                    <input class="btn btn-primary" type="submit" name="save" value="{lang key='supportticketsticketsubmit'}" />
                    <input class="btn btn-default" type="reset" value="{lang key='cancel'}" onclick="jQuery('#ticketReply').click()" />
                </div>
            </form>

        </div>
    </div>
{/if}
