{* WS-G clientareaemails.tpl
   Base: templates/twenty-one/clientareaemails.tpl
   Parent: twenty-one (NOT six)
   A11y fixes:
   - Table: add <caption> for the emails list table.
   - thead th: add scope="col" to all column headers.
   - Row onclick popup: tr onclick kept (parent behaviour) but the explicit
     "View" button is the primary keyboard path — it already has text content.
   - Attachment icon in subject cell: aria-hidden (decorative paperclip).
   - Loading spinner icon: aria-hidden.
   - fixAllDataTables() from a11y-one.js handles live-region announce + caption
     update on pagination — reuse (no new helper needed). *}

{* Clear page heading. *}
<h1 class="h3 mb-4">{lang key='navemailssent'}</h1>
{include file="$template/includes/tablelist.tpl" tableName="EmailsList" noSortColumns="-1"}

<script>
    jQuery(document).ready(function () {
        var table = jQuery('#tableEmailsList').show().DataTable();

        {if $orderby == 'date'}
            table.order(0, '{$sort}');
        {elseif $orderby == 'subject'}
            table.order(1, '{$sort}');
        {/if}
        table.draw();
        jQuery('#tableLoading').hide();
    });
</script>

<div class="table-container clearfix">
    <table id="tableEmailsList" class="table table-list w-hidden">
        <caption class="sr-only">{lang key='a11yEmailsTableCaption'}</caption>
        <thead>
            <tr>
                <th scope="col">{lang key='clientareaemailsdate'}</th>
                <th scope="col">{lang key='clientareaemailssubject'}</th>
                <th scope="col"><span class="sr-only">{lang key='a11yEmailsActions'}</span></th>
            </tr>
        </thead>
        <tbody>
            {foreach $emails as $email}
                <tr onclick="popupWindow('viewemail.php?id={$email.id}', 'emailWin', '800', '600')">
                    <td class="text-center"><span class="w-hidden">{$email.normalisedDate}</span>{$email.date}</td>
                    <td>{$email.subject}{if $email.attachmentCount > 0} <i class="fal fa-paperclip" aria-hidden="true"></i>{/if}</td>
                    <td class="text-center">
                        <button type="button" class="btn btn-info btn-sm text-nowrap" onclick="popupWindow('viewemail.php?id={$email.id}', 'emailWin', '800', '600', 'scrollbars=1,')">
                            {lang key='emailviewmessage'}
                        </button>
                    </td>
                </tr>
            {/foreach}
        </tbody>
    </table>
    <div class="text-center" id="tableLoading">
        <p><i class="fas fa-spinner fa-spin" aria-hidden="true"></i> {lang key='loading'}</p>
    </div>
</div>
