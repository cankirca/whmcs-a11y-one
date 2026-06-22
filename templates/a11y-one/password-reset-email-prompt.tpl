<div class="mb-4">
    <h2 class="h4" id="resetEmailHeading">{lang key='pwresetemailneeded'}</h2>
</div>

<form method="post" action="{routePath('password-reset-validate-email')}" role="form" aria-labelledby="resetEmailHeading">
    <input type="hidden" name="action" value="reset" />

    <div class="form-group">
        <label for="inputEmail">{lang key='loginemail'}</label>
        <div class="input-group input-group-merge">
            <div class="input-group-prepend">
              <span class="input-group-text"><i class="fas fa-user" aria-hidden="true"></i></span>
            </div>
            <input type="email" class="form-control" name="email" id="inputEmail" autocomplete="username" autofocus>
          </div>
    </div>

    {if $captcha && $captcha->isEnabled() && $showCaptchaAfterLimit}
        <div class="text-center margin-bottom">
            {include file="$template/includes/captcha.tpl"}
        </div>
    {/if}

    <div class="form-group text-center">
        <button type="submit" id="resetPasswordButton" {if $showCaptchaAfterLimit}data-captcha-required="true"{/if} class="btn btn-primary{$captcha->getButtonClass($captchaForm)}">
            {lang key='pwresetsubmit'}
        </button>
    </div>

</form>
