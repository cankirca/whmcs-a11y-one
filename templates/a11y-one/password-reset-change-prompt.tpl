<h2 class="h4 mb-3" id="changePasswordHeading">{lang key='pwresetenternewpw'}</h2>

<form class="using-password-strength" method="POST" action="{routePath('password-reset-change-perform')}" aria-labelledby="changePasswordHeading">
    <input type="hidden" name="answer" id="answer" value="{$securityAnswer}" />

    <div id="newPassword1" class="form-group has-feedback">
        <label for="inputNewPassword1" class="control-label">{lang key='newpassword'}</label>
        <div class="input-group input-group-merge">
            <input type="password" name="newpw" id="inputNewPassword1" class="form-control pw-input" autocomplete="new-password" />
            <div class="input-group-append">
                <button type="button" class="btn btn-default btn-reveal-pw" aria-label="{lang key='userLogin.showPassword'}" aria-pressed="false" aria-controls="inputNewPassword1">
                    <i class="fas fa-eye" aria-hidden="true"></i>
                </button>
            </div>
        </div>
    </div>

    <div id="newPassword2" class="form-group has-feedback">
        <label class="control-label" for="inputNewPassword2">{lang key='confirmnewpassword'}</label>
        <div class="input-group input-group-merge">
            <input type="password" name="confirmpw" id="inputNewPassword2" class="form-control pw-input" autocomplete="new-password" />
            <div class="input-group-append">
                <button type="button" class="btn btn-default btn-reveal-pw" aria-label="{lang key='userLogin.showPassword'}" aria-pressed="false" aria-controls="inputNewPassword2">
                    <i class="fas fa-eye" aria-hidden="true"></i>
                </button>
            </div>
        </div>
        <div id="inputNewPassword2Msg"></div>
    </div>

    <div class="form-group">
        <label class="control-label">{lang key='pwstrength'}</label>
        {include file="$template/includes/pwstrength.tpl" maximumPasswordLength=$maximumPasswordLength}
    </div>

    <div class="form-group">
        <div class="text-center">
            <input class="btn btn-primary" type="submit" name="submit" value="{lang key='clientareasavechanges'}" />
            <input class="btn btn-default" type="reset" value="{lang key='cancel'}" />
        </div>
    </div>

</form>
