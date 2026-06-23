{include file="$template/includes/tablelist.tpl" tableName="InvoicesList" filterColumn="4"}

<script>
    jQuery(document).ready(function() {
        var table = jQuery('#tableInvoicesList').show().DataTable();

        {if $orderby == 'default'}
            table.order([4, 'desc'], [2, 'asc']);
        {elseif $orderby == 'invoicenum'}
            table.order(0, '{$sort}');
        {elseif $orderby == 'date'}
            table.order(1, '{$sort}');
        {elseif $orderby == 'duedate'}
            table.order(2, '{$sort}');
        {elseif $orderby == 'total'}
            table.order(3, '{$sort}');
        {elseif $orderby == 'status'}
            table.order(4, '{$sort}');
        {/if}
        table.draw();
        jQuery('#tableLoading').hide();
    });
</script>

<div class="table-container clearfix">
    <table id="tableInvoicesList" class="table table-list w-hidden">
        <caption class="sr-only">{lang key='invoices'}</caption>
        <thead>
            <tr>
                <th scope="col">{lang key='invoicestitle'}</th>
                <th scope="col">{lang key='invoicesdatecreated'}</th>
                <th scope="col">{lang key='invoicesdatedue'}</th>
                <th scope="col">{lang key='invoicestotal'}</th>
                <th scope="col">{lang key='invoicesstatus'}</th>
            </tr>
        </thead>
        <tbody>
            {foreach $invoices as $invoice}
                <tr onclick="clickableSafeRedirect(event, 'viewinvoice.php?id={$invoice.id}', false)">
                    <th scope="row"><a href="viewinvoice.php?id={$invoice.id}" class="a11y-row-link">{$invoice.invoicenum}</a></th>
                    <td><span class="w-hidden">{$invoice.normalisedDateCreated}</span>{$invoice.datecreated}</td>
                    <td><span class="w-hidden">{$invoice.normalisedDateDue}</span>{$invoice.datedue}</td>
                    <td data-order="{$invoice.totalnum}">{$invoice.total}</td>
                    <td><span class="label status status-{$invoice.statusClass}">{$invoice.status}<span class="sr-only">: {lang key='invoicesstatus'}</span></span></td>
                </tr>
            {/foreach}
        </tbody>
    </table>
    <div class="text-center" id="tableLoading" role="status" aria-live="polite">
        <p><i class="fas fa-spinner fa-spin" aria-hidden="true"></i> {lang key='loading'}</p>
    </div>
</div>
