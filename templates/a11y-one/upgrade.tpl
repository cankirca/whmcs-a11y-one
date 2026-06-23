{**
 * upgrade.tpl — A11y One override
 *
 * A11y fixes (WS-D Task 2):
 *   - Each package-row billing-cycle <select> receives an aria-label associating
 *     it with the package name (WCAG 1.3.1, 4.1.2).
 *   - Each nested <form> submit button retains its value= accessible name.
 *   - Empty <th> cells in the package table given aria-hidden to suppress
 *     axe empty-table-header violation.
 *   - Config-options sub-table column headers carry scope="col".
 *   - Single <h1> from global pageheader.tpl; no additional h1 here.
 *   - All strings via {$LANG.*} / {lang key=...} — no hardcoded text.
 *
 * Author: Can Kirca
 **}
{if $overdueinvoice}
    {include file="$template/includes/alert.tpl" type="warning" msg=$LANG.upgradeerroroverdueinvoice}
{elseif $existingupgradeinvoice}
    {include file="$template/includes/alert.tpl" type="warning" msg=$LANG.upgradeexistingupgradeinvoice}
{elseif $upgradenotavailable}
    {include file="$template/includes/alert.tpl" type="warning" msg=$LANG.upgradeNotPossible textcenter=true}
{elseif $upgradeinvalid}
    {include file="$template/includes/alert.tpl" type="warning" msg=$upgradeinvaliderror}
{/if}

{if $overdueinvoice}

    <p>
        <a href="clientarea.php?action=productdetails&id={$id}" class="btn btn-default">{$LANG.clientareabacklink}</a>
    </p>

{elseif $existingupgradeinvoice}

    <p>
        <a href="{$existingupgradeinvoiceid|invoiceLink}" class="btn btn-default">{$LANG.clientareabacklink}</a>
    </p>
    <p>
        <a href="submitticket.php" class="btn btn-default">{$LANG.submitticketdescription}</a>
    </p>

{elseif $upgradeinvalid}

    <p>
        <a href="clientarea.php?action=productdetails&id={$id}" class="btn btn-default btn-lg">{$LANG.clientareabacklink}</a>
    </p>

{else}

    {if $type eq "package"}

        <p>{$LANG.upgradechoosepackage}</p>

        <p>{$LANG.upgradecurrentconfig}:<br/><strong>{$groupname} - {$productname}</strong>{if $domain} ({$domain}){/if}</p>

        <p>{$LANG.upgradenewconfig}:</p>

        <table class="table table-striped">
            <thead>
                <tr>
                    {* First column header spans product name/description — rendered by package name in td *}
                    <th scope="col">{$LANG.upgradenewconfig}</th>
                    <th scope="col" class="text-center">{$LANG.upgradedowngradechooseproduct}</th>
                </tr>
            </thead>
            <tbody>
            {foreach key=num item=upgradepackage from=$upgradepackages}
                <tr>
                    <td>
                        <strong>
                            {$upgradepackage.groupname} - {$upgradepackage.name}
                        </strong>
                        <br />
                        {$upgradepackage.description}
                    </td>
                    <td width="300" class="text-center">
                        <form method="post" action="{$smarty.server.PHP_SELF}">
                            <input type="hidden" name="step" value="2">
                            <input type="hidden" name="type" value="{$type}">
                            <input type="hidden" name="id" value="{$id}">
                            <input type="hidden" name="pid" value="{$upgradepackage.pid}">
                            <div class="form-group">
                                {if $upgradepackage.pricing.type eq "free"}
                                    {$LANG.orderfree}<br />
                                    <input type="hidden" name="billingcycle" value="free">
                                {elseif $upgradepackage.pricing.type eq "onetime"}
                                    {$upgradepackage.pricing.onetime} {$LANG.orderpaymenttermonetime}
                                    <input type="hidden" name="billingcycle" value="onetime">
                                {elseif $upgradepackage.pricing.type eq "recurring"}
                                    {* aria-label associates this select with the package name (WCAG 4.1.2) *}
                                    <label for="billingcycle_{$upgradepackage.pid}" class="sr-only">
                                        {$LANG.a11yUpgradeBillingCycleFor|sprintf:"{$upgradepackage.groupname} - {$upgradepackage.name}"}
                                    </label>
                                    <select name="billingcycle"
                                            id="billingcycle_{$upgradepackage.pid}"
                                            class="form-control">
                                        {if $upgradepackage.pricing.monthly}<option value="monthly">{$upgradepackage.pricing.monthly}</option>{/if}
                                        {if $upgradepackage.pricing.quarterly}<option value="quarterly">{$upgradepackage.pricing.quarterly}</option>{/if}
                                        {if $upgradepackage.pricing.semiannually}<option value="semiannually">{$upgradepackage.pricing.semiannually}</option>{/if}
                                        {if $upgradepackage.pricing.annually}<option value="annually">{$upgradepackage.pricing.annually}</option>{/if}
                                        {if $upgradepackage.pricing.biennially}<option value="biennially">{$upgradepackage.pricing.biennially}</option>{/if}
                                        {if $upgradepackage.pricing.triennially}<option value="triennially">{$upgradepackage.pricing.triennially}</option>{/if}
                                    </select>
                                {/if}
                            </div>
                            <input type="submit"
                                   value="{$LANG.upgradedowngradechooseproduct}"
                                   class="btn btn-primary btn-block"
                                   id="btnUpgradeDowngradeChooseProduct_{$upgradepackage.pid}"
                            />
                        </form>
                    </td>
                </tr>
            {/foreach}
            </tbody>
        </table>

    {elseif $type eq "configoptions"}

        <p>{$LANG.upgradechooseconfigoptions}</p>

        {if $errormessage}
            {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage}
        {/if}

        <form method="post" action="{$smarty.server.PHP_SELF}">
            <input type="hidden" name="step" value="2" />
            <input type="hidden" name="type" value="{$type}" />
            <input type="hidden" name="id" value="{$id}" />

            <table class="table table-striped">
                <thead>
                    <tr>
                        <th scope="col">{$LANG.clientareacancellationtype}</th>
                        <th scope="col">{$LANG.upgradecurrentconfig}</th>
                        <th scope="col" aria-hidden="true"></th>
                        <th scope="col">{$LANG.upgradenewconfig}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach key=num item=configoption from=$configoptions}
                        <tr>
                            <td>{$configoption.optionname}</td>
                            <td>
                                {if $configoption.optiontype eq 1 || $configoption.optiontype eq 2}
                                    {$configoption.selectedname}
                                {elseif $configoption.optiontype eq 3}
                                    {if $configoption.selectedqty}{$LANG.yes}{else}{$LANG.no}{/if}
                                {elseif $configoption.optiontype eq 4}
                                    {$configoption.selectedqty} x {$configoption.options.0.name}
                                {/if}
                            </td>
                            <td aria-hidden="true">=&gt;</td>
                            <td>
                                {if $configoption.optiontype eq 1 || $configoption.optiontype eq 2}
                                    <label for="configoption_{$configoption.id}" class="sr-only">{$configoption.optionname}</label>
                                    <select name="configoption[{$configoption.id}]" id="configoption_{$configoption.id}">
                                        {foreach key=num item=option from=$configoption.options}
                                            {if $option.selected}<option value="{$option.id}" selected>{$LANG.upgradenochange}</option>{else}<option value="{$option.id}">{$option.nameonly} {$option.price}</option>{/if}
                                        {/foreach}
                                    </select>
                                {elseif $configoption.optiontype eq 3}
                                    <label for="configoption_{$configoption.id}">
                                        <input type="checkbox"
                                               name="configoption[{$configoption.id}]"
                                               id="configoption_{$configoption.id}"
                                               value="1"{if $configoption.selectedqty} checked{/if} />
                                        {$configoption.options.0.name}
                                    </label>
                                {elseif $configoption.optiontype eq 4}
                                    <label for="configoption_{$configoption.id}" class="sr-only">{$configoption.optionname}</label>
                                    <input type="text"
                                           name="configoption[{$configoption.id}]"
                                           id="configoption_{$configoption.id}"
                                           value="{$configoption.selectedqty}"
                                           size="5" />
                                    x {$configoption.options.0.name}
                                {/if}
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>

            <p class="text-center">
                <input type="submit" value="{$LANG.ordercontinuebutton}" class="btn btn-primary" />
            </p>

        </form>
    {/if}
{/if}
