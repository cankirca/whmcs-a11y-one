{* A11y One — usagebillingpricing.tpl override (metric pricing modal).
   Author: Can Kirca
   WS-D Task 1: accessible dialog pattern (role=dialog, aria-modal=true,
   aria-labelledby, close button aria-label, focus management via Bootstrap 4).
   Pricing table has <caption> (sr-only) + <th scope="col"> on column headers. *}

<div class="modal fade modal-metric-pricing" tabindex="-1" role="dialog" aria-modal="true" aria-labelledby="modalMetricPricingTitle-{$metric.systemName}" id="modalMetricPricing-{$metric.systemName}">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="modalMetricPricingTitle-{$metric.systemName}">{$metric.displayName} {lang key='metrics.pricing'}</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="{lang key='close'}"><span aria-hidden="true">&times;</span></button>
            </div>
            <div class="modal-body">
                <p>{$metric.pricingSchema.info}<br/>
                    {$metric.pricingSchema.detail}
                </p>
                <table class="table table-sm table-striped">
                    <caption class="sr-only">{lang key='metrics.pricingTableCaption'}</caption>
                    <thead>
                        <tr>
                            <th scope="col" class="text-center">{lang key='metrics.startingQuantity'}</th>
                            <th scope="col" class="text-center">{lang key='metrics.pricePer'} {if $metric.unitName}{$metric.unitName}{else}{lang key='metrics.unit'}{/if}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $metric.pricing as $pricing}
                            <tr>
                                <td>{$pricing.from}</td>
                                <td>{$pricing.price_per_unit}</td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
                {if $metric.includedQuantity}
                    <p>{$metric.includedQuantity} {$metric.includedQuantityUnits} {lang key='metrics.includedInBase'}</p>
                {/if}
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{lang key='close'}</button>
            </div>
        </div>
    </div>
</div>
