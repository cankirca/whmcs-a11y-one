{* WS-G error/rate-limit-exceeded.tpl
   Base: templates/twenty-one/error/rate-limit-exceeded.tpl
   Parent: twenty-one (NOT six)
   Rendered inside site chrome; a11y-one.js loads via footer.
   A11y fixes:
   - Decorative exclamation-circle icon before h1: aria-hidden.
   - Single h1 (already present in parent) — preserved.
   - h3 subtitle in parent: demoted to h2 (parent skipped h2 → h3).
   - Links use real href — correct in parent.
   - display-1 text-primary contrast fix: see custom.css WS-G. *}

<div class="container">
    <div class="text-center p-5">

        <i class="fas fa-exclamation-circle display-1 font-weight-bold text-primary" aria-hidden="true"></i>
        <h1 class="display-1 font-weight-bold text-primary line-height-reduced mb-5">
            {lang key="errorPage.rateLimitExceeded.title"}
        </h1>
        <h2>{lang key="errorPage.rateLimitExceeded.subtitle"}</h2>
        <p>{lang key="errorPage.rateLimitExceeded.description"}</p>

        <div class="buttons">
            <a href="{$systemurl}" class="btn btn-primary px-4">
                {lang key="errorPage.rateLimitExceeded.home"}
            </a>
        </div>

    </div>
</div>
