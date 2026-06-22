{*
 * ticketfeedback.tpl — A11y One child-theme override
 *
 * Accessibility improvements over the parent (twenty-one):
 *   - Each staff member's 1–10 rating is wrapped in a <fieldset> + <legend>
 *     so the group context is announced by screen readers.
 *   - The rating <table> uses real <th scope="col"> for number and label
 *     headers (the parent used <td> throughout).
 *   - Each radio input carries an aria-label of "N out of 10" via the
 *     a11yFeedbackRatingLabel lang key so the accessible name is self-
 *     contained (no reliance on visual-only column headers).
 *   - The per-staff comments textarea has an explicit <label for>.
 *   - The general-comments textarea has an explicit <label for>.
 *   - Decorative icon (arrow) carries aria-hidden="true".
 *   - All new user-facing strings go through {lang key='...'} — no
 *     hardcoded English.
 *   - CSRF token and all hidden inputs are preserved unchanged.
 *
 * Author: Can Kirca <cankirca@gmail.com>
 *}
<div class="card">
    <div class="card-body">
        {if $stillopen}
            {include file="$template/includes/alert.tpl" type="warning" msg="{lang key='feedbackclosed'}" textcenter=true}

            <p class="text-center">
                <a href="clientarea.php" class="btn btn-primary">{lang key='returnclient'}</a>
            </p>
        {elseif $feedbackdone}
            {include file="$template/includes/alert.tpl" type="success" msg="{lang key='feedbackprovided'}" textcenter=true}

            <p class="text-center">{lang key='feedbackthankyou'}</p>

            <p class="text-center">
                <a href="clientarea.php" class="btn btn-primary">{lang key='returnclient'}</a>
            </p>
        {elseif $success}
            {include file="$template/includes/alert.tpl" type="success" msg="{lang key='feedbackreceived'}" textcenter=true}

            <p class="text-center">{lang key='feedbackthankyou'}</p>

            <p class="text-center">
                <a href="clientarea.php" class="btn btn-primary">{lang key='returnclient'}</a>
            </p>
        {else}

            {if $errormessage}
                {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage}
            {/if}

            <p>{lang key='feedbackdesc'}</p>

            <p class="text-center">
                <a href="viewticket.php?tid={$tid}&amp;c={$c}" class="btn btn-success">
                    {lang key='feedbackclickreview'}&nbsp;
                    <i class="fas fa-arrow-right" aria-hidden="true"></i>
                </a>
            </p>

            <div class="row">
                <div class="col-sm-10 offset-sm-1">
                    <table class="table table-striped">
                        <tbody>
                            <tr>
                                <td>{lang key='feedbackopenedat'}:</td>
                                <td><strong>{$opened}</strong></td>
                            </tr>
                            <tr>
                                <td>{lang key='feedbacklastreplied'}:</td>
                                <td><strong>{$lastreply}</strong></td>
                            </tr>
                            <tr>
                                <td>{lang key='feedbackstaffinvolved'}:</td>
                                <td><strong>{if $staffinvolvedtext}{$staffinvolvedtext}{else}{lang key='none'}{/if}</strong></td>
                            </tr>
                            <tr>
                                <td>{lang key='feedbacktotalduration'}:</td>
                                <td><strong>{$duration}</strong></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <form method="post" action="{$smarty.server.PHP_SELF}?tid={$tid}&c={$c}&feedback=1">
                <input type="hidden" name="validate" value="true" />

                {foreach $staffinvolved as $staffid => $staff}

                    <div class="ticketfeedbackstaffcont">

                        {* ---------------------------------------------------------- *}
                        {* Per-staff rating: fieldset groups the 1–10 radios so       *}
                        {* screen readers announce the staff name and context together *}
                        {* ---------------------------------------------------------- *}
                        <fieldset class="a11y-feedback-fieldset">
                            <legend>
                                {lang key='feedbackpleaserate1'} <strong>{$staff}</strong> {lang key='feedbackhandled'}
                            </legend>

                            <table class="table text-center a11y-feedback-table" role="presentation">
                                <thead>
                                    <tr>
                                        <th scope="col">{lang key='feedbackworst'}</th>
                                        {foreach $ratings as $rating}
                                            <th scope="col">{$rating}</th>
                                        {/foreach}
                                        <th scope="col">{lang key='feedbackbest'}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td aria-hidden="true"></td>
                                        {foreach $ratings as $rating}
                                            <td>
                                                <input
                                                    type="radio"
                                                    class="form-check-input"
                                                    id="rate_{$staffid}_{$rating}"
                                                    name="rate[{$staffid}]"
                                                    value="{$rating}"
                                                    aria-label="{$rating} {lang key='a11yFeedbackOutOf10'}"
                                                    {if $rate.$staffid eq $rating}checked{/if}
                                                />
                                            </td>
                                        {/foreach}
                                        <td aria-hidden="true"></td>
                                    </tr>
                                </tbody>
                            </table>

                        </fieldset>

                        {* ---------------------------------------------------------- *}
                        {* Per-staff comments — textarea has an explicit <label for>   *}
                        {* ---------------------------------------------------------- *}
                        <div class="a11y-feedback-comment-group">
                            <label for="comments_{$staffid}" class="a11y-feedback-comment-label">
                                {lang key='feedbackpleasecomment1'} <strong>{$staff}</strong> {lang key='feedbackhandled'}.
                            </label>
                            <div class="row">
                                <div class="col-sm-10 offset-sm-1">
                                    <textarea
                                        id="comments_{$staffid}"
                                        name="comments[{$staffid}]"
                                        rows="4"
                                        class="form-control"
                                    >{$comments.$staffid}</textarea>
                                </div>
                            </div>
                        </div>

                    </div>

                {/foreach}

                {* ---------------------------------------------------------- *}
                {* General improvement comments — labelled textarea            *}
                {* ---------------------------------------------------------- *}
                <label for="comments_generic" class="a11y-feedback-comment-label">
                    {lang key='feedbackimprove'}
                </label>
                <div class="row">
                    <div class="col-sm-10 offset-sm-1">
                        <textarea
                            id="comments_generic"
                            name="comments[generic]"
                            rows="4"
                            class="form-control"
                        >{$comments.generic}</textarea>
                    </div>
                </div>

                <br />

                <div class="form-group text-center">
                    <input class="btn btn-primary" type="submit" name="save" value="{lang key='clientareasavechanges'}" />
                    <input class="btn btn-default" type="reset" value="{lang key='cancel'}" />
                </div>

            </form>

        {/if}
    </div>
</div>
