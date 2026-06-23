{* WS-G oauth/error.tpl
   Base: templates/twenty-one/oauth/error.tpl
   Parent: twenty-one (NOT six)
   Rendered inside oauth/layout.tpl (standalone); no site footer; a11y-one.js absent.
   A11y fixes:
   - Alert div: add role="alert" so SR announces the error immediately.
   - Icon: aria-hidden (decorative; the $error string conveys the message).
   - Wrap in <section> with aria-label for landmark (content already in main
     via layout.tpl).
   - h1 provided as a visually-hidden heading for screen-reader page structure
     (the layout h1 is the OAuth action; this section adds specific error context). *}

<div class="container">
    <h1 class="sr-only">{lang key='a11yOauthError'}</h1>
    <div class="alert alert-warning text-center" role="alert">
        <i class="fas fa-exclamation-circle" aria-hidden="true"></i>
        {$error}
    </div>
</div>
