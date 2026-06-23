{*
 * A11y One – contact.tpl override
 * Author: Can Kirca <cankirca@gmail.com>
 * Fixes:
 *   - Page heading is a real <h1> (parent used <h6 class="h3"> which is
 *     not a heading for AT even though it looks like one visually).
 *   - All fields retain proper <label for> associations (carried over
 *     from parent, verified not detached by the row layout).
 *   - Required fields marked with aria-required="true".
 *   - autocomplete tokens added (name/email).
 *   - captcha include uses the a11y-one override (already has alt text +
 *     label on the text input).
 *   - Submit button retains its visible text label.
 *   - Decorative icons get aria-hidden="true".
 *}
<div class="card mb-4">
    <div class="card-body extra-padding">

        <div class="mb-4">
            <h1 class="h3">{lang key='contactus'}</h1>
            <p class="text-muted mb-0">{lang key='readyforquestions'}</p>
        </div>

        {if $sent}
            {include file="$template/includes/alert.tpl" type="success" msg="{lang key='contactsent'}" textcenter=true}
        {/if}

        {if $errormessage}
            {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage}
        {/if}

        {if !$sent}
            <form method="post" action="contact.php" role="form" novalidate>
                <input type="hidden" name="action" value="send" />

                <div class="form-group row">
                    <label for="inputName" class="col-sm-3 col-form-label text-right">
                        {lang key='supportticketsclientname'}
                    </label>
                    <div class="col-sm-7">
                        <input type="text"
                               name="name"
                               value="{$name}"
                               class="form-control"
                               id="inputName"
                               autocomplete="name"
                               aria-required="true" />
                    </div>
                </div>

                <div class="form-group row">
                    <label for="inputEmail" class="col-sm-3 col-form-label text-right">
                        {lang key='supportticketsclientemail'}
                    </label>
                    <div class="col-sm-7">
                        <input type="email"
                               name="email"
                               value="{$email}"
                               class="form-control"
                               id="inputEmail"
                               autocomplete="email"
                               aria-required="true" />
                    </div>
                </div>

                <div class="form-group row">
                    <label for="inputSubject" class="col-sm-3 col-form-label text-right">
                        {lang key='supportticketsticketsubject'}
                    </label>
                    <div class="col-sm-7">
                        <input type="text"
                               name="subject"
                               value="{$subject}"
                               class="form-control"
                               id="inputSubject"
                               aria-required="true" />
                    </div>
                </div>

                <div class="form-group row">
                    <label for="inputMessage" class="col-sm-3 col-form-label text-right">
                        {lang key='contactmessage'}
                    </label>
                    <div class="col-sm-9">
                        <textarea name="message"
                                  rows="7"
                                  class="form-control"
                                  id="inputMessage"
                                  aria-required="true">{$message}</textarea>
                    </div>
                </div>

                {if $captcha}
                    <div class="text-center margin-bottom">
                        {include file="$template/includes/captcha.tpl"}
                    </div>
                {/if}

                <div class="text-center">
                    <button type="submit" class="btn btn-primary{$captcha->getButtonClass($captchaForm)}">
                        {lang key='contactsend'}
                    </button>
                </div>
            </form>
        {/if}

    </div>
</div>
