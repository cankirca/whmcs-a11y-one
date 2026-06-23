{* WS-G error/page-not-found.tpl
   Base: templates/twenty-one/error/page-not-found.tpl
   Parent: twenty-one (NOT six)
   Rendered inside site chrome (header/footer); a11y-one.js loads via footer.
   A11y fixes:
   - Decorative exclamation-circle icon before h1: aria-hidden.
   - Single h1 (already present in parent as display-1) — preserved.
   - h3 subtitle: demoted to h2 (parent used h3 directly under h1 — skip).
   - Links use real href (no javascript:) — already correct in parent.
   - Text contrast: display-1 text-primary uses Bootstrap's #007bff on white
     background (~3.1:1 — FAILS AA). Override in custom.css WS-G block. *}

<div class="container">
    <div class="text-center p-5">

        <i class="fas fa-exclamation-circle display-1 font-weight-bold text-primary" aria-hidden="true"></i>
        <h1 class="display-1 font-weight-bold text-primary line-height-reduced mb-5">
            {lang key="errorPage.404.title"}
        </h1>
        <h2>{lang key="errorPage.404.subtitle"}</h2>
        <p>{lang key="errorPage.404.description"}</p>

        <div class="buttons">
            <a href="{$systemurl}" class="btn btn-primary px-4">
                {lang key="errorPage.404.home"}
            </a>
            <a href="{$systemurl}contact.php" class="btn btn-info px-4">
                {lang key="errorPage.404.submitTicket"}
            </a>
        </div>

    </div>
</div>
