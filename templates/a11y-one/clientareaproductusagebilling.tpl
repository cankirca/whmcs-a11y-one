{* A11y One — clientareaproductusagebilling.tpl override.
   Author: Can Kirca
   WS-D Task 1: metric table gets <caption> (sr-only) + <th scope="col"> on headers.
   SOURCE NOTE: no metered product is seeded for the a11ytest client (the seed creates
   a standard hosting service without usage metrics). This template is source-verified
   for correct a11y markup; the metric tab only renders when $metricStats is truthy. *}

{* Clear page heading. *}
<h1 class="h3 mb-4">{lang key='metrics.title'}</h1>
<p>{lang key='metrics.explanation'}</p>
<table class="table table-striped mb-1 table-solid-bottom-border-light-gray">
    <caption class="sr-only">{lang key='metrics.tableCaption'}</caption>
    <thead>
        <tr>
            <th scope="col">{lang key='metrics.metric'}</th>
            <th scope="col">{lang key='metrics.currentUsage'}</th>
            <th scope="col">{lang key='metrics.pricing'}</th>
            <th scope="col">{lang key='metrics.lastUpdated'}</th>
        </tr>
    </thead>
    <tbody>
        {foreach $metricStats as $metric}
            <tr>
                <td>{$metric.displayName}</td>
                <td>{$metric.currentValue}</td>
                <td>
                    {if count($metric.pricing) > 1}
                        {lang key='metrics.startingFrom'} {$metric.lowestPrice} / {if $metric.unitName}{$metric.unitName}{else}{lang key='metrics.unit'}{/if}
                        <br>
                        <button type="button" class="btn btn-default btn-xs" data-toggle="modal" data-target="#modalMetricPricing-{$metric.systemName}">
                            {lang key='metrics.viewPricing'}
                        </button>
                    {elseif count($metric.pricing) == 1}
                        {$metric.lowestPrice} / {if $metric.unitName}{$metric.unitName}{else}{lang key='metrics.unit'}{/if}
                        {if $metric.includedQuantity > 0} ({$metric.includedQuantity} {lang key='metrics.includedNotCounted'}){/if}
                    {else}
                        &mdash;
                    {/if}
                    {include file="$template/usagebillingpricing.tpl"}
                </td>
                <td>{if is_string($metric.lastUpdated)}{$metric.lastUpdated}{else}{$metric.lastUpdated->diffForHumans()}{/if}</td>
            </tr>
        {/foreach}
    </tbody>
</table>
