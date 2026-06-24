{* A11y One — account-user-permissions.tpl
   Parent: templates/twenty-one/account-user-permissions.tpl
   WS-B: Permission checkboxes wrapped in <fieldset>/<legend>; each checkbox
         gets an explicit <label for="..."> with a matching id on the input.
*}
{* Clear page heading. *}
<h1 class="h3 mb-4">{lang key='userManagement.managePermissions'}</h1>
{include file="$template/includes/flashmessage.tpl"}

<div class="card">
    <div class="card-body">
        <h3 class="card-title">{lang key='userManagement.managePermissions'}</h3>

        <p>{$user->email}</p>

        <form method="post"
              action="{routePath('account-users-permissions-save', $user->id)}"
              aria-label="{lang key='userManagement.managePermissions'}">

            {* WS-B: permissions checkbox matrix in a labelled fieldset *}
            <fieldset class="a11y-permissions">
                <legend class="h5">{lang key="userManagement.permissions"}</legend>

                {foreach $permissions as $permission}
                    <label class="form-check form-check-inline" for="perm_{$permission.key}">
                        <input type="checkbox"
                               class="form-check-input"
                               id="perm_{$permission.key}"
                               name="perms[{$permission.key}]"
                               value="1"
                               {if $userPermissions->hasPermission($permission.key)}checked{/if}>
                        {$permission.title}
                        <span class="d-none d-md-inline" aria-hidden="true">-</span>
                        <br class="d-md-none">
                        <span class="text-muted">{$permission.description}</span>
                    </label>
                    <br>
                {/foreach}

            </fieldset>

            <br>

            <p>
                <button type="submit" class="btn btn-primary">
                    {lang key="clientareasavechanges"}
                </button>
                <a href="{routePath('account-users')}" class="btn btn-default">
                    {lang key="clientareacancel"}
                </a>
            </p>

        </form>

    </div>
</div>
