<link rel="stylesheet" type="text/css" href="{assetPath file='all.min.css'}?v={$versionHash}" />
{assetExists file="custom.css"}
<link rel="stylesheet" type="text/css" href="{$__assetPath__}?v={$versionHash}" />
{/assetExists}
<link rel="stylesheet" type="text/css" href="{$WEB_ROOT}/templates/orderforms/a11y-cart/custom.css?v={$versionHash}" />
<script type="text/javascript" src="{assetPath file='scripts.min.js'}?v={$versionHash}"></script>
<script type="text/javascript" src="{$WEB_ROOT}/templates/orderforms/a11y-cart/js/a11y-cart.js?v={$versionHash}"></script>
