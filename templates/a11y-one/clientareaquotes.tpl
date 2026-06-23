{include file="$template/includes/tablelist.tpl" tableName="QuotesList"  noSortColumns="5" filterColumn="4"}

<script>
    jQuery(document).ready(function() {
        var table = jQuery('#tableQuotesList').show().DataTable();

        {if $orderby == 'id'}
            table.order(0, '{$sort}');
        {elseif $orderby == 'date'}
            table.order(2, '{$sort}');
        {elseif $orderby == 'validuntil'}
            table.order(3, '{$sort}');
        {elseif $orderby == 'stage'}
            table.order(4, '{$sort}');
        {/if}
        table.draw();
        jQuery('#tableLoading').hide();
    });
</script>

<div class="table-container clearfix">
    <table id="tableQuotesList" class="table table-list w-hidden">
        <caption class="sr-only">{lang key='clientareaquotes'}</caption>
        <thead>
            <tr>
                <th scope="col">{lang key='quotenumber'}</th>
                <th scope="col">{lang key='quotesubject'}</th>
                <th scope="col">{lang key='quotedatecreated'}</th>
                <th scope="col">{lang key='quotevaliduntil'}</th>
                <th scope="col">{lang key='quotestage'}</th>
                <th scope="col"><span class="sr-only">{lang key='a11yQuoteActions'}</span></th>
            </tr>
        </thead>
        <tbody>
            {foreach $quotes as $quote}
                <tr onclick="clickableSafeRedirect(event, 'viewquote.php?id={$quote.id}', true)">
                    <th scope="row"><a href="viewquote.php?id={$quote.id}" class="a11y-row-link">{$quote.id}</a></th>
                    <td>{$quote.subject}</td>
                    <td><span class="w-hidden">{$quote.normalisedDateCreated}</span>{$quote.datecreated}</td>
                    <td><span class="w-hidden">{$quote.normalisedValidUntil}</span>{$quote.validuntil}</td>
                    <td><span class="label status status-{$quote.stageClass}">{$quote.stage}<span class="sr-only">: {lang key='quotestage'}</span></span></td>
                    <td class="text-center">
                        <form method="post" action="dl.php">
                            <input type="hidden" name="type" value="q" />
                            <input type="hidden" name="id" value="{$quote.id}" />
                            <button type="submit" class="btn btn-default btn-sm"><i class="fas fa-download" aria-hidden="true"></i> {lang key='quotedownload'}</button>
                        </form>
                    </td>
                </tr>
            {/foreach}
        </tbody>
    </table>
    <div class="text-center" id="tableLoading" role="status" aria-live="polite">
        <p><i class="fas fa-spinner fa-spin" aria-hidden="true"></i> {lang key='loading'}</p>
    </div>
</div>
