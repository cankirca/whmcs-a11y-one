{* WS-G 3dsecure.tpl
   Base: templates/twenty-one/3dsecure.tpl
   Parent: twenty-one (NOT six)
   Rendered inside site chrome (header/footer includes); a11y-one.js loads.
   The iframe auto-submits via setTimeout in the inherited parent script.
   A11y fixes:
   - iframe: title attribute describing the 3D-Secure authentication frame.
   - Hidden auth form: class="w-hidden" preserved (JS reveals and targets iframe).
   - No no-JS fallback needed: WHMCS 3DS flow requires JS; a note in the alert
     (already present via creditcard3dsecure lang key) describes what's happening.
   Note: a11y-one.js loads via site footer; no self-load needed. *}

{include file="$template/includes/alert.tpl" type="info" msg="{lang key='creditcard3dsecure'}" textcenter=true}

<div class="card">
    <div class="card-body text-center">
        <div id="frmThreeDAuth" class="w-hidden">
            {$code}
        </div>

        <iframe
            name="3dauth"
            height="500"
            scrolling="auto"
            src="about:blank"
            class="submit-3d p-3"
            title="{lang key='a11y3dSecureFrame'}"></iframe>
    </div>
</div>

<script>
    jQuery("#frmThreeDAuth").find("form:first").attr('target', '3dauth');
    setTimeout("autoSubmitFormByContainer('frmThreeDAuth')", 1000);
</script>
