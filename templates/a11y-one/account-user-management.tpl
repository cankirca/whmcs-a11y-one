{* A11y One — account-user-management.tpl
   Parent: templates/twenty-one/account-user-management.tpl
   WS-B: Table gets <caption> + <thead> + <th scope="col">; action links get
         aria-disabled + aria-haspopup; 2FA icon aria-hidden; invite form gets
         sr-only email label; radio group in fieldset/legend; permission checkboxes
         labelled; modals get role/aria-modal/aria-labelledby.
*}
{include file="$template/includes/flashmessage.tpl"}

<div class="card">
    <div class="card-body">
        <h3 class="card-title">{lang key="navUserManagement"}</h3>

        <p>{lang key="userManagement.usersFound" count=$users->count()}</p>

        <table class="table table-striped">
            <caption class="sr-only">{lang key="wsb.subUserTableCaption"}</caption>
            <thead>
                <tr>
                    <th scope="col">{lang key="userManagement.emailAddress"} / {lang key="userManagement.lastLogin"}</th>
                    <th scope="col" width="300">{lang key="userManagement.actions"}</th>
                </tr>
            </thead>
            <tbody>
            {foreach $users as $user}
                <tr>
                    <td>
                        {$user->email}
                        {if $user->pivot->owner}
                            <span class="label label-info">{lang key="clientOwner"}</span>
                        {/if}
                        {if $user->hasTwoFactorAuthEnabled()}
                            <i class="fas fa-shield text-success" aria-hidden="true" data-toggle="tooltip" data-placement="auto right" title="{lang key='twoFactor.enabled'}"></i>
                        {else}
                            <i class="fas fa-shield text-grey" aria-hidden="true" data-toggle="tooltip" data-placement="auto right" title="{lang key='twoFactor.disabled'}"></i>
                        {/if}
                        <br>
                        <small>
                            {lang key="userManagement.lastLogin"}:
                            {if $user->pivot->hasLastLogin()}
                                {$user->pivot->getLastLogin()->diffForHumans()}
                            {else}
                                {lang key='never'}
                            {/if}
                        </small>
                    </td>
                    <td>
                        <a href="{routePath('account-users-permissions', $user->id)}"
                           class="btn btn-default btn-sm btn-manage-permissions{if $user->pivot->owner} disabled{/if}"
                           {if $user->pivot->owner}aria-disabled="true"{/if}>
                            {lang key="userManagement.managePermissions"}
                        </a>
                        <a href="#"
                           class="btn btn-danger btn-sm btn-remove-user{if $user->pivot->owner} disabled{/if}"
                           data-id="{$user->id}"
                           {if $user->pivot->owner}aria-disabled="true" tabindex="-1"{else}aria-haspopup="dialog"{/if}>
                            {lang key="userManagement.removeAccess"}
                        </a>
                    </td>
                </tr>
            {/foreach}
            {if $invites->count() > 0}
                <tr>
                    <td colspan="2">
                        <strong>{lang key="userManagement.pendingInvites"}</strong>
                    </td>
                </tr>
                {foreach $invites as $invite}
                    <tr>
                        <td>
                            {$invite->email}
                            <br>
                            <small>
                                {lang key="userManagement.inviteSent"}:
                                {$invite->created_at->diffForHumans()}
                            </small>
                        </td>
                        <td>
                            <form method="post" action="{routePath('account-users-invite-resend')}">
                                <input type="hidden" name="inviteid" value="{$invite->id}">
                                <button type="submit" class="btn btn-default btn-sm">
                                    {lang key="userManagement.resendInvite"}
                                </button>
                                <button type="button"
                                        class="btn btn-danger btn-sm btn-cancel-invite"
                                        data-id="{$invite->id}"
                                        aria-haspopup="dialog">
                                    {lang key="userManagement.cancelInvite"}
                                </button>
                            </form>
                        </td>
                    </tr>
                {/foreach}
            {/if}
            </tbody>
        </table>

        <p class="text-muted m-0">* {lang key="userManagement.accountOwnerPermissionsInfo"}</p>

    </div>
</div>

<div class="card">
    <div class="card-body">
        <h3 class="card-title">{lang key="userManagement.inviteNewUser"}</h3>

        <p>{lang key="userManagement.inviteNewUserDescription"}</p>

        <form method="post" action="{routePath('account-users-invite')}">
            <div class="form-group">
                {* WS-B: explicit label — parent used placeholder only *}
                <label for="inputInviteEmail" class="sr-only">{lang key='wsb.inviteEmailLabel'}</label>
                <input type="email"
                       id="inputInviteEmail"
                       name="inviteemail"
                       placeholder="name@example.com"
                       class="form-control"
                       value="{$formdata.inviteemail}"
                       autocomplete="email">
            </div>
            {* WS-B: radio group in fieldset/legend *}
            <fieldset class="a11y-permissions">
                <legend class="h6">{lang key='wsb.permissionsGroupLabel'}</legend>
                <div class="form-group">
                    <label class="form-check form-check-inline" for="permAll">
                        <input type="radio" class="form-check-input" id="permAll" name="permissions" value="all" checked="checked">
                        {lang key="userManagement.allPermissions"}
                    </label>
                    <label class="form-check form-check-inline" for="permChoose">
                        <input type="radio" class="form-check-input" id="permChoose" name="permissions" value="choose">
                        {lang key="userManagement.choosePermissions"}
                    </label>
                </div>
            </fieldset>
            <div class="well mb-3 w-hidden" id="invitePermissions" aria-live="polite">
                {foreach $permissions as $permission}
                    <label class="form-check form-check-inline" for="perm_{$permission.key}">
                        <input type="checkbox" class="form-check-input" id="perm_{$permission.key}" name="perms[{$permission.key}]" value="1">
                        {$permission.title}
                        <span class="d-none d-md-inline" aria-hidden="true">-</span>
                        <br class="d-md-none">
                        <span class="text-muted">{$permission.description}</span>
                    </label>
                    <br>
                {/foreach}
            </div>
            <button type="submit" class="btn btn-primary">
                {lang key="userManagement.sendInvite"}
            </button>
        </form>

    </div>
</div>

<form method="post" action="{routePath('user-accounts')}">
    <input type="hidden" name="id" value="" id="inputSwitchAcctId">
</form>

<form method="post" action="{routePath('account-users-remove')}">
    <input type="hidden" name="userid" id="inputRemoveUserId">
    <div class="modal fade"
         id="modalRemoveUser"
         tabindex="-1"
         role="dialog"
         aria-modal="true"
         aria-labelledby="modalRemoveUserTitle">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header card-header bg-primary text-light">
                    <h4 class="modal-title" id="modalRemoveUserTitle">
                        {lang key="userManagement.removeAccess"}
                    </h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="{lang key='close'}"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    <p>{lang key="userManagement.removeAccessSure"}</p>
                    <p>{lang key="userManagement.removeAccessInfo"}</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        {lang key="cancel"}
                    </button>
                    <button type="submit" class="btn btn-primary" id="btnRemoveUserConfirm">
                        {lang key="confirm"}
                    </button>
                </div>
            </div>
        </div>
    </div>
</form>

<form method="post" action="{routePath('account-users-invite-cancel')}">
    <input type="hidden" name="inviteid" id="inputCancelInviteId">
    <div class="modal fade"
         id="modalCancelInvite"
         tabindex="-1"
         role="dialog"
         aria-modal="true"
         aria-labelledby="modalCancelInviteTitle">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header card-header bg-primary text-light">
                    <h4 class="modal-title" id="modalCancelInviteTitle">
                        {lang key="userManagement.cancelInvite"}
                    </h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="{lang key='close'}"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    <p>{lang key="userManagement.cancelInviteSure"}</p>
                    <p>{lang key="userManagement.cancelInviteInfo"}</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        {lang key="cancel"}
                    </button>
                    <button type="submit" class="btn btn-primary" id="btnCancelInviteConfirm">
                        {lang key="confirm"}
                    </button>
                </div>
            </div>
        </div>
    </div>
</form>

<script>
    jQuery(document).ready(function() {
        jQuery('input:radio[name=permissions]').change(function () {
            if (this.value === 'choose') {
                jQuery('#invitePermissions').slideDown();
            } else {
                jQuery('#invitePermissions').slideUp();
            }
        });
        jQuery('.btn-manage-permissions').click(function(e) {
            if (jQuery(this).attr('disabled')) {
                e.preventDefault();
            }
        });
        jQuery('.btn-remove-user').click(function(e) {
            e.preventDefault();
            if (jQuery(this).attr('disabled')) {
                return;
            }
            jQuery('#inputRemoveUserId').val(jQuery(this).data('id'));
            jQuery('#modalRemoveUser').modal('show');
        });
        jQuery('.btn-cancel-invite').click(function(e) {
            e.preventDefault();
            jQuery('#inputCancelInviteId').val(jQuery(this).data('id'));
            jQuery('#modalCancelInvite').modal('show');
        });
    });
</script>
