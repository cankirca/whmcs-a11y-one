{*
    A11y One — accessible ticket-submitted confirmation.
    Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca

    Accessibility changes vs parent twenty-one:
      - The page title is promoted from <h3 class="card-title"> to a single
        top-level <h1 class="card-title h3"> (visual size preserved) so the page
        has exactly one <h1> and a correct heading order — the parent submit flow
        ships no <h1>, which axe flags as page-has-heading-one / heading-order.
      - The success banner is a role="status" live region with an sr-only
        "Success:" prefix so the outcome is announced and not colour-only.
      - The decorative arrow icon on the continue button is aria-hidden.
*}
<div class="card">
    <div class="card-body extra-padding">

        <h1 class="card-title h3">{lang key="createNewSupportRequest"}</h1>

        <div class="alert alert-success text-center" role="status">
            <strong>
                <span class="sr-only">{lang key='success'}: </span>
                {lang key='supportticketsticketcreated'}
                <a id="ticket-number" href="viewticket.php?tid={$tid}&amp;c={$c}" class="alert-link">#{$tid}</a>
            </strong>
        </div>

        <div class="row">
            <div class="col-10 offset-1">
                <p>{lang key='supportticketsticketcreateddesc'}</p>
            </div>
        </div>

        <br />

        <p class="text-center">
            <a href="viewticket.php?tid={$tid}&amp;c={$c}" class="btn btn-default">
                {lang key='continue'}
                <i class="fas fa-arrow-circle-right" aria-hidden="true"></i>
            </a>
        </p>

    </div>
</div>
