{*
    A11y One — accessible "open a ticket" step one (department picker).
    Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca

    Changes vs parent twenty-one:
      - Department <a> links already carry the department name as their text
        (clear accessible name); the leading envelope icon is decorative, so it
        is marked aria-hidden="true" to avoid duplicate/garbled SR output.
*}
<div class="card">
    <div class="card-body extra-padding">

        <div class="mb-4">
            <h1 class="card-title h3">{lang key="createNewSupportRequest"}</h1>
            <p class="text-muted mb-0">{lang key='supportticketsheader'}</p>
        </div>

        <div class="row">
            <div class="col-sm-10 offset-sm-1">
                {foreach $departments as $num => $department}
                    <p class="h5">
                        <a href="{$smarty.server.PHP_SELF}?step=2&amp;deptid={$department.id}">
                            <i class="fas fa-envelope" aria-hidden="true"></i>
                            &nbsp;{$department.name}
                        </a>
                    </p>
                    {if $department.description}
                        <p class="text-muted">{$department.description}</p>
                    {/if}
                {foreachelse}
                    {include file="$template/includes/alert.tpl" type="info" msg="{lang key='nosupportdepartments'}" textcenter=true}
                {/foreach}
            </div>
        </div>

    </div>
</div>
