<h2 class="h4 mb-3">{lang key='pwresetsecurityquestionrequired'}</h2>

{if $errorMessage}
    <p class="alert alert-danger text-center" id="securityErrorMsg" role="alert">
        {$errorMessage}
    </p>
{/if}

<form method="post" action="{routePath('password-reset-security-verify')}" class="form-stacked" aria-labelledby="securityHeading">
    <div class="form-group">
        <label for="inputAnswer">{$securityQuestion}</label>
        <input type="text" name="answer" class="form-control" id="inputAnswer"{if $errorMessage} aria-describedby="securityErrorMsg"{/if} autofocus>
    </div>

    <div class="form-group text-center">
        <button type="submit" class="btn btn-primary">{lang key='pwresetsubmit'}</button>
    </div>
</form>
