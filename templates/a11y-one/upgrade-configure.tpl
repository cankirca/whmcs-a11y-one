{**
 * upgrade-configure.tpl — A11y One override
 *
 * A11y fixes (WS-D Task 2):
 *   - Billing-cycle <select> per product card receives an aria-label associating
 *     it with the product name (WCAG 4.1.2).
 *   - Quantity <input type="number"> is labelled via wrapping <label> with
 *     an explicit visible text from {lang key='orderForm.qty'} (already in
 *     parent); the label now uses for/id to make the association explicit.
 *   - ionRangeSlider: this template does NOT render an ionRangeSlider widget;
 *     the parent uses <input type="number"> with a <label class="checkbox-inline">
 *     wrapping pattern (lines 83-89 of parent). That pattern is preserved and
 *     improved here with an explicit for/id association. The native number input
 *     is fully operable; no canvas slider is present.
 *   - NOTE: configurable-option groups (radio/checkbox per option) do NOT appear
 *     in this template (upgrade-configure.tpl); those live in upgrade.tpl
 *     (legacy configoptions flow) and are fixed there with fieldset/legend.
 *     This template renders a product-card selection UI only.
 *   - h3/h4 headings preserved (h1 comes from global pageheader.tpl).
 *   - All strings via {lang key=...} — no hardcoded text.
 *   - Decorative icons carry aria-hidden="true".
 *
 * Author: Can Kirca
 **}
<div class="upgrade">
    {if !$serviceToBeUpgraded && $errorMessage}
        <div class="alert alert-warning">
            {$errorMessage}
        </div>
    {else}
        <h3>{lang key="upgradeService.serviceBeingUpgraded"}</h3>

        <div class="product-to-be-upgraded">
            <div class="row">
                <div class="col-sm-9">
                    <h4>
                        {if $serviceToBeUpgraded->isService()}
                            {$serviceToBeUpgraded->product->productGroup->name} - {$serviceToBeUpgraded->product->name}
                        {else}
                            {$serviceToBeUpgraded->productAddon->name}
                        {/if}
                    </h4>
                    <h5>
                        {if $serviceToBeUpgraded->domain}
                            {$serviceToBeUpgraded->domain}
                        {elseif $serviceToBeUpgraded->isAddon() && $serviceToBeUpgraded->service->domain}
                            {$serviceToBeUpgraded->service->domain}
                        {else}
                            {lang key="noDomain"}
                        {/if}
                    </h5>
                </div>
                <div class="col-sm-3 text-right">
                    <a href="{$WEB_ROOT}/clientarea.php?action=productdetails&id={if $serviceToBeUpgraded->isService()}{$serviceToBeUpgraded->id}{elseif $serviceToBeUpgraded->isAddon()}{$serviceToBeUpgraded->service->id}{/if}" class="btn btn-default">
                        {lang key="manage"}
                    </a>
                </div>
            </div>
        </div>

        {if $errorMessage}
            <div class="alert alert-warning">
                {$errorMessage}
            </div>
        {/if}

        <h3>{lang key="upgradeService.chooseNew"}</h3>

        <div class="products row">
            {foreach $upgradeProducts as $key => $product}
                <div class="column col-sm-{if count($upgradeProducts) >= 3}4{else}6{/if}">
                    <div class="product">
                        <div class="header">
                            <h4>
                                {$product->name}
                            </h4>
                            <p>{$product->description}</p>
                        </div>
                        {if $product->id == $serviceToBeUpgraded->productId}
                            <div class="current">
                                {lang key="upgradeService.currentProduct"}
                            </div>
                        {/if}
                        {if $product->productKey == $recommendedProductKey}
                            <div class="recommended">
                                {lang key="upgradeService.recommended"}
                            </div>
                        {/if}
                        <ul>
                            {foreach $product->features as $label => $value}
                                <li>
                                    {if $value}
                                        {$label}:
                                        {if $value !== true}
                                            {$value}
                                        {/if}
                                    {/if}
                                </li>
                            {/foreach}
                        </ul>
                        <div class="footer">
                            <form method="post" action="{routePath('upgrade-add-to-cart')}">
                                <input type="hidden" name="isproduct" value="{$isService}">
                                <input type="hidden" name="serviceid" value="{$serviceToBeUpgraded->id}">
                                <input type="hidden" name="productid" value="{$product->id}">
                                {if $allowMultipleQuantities}
                                    {* Quantity input: label uses for/id for explicit association (WCAG 4.1.2) *}
                                    <div class="text-right margin-bottom-5">
                                        <label for="qty_{$product->productKey}" class="control-label">
                                            {lang key='orderForm.qty'}
                                            <input type="number"
                                                   name="qty"
                                                   id="qty_{$product->productKey}"
                                                   min="{$minimumQuantity}"
                                                   value="{$currentQuantity}"
                                                   class="form-control input-inline input-inline-100">
                                        </label>
                                    </div>
                                {/if}
                                {* Billing-cycle select: aria-label associates with product name (WCAG 4.1.2) *}
                                <label for="billingcycle_{$product->productKey}" class="sr-only">
                                    {$LANG.a11yUpgradeBillingLabel} — {$product->name}
                                </label>
                                <select name="billingcycle"
                                        id="billingcycle_{$product->productKey}"
                                        class="form-control">
                                    {foreach $product->pricing()->allAvailableCycles() as $cycle}
                                        {if $permittedBillingCycles->showCycleForProduct($cycle->cycle())}
                                            <option value="{$cycle->cycle()}"
                                                    {if $permittedBillingCycles->isCycleDisabledForProduct(
                                                            $product->id,
                                                            $cycle->cycle()
                                                    )}
                                                        disabled
                                                    {/if}
                                            >
                                                {if $cycle->isRecurring()}
                                                    {if $cycle->isYearly()}
                                                        {$cycle->cycleInYears()}
                                                    {else}
                                                        {$cycle->cycleInMonths()}
                                                    {/if}
                                                    -
                                                {/if}
                                                {$cycle->toFullString()}
                                            </option>
                                        {/if}
                                    {/foreach}
                                </select>
                                <button type="submit"
                                        class="btn btn-block"
                                        id="btnUpgradeSelect-{$product->productKey}"
                                        {if !$product->eligibleForUpgrade}disabled="disabled"{/if}>
                                    {lang key="upgradeService.select"}
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                {if count($upgradeProducts) >= 3 && (($key + 1) % 3 == 0)}
                    </div><div class="products row">
                {/if}
            {/foreach}
        </div>
    {/if}
</div>
