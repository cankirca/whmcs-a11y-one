<div class="card">
    <div class="card-body">
        <h2 class="card-title h3">{lang key='sidebars.viewAccount.changePassword'}</h2>

        {include file="$template/includes/flashmessage.tpl"}

        <form class="using-password-strength" method="post" action="{routePath('user-password')}" role="form" aria-labelledby="changePasswordTitle">
            <input type="hidden" name="submit" value="true" />
            <div class="form-group row">
                <label for="inputExistingPassword" class="col-xl-4 col-form-label">{lang key='existingpassword'}</label>
                <div class="col-xl-5">
                    <div class="input-group input-group-merge">
                        <input type="password" class="form-control pw-input" name="existingpw" id="inputExistingPassword" autocomplete="current-password" />
                        <div class="input-group-append">
                            <button type="button" class="btn btn-default btn-reveal-pw" aria-label="{lang key='userLogin.showPassword'}" aria-pressed="false" aria-controls="inputExistingPassword">
                                <i class="fas fa-eye" aria-hidden="true"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="newPassword1" class="form-group has-feedback row">
                <label for="inputNewPassword1" class="col-xl-4 col-form-label">{lang key='newpassword'}</label>
                <div class="col-xl-5">
                    <div class="input-group input-group-merge">
                        <input type="password" class="form-control pw-input" name="newpw" id="inputNewPassword1" autocomplete="new-password" />
                        <div class="input-group-append">
                            <button type="button" class="btn btn-default btn-reveal-pw" aria-label="{lang key='userLogin.showPassword'}" aria-pressed="false" aria-controls="inputNewPassword1">
                                <i class="fas fa-eye" aria-hidden="true"></i>
                            </button>
                        </div>
                    </div>
                    {include file="$template/includes/pwstrength.tpl" maximumPasswordLength=$maximumPasswordLength}
                </div>
                <div class="col-xl-3">
                    <button type="button" class="btn btn-default btn-block generate-password" data-targetfields="inputNewPassword1,inputNewPassword2">
                        {lang key='generatePassword.btnLabel'}
                    </button>
                </div>
            </div>
            <div id="newPassword2" class="form-group has-feedback row">
                <label for="inputNewPassword2" class="col-xl-4 col-form-label">{lang key='confirmnewpassword'}</label>
                <div class="col-xl-5">
                    <div class="input-group input-group-merge">
                        <input type="password" class="form-control pw-input" name="confirmpw" id="inputNewPassword2" autocomplete="new-password" />
                        <div class="input-group-append">
                            <button type="button" class="btn btn-default btn-reveal-pw" aria-label="{lang key='userLogin.showPassword'}" aria-pressed="false" aria-controls="inputNewPassword2">
                                <i class="fas fa-eye" aria-hidden="true"></i>
                            </button>
                        </div>
                    </div>
                    <div id="inputNewPassword2Msg"></div>
                </div>
            </div>
            <div class="form-group row">
                <div class="col-xl-offset-4 col-xl-8 text-center">
                    <input class="btn btn-primary" type="submit" value="{lang key='clientareasavechanges'}" />
                    <input class="btn btn-default" type="reset" value="{lang key='cancel'}" />
                </div>
            </div>
        </form>

    </div>
</div>
