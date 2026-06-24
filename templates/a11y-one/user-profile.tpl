{* A11y One — user-profile.tpl
   Parent: templates/twenty-one/user-profile.tpl
   WS-B: Both forms get aria-labelledby; second form uses unique IDs
         (inputEmailAddress, inputEmailPasswordConfirm) to prevent duplicate IDs;
         email verification status badge gets role="status" + data-a11y-status-label;
         autocomplete tokens added; name inputs avoid collision between forms.
*}
{* Clear page heading. *}
<h1 class="h3 mb-4">{lang key='userProfile.profile'}</h1>
{include file="$template/includes/flashmessage.tpl"}

<div class="card">
    <div class="card-body">
        <h3 class="card-title" id="profileNameHeading">{lang key='userProfile.profile'}</h3>

        <form method="post"
              action="{routePath('user-profile-save')}"
              aria-labelledby="profileNameHeading">
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="inputFirstName" class="col-form-label">
                            {lang key='clientareafirstname'}
                        </label>
                        <input
                            type="text"
                            name="firstname"
                            id="inputFirstName"
                            value="{$user->firstName}"
                            class="form-control"
                            autocomplete="given-name"
                            {if in_array('firstname', $uneditableFields)}disabled="disabled"{/if}
                        >
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="inputLastName" class="col-form-label">
                            {lang key='clientarealastname'}
                        </label>
                        <input
                            type="text"
                            name="lastname"
                            id="inputLastName"
                            value="{$user->lastName}"
                            class="form-control"
                            autocomplete="family-name"
                            {if in_array('lastname', $uneditableFields)}disabled="disabled"{/if}
                        >
                    </div>
                </div>
            </div>
            <input class="btn btn-primary" id="btnSaveNameChanges" type="submit" name="save" value="{lang key='clientareasavechanges'}" />
            <input class="btn btn-default" type="reset" value="{lang key='cancel'}" />
        </form>

    </div>
</div>

<div class="card">
    <div class="card-body">
        <h3 class="card-title" id="profileEmailHeading">{lang key='userProfile.changeEmail'}</h3>

        <p>
            {* WS-B: role="status" + aria-label for AT announcement of verification state *}
            {if $user->needsToCompleteEmailVerification()}
                <span class="label label-default"
                      role="status"
                      data-a11y-status-label=""
                      aria-label="{lang key='wsb.emailStatusNotVerified'}">
                    {lang key='userProfile.notVerified'}
                </span>
            {elseif $user->emailVerified()}
                <span class="label label-success"
                      role="status"
                      data-a11y-status-label=""
                      aria-label="{lang key='wsb.emailStatusVerified'}">
                    {lang key='userProfile.verified'}
                </span>
            {/if}
        </p>

        {* WS-B: second form uses unique IDs to prevent collision with first form *}
        <form method="post"
              action="{routePath('user-profile-email-save')}"
              aria-labelledby="profileEmailHeading">
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="inputEmailAddress" class="col-form-label">
                            {lang key='clientareaemail'}
                        </label>
                        <input
                            type="email"
                            name="email"
                            id="inputEmailAddress"
                            value="{$user->email}"
                            class="form-control"
                            autocomplete="email"
                            {if in_array('email', $uneditableFields)}disabled="disabled"{/if}
                        >
                    </div>

                    {if !in_array('email', $uneditableFields)}
                        <div class="form-group">
                            <label for="inputEmailPasswordConfirm" class="col-form-label">
                                {lang key='existingpassword'}
                            </label>
                            <input
                                type="password"
                                name="existing_password"
                                id="inputEmailPasswordConfirm"
                                class="form-control"
                                autocomplete="current-password"
                            >
                        </div>
                    {/if}
                </div>
            </div>
            <input class="btn btn-primary" id="btnSaveEmailChanges" type="submit" name="save" value="{lang key='clientareasavechanges'}" />
            <input class="btn btn-default" type="reset" value="{lang key='cancel'}" />
        </form>

    </div>
</div>
