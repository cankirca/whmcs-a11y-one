{*
    A11y One — accessible support ticket list.
    Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca

    Accessibility changes vs parent twenty-one:
      - The whole <tr> used a JS-only onclick to navigate (keyboard-inaccessible
        and a double-activation hazard alongside the inner <a>). The subject cell
        already holds a real <a href>; we make that the single, keyboard-reachable
        navigation control covering the row's intent and DROP the row onclick.
        Its accessible name is the ticket number + subject (no extra markup needed
        beyond the existing spans, which read as one link name).
      - The unread indicator was conveyed by colour/weight only (.unread class).
        We add an sr-only "(unread)" / "(read)" suffix so it is perceivable
        without sight.
    DataTables a11y (caption/scope/sort/pagination) is applied by a11y-one.js
    via the shared tablelist behaviour.
*}
{include file="$template/includes/tablelist.tpl" tableName="TicketsList" filterColumn="2"}

<script>
    jQuery(document).ready(function () {
        var table = jQuery('#tableTicketsList').show().DataTable();
        {if $orderby == 'did' || $orderby == 'dept'}
            table.order(0, '{$sort}');
        {elseif $orderby == 'subject' || $orderby == 'title'}
            table.order(1, '{$sort}');
        {elseif $orderby == 'status'}
            table.order(2, '{$sort}');
        {elseif $orderby == 'lastreply'}
            table.order(3, '{$sort}');
        {/if}
        table.draw();
        jQuery('#tableLoading').hide();
    });
</script>

<div class="table-container clearfix">
    <table id="tableTicketsList" class="table table-list w-hidden">
        <thead>
            <tr>
                <th>{lang key='supportticketsdepartment'}</th>
                <th>{lang key='supportticketssubject'}</th>
                <th>{lang key='supportticketsstatus'}</th>
                <th>{lang key='supportticketsticketlastupdated'}</th>
            </tr>
        </thead>
        <tbody>
            {foreach $tickets as $ticket}
                <tr>
                    <td>
                        {$ticket.department}
                    </td>
                    <td>
                        <a href="viewticket.php?tid={$ticket.tid}&amp;c={$ticket.c}" class="border-left">
                            <span class="ticket-number">#{$ticket.tid}</span>
                            <span class="ticket-subject{if $ticket.unread} unread{/if}">{$ticket.subject|escape}</span>
                            <span class="sr-only">{if $ticket.unread}({lang key='ticketStatusUnread'}){else}({lang key='ticketStatusRead'}){/if}</span>
                        </a>
                    </td>
                    <td>
                        <span class="label status {if is_null($ticket.statusColor)}status-{$ticket.statusClass}"{else}status-custom" style="background-color:{$ticket.statusColor}"{/if}>
                            {$ticket.status|strip_tags}
                        </span>
                    </td>
                    <td class="text-center">
                        <span class="w-hidden">{$ticket.normalisedLastReply}</span>
                        {$ticket.lastreply}
                    </td>
                </tr>
            {/foreach}
        </tbody>
    </table>
    <div class="text-center" id="tableLoading">
        <p><i class="fas fa-spinner fa-spin" aria-hidden="true"></i> {lang key='loading'}</p>
    </div>
</div>
