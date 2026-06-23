{* WS-G error/internal-error.tpl
   Base: templates/twenty-one/error/internal-error.tpl
   Parent: twenty-one (NOT six)
   STANDALONE page (own <!DOCTYPE> + full HTML). No site chrome; no footer;
   a11y-one.js does NOT load. All fixes are self-sufficient.
   This template uses PHP-style {{double-brace}} placeholders (not Smarty) —
   WHMCS substitutes them directly in the PHP error handler, not via Smarty.
   A11y fixes:
   - html lang: hardcoded "en" (no Smarty language var available at this point).
   - <main> landmark wraps the error container.
   - Single clear h1 ("Oops!") already present — preserved.
   - Contact link already uses mailto: href — real link, no JS.
   - Back-to-homepage link already uses real href — real link, no JS.
   - Added skip link (minimal; errors are short pages but good practice).
   - Color: inline style palette already uses sufficient contrast (#336699 on white).
   - No a11y-one.js: file is served before Smarty context is established. *}

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Error — Oops!</title>
    <style>
        body {
            margin: 30px 40px;
            background-color: #f6f6f6;
        }
        .error-container {
            padding: 50px 40px;
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
            font-size: 14px;
        }
        h1 {
            margin: 0;
            font-size: 48px;
            font-weight: 400;
        }
        h2 {
            margin: 0;
            font-size: 26px;
            font-weight: 300;
        }
        a {
            color: #336699;
        }
        p.back-to-home {
            margin-top: 30px;
        }
        p.debug {
            padding: 20px 0;
            font-family: "Courier New", Courier, monospace, serif;
            font-size: 14px;
        }
        .info {
            border: solid 1px #999;
            padding: 5px;
            background-color: #d9edf7;
        }
        .sr-only {
            position: absolute;
            width: 1px;
            height: 1px;
            padding: 0;
            margin: -1px;
            overflow: hidden;
            clip: rect(0, 0, 0, 0);
            white-space: nowrap;
            border: 0;
        }
        .sr-only-focusable:focus {
            position: static;
            width: auto;
            height: auto;
            overflow: visible;
            clip: auto;
            white-space: normal;
        }
    </style>
</head>
<body>
    <a class="sr-only sr-only-focusable" href="#main-body">Skip to main content</a>
    <main id="main-body">
        <div class="error-container">
            <h1>Oops!</h1>
            <h2>Something went wrong and we couldn't process your request.</h2>
            <p>Please go back to the previous page and try again.</p>
            <p>If the problem persists, please <a href="mailto:{{email}}">contact us</a>.</p>
            <p class="back-to-home"><a href="{{systemurl}}">&laquo; Back to Homepage</a></p>
            {{environmentIssues}}
            <p class="debug">{{adminHelp}}<br/>{{stacktrace}}</p>
        </div>
    </main>
</body>
</html>
