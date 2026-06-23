{* WS-G access-denied.tpl
   Base: templates/twenty-one/access-denied.tpl
   Parent: twenty-one (NOT six)
   Rendered inside site chrome; a11y-one.js loads via footer.
   A11y fixes:
   - "Go back" button: replaces javascript:history.go(-1) href with a real
     <button type="button"> wired via inline script (no new helper needed;
     this is a one-liner with no reuse case).
   - h1 already present in parent (the "Oops!" heading) — preserved.
   - Icons (arrow-circle-left, home): aria-hidden (decorative).
   - Allowed permissions list: already in <div class="list-group"> — converted
     to <ul> list for proper list semantics.
   - Permission denied message uses existing lang keys. *}

<div class="text-center">
    <div class="card py-3">
        <div class="card-body">
            <h1>{lang key='oops'}!</h1>
            <div class="pb-2">{lang key='subaccountpermissiondenied'}</div>
            {if !empty($allowedpermissions)}
                <div>{lang key='subaccountallowedperms'}</div>
                <ul class="list-group list-group-flush text-left d-inline-block">
                    {foreach $allowedpermissions as $permission}
                        <li class="list-group-item">{$permission}</li>
                    {/foreach}
                </ul>
            {/if}
            <div>{lang key='subaccountcontactmaster'}</div>
        </div>
        <div class="buttons pt-2 pb-4">
            <button type="button" class="btn btn-primary" id="btnGoBack">
                <i class="fas fa-arrow-circle-left" aria-hidden="true"></i>
                {lang key='goback'}
            </button>
            <a href="index.php" class="btn btn-default">
                <i class="fas fa-home" aria-hidden="true"></i>
                {lang key='returnhome'}
            </a>
        </div>
    </div>
</div>

<script>
    (function () {
        var btn = document.getElementById('btnGoBack');
        if (btn) {
            btn.addEventListener('click', function () { history.go(-1); });
        }
    }());
</script>
