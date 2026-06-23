<!DOCTYPE html>
<html lang="{if $language == 'turkish'}tr{else}en{/if}">
<head>
    <meta charset="{$charset}" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{$companyname} - {$pagetitle}</title>

    <link href="{assetPath file='all.min.css'}?v={$versionHash}" rel="stylesheet">
    <link href="{assetPath file='theme.min.css'}?v={$versionHash}" rel="stylesheet">
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome.min.css" rel="stylesheet">
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-solid.min.css" rel="stylesheet">
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-regular.min.css" rel="stylesheet">
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-light.min.css" rel="stylesheet">
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-brands.min.css" rel="stylesheet">
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-duotone.min.css" rel="stylesheet">
    <link href="{assetPath file='invoice.min.css'}?v={$versionHash}" rel="stylesheet">
    <link href="{$WEB_ROOT}/templates/{$template}/css/custom.css?v={$versionHash}" rel="stylesheet">
    <script>var whmcsBaseUrl = "{$WEB_ROOT}";</script>
    <script src="{assetPath file='scripts.min.js'}?v={$versionHash}"></script>

</head>
<body>

<a class="skip-link" href="#main-body">{lang key='skipToMainContent'}</a>

<main id="main-body" tabindex="-1" class="container-fluid invoice-container">
    <div class="row invoice-header">
        <div class="col-12 col-sm-6 justify-content-sm-between text-center text-sm-left invoice-col">

            {if $logo}
                <p><img src="{$logo}" alt="{$companyname}" /></p>
            {else}
                <h2>{$companyname}</h2>
            {/if}
            <h1 class="h3">{$pagetitle}</h1>

        </div>
    </div>
    <hr>
    <div class="row justify-content-sm-between">
        <div class="col-12 col-sm-6 order-sm-last text-sm-right invoice-col right">
            <strong>{lang key='billing.issuedby'}</strong>
            <address class="small-text">
                {$issuedBy}
                {if $taxCode}<br />{$taxIdLabel}: {$taxCode}{/if}
            </address>
        </div>
        <div class="col-12 col-sm-6 invoice-col">
            <strong>{lang key='billing.issuedto'}</strong>
            <address class="small-text">
                {if $clientsdetails.companyname}{$clientsdetails.companyname}<br />{/if}
                {$clientsdetails.firstname} {$clientsdetails.lastname}<br />
                {$clientsdetails.address1}, {$clientsdetails.address2}<br />
                {$clientsdetails.city}, {$clientsdetails.state}, {$clientsdetails.postcode}<br />
                {$clientsdetails.country}
                {if $clientsdetails.tax_id}
                    <br />{$taxIdLabel}: {$clientsdetails.tax_id}
                {/if}
                {if $customfields}
                    <br /><br />
                    {foreach $customfields as $customfield}
                        {$customfield.fieldname}: {$customfield.value}<br />
                    {/foreach}
                {/if}
            </address>
        </div>
    </div>
    <div class="row">
        <div class="col-12 col-sm-6 invoice-col">
            <strong>{lang key='billing.issuedate'}</strong><br>
            <span class="small-text">{$dateIssued}</span><br>
        </div>
    </div>
    <br />

    {if $notes}
        {include file="$template/includes/panel.tpl" type="info" headerTitle="{lang key='invoicesnotes'}" bodyContent=$notes}
    {/if}

    <div class="card bg-default">
        <div class="card-header">
            <h2 class="card-title mb-0 font-size-24 h4"><strong>{$itemTableTitle}</strong></h2>
        </div>
        <div class="table-responsive">
            <table class="table table-sm">
                <caption class="sr-only">{$itemTableTitle}</caption>
                <thead>
                <tr>
                    <th scope="col"><strong>{lang key='invoicesdescription'}</strong></th>
                    <th scope="col" width="20%" class="text-center"><strong>{lang key='invoicesamount'}</strong></th>
                </tr>
                </thead>
                <tbody>
                {foreach $billingNote->lineItems as $item}
                    <tr>
                        <td>{$item->description}{if $item->isTaxed eq "true"} *{/if}</td>
                        <td class="text-center">{$item->amount}</td>
                    </tr>
                {/foreach}
                <tr>
                    <td class="total-row text-right"><strong>{lang key='invoicessubtotal'}</strong></td>
                    <td class="total-row text-center">{$billingNote->subTotal}</td>
                </tr>
                {foreach $billingNote->taxes as $tax}
                    <tr>
                        <td class="total-row text-right"><strong>{$tax->rate} {$tax->name}</strong></td>
                        <td class="total-row text-center">{$tax->price}</td>
                    </tr>
                {/foreach}
                <tr>
                    <td class="total-row text-right"><strong>{lang key='invoicestotal'}</strong></td>
                    <td class="total-row text-center">{$billingNote->total}</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    {if $taxrate}
        <p>* {lang key='invoicestaxindicator'}</p>
    {/if}

    <hr />

    <div class="row w-100 mx-auto mb-3">
        <div class="card w-100">
            <div class="card-title py-1 px-2 text-white mb-0 font-weight-bold bg-info">
                {lang key='billing.ledger.title'}
            </div>
            <div class="card-text table-responsive transactions-container">
                <table class="table table-sm">
                    <caption class="sr-only">{lang key='billing.ledger.title'}</caption>
                    <thead>
                    <tr>
                        <th scope="col" class="text-center font-weight-bold">{lang key='billing.ledger.date'}</th>
                        <th scope="col" class="text-center font-weight-bold">{lang key='billing.ledger.type'}</th>
                        <th scope="col" class="text-center font-weight-bold">{lang key='billing.ledger.reference'}</th>
                        <th scope="col" class="text-center font-weight-bold">{lang key='invoicestransamount'}</th>
                    </tr>
                    </thead>
                    <tbody>
                    {foreach $transactions as $transaction}
                        <tr>
                            <td class="text-center">{$transaction->clientDate}</td>
                            <td class="text-center">{$transaction->typeLabel}</td>
                            <td class="text-center">{$transaction->clientReferenceId}</td>
                            <td class="text-center">{$transaction->amount}</td>
                        </tr>
                        {foreachelse}
                        <tr>
                            <td class="text-center" colspan="4">{lang key='invoicestransnonefound'}</td>
                        </tr>
                    {/foreach}
                    <tr>
                        <td class="total-row text-right font-weight-bold" colspan="3">{lang key='invoicesbalance'}</td>
                        <td class="total-row text-center">{$billingNote->balance}</td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="float-right btn-group btn-group-sm d-print-none">
        <button type="button" class="btn btn-default" onclick="window.print()"><i class="fas fa-print" aria-hidden="true"></i> {lang key='print'}</button>
    </div>

</main>

<p class="text-center d-print-none"><a href="clientarea.php?action=invoices">{lang key='invoicesbacktoclientarea'}</a></p>

</body>
</html>
