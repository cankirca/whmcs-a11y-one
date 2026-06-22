<div class="providerLinkingFeedback"></div>

<form method="post" action="{routePath('login-validate')}" class="login-form" aria-labelledby="loginHeading">
    <div class="card mw-540 mb-md-4 mt-md-4">
        <div class="card-body px-sm-5 py-5">
            <div class="mb-4">
                <h1 id="loginHeading" class="h3">{lang key='loginbutton'}</h1>
                <p class="text-muted mb-0">{lang key='userLogin.signInToContinue'}</p>
            </div>
            {include file="$template/includes/flashmessage.tpl"}
            <div class="form-group">
                <label for="inputEmail" class="form-control-label">{lang key='clientareaemail'}</label>
                <div class="input-group input-group-merge">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fas fa-user" aria-hidden="true"></i></span>
                    </div>
                    <input type="email" class="form-control" name="username" id="inputEmail" autocomplete="username">
                </div>
            </div>
            <div class="form-group mb-4">
                <div class="d-flex align-items-center justify-content-between">
                    <label for="inputPassword" class="form-control-label">{lang key='clientareapassword'}</label>
                    <div class="mb-2">
                        <a href="{routePath('password-reset-begin')}" class="small text-muted">{lang key='forgotpw'}</a>
                    </div>
                </div>
                <div class="input-group input-group-merge">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fas fa-key" aria-hidden="true"></i></span>
                    </div>
                    <input type="password" class="form-control pw-input" name="password" id="inputPassword" placeholder="{lang key='clientareapassword'}" autocomplete="current-password">
                    <div class="input-group-append">
                        <button class="btn btn-default btn-reveal-pw" type="button" aria-label="{lang key='userLogin.showPassword'}" aria-pressed="false"
                                aria-controls="inputPassword">
                            <i class="fas fa-eye" aria-hidden="true"></i>
                        </button>
                    </div>
                </div>
            </div>
            {if $captcha->isEnabled()}
                {include file="$template/includes/captcha.tpl"}
            {/if}
            <div class="form-check mb-3">
                <input type="checkbox" class="form-check-input" name="rememberme" id="rememberme">
                <label class="form-check-label" for="rememberme">{lang key='loginrememberme'}</label>
            </div>
            <button id="login" type="submit" class="btn btn-primary btn-block{$captcha->getButtonClass($captchaForm)}">
                {lang key='loginbutton'}
            </button>
        </div>
        <div class="card-footer px-md-5">
            <small>{lang key='userLogin.notRegistered'}</small>
            <a href="{$WEB_ROOT}/register.php" class="small font-weight-bold">{lang key='userLogin.createAccount'}</a>
        </div>
    </div>
</form>

{include file="$template/includes/linkedaccounts.tpl" linkContext="login" customFeedback=true}
